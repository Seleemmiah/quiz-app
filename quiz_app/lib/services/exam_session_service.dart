import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'device_fingerprint_service.dart';

/// Service for managing exam sessions and preventing concurrent access
class ExamSessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _heartbeatTimer;

  /// Start an exam session with device fingerprint validation
  /// Returns true if session started successfully, false if blocked
  Future<bool> startExamSession({
    required String examId,
    String? quizId,
  }) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return false;

      final deviceFingerprint =
          await DeviceFingerprintService.getDeviceFingerprint();
      final sessionId = '${examId}_$userId';

      // Check for existing active session
      final existingSession = await _firestore
          .collection('active_exam_sessions')
          .doc(sessionId)
          .get();

      if (existingSession.exists) {
        final data = existingSession.data();
        final storedFingerprint = data?['deviceFingerprint'];
        final lastActivity = (data?['lastActivity'] as Timestamp?)?.toDate();

        // If session exists from different device and is recent (< 5 min old)
        if (storedFingerprint != deviceFingerprint) {
          if (lastActivity != null &&
              DateTime.now().difference(lastActivity).inMinutes < 5) {
            // Reject - concurrent session detected
            return false;
          }
        }
      }

      // Create/update session
      await _firestore.collection('active_exam_sessions').doc(sessionId).set({
        'examId': examId,
        'quizId': quizId,
        'userId': userId,
        'deviceFingerprint': deviceFingerprint,
        'startTime': FieldValue.serverTimestamp(),
        'lastActivity': FieldValue.serverTimestamp(),
        'status': 'active',
      });

      // Start heartbeat to keep session alive
      _startHeartbeat(sessionId);

      return true;
    } catch (e) {
      print('Error starting exam session: $e');
      return false;
    }
  }

  /// Update session activity (heartbeat)
  void _startHeartbeat(String sessionId) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _firestore.collection('active_exam_sessions').doc(sessionId).update({
        'lastActivity': FieldValue.serverTimestamp(),
      }).catchError((e) {
        print('Heartbeat error: $e');
        timer.cancel();
      });
    });
  }

  /// End exam session
  Future<void> endExamSession({
    required String examId,
  }) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      _heartbeatTimer?.cancel();

      final sessionId = '${examId}_$userId';
      await _firestore
          .collection('active_exam_sessions')
          .doc(sessionId)
          .update({
        'status': 'completed',
        'endTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error ending exam session: $e');
    }
  }

  /// Check if user has an active session for this exam
  Future<bool> hasActiveSession({
    required String examId,
  }) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return false;

      final sessionId = '${examId}_$userId';
      final session = await _firestore
          .collection('active_exam_sessions')
          .doc(sessionId)
          .get();

      if (!session.exists) return false;

      final data = session.data();
      final status = data?['status'];
      final lastActivity = (data?['lastActivity'] as Timestamp?)?.toDate();

      // Session is active if status is 'active' and last activity was recent
      return status == 'active' &&
          lastActivity != null &&
          DateTime.now().difference(lastActivity).inMinutes < 5;
    } catch (e) {
      print('Error checking active session: $e');
      return false;
    }
  }

  /// Clean up old sessions (call this periodically or via Cloud Function)
  static Future<void> cleanupOldSessions() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final fiveMinutesAgo =
          DateTime.now().subtract(const Duration(minutes: 5));

      final oldSessions = await firestore
          .collection('active_exam_sessions')
          .where('lastActivity', isLessThan: Timestamp.fromDate(fiveMinutesAgo))
          .where('status', isEqualTo: 'active')
          .get();

      final batch = firestore.batch();
      for (final doc in oldSessions.docs) {
        batch.update(doc.reference, {
          'status': 'expired',
          'expiredAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      print('Error cleaning up old sessions: $e');
    }
  }

  void dispose() {
    _heartbeatTimer?.cancel();
  }
}
