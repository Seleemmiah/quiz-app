import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

/// FREE Notification Service - No Cloud Functions Required!
/// Uses local notifications and Firestore listeners
class FreeNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<QuerySnapshot>? _notificationListener;
  Set<String> _processedNotifications = {};

  /// Initialize the notification service
  Future<void> initialize() async {
    // Initialize local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for iOS
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Start listening for new notifications
    _startListening();
  }

  /// Start listening for new notifications in Firestore
  void _startListening() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    _notificationListener = _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final doc = change.doc;
          final data = doc.data()!;

          // Only process if we haven't seen this notification before
          if (!_processedNotifications.contains(doc.id)) {
            _processedNotifications.add(doc.id);
            _showLocalNotification(
              id: doc.id.hashCode,
              title: data['title'] ?? 'Notification',
              body: data['message'] ?? '',
              payload: doc.id,
            );
          }
        }
      }
    });
  }

  /// Show a local notification
  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'quiz_app_channel',
      'Quiz Notifications',
      channelDescription: 'Notifications for quizzes, exams, and achievements',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Navigate to notifications screen or specific content
    // This will be handled by your app's navigation
    print('Notification tapped: ${response.payload}');
  }

  /// Create a notification in Firestore
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    String type = 'general',
    Map<String, dynamic>? data,
  }) async {
    await _firestore.collection('notifications').add({
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'data': data ?? {},
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
    });
  }

  /// Schedule an exam reminder
  Future<void> scheduleExamReminder({
    required String userId,
    required String examTitle,
    required DateTime examTime,
    required String examId,
  }) async {
    final now = DateTime.now();

    // Schedule notifications at different intervals
    final reminders = [
      {
        'time': examTime.subtract(const Duration(days: 1)),
        'message': '📅 Tomorrow'
      },
      {
        'time': examTime.subtract(const Duration(hours: 1)),
        'message': '⏰ In 1 hour'
      },
      {
        'time': examTime.subtract(const Duration(minutes: 5)),
        'message': '🚨 In 5 minutes'
      },
    ];

    for (var i = 0; i < reminders.length; i++) {
      final reminderTime = reminders[i]['time'] as DateTime;
      final message = reminders[i]['message'] as String;

      if (reminderTime.isAfter(now)) {
        await _scheduleNotification(
          id: examId.hashCode + i,
          title: '🎓 Exam Reminder: $examTitle',
          body: '$message - Get ready!',
          scheduledTime: reminderTime,
        );
      }
    }
  }

  /// Schedule a notification for a specific time
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'quiz_app_channel',
      'Quiz Notifications',
      channelDescription: 'Notifications for quizzes, exams, and achievements',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
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

    await sendNotification(
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

  /// Send achievement notification
  Future<void> sendAchievementNotification({
    required String userId,
    required String achievementTitle,
    required String achievementDescription,
  }) async {
    await sendNotification(
      userId: userId,
      title: '🏆 Achievement Unlocked!',
      message: '$achievementTitle - $achievementDescription',
      type: 'achievement',
      data: {'achievementTitle': achievementTitle},
    );
  }

  /// Send class announcement to all students
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
        await sendNotification(
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

  /// Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Dispose the service
  void dispose() {
    _notificationListener?.cancel();
    _processedNotifications.clear();
  }
}
