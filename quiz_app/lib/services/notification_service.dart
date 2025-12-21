import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/models/notification_model.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app/models/notification_preferences_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      // Fallback to UTC if local timezone fails
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Initialize Firebase Cloud Messaging
  Future<void> initializeFCM() async {
    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request permission
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('FCM permission granted');

        // For iOS: Get APNS token (may be null initially)
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          try {
            final apnsToken = await messaging.getAPNSToken();
            if (apnsToken != null) {
              debugPrint('APNS Token: $apnsToken');
            } else {
              debugPrint(
                  'APNS token is null - FCM may not work properly on iOS until token is available');
            }
          } catch (e) {
            debugPrint('Error getting APNS token: $e');
          }
        }

        // Get FCM token with error handling
        try {
          final token = await messaging.getToken();
          if (token != null) {
            debugPrint('FCM Token: $token');

            // Save to Firestore
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await _firestore
                  .collection('users')
                  .doc(user.uid)
                  .update({'fcmToken': token});
            }
          }
        } catch (e) {
          debugPrint('Error getting FCM token: $e');
          // Continue without FCM token - app can still work
        }

        // Handle token refresh
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await _firestore
                .collection('users')
                .doc(user.uid)
                .update({'fcmToken': newToken});
          }
        });

        // Handle foreground messages
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          debugPrint('Foreground message: ${message.notification?.title}');
          if (message.notification != null) {
            showNotification(
              title: message.notification!.title ?? '',
              body: message.notification!.body ?? '',
            );
          }
        });
      }
    } catch (e) {
      debugPrint('Error initializing FCM: $e');
    }
  }

  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleDailyNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Time for a Quiz!',
        'Keep your streak alive! Play a quick quiz now.',
        _nextInstanceOfSixPM(),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'daily_reminder_channel', 'Daily Reminders',
                channelDescription: 'Daily reminder to play quiz',
                importance: Importance.max,
                priority: Priority.high)),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'general_notifications',
      'General Notifications',
      channelDescription: 'General app notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Schedule a local notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'study_reminders',
            'Study Reminders',
            channelDescription: 'Reminders to review your study cards',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      debugPrint('Scheduled notification $id for $scheduledDate');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // Firestore Integration
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of notifications for a user
  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID
        return NotificationModel.fromJson(data);
      }).toList();
    });
  }

  // Get unread count
  Stream<int> getUnreadCount(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Send a notification
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) async {
    final id = _firestore.collection('notifications').doc().id;
    final notification = NotificationModel(
      id: id,
      userId: userId,
      title: title,
      body: body,
      type: type,
      createdAt: DateTime.now(),
      data: data,
    );

    await _firestore
        .collection('notifications')
        .doc(id)
        .set(notification.toJson());
  }

  // Mark as read
  Future<void> markAsRead(String notificationId) async {
    await _firestore
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  // Mark all as read
  Future<void> markAllAsRead(String userId) async {
    final batch = _firestore.batch();
    final query = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in query.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }

  // Schedule a reminder notification for an event
  Future<void> scheduleEventReminder({
    required String eventId,
    required String title,
    required String body,
    required DateTime scheduledAt,
    Duration reminderBefore = const Duration(hours: 1),
  }) async {
    try {
      final reminderTime = scheduledAt.subtract(reminderBefore);
      final now = DateTime.now();

      debugPrint('=== Event Reminder Scheduling ===');
      debugPrint('Event ID: $eventId');
      debugPrint('Event time: $scheduledAt');
      debugPrint('Reminder before: $reminderBefore');
      debugPrint('Reminder time: $reminderTime');
      debugPrint('Current time: $now');
      debugPrint('Is future: ${reminderTime.isAfter(now)}');

      // Only schedule if reminder is in the future
      if (reminderTime.isAfter(now)) {
        debugPrint('Scheduling notification for $reminderTime');
        await flutterLocalNotificationsPlugin.zonedSchedule(
          eventId.hashCode, // Use event ID hash as notification ID
          title,
          body,
          tz.TZDateTime.from(reminderTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'event_reminders',
              'Event Reminders',
              channelDescription: 'Reminders for scheduled class events',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        debugPrint('✅ Notification scheduled successfully!');
      } else {
        debugPrint('⚠️ Reminder time is in the past, not scheduling');
      }
    } catch (e) {
      debugPrint('❌ Error scheduling event reminder: $e');
    }
  }

  // Cancel an event reminder
  Future<void> cancelEventReminder(String eventId) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(eventId.hashCode);
    } catch (e) {
      debugPrint('Error canceling event reminder: $e');
    }
  }

  // Notification Preferences Management
  Future<NotificationPreferences> getUserPreferences(String userId) async {
    try {
      final doc = await _firestore
          .collection('user_preferences')
          .doc(userId)
          .collection('settings')
          .doc('notifications')
          .get();

      if (doc.exists) {
        return NotificationPreferences.fromJson(doc.data()!);
      }
      return NotificationPreferences(); // Return defaults
    } catch (e) {
      debugPrint('Error loading notification preferences: $e');
      return NotificationPreferences();
    }
  }

  Future<void> saveUserPreferences(
      String userId, NotificationPreferences preferences) async {
    try {
      await _firestore
          .collection('user_preferences')
          .doc(userId)
          .collection('settings')
          .doc('notifications')
          .set(preferences.toJson());
    } catch (e) {
      debugPrint('Error saving notification preferences: $e');
    }
  }

  // Check if notification should be sent based on preferences
  Future<bool> shouldSendNotification(
      String userId, NotificationType type) async {
    final prefs = await getUserPreferences(userId);
    if (!prefs.enableInAppNotifications) return false;
    return prefs.enabledNotificationTypes.contains(type.name);
  }

  tz.TZDateTime _nextInstanceOfSixPM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 18); // 6 PM
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
