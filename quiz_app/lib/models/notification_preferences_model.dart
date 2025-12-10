class NotificationPreferences {
  final bool enableInAppNotifications;
  final bool enableEventReminders;
  final Duration reminderTimeBefore;
  final Set<String> enabledNotificationTypes;

  NotificationPreferences({
    this.enableInAppNotifications = true,
    this.enableEventReminders = true,
    this.reminderTimeBefore = const Duration(hours: 1),
    Set<String>? enabledNotificationTypes,
  }) : enabledNotificationTypes = enabledNotificationTypes ??
            {'classInvite', 'quizPosted', 'scheduleUpdate', 'general'};

  Map<String, dynamic> toJson() {
    return {
      'enableInAppNotifications': enableInAppNotifications,
      'enableEventReminders': enableEventReminders,
      'reminderTimeBeforeMinutes': reminderTimeBefore.inMinutes,
      'enabledNotificationTypes': enabledNotificationTypes.toList(),
    };
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      enableInAppNotifications:
          json['enableInAppNotifications'] as bool? ?? true,
      enableEventReminders: json['enableEventReminders'] as bool? ?? true,
      reminderTimeBefore:
          Duration(minutes: json['reminderTimeBeforeMinutes'] as int? ?? 60),
      enabledNotificationTypes:
          (json['enabledNotificationTypes'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toSet() ??
              {'classInvite', 'quizPosted', 'scheduleUpdate', 'general'},
    );
  }

  NotificationPreferences copyWith({
    bool? enableInAppNotifications,
    bool? enableEventReminders,
    Duration? reminderTimeBefore,
    Set<String>? enabledNotificationTypes,
  }) {
    return NotificationPreferences(
      enableInAppNotifications:
          enableInAppNotifications ?? this.enableInAppNotifications,
      enableEventReminders: enableEventReminders ?? this.enableEventReminders,
      reminderTimeBefore: reminderTimeBefore ?? this.reminderTimeBefore,
      enabledNotificationTypes:
          enabledNotificationTypes ?? this.enabledNotificationTypes,
    );
  }
}
