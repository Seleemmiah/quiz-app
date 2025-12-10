import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Optimized Firestore service for handling high concurrent load
class ScalableFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Execute operation with retry logic and exponential backoff
  static Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(milliseconds: 500),
  }) async {
    int attempts = 0;
    Duration delay = initialDelay;

    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          rethrow;
        }

        // Exponential backoff with jitter
        final jitter =
            Duration(milliseconds: (delay.inMilliseconds * 0.1).toInt());
        await Future.delayed(delay + jitter);
        delay = delay * 2; // Double the delay each time
      }
    }

    throw Exception('Max retries exceeded');
  }

  /// Submit exam response with sharding for load distribution
  Future<void> submitExamResponse({
    required String examId,
    required String userId,
    required Map<String, dynamic> responseData,
  }) async {
    return executeWithRetry(() async {
      // Use sharding to distribute writes across multiple collections
      final shardId = userId.hashCode.abs() % 10; // 10 shards

      final batch = _firestore.batch();

      // Write to sharded collection
      final responseRef =
          _firestore.collection('exam_responses_shard_$shardId').doc();

      batch.set(responseRef, {
        ...responseData,
        'examId': examId,
        'userId': userId,
        'shardId': shardId,
        'submittedAt': FieldValue.serverTimestamp(),
      });

      // Update user's exam history (separate shard)
      final historyShardId = userId.hashCode.abs() % 5;
      final historyRef = _firestore
          .collection('user_exam_history_shard_$historyShardId')
          .doc(userId)
          .collection('exams')
          .doc(examId);

      batch.set(
          historyRef,
          {
            'examId': examId,
            'score': responseData['score'],
            'submittedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true));

      await batch.commit();
    });
  }

  /// Get exam responses with sharding awareness
  Future<List<Map<String, dynamic>>> getExamResponses({
    required String examId,
    int? limit,
  }) async {
    final List<Map<String, dynamic>> allResponses = [];

    // Query all shards in parallel
    final futures = List.generate(10, (shardId) {
      var query = _firestore
          .collection('exam_responses_shard_$shardId')
          .where('examId', isEqualTo: examId);

      if (limit != null) {
        query = query.limit((limit / 10).ceil());
      }

      return query.get();
    });

    final results = await Future.wait(futures);

    for (final snapshot in results) {
      for (final doc in snapshot.docs) {
        allResponses.add({
          'id': doc.id,
          ...doc.data(),
        });
      }
    }

    // Sort by submission time
    allResponses.sort((a, b) {
      final aTime = (a['submittedAt'] as Timestamp?)?.toDate() ?? DateTime(0);
      final bTime = (b['submittedAt'] as Timestamp?)?.toDate() ?? DateTime(0);
      return bTime.compareTo(aTime);
    });

    if (limit != null && allResponses.length > limit) {
      return allResponses.sublist(0, limit);
    }

    return allResponses;
  }

  /// Batch write multiple documents efficiently
  Future<void> batchWrite(
      List<Map<String, dynamic>> documents, String collection) async {
    return executeWithRetry(() async {
      // Firestore batch limit is 500 operations
      const batchSize = 500;

      for (var i = 0; i < documents.length; i += batchSize) {
        final batch = _firestore.batch();
        final end = (i + batchSize < documents.length)
            ? i + batchSize
            : documents.length;

        for (var j = i; j < end; j++) {
          final docRef = _firestore.collection(collection).doc();
          batch.set(docRef, documents[j]);
        }

        await batch.commit();
      }
    });
  }

  /// Update leaderboard with sharding
  Future<void> updateLeaderboard({
    required String userId,
    required String examId,
    required int score,
  }) async {
    return executeWithRetry(() async {
      final shardId = userId.hashCode.abs() % 10;

      await _firestore
          .collection('leaderboard_shard_$shardId')
          .doc(userId)
          .set({
        'userId': userId,
        'exams': {
          examId: {
            'score': score,
            'timestamp': FieldValue.serverTimestamp(),
          }
        },
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  /// Get aggregated leaderboard across all shards
  Future<List<Map<String, dynamic>>> getLeaderboard({
    required String examId,
    int limit = 100,
  }) async {
    final List<Map<String, dynamic>> allScores = [];

    // Query all shards in parallel
    final futures = List.generate(10, (shardId) {
      return _firestore.collection('leaderboard_shard_$shardId').get();
    });

    final results = await Future.wait(futures);

    for (final snapshot in results) {
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final exams = data['exams'] as Map<String, dynamic>?;

        if (exams != null && exams.containsKey(examId)) {
          final examData = exams[examId] as Map<String, dynamic>;
          allScores.add({
            'userId': data['userId'],
            'score': examData['score'],
            'timestamp': examData['timestamp'],
          });
        }
      }
    }

    // Sort by score descending
    allScores.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

    return allScores.take(limit).toList();
  }

  /// Increment counter with distributed counter pattern
  Future<void> incrementCounter({
    required String counterId,
    required String field,
    int incrementBy = 1,
  }) async {
    // Use 10 shards for distributed counter
    final shardId = DateTime.now().millisecondsSinceEpoch % 10;

    await _firestore
        .collection('counters')
        .doc(counterId)
        .collection('shards')
        .doc('shard_$shardId')
        .set({
      field: FieldValue.increment(incrementBy),
    }, SetOptions(merge: true));
  }

  /// Get counter value by aggregating all shards
  Future<int> getCounterValue({
    required String counterId,
    required String field,
  }) async {
    final snapshot = await _firestore
        .collection('counters')
        .doc(counterId)
        .collection('shards')
        .get();

    int total = 0;
    for (final doc in snapshot.docs) {
      final value = doc.data()[field] as int?;
      if (value != null) {
        total += value;
      }
    }

    return total;
  }
}
