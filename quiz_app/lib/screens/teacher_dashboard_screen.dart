import 'package:flutter/material.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/models/quiz_result.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/screens/create_quiz_screen.dart';
import 'package:quiz_app/services/professional_notification_service.dart';
import 'package:quiz_app/widgets/teacher_analytics.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirestoreService _firestoreService = FirestoreService();

  List<Map<String, dynamic>> _students = [];
  List<QuizResult> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final teacherId = FirebaseAuth.instance.currentUser?.uid;
      List<Map<String, dynamic>> students = [];

      if (teacherId != null) {
        students = await _firestoreService.getTeacherStudents(teacherId);
      }

      final results = await _firestoreService.getAllQuizResults();

      if (mounted) {
        setState(() {
          _students = students;
          _results = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Students', icon: Icon(Icons.people)),
            Tab(text: 'Results', icon: Icon(Icons.assignment)),
            Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildStudentList(),
                _buildResultsList(),
                _buildAnalytics(),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateExamDialog,
        icon: const Icon(Icons.add),
        label: const Text('Create Exam'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Widget _buildStudentList() {
    if (_students.isEmpty) {
      return _buildEmptyState('No students registered yet.');
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return FadeInUp(
            delay: Duration(milliseconds: index * 50),
            child: Card(
              margin: const EdgeInsets.only(bottom: 6), // Sleeker margin
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(
                    (student['username'] as String? ?? 'U')[0].toUpperCase(),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                title: Text(
                  student['username'] ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student['email'] ?? ''),
                    if (student['matricNumber'] != null)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'ID: ${student['matricNumber']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsList() {
    if (_results.isEmpty) {
      return _buildEmptyState('No quiz results yet.');
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final result = _results[index];
          final percentage = (result.score / result.totalQuestions) * 100;
          final color = percentage >= 70
              ? Colors.green
              : (percentage >= 50 ? Colors.orange : Colors.red);

          return FadeInUp(
            delay: Duration(milliseconds: index * 50),
            child: Card(
              margin: const EdgeInsets.only(bottom: 6), // Sleeker margin
              child: Padding(
                padding: const EdgeInsets.all(12), // Compact padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            result.category,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${percentage.toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        // In a real app, we'd fetch the student name here using userId
                        // For now, we'll show the ID or a placeholder
                        Expanded(
                          child: Text(
                            'Student ID: ${result.userId.substring(0, 5)}...',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, h:mm a').format(result.date),
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Score: ${result.score}/${result.totalQuestions} • Difficulty: ${result.difficulty}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalytics() {
    return TeacherAnalytics(
      results: _results,
      students: _students,
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showCreateExamDialog() {
    final subjectController = TextEditingController();
    final durationController =
        TextEditingController(text: '20'); // Default 20 minutes
    final matricYearController = TextEditingController();
    final deptCodesController = TextEditingController();
    final carryOverMatricsController = TextEditingController();
    String selectedDifficulty = 'Medium';
    DateTime? startTime;
    DateTime? endTime;
    String? quizId; // Store quiz ID for custom questions

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create New Exam 📝'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject / Category',
                    hintText: 'e.g., Mathematics',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedDifficulty,
                  decoration: const InputDecoration(
                    labelText: 'Difficulty',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Easy', 'Medium', 'Hard']
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => selectedDifficulty = value!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (minutes)',
                    hintText: 'e.g., 20',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.timer),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                const Divider(),
                const Text(
                  'Access Control (Optional)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: matricYearController,
                  decoration: const InputDecoration(
                    labelText: 'Matric Year',
                    hintText: 'e.g., 200 (for 2020 entry)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                    helperText: 'Leave empty for no restriction',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deptCodesController,
                  decoration: const InputDecoration(
                    labelText: 'Department Code(s)',
                    hintText: 'e.g., 221 or 221,222,223 for multiple',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                    helperText: 'Separate multiple codes with commas',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: carryOverMatricsController,
                  decoration: const InputDecoration(
                    labelText: 'Carry-Over Students (Optional)',
                    hintText: 'e.g., 198/221/045, 199/221/023',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_add),
                    helperText: 'Full matric numbers, separated by commas',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                const Divider(),
                // Start Time Picker
                ListTile(
                  title: Text(startTime == null
                      ? 'Select Start Time'
                      : 'Start: ${DateFormat('MMM d, h:mm a').format(startTime!)}'),
                  leading: const Icon(Icons.access_time),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          startTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(height: 8),
                // End Time Picker
                ListTile(
                  title: Text(endTime == null
                      ? 'Select End Time'
                      : 'End: ${DateFormat('MMM d, h:mm a').format(endTime!)}'),
                  leading: const Icon(Icons.event_busy),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: startTime ?? DateTime.now(),
                      firstDate: startTime ?? DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          endTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(height: 16),
                // Create Questions Button
                OutlinedButton.icon(
                  onPressed: () async {
                    final returnedQuizId = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const CreateQuizScreen(isForExam: true),
                      ),
                    );
                    if (returnedQuizId != null) {
                      setState(() {
                        quizId = returnedQuizId;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                '✅ Custom questions created! Now complete exam details.')),
                      );
                    }
                  },
                  icon: Icon(quizId != null ? Icons.check_circle : Icons.quiz),
                  label: Text(quizId != null
                      ? 'Questions Added ✓'
                      : 'Create Custom Questions (Optional)'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor:
                        quizId != null ? Colors.green.shade50 : null,
                    foregroundColor:
                        quizId != null ? Colors.green.shade700 : null,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (subjectController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a subject')),
                  );
                  return;
                }
                if (startTime == null || endTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select start and end times')),
                  );
                  return;
                }
                if (endTime!.isBefore(startTime!)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('End time must be after start time')),
                  );
                  return;
                }

                try {
                  final code = _generateExamCode();
                  final duration = int.tryParse(durationController.text) ?? 20;

                  final examData = {
                    'code': code,
                    'subject': subjectController.text.trim(),
                    'difficulty': selectedDifficulty,
                    'durationMinutes': duration,
                    'startTime': startTime!.toIso8601String(),
                    'endTime': endTime!.toIso8601String(),
                    'createdAt': DateTime.now().toIso8601String(),
                    'teacherId':
                        FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
                    if (quizId != null)
                      'quizId': quizId, // Include custom questions
                    // Matric number restrictions
                    if (matricYearController.text.isNotEmpty)
                      'matricYear': matricYearController.text.trim(),
                    if (deptCodesController.text.isNotEmpty)
                      'allowedDeptCodes': deptCodesController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
                    if (carryOverMatricsController.text.isNotEmpty)
                      'carryOverMatrics': carryOverMatricsController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
                  };

                  await _firestoreService.createExam(examData);

                  // Send Notifications
                  try {
                    // Get all students
                    final allStudents = await _firestoreService.getStudents();
                    List<String> targetStudentIds = [];

                    final matricYear = matricYearController.text.trim();
                    final deptCodes = deptCodesController.text.isNotEmpty
                        ? deptCodesController.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList()
                        : [];

                    for (var student in allStudents) {
                      final studentId = student['uid'] as String?;
                      final matricNumber = student['matricNumber'] as String?;

                      if (studentId != null) {
                        bool matches = true;

                        // Check Matric Year (e.g., 200 matches 20/...)
                        if (matricYear.isNotEmpty && matricNumber != null) {
                          // Simple check: if matric number starts with or contains the year
                          // This is a heuristic; adjust based on actual matric format
                          if (!matricNumber.contains(matricYear)) {
                            matches = false;
                          }
                        }

                        // Check Dept Code
                        if (deptCodes.isNotEmpty && matricNumber != null) {
                          bool deptMatch = false;
                          for (var code in deptCodes) {
                            if (matricNumber.contains(code)) {
                              deptMatch = true;
                              break;
                            }
                          }
                          if (!deptMatch) matches = false;
                        }

                        if (matches) {
                          targetStudentIds.add(studentId);
                        }
                      }
                    }

                    if (targetStudentIds.isNotEmpty) {
                      final notificationService =
                          ProfessionalNotificationService();

                      // 1. Send Notifications
                      await notificationService.sendExamCreatedNotification(
                        studentIds: targetStudentIds,
                        examTitle: subjectController.text.trim(),
                        examTime: startTime!,
                        examId: code,
                      );

                      // 2. Link Students to Teacher (My Students)
                      try {
                        final teacherId =
                            FirebaseAuth.instance.currentUser?.uid;
                        if (teacherId != null) {
                          await _firestoreService.addStudentsToTeacher(
                              teacherId, targetStudentIds);
                        }
                      } catch (e) {
                        print("Error linking students: $e");
                      }
                    }
                  } catch (e) {
                    // In production, you might want to log this to a service
                  }

                  if (context.mounted) {
                    Navigator.pop(context);
                    _showCodeDialog(code, startTime!, endTime!, duration);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error creating exam: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                }
              },
              child: const Text('Generate Code'),
            ),
          ],
        ),
      ),
    );
  }

  String _generateExamCode() {
    // Generate a random 6-character alphanumeric code
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    // Simple random string generation
    return List.generate(
        6, (index) => chars[(random + index * 7) % chars.length]).join();
  }

  void _showCodeDialog(
      String code, DateTime startTime, DateTime endTime, int duration) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exam Created! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this code with your students:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Colors.purple,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.access_time, 'Start',
                DateFormat('MMM d, h:mm a').format(startTime)),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.event_busy, 'End',
                DateFormat('MMM d, h:mm a').format(endTime)),
            const SizedBox(height: 8),
            _buildInfoRow(
                Icons.timer, 'Duration', '$duration minutes per student'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
