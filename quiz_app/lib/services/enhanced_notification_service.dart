import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Enhanced notification service for in-app and push notifications
class EnhancedNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize notification service
  Future<void> initialize() async {
    // Request permission for iOS
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token and save to Firestore
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveFCMToken(token);
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen(_saveFCMToken);
  }

  /// Save FCM token to user's document
  Future<void> _saveFCMToken(String token) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection('users').doc(userId).set({
      'fcmToken': token,
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Send notification to a specific user
  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String message,
    String type = 'general',
    Map<String, dynamic>? data,
  }) async {
    try {
      // Create notification document in Firestore
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
        'data': data ?? {},
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });

      // The Cloud Function will handle sending the push notification
      // based on the user's FCM token
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  /// Send exam reminder notification
  Future<void> sendExamReminder({
    required String userId,
    required String examTitle,
    required DateTime examTime,
    required String examId,
  }) async {
    final minutesUntilExam = examTime.difference(DateTime.now()).inMinutes;

    String message;
    if (minutesUntilExam <= 5) {
      message = '⏰ Your exam "$examTitle" starts in $minutesUntilExam minutes!';
    } else if (minutesUntilExam <= 30) {
      message = '📝 Reminder: "$examTitle" starts in $minutesUntilExam minutes';
    } else {
      message = '📅 Upcoming exam: "$examTitle" at ${_formatTime(examTime)}';
    }

    await sendNotificationToUser(
      userId: userId,
      title: '🎓 Exam Reminder',
      message: message,
      type: 'exam_reminder',
      data: {
        'examId': examId,
        'examTitle': examTitle,
        'examTime': examTime.toIso8601String(),
      },
    );
  }

  /// Send notification to all students in a class
  Future<void> sendClassNotification({
    required String classId,
    required String title,
    required String message,
    String type = 'class',
    Map<String, dynamic>? data,
  }) async {
    try {
      // Get all students in the class
      final classDoc =
          await _firestore.collection('classes').doc(classId).get();
      final studentIds = List<String>.from(classDoc.data()?['students'] ?? []);

      // Send notification to each student
      for (final studentId in studentIds) {
        await sendNotificationToUser(
          userId: studentId,
          title: title,
          message: message,
          type: type,
          data: {...?data, 'classId': classId},
        );
      }
    } catch (e) {
      print('Error sending class notification: $e');
    }
  }

  /// Send quiz completion notification
  Future<void> sendQuizCompletionNotification({
    required String userId,
    required int score,
    required int totalQuestions,
    required String quizTitle,
  }) async {
    final percentage = (score / totalQuestions * 100).round();
    String emoji = percentage >= 80
        ? '🎉'
        : percentage >= 60
            ? '👍'
            : '📚';

    await sendNotificationToUser(
      userId: userId,
      title: '$emoji Quiz Completed!',
      message:
          'You scored $score/$totalQuestions ($percentage%) on "$quizTitle"',
      type: 'quiz_completion',
      data: {
        'score': score,
        'totalQuestions': totalQuestions,
        'percentage': percentage,
      },
    );
  }

  /// Send achievement unlocked notification
  Future<void> sendAchievementNotification({
    required String userId,
    required String achievementTitle,
    required String achievementDescription,
  }) async {
    await sendNotificationToUser(
      userId: userId,
      title: '🏆 Achievement Unlocked!',
      message: '$achievementTitle - $achievementDescription',
      type: 'achievement',
      data: {
        'achievementTitle': achievementTitle,
      },
    );
  }

  /// Schedule exam reminder notifications
  Future<void> scheduleExamReminders({
    required String examId,
    required String examTitle,
    required DateTime examTime,
    required List<String> studentIds,
  }) async {
    // Send reminders at different intervals
    final now = DateTime.now();
    final timeUntilExam = examTime.difference(now);

    // Schedule reminders for 1 day, 1 hour, and 5 minutes before
    final reminderTimes = [
      Duration(days: 1),
      Duration(hours: 1),
      Duration(minutes: 5),
    ];

    for (final reminderTime in reminderTimes) {
      if (timeUntilExam > reminderTime) {
        // Create a scheduled notification document
        await _firestore.collection('scheduled_notifications').add({
          'examId': examId,
          'examTitle': examTitle,
          'examTime': Timestamp.fromDate(examTime),
          'studentIds': studentIds,
          'sendAt': Timestamp.fromDate(examTime.subtract(reminderTime)),
          'type': 'exam_reminder',
          'sent': false,
        });
      }
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }
}
