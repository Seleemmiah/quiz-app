import 'package:flutter/material.dart';
import 'package:quiz_app/models/class_model.dart';
import 'package:quiz_app/services/class_service.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/widgets/glass_dialog.dart';

class ScheduleClassScreen extends StatefulWidget {
  final ClassModel classModel;
  final Map<String, dynamic>? existingEvent; // For edit mode
  final String? eventId; // For edit mode

  const ScheduleClassScreen({
    super.key,
    required this.classModel,
    this.existingEvent,
    this.eventId,
  });

  @override
  State<ScheduleClassScreen> createState() => _ScheduleClassScreenState();
}

class _ScheduleClassScreenState extends State<ScheduleClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  Duration _selectedReminderTime = const Duration(hours: 1); // Default 1 hour
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill form if editing
    if (widget.existingEvent != null) {
      _titleController.text = widget.existingEvent!['title'] as String;
      _descriptionController.text =
          widget.existingEvent!['description'] as String? ?? '';
      final scheduledAt = DateTime.fromMillisecondsSinceEpoch(
          widget.existingEvent!['scheduledAt'] as int);
      _selectedDate = scheduledAt;
      _selectedTime = TimeOfDay.fromDateTime(scheduledAt);
      // Load reminder time if exists
      final reminderMinutes =
          widget.existingEvent!['reminderBeforeMinutes'] as int?;
      if (reminderMinutes != null) {
        _selectedReminderTime = Duration(minutes: reminderMinutes);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    // Ensure initialDate is not before firstDate.
    // If _selectedDate is in the past, use `now` as the initial date.
    final initialPickerDate = _selectedDate.isBefore(now) ? now : _selectedDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialPickerDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _scheduleEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final scheduledDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      if (widget.eventId != null) {
        // Update existing event
        await ClassService().updateEvent(
          eventId: widget.eventId!,
          classId: widget.classModel.classId,
          title: _titleController.text,
          description: _descriptionController.text,
          scheduledAt: scheduledDateTime,
        );
      } else {
        // Create new event
        await ClassService().scheduleEvent(
          classId: widget.classModel.classId,
          title: _titleController.text,
          description: _descriptionController.text,
          scheduledAt: scheduledDateTime,
          reminderBeforeMinutes: _selectedReminderTime.inMinutes,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.eventId != null
                  ? 'Event updated successfully!'
                  : 'Event scheduled successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventId != null ? 'Edit Event' : 'Schedule Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schedule for ${widget.classModel.className}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  hintText: 'e.g., Live Review Session',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'e.g., We will cover Chapter 5...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              const Text('Date & Time',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        DateFormat.yMMMd().format(_selectedDate),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectTime(context),
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        _selectedTime.format(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Remind me',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(_getReminderTimeText()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showReminderTimePicker(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _scheduleEvent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(widget.eventId != null
                          ? 'Update Event'
                          : 'Schedule Event'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getReminderTimeText() {
    final minutes = _selectedReminderTime.inMinutes;
    if (minutes < 60) {
      return '$minutes minutes before';
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      return '$hours hour${hours > 1 ? 's' : ''} before';
    } else {
      final days = minutes ~/ 1440;
      return '$days day${days > 1 ? 's' : ''} before';
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

    final selected = await GlassDialog.show<Duration>(
      context: context,
      title: 'Reminder Time',
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
            selected: duration == _selectedReminderTime,
            onTap: () => Navigator.pop(context, duration),
          );
        }).toList(),
      ),
    );

    if (selected != null) {
      setState(() {
        _selectedReminderTime = selected;
      });
    }
  }
}
