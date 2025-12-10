import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:async';
import 'dart:math';
import 'package:quiz_app/services/statistics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Professional Notification Service
/// Handles all app notifications - in-app, push, and smart scheduling based on user performance
class ProfessionalNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final StatisticsService _statisticsService = StatisticsService();

  StreamSubscription<QuerySnapshot>? _notificationListener;
  Set<String> _processedNotifications = {};
  Timer? _motivationalTimer;

  // --- EXTENSIVE QUOTE LIBRARY ---

  // High Performance Quotes (Average > 80%)
  static const List<String> _highPerformanceQuotes = [
    "🔥 You're on fire! Keep that streak alive!",
    "🏆 Excellence is not an act, but a habit. You're proving it!",
    "🚀 The sky is the limit! Your recent results are outstanding.",
    "💎 You're mastering this! What's your next challenge?",
    "🌟 A+ Performance! Don't stop now, you're unstoppable!",
    "🎓 You're crushing it! Future expert loading...",
    "⚡ Your brain is in beast mode today!",
    "🥇 Gold standard effort! Keep setting the bar high.",
    "🧠 Your knowledge is compounding. Keep investing!",
    "🎈 Fantastic work! Learning looks good on you.",
  ];

  // Improvement Needed (Average < 50%)
  static const List<String> _encouragementQuotes = [
    "🌱 All experts were once beginners. Keep going!",
    "💪 Mistakes are proof that you are trying.",
    "📉 Failure is just the opportunity to begin again more intelligently.",
    "🚶‍♂️ Small steps every day add up to big results.",
    "🧗‍♀️ The view is best from the top, keep climbing!",
    "🦁 Courage doesn't always roar. Sometimes it's trying again tomorrow.",
    "🧱 Don't give up. Great things take time.",
    "✨ Your potential is greater than you think. Believe it!",
    "📚 One more quiz could make it click. Try again!",
    "🔄 Consistency beats intensity. Just show up today.",
  ];

  // Routine / Maintenance (50-80% or New User)
  static const List<String> _generalQuotes = [
    "⏱️ 5 minutes of learning today > 0 minutes.",
    "🧠 Is your brain hungry? Feed it a quiz!",
    "📅 Make today count. Learn something new.",
    "💡 Knowledge is power. Charge up!",
    "🔋 Recharge your mind with a quick challenge.",
    "🎯 Stay focused, stay sharp.",
    "🌊 Learning is a journey, enjoy the ride.",
    "🔑 Education unlocks doors. Keep collecting keys.",
    "📱 Turn scrolling time into learning time.",
    "🧘‍♀️ A disciplined mind leads to happiness.",
  ];

  /// Initialize the notification service
  Future<void> initialize() async {
    tz.initializeTimeZones(); // Ensure timezones are initialized

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

    // Request permissions
    await _requestPermissions();

    // Configure FCM
    await _configureFCM();

    // Start smart scheduling
    _scheduleMotivationalNotifications();
  }

  Future<void> _requestPermissions() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  Future<void> _configureFCM() async {
    // Get and save FCO token
    try {
      String? token = await _fcm.getToken();
      if (token != null) {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          await _firestore.collection('users').doc(userId).update({
            'fcmToken': token,
            'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      // Listen for token refresh
      _fcm.onTokenRefresh.listen((newToken) async {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          await _firestore.collection('users').doc(userId).update({
            'fcmToken': newToken,
            'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      debugPrint('Error configuring FCM: $e');
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(
        id: message.hashCode,
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
        payload: message.data.toString(),
      );
    });

    // Handle background opens
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message.data);
    });
  }

  // ==================== SMART SCHEDULING ====================

  /// Update the daily motivation time
  Future<void> updateDailyMotivationTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('motivation_hour', time.hour);
    await prefs.setInt('motivation_minute', time.minute);

    // Reschedule immediately
    _scheduleMotivationalNotifications();
  }

  /// Schedule daily motivational notifications based on user stats
  Future<void> _scheduleMotivationalNotifications() async {
    // Cancel existing timer/schedules
    _motivationalTimer?.cancel();

    // Check if we should use a custom time
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('motivation_hour') ?? 9; // Default 9 AM
    final minute = prefs.getInt('motivation_minute') ?? 0;

    // Schedule the job
    await _scheduleDailyJob(hour, minute);
  }

  Future<void> _scheduleDailyJob(int hour, int minute) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Get the smart message based on CURRENT performance
    final message = await _getSmartMessage();

    // Cancel previous motivation notification to avoid duplicates
    await _localNotifications.cancel(101);

    await _localNotifications.zonedSchedule(
      101, // ID for motivation
      'Daily Mindly Motivation 🎓',
      message,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'motivation_channel',
          'Daily Motivation',
          channelDescription: 'Daily inspiring quotes',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.time, // Repeat daily at this time
    );

    debugPrint('📅 Scheduled smart motivation for: $scheduledDate');
  }

  Future<String> _getSmartMessage() async {
    try {
      final stats = await _statisticsService.getStatistics();
      final average = stats.averageScore;
      final totalQuizzes = stats.totalQuizzes;

      final random = Random();

      if (totalQuizzes < 3) {
        // New user
        return _generalQuotes[random.nextInt(_generalQuotes.length)];
      } else if (average >= 80) {
        return _highPerformanceQuotes[
            random.nextInt(_highPerformanceQuotes.length)];
      } else if (average < 50) {
        return _encouragementQuotes[
            random.nextInt(_encouragementQuotes.length)];
      } else {
        return _generalQuotes[random.nextInt(_generalQuotes.length)];
      }
    } catch (e) {
      return "🚀 Keep learning every day!"; // Fallback
    }
  }

  // ==================== NOTIFICATION HANDLING ====================

  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'quiz_app_channel',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      // Handle navigation logic here if needed
    }
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    // Implement deep linking logic here
  }

  // ==================== FIRESTORE HELPERS ====================

  Future<void> _sendNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    await _firestore.collection('notifications').add({
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
      'data': data,
    });
  }

  // ==================== APP EVENTS ====================

  Future<void> sendWelcomeNotification(String userId, String username) async {
    await _sendNotification(
      userId: userId,
      title: 'When learning meets fun! 🎓',
      message: 'Hi $username! Let\'s smarten up together.',
      type: 'welcome',
    );
  }

  Future<void> sendProfileCompletedNotification(String userId) async {
    await _sendNotification(
      userId: userId,
      title: '✅ All Set!',
      message: 'Your profile is ready. Let\'s pass some quizzes!',
      type: 'profile',
    );
  }

  Future<void> sendQuizScoreNotification({
    required String userId,
    required int score,
    required int totalQuestions,
    required String quizTitle,
  }) async {
    final percentage = (score / totalQuestions * 100).round();

    if (percentage >= 60) {
      await sendQuizPassedNotification(
        userId: userId,
        score: score,
        totalQuestions: totalQuestions,
        quizTitle: quizTitle,
      );
    } else {
      await sendQuizFailedNotification(
        userId: userId,
        score: score,
        totalQuestions: totalQuestions,
        quizTitle: quizTitle,
      );
    }
  }

  Future<void> sendQuizPassedNotification({
    required String userId,
    required int score,
    required int totalQuestions,
    required String quizTitle,
  }) async {
    final percentage = (score / totalQuestions * 100).round();
    await _sendNotification(
      userId: userId,
      title: '🎉 Quiz Passed!',
      message: 'You scored $percentage% on "$quizTitle". Great job!',
      type: 'quiz_passed',
      data: {'score': score, 'total': totalQuestions, 'quiz': quizTitle},
    );
  }

  Future<void> sendQuizFailedNotification({
    required String userId,
    required int score,
    required int totalQuestions,
    required String quizTitle,
  }) async {
    final percentage = (score / totalQuestions * 100).round();
    await _sendNotification(
      userId: userId,
      title: '📚 Keep Trying!',
      message: 'You scored $percentage% on "$quizTitle". Try again!',
      type: 'quiz_failed',
      data: {'score': score, 'total': totalQuestions, 'quiz': quizTitle},
    );
  }

  Future<void> sendPerfectScoreNotification({
    required String userId,
    required String quizTitle,
  }) async {
    await _sendNotification(
      userId: userId,
      title: '🌟 Perfect Score!',
      message: '100% on "$quizTitle"! Absolutely flawless!',
      type: 'perfect_score',
      data: {'quizTitle': quizTitle},
    );
  }

  // ==================== EXAM EVENTS ====================

  Future<void> sendExamCreatedNotification({
    required List<String> studentIds,
    required String examTitle,
    required DateTime examTime,
    required String examId,
  }) async {
    for (final studentId in studentIds) {
      await _sendNotification(
        userId: studentId,
        title: '📝 Exam Alert',
        message: 'Exam "$examTitle" is set for ${_formatDateTime(examTime)}',
        type: 'exam_created',
        data: {'examId': examId},
      );
      await scheduleExamReminders(
          userId: studentId,
          examTitle: examTitle,
          examTime: examTime,
          examId: examId);
    }
  }

  Future<void> scheduleExamReminders({
    required String userId,
    required String examTitle,
    required DateTime examTime,
    required String examId,
  }) async {
    // Schedule reminders
    final now = DateTime.now();
    if (examTime.subtract(Duration(hours: 1)).isAfter(now)) {
      // Placeholder for reminder scheduling implementation
    }
  }

  Future<void> sendExamStartingNotification({
    required String userId,
    required String examTitle,
  }) async {
    await _sendNotification(
      userId: userId,
      title: '🚀 Exam Started',
      message: '"$examTitle" is happening now. Good luck!',
      type: 'exam_starting',
    );
  }

  Future<void> sendExamCompletedNotification({
    required String userId,
    required String examTitle,
    required int score,
    required int totalQuestions,
  }) async {
    // ...
  }

  // ==================== ACHIEVEMENT & CLASS EVENTS ====================

  Future<void> sendAchievementNotification({
    required String userId,
    required String achievementTitle,
    required String achievementDescription,
  }) async {
    await _sendNotification(
      userId: userId,
      title: '🏆 Achievement Unlocked!',
      message: '$achievementTitle: $achievementDescription',
      type: 'achievement',
    );
  }

  Future<void> sendLevelUpNotification({
    required String userId,
    required int newLevel,
  }) async {
    await _sendNotification(
      userId: userId,
      title: '🆙 Level Up!',
      message: 'You reached Level $newLevel! Keep it up!',
      type: 'level_up',
    );
  }

  Future<void> sendStreakMilestoneNotification({
    required String userId,
    required int streakDays,
  }) async {
    await _sendNotification(
      userId: userId,
      title: '🔥 $streakDays Day Streak!',
      message: 'You\'re unstoppable! $streakDays days.',
      type: 'streak',
    );
  }

  Future<void> sendClassJoinedNotification({
    required String userId,
    required String className,
  }) async {
    await _sendNotification(
      userId: userId,
      title: '👥 Class Joined',
      message: 'Welcome to "$className".',
      type: 'class_joined',
    );
  }

  Future<void> sendClassAnnouncement({
    required String classId,
    required String title,
    required String message,
  }) async {
    // Fetch students and send
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void dispose() {
    _notificationListener?.cancel();
    _motivationalTimer?.cancel();
  }
}
