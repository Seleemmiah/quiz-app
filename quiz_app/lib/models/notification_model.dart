enum NotificationType {
  classInvite,
  quizPosted,
  general,
  scheduleUpdate,
}

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type.name,
      'isRead': isRead,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'data': data,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'body' and 'message' fields
    final body = (json['body'] ?? json['message'] ?? '') as String;

    // Handle both 'title' formats
    final title = (json['title'] ?? 'Notification') as String;

    // Handle type - could be string or enum name
    final typeString = json['type'] as String?;
    NotificationType type = NotificationType.general;
    if (typeString != null) {
      try {
        type = NotificationType.values.firstWhere(
          (e) => e.name == typeString,
          orElse: () => NotificationType.general,
        );
      } catch (e) {
        type = NotificationType.general;
      }
    }

    // Handle createdAt - could be Timestamp or int
    DateTime createdAt;
    try {
      if (json['createdAt'] is int) {
        createdAt =
            DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int);
      } else if (json['createdAt'] != null) {
        // Handle Firestore Timestamp
        final timestamp = json['createdAt'];
        createdAt = timestamp.toDate();
      } else {
        createdAt = DateTime.now();
      }
    } catch (e) {
      createdAt = DateTime.now();
    }

    return NotificationModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: title,
      body: body,
      type: type,
      isRead: json['read'] as bool? ?? json['isRead'] as bool? ?? false,
      createdAt: createdAt,
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}
