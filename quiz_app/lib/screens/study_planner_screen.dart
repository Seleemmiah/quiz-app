import 'package:flutter/material.dart';
import 'package:quiz_app/models/study_plan.dart';
import 'package:quiz_app/services/study_planner_service.dart';
import 'package:quiz_app/widgets/glass_card.dart';
import 'package:intl/intl.dart';

class StudyPlannerScreen extends StatefulWidget {
  const StudyPlannerScreen({super.key});

  @override
  State<StudyPlannerScreen> createState() => _StudyPlannerScreenState();
}

class _StudyPlannerScreenState extends State<StudyPlannerScreen> {
  final StudyPlannerService _plannerService = StudyPlannerService();
  StudyPlan? _currentPlan;
  bool _isLoading = true;

  // Form controllers
  final _examNameController = TextEditingController();
  DateTime? _selectedDate;
  final _topicsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  Future<void> _loadPlan() async {
    setState(() => _isLoading = true);
    try {
      final plan = await _plannerService.getCurrentPlan();
      if (mounted) {
        setState(() {
          _currentPlan = plan;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load plan: $e')),
        );
      }
    }
  }

  Future<void> _createPlan() async {
    if (_examNameController.text.isEmpty ||
        _selectedDate == null ||
        _topicsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final topics = _topicsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (topics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one topic')),
      );
      return;
    }

    try {
      await _plannerService.createPlan(
        examName: _examNameController.text,
        examDate: _selectedDate!,
        topics: topics,
      );
      _loadPlan();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create plan: $e')),
        );
      }
    }
  }

  Future<void> _deletePlan() async {
    try {
      await _plannerService.deletePlan();
      // Reset controllers
      _examNameController.clear();
      _topicsController.clear();
      _selectedDate = null;
      _loadPlan();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete plan: $e')),
        );
      }
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Plan?'),
        content: const Text('Are you sure you want to delete your study plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePlan();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Study Planner'),
        actions: [
          if (_currentPlan != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmation(),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentPlan == null
              ? _buildCreatePlanForm()
              : _buildPlanDashboard(),
    );
  }

  Widget _buildCreatePlanForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Create Your Study Plan 📅',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _examNameController,
                    decoration: const InputDecoration(
                      labelText: 'Exam Name (e.g., Final Exam)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Exam Date',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : DateFormat('MMM d, yyyy').format(_selectedDate!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _topicsController,
                    decoration: const InputDecoration(
                      labelText: 'Topics (comma separated)',
                      hintText: 'Math, Physics, Chemistry',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.list),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _createPlan,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Generate Plan', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanDashboard() {
    final plan = _currentPlan!;
    final today = DateTime.now();
    final todaySession = plan.sessions.firstWhere(
      (s) =>
          s.date.year == today.year &&
          s.date.month == today.month &&
          s.date.day == today.day,
      orElse: () => StudySession(
          id: '',
          date: today,
          topic: 'Rest Day',
          durationMinutes: 0,
          completed: true),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    plan.examName,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${plan.daysUntilExam} days left',
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                  Text(
                    DateFormat('MMMM d, yyyy').format(plan.examDate),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Today's Session
          const Text(
            "Today's Session",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GlassCard(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    todaySession.completed ? Colors.green : Colors.blue,
                child: Icon(
                    todaySession.completed ? Icons.check : Icons.menu_book,
                    color: Colors.white),
              ),
              title: Text(todaySession.topic),
              subtitle: Text('${todaySession.durationMinutes} mins'),
              trailing: todaySession.id.isNotEmpty && !todaySession.completed
                  ? ElevatedButton(
                      onPressed: () async {
                        await _plannerService.completeSession(todaySession.id);
                        _loadPlan();
                      },
                      child: const Text('Complete'),
                    )
                  : todaySession.completed
                      ? const Text('Done!',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold))
                      : null,
            ),
          ),
          const SizedBox(height: 24),

          // Upcoming Sessions
          const Text(
            "Upcoming Sessions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: plan.sessions.length,
            itemBuilder: (context, index) {
              final session = plan.sessions[index];
              // Skip past sessions or today (already shown)
              if (session.date.isBefore(today) ||
                  (session.date.year == today.year &&
                      session.date.month == today.month &&
                      session.date.day == today.day)) {
                return const SizedBox.shrink();
              }
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today, size: 20),
                  title: Text(session.topic),
                  subtitle: Text(DateFormat('MMM d').format(session.date)),
                  trailing: Text('${session.durationMinutes}m'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
