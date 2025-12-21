import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/notification_model.dart';
import 'package:quiz_app/services/notification_service.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view notifications')),
      );
    }

    final notificationService = NotificationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: () => notificationService.markAllAsRead(user.uid),
          ),
        ],
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: notificationService.getUserNotifications(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Dismissible(
                key: Key(notification.id),
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  notificationService.deleteNotification(notification.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notification deleted'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Card(
                  elevation: notification.isRead ? 0 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: notification.isRead
                          ? Colors.transparent
                          : Theme.of(context)
                              .primaryColor
                              .withOpacity(0.3),
                      width: notification.isRead ? 0 : 1.5,
                    ),
                  ),
                  color: notification.isRead
                      ? Theme.of(context).cardColor
                      : Theme.of(context).primaryColor.withOpacity(0.05),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (!notification.isRead) {
                        notificationService.markAsRead(notification.id);
                      }
                      _handleNavigation(context, notification);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // App Icon + Notification Type Icon
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Main app icon
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    '🎓',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              // Small notification type badge
                              Positioned(
                                right: -3,
                                bottom: -3,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: notification.isRead
                                        ? Colors.grey
                                        : Theme.of(context).primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(context).cardColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Icon(
                                    _getIconForType(notification.type),
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          // Notification content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification.title,
                                        style: TextStyle(
                                          fontWeight: notification.isRead
                                              ? FontWeight.w600
                                              : FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    if (!notification.isRead)
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notification.body,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[300]
                                        : Colors.grey[700],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 12,
                                      color: Colors.grey[500],
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      _formatDate(notification.createdAt),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.classInvite:
        return Icons.group_add;
      case NotificationType.quizPosted:
        return Icons.quiz;
      case NotificationType.scheduleUpdate:
        return Icons.event;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat.jm().format(date); // 5:30 PM
    } else if (difference.inDays < 7) {
      return DateFormat.E().format(date); // Mon
    } else {
      return DateFormat.MMMd().format(date); // Jan 1
    }
  }

  void _handleNavigation(BuildContext context, NotificationModel notification) {
    if (notification.data != null) {
      final route = notification.data!['route'];
      final args = notification.data!['arguments'];

      if (route != null) {
        Navigator.pushNamed(context, route, arguments: args);
      }
    }
  }
}
