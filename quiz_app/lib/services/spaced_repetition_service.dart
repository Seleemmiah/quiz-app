import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/statistics_service.dart';
import 'package:quiz_app/utils/firestore_error_handler.dart';

class SpacedRepetitionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Record a review outcome using SM-2 algorithm
  Future<void> recordReview(Question question, bool wasCorrect) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docId = _generateQuestionId(question);
    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('spacedRepetition')
        .doc(docId);

    await FirestoreErrorHandler.executeWithRetry(
      operation: () async {
        final doc = await docRef.get();

        int interval = 1; // days
        double easeFactor = 2.5;
        int repetitions = 0;

        if (doc.exists) {
          final data = doc.data()!;
          interval = data['interval'] ?? 1;
          easeFactor = (data['easeFactor'] ?? 2.5).toDouble();
          repetitions = data['repetitions'] ?? 0;
        }

        if (wasCorrect) {
          if (repetitions == 0) {
            interval = 1;
          } else if (repetitions == 1) {
            interval = 6;
          } else {
            interval = (interval * easeFactor).round();
          }
          repetitions++;
          // Ease factor update (modified SM-2)
          // quality: 5 if correct, adjust ease factor
          easeFactor = easeFactor + (0.1 - (5 - 5) * (0.08 + (5 - 5) * 0.02));
        } else {
          repetitions = 0;
          interval = 1;
          easeFactor = (easeFactor - 0.2).clamp(1.3, 2.5);
        }

        final nextReview = DateTime.now().add(Duration(days: interval));

        await docRef.set({
          'questionData': question.toMap(),
          'nextReview': nextReview.toIso8601String(),
          'interval': interval,
          'easeFactor': easeFactor,
          'repetitions': repetitions,
          'lastReviewed': DateTime.now().toIso8601String(),
        }, SetOptions(merge: true));
      },
      operationName: 'Record Spaced Repetition Review',
    );

    await StatisticsService().recordSpacedReview();
  }

  // Get all questions due for review today
  Future<List<Question>> getDueQuestions() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final now = DateTime.now().toIso8601String();

    final snapshot = await FirestoreErrorHandler.executeWithRetry(
      operation: () => _firestore
          .collection('users')
          .doc(user.uid)
          .collection('spacedRepetition')
          .where('nextReview', isLessThanOrEqualTo: now)
          .get(),
      operationName: 'Fetch Due SR Questions',
    );

    if (snapshot == null) return [];

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Question.fromMap(data['questionData']);
    }).toList();
  }

  // Get total count of due reviews
  Future<int> getDueCount() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    final now = DateTime.now().toIso8601String();
    try {
      final count = await FirestoreErrorHandler.executeWithRetry(
        operationName: 'Fetch Due SR Count',
        operation: () async {
          final snapshot = await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('spacedRepetition')
              .where('nextReview', isLessThanOrEqualTo: now)
              .count()
              .get();
          return snapshot.count;
        },
      );
      return count ?? 0;
    } catch (e) {
      debugPrint('Error getting due count: $e');
      return 0;
    }
  }

  String _generateQuestionId(Question q) {
    // Generate a stable ID from the question text to avoid duplicates
    return q.question.hashCode.toString();
  }
}
