import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String fetchBackgroundNotificationsTask = "fetchBackgroundNotifications";

/// Entry point for the background task
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackgroundNotificationsTask:
        try {
          // 1. Initialize Firebase
          await Firebase.initializeApp();

          // 2. Initialize Local Notifications
          final FlutterLocalNotificationsPlugin
              flutterLocalNotificationsPlugin =
              FlutterLocalNotificationsPlugin();
          const AndroidInitializationSettings initializationSettingsAndroid =
              AndroidInitializationSettings('@mipmap/ic_launcher');
          const InitializationSettings initializationSettings =
              InitializationSettings(android: initializationSettingsAndroid);
          await flutterLocalNotificationsPlugin
              .initialize(initializationSettings);

          // 3. Get User ID (We need to store it in SharedPreferences because Auth might not be ready)
          final prefs = await SharedPreferences.getInstance();
          final userId = prefs.getString('current_user_id');

          if (userId != null) {
            // 4. Check for new notifications in Firestore
            // We check for notifications created in the last 20 minutes (since task runs ~15 min)
            final now = DateTime.now();
            final twentyMinutesAgo = now.subtract(const Duration(minutes: 20));

            final snapshot = await FirebaseFirestore.instance
                .collection('notifications')
                .where('userId', isEqualTo: userId)
                .where('read', isEqualTo: false)
                .where('createdAt', isGreaterThan: twentyMinutesAgo)
                .get();

            for (var doc in snapshot.docs) {
              final data = doc.data();

              // Show Notification
              await flutterLocalNotificationsPlugin.show(
                doc.id.hashCode,
                data['title'] ?? 'New Notification',
                data['message'] ?? 'You have a new message',
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    'quiz_app_background',
                    'Background Notifications',
                    channelDescription:
                        'Notifications received while app is closed',
                    importance: Importance.high,
                    priority: Priority.high,
                    largeIcon: const DrawableResourceAndroidBitmap(
                        '@mipmap/ic_launcher'),
                    styleInformation: BigTextStyleInformation(
                      data['message'] ?? '',
                      htmlFormatBigText: true,
                      contentTitle: data['title'],
                      htmlFormatContentTitle: true,
                    ),
                  ),
                ),
              );
            }
          }
        } catch (e) {
          print("Background fetch failed: $e");
          return Future.value(false);
        }
        break;
    }
    return Future.value(true);
  });
}

class BackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true, // Set to false in production
    );
  }

  static Future<void> registerPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      "1",
      fetchBackgroundNotificationsTask,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  // Helper to save current user ID for background access
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user_id', userId);
  }
}
