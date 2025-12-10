import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/notification_preferences_model.dart';
import 'package:quiz_app/services/notification_service.dart';
import 'package:quiz_app/services/professional_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  final _notificationService = NotificationService();
  NotificationPreferences? _preferences;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final prefs = await _notificationService.getUserPreferences(user.uid);
      setState(() {
        _preferences = prefs;
        _isLoading = false;
      });
    }
  }

  Future<void> _savePreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _preferences != null) {
      await _notificationService.saveUserPreferences(user.uid, _preferences!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preferences saved successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _preferences == null
              ? const Center(child: Text('Error loading preferences'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SwitchListTile(
                      title: const Text('Enable In-App Notifications'),
                      subtitle:
                          const Text('Receive notifications within the app'),
                      value: _preferences!.enableInAppNotifications,
                      onChanged: (value) {
                        setState(() {
                          _preferences = _preferences!
                              .copyWith(enableInAppNotifications: value);
                        });
                        _savePreferences();
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Enable Event Reminders'),
                      subtitle:
                          const Text('Get reminders before scheduled events'),
                      value: _preferences!.enableEventReminders,
                      onChanged: (value) {
                        setState(() {
                          _preferences = _preferences!
                              .copyWith(enableEventReminders: value);
                        });
                        _savePreferences();
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Daily Motivation Time'),
                      subtitle: FutureBuilder<SharedPreferences>(
                        future: SharedPreferences.getInstance(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return const Text('Loading...');
                          final hour =
                              snapshot.data!.getInt('motivation_hour') ?? 9;
                          final minute =
                              snapshot.data!.getInt('motivation_minute') ?? 0;
                          final time = TimeOfDay(hour: hour, minute: minute);
                          return Text(time.format(context));
                        },
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final hour = prefs.getInt('motivation_hour') ?? 9;
                        final minute = prefs.getInt('motivation_minute') ?? 0;
                        final initialTime =
                            TimeOfDay(hour: hour, minute: minute);

                        if (context.mounted) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: initialTime,
                          );

                          if (time != null && context.mounted) {
                            // Update UI immediately
                            setState(() {});

                            // Save to Service
                            // We use the ProfessionalNotificationService for this new feature
                            await ProfessionalNotificationService()
                                .updateDailyMotivationTime(time);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Daily motivation time updated!')),
                            );
                          }
                        }
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Reminder Time'),
                      subtitle: Text(_getReminderTimeText()),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showReminderTimePicker(),
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Notification Types',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // ... rest of the existing checkboxes ...
                    CheckboxListTile(
                      title: const Text('Class Invites'),
                      value: _preferences!.enabledNotificationTypes
                          .contains('classInvite'),
                      onChanged: (value) {
                        setState(() {
                          final types = Set<String>.from(
                              _preferences!.enabledNotificationTypes);
                          if (value == true) {
                            types.add('classInvite');
                          } else {
                            types.remove('classInvite');
                          }
                          _preferences = _preferences!
                              .copyWith(enabledNotificationTypes: types);
                        });
                        _savePreferences();
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Quiz Posted'),
                      value: _preferences!.enabledNotificationTypes
                          .contains('quizPosted'),
                      onChanged: (value) {
                        setState(() {
                          final types = Set<String>.from(
                              _preferences!.enabledNotificationTypes);
                          if (value == true) {
                            types.add('quizPosted');
                          } else {
                            types.remove('quizPosted');
                          }
                          _preferences = _preferences!
                              .copyWith(enabledNotificationTypes: types);
                        });
                        _savePreferences();
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Schedule Updates'),
                      value: _preferences!.enabledNotificationTypes
                          .contains('scheduleUpdate'),
                      onChanged: (value) {
                        setState(() {
                          final types = Set<String>.from(
                              _preferences!.enabledNotificationTypes);
                          if (value == true) {
                            types.add('scheduleUpdate');
                          } else {
                            types.remove('scheduleUpdate');
                          }
                          _preferences = _preferences!
                              .copyWith(enabledNotificationTypes: types);
                        });
                        _savePreferences();
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('General Notifications'),
                      value: _preferences!.enabledNotificationTypes
                          .contains('general'),
                      onChanged: (value) {
                        setState(() {
                          final types = Set<String>.from(
                              _preferences!.enabledNotificationTypes);
                          if (value == true) {
                            types.add('general');
                          } else {
                            types.remove('general');
                          }
                          _preferences = _preferences!
                              .copyWith(enabledNotificationTypes: types);
                        });
                        _savePreferences();
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Sound Effects'),
                      subtitle: const Text('Play sounds for quiz interactions'),
                      value: true, // TODO: Connect to SoundService
                      onChanged: (value) {
                        // TODO: Implement sound toggle
                        // SoundService().setSoundEnabled(value);
                      },
                    ),
                  ],
                ),
    );
  }

  String _getReminderTimeText() {
    final minutes = _preferences!.reminderTimeBefore.inMinutes;
    if (minutes < 60) {
      return '$minutes minutes before';
    } else if (minutes < 1440) {
      return '${minutes ~/ 60} hour${minutes ~/ 60 > 1 ? 's' : ''} before';
    } else {
      return '${minutes ~/ 1440} day${minutes ~/ 1440 > 1 ? 's' : ''} before';
    }
  }

  Future<void> _showReminderTimePicker() async {
    final options = [
      const Duration(minutes: 15),
      const Duration(minutes: 30),
      const Duration(hours: 1),
      const Duration(hours: 2),
      const Duration(hours: 6),
      const Duration(days: 1),
    ];

    final selected = await showDialog<Duration>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reminder Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((duration) {
            String label;
            if (duration.inMinutes < 60) {
              label = '${duration.inMinutes} minutes before';
            } else if (duration.inHours < 24) {
              label =
                  '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''} before';
            } else {
              label =
                  '${duration.inDays} day${duration.inDays > 1 ? 's' : ''} before';
            }

            return ListTile(
              title: Text(label),
              selected: duration == _preferences!.reminderTimeBefore,
              onTap: () => Navigator.pop(context, duration),
            );
          }).toList(),
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        _preferences = _preferences!.copyWith(reminderTimeBefore: selected);
      });
      _savePreferences();
    }
  }
}
