import 'package:flutter/material.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/models/quiz_result.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/screens/create_quiz_screen.dart';
import 'package:quiz_app/services/professional_notification_service.dart';
import 'package:quiz_app/widgets/teacher_analytics.dart';
import 'package:quiz_app/services/preferences_service.dart';
import 'package:quiz_app/services/pdf_service.dart';

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
  List<Map<String, dynamic>> _exams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final teacherId = FirebaseAuth.instance.currentUser?.uid;
      List<Map<String, dynamic>> students = [];
      List<QuizResult> results = [];

      if (teacherId != null) {
        // Step 1: Fetch students and exams in parallel
        final data = await Future.wait([
          _firestoreService.getTeacherStudents(teacherId),
          _firestoreService.getExamsByTeacher(teacherId),
        ]);

        students = data[0];
        _exams = data[1];

        // Step 2: Fetch results only for those students
        final studentIds = students.map((s) => s['uid'] as String).toList();
        results = await _firestoreService.getResultsForStudents(studentIds);
      }

      if (mounted) {
        setState(() {
          _students = students;
          _results = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading teacher data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted) setState(() {});
  }

  Future<void> _exportCurrentResults() async {
    if (_results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results available to export.')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Prepare data by linking results with student info
      final exportData = _results.map((result) {
        final student = _students.firstWhere(
          (s) => s['uid'] == result.userId,
          orElse: () => {'username': 'Unknown', 'matricNumber': 'N/A'},
        );

        return {
          'userName': student['username'] ?? 'Unknown',
          'matricNumber': student['matricNumber'] ?? 'N/A',
          'score': result.score,
          'totalQuestions': result.totalQuestions,
          'percentage': result.percentage,
          'category': result.category,
        };
      }).toList();

      await PdfService.generateResultsPdf(
        className: 'Teacher Dashboard',
        quizTitle: 'All Student Results',
        results: exportData,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF generated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    }
  }

  Future<void> _notifyAllStudents() async {
    if (_students.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notify All Students? 📢'),
        content: Text(
          'Send a notification to all ${_students.length} students currently linked to you?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send Broadcast'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final studentIds = _students.map((s) => s['uid'] as String).toList();

      try {
        await ProfessionalNotificationService.instance
            .sendResultsReleasedNotification(
          studentIds: studentIds,
          examTitle: "Teacher Broadcast",
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Broadcast notification sent successfully!'),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<void> _releaseResults(String examCode) async {
    try {
      await _firestoreService.releaseExamResults(examCode);

      // Update local state to show as released
      if (mounted) {
        setState(() {
          final index = _exams.indexWhere((e) => e['code'] == examCode);
          if (index != -1) {
            _exams[index]['resultsReleased'] = true;
          }
        });
      }

      // Notify all students about the release
      final studentIds = _students.map((s) => s['uid'] as String).toList();

      if (studentIds.isNotEmpty) {
        await ProfessionalNotificationService.instance
            .sendResultsReleasedNotification(
          studentIds: studentIds,
          examTitle: "Exam results (Code: $examCode)",
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Results released and students notified!'),
              ],
            ),
            backgroundColor: Colors.green[700],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final cleanError = e.toString().replaceAll('Exception:', '').trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(cleanError)),
              ],
            ),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showReleaseExamDialog() {
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Release Exam Results 🔓'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter the 6-character access code for the exam you want to release scores and explanations for.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                hintText: 'Exam Code (e.g. A1B2C3)',
                border: OutlineInputBorder(),
              ),
              maxLength: 6,
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final code = codeController.text.trim().toUpperCase();
              if (code.length == 6) {
                Navigator.pop(context);
                _releaseResults(code);
              }
            },
            child: const Text('Release & Notify'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          if (_results.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Export Results',
              onPressed: _exportCurrentResults,
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'reset_students') {
                _showResetStudentsDialog();
              } else if (value == 'saved_reports') {
                _showSavedReports();
              } else if (value == 'export_all') {
                _exportCurrentResults();
              } else if (value == 'notify_all') {
                _notifyAllStudents();
              } else if (value == 'release_exam') {
                _showReleaseExamDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'notify_all',
                child: Row(
                  children: [
                    Icon(Icons.notifications_active, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text('Notify All Students'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'release_exam',
                child: Row(
                  children: [
                    Icon(Icons.lock_open, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Release Exam Results'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'reset_students',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Reset Student List'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'saved_reports',
                child: Row(
                  children: [
                    Icon(Icons.bookmarks, color: Colors.purple),
                    SizedBox(width: 8),
                    Text('Saved Reports'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export_all',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Export All Results (PDF)'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Exams', icon: Icon(Icons.quiz)),
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
                _buildExamsList(),
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

  Widget _buildExamsList() {
    if (_exams.isEmpty) {
      return _buildEmptyState('No exams created yet.');
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _exams.length,
        itemBuilder: (context, index) {
          final exam = _exams[index];
          final isReleased = exam['resultsReleased'] ?? false;
          final startTime = DateTime.parse(exam['startTime']);
          final endTime = DateTime.parse(exam['endTime']);
          final now = DateTime.now();

          String status = 'Upcoming';
          Color statusColor = Colors.blue;
          if (now.isAfter(startTime) && now.isBefore(endTime)) {
            status = 'Active';
            statusColor = Colors.green;
          } else if (now.isAfter(endTime)) {
            status = 'Expired';
            statusColor = Colors.grey;
          }

          return FadeInUp(
            delay: Duration(milliseconds: index * 50),
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                title: Text(
                  exam['subject'] ?? 'Untitled Exam',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Code: ${exam['code']} • $status'),
                leading: CircleAvatar(
                  backgroundColor: statusColor.withOpacity(0.1),
                  child: Icon(Icons.assignment, color: statusColor, size: 20),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          Icons.calendar_today,
                          'Schedule: ${DateFormat('MMM d, HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}',
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          Icons.timer,
                          'Duration: ${exam['durationMinutes']} minutes',
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: isReleased
                                    ? null
                                    : () => _releaseResults(exam['code']),
                                icon: Icon(
                                  isReleased
                                      ? Icons.check_circle
                                      : Icons.launch,
                                  size: 18,
                                ),
                                label: Text(
                                  isReleased
                                      ? 'Results Released'
                                      : 'Release Results',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isReleased ? Colors.green : Colors.purple,
                                  foregroundColor: Colors.white,
                                ),
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
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ),
      ],
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
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
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
                    if (student['matricNumber'] != null)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          student['matricNumber'],
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
          final student = _students.firstWhere(
            (s) => s['uid'] == result.userId,
            orElse: () => {'username': 'Unknown', 'matricNumber': 'N/A'},
          );
          final percentage = (result.score / result.totalQuestions) * 100;
          final color = percentage >= 70
              ? Colors.green
              : (percentage >= 50 ? Colors.orange : Colors.red);

          return FadeInUp(
            delay: Duration(milliseconds: index * 50),
            child: Card(
              margin: const EdgeInsets.only(bottom: 6),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student['username'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                student['matricNumber'] ?? 'No Matric Number',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${percentage.toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon:
                              const Icon(Icons.bookmark_add_outlined, size: 20),
                          color: Colors.purple,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Save Report',
                          onPressed: () => _saveResult(result),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${result.category} • ${result.difficulty}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Text(
                          DateFormat('MMM d').format(result.date),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 11,
                          ),
                        ),
                      ],
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
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        children: [
          TeacherAnalytics(results: _results, students: _students),
        ],
      ),
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
    final durationController = TextEditingController(
      text: '20',
    ); // Default 20 minutes
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
                  title: Text(
                    startTime == null
                        ? 'Select Start Time'
                        : 'Start: ${DateFormat('MMM d, h:mm a').format(startTime!)}',
                  ),
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
                  title: Text(
                    endTime == null
                        ? 'Select End Time'
                        : 'End: ${DateFormat('MMM d, h:mm a').format(endTime!)}',
                  ),
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
                            '✅ Custom questions created! Now complete exam details.',
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(quizId != null ? Icons.check_circle : Icons.quiz),
                  label: Text(
                    quizId != null
                        ? 'Questions Added ✓'
                        : 'Create Custom Questions (Optional)',
                  ),
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
                      content: Text('Please select start and end times'),
                    ),
                  );
                  return;
                }
                if (endTime!.isBefore(startTime!)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('End time must be after start time'),
                    ),
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
                    'resultsReleased':
                        false, // Privacy: Teachers release manually
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
      6,
      (index) => chars[(random + index * 7) % chars.length],
    ).join();
  }

  void _showCodeDialog(
    String code,
    DateTime startTime,
    DateTime endTime,
    int duration,
  ) {
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
            _buildInfoRow(
              Icons.access_time,
              'Start',
              DateFormat('MMM d, h:mm a').format(startTime),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.event_busy,
              'End',
              DateFormat('MMM d, h:mm a').format(endTime),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.timer,
              'Duration',
              '$duration minutes per student',
            ),
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

  Future<void> _saveResult(QuizResult result) async {
    Map<String, dynamic> student = {};
    try {
      student = _students.firstWhere(
        (s) => s['uid'] == result.userId,
        orElse: () => {'username': 'Unknown', 'matricNumber': 'N/A'},
      );
    } catch (_) {
      student = {'username': 'Unknown', 'matricNumber': 'N/A'};
    }

    final resultData = {
      'id': result.id,
      'studentName': student['username'] ?? 'Unknown',
      'matricNumber': student['matricNumber'] ?? 'N/A',
      'score': result.score,
      'total': result.totalQuestions,
      'category': result.category,
      'date': result.date.toIso8601String(),
    };

    await PreferencesService.saveResult(resultData);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Result saved to local reports! 📝'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _showResetStudentsDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Reset Student List?'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will clear ALL student-teacher links.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('After resetting:'),
            SizedBox(height: 8),
            Text('✅ Student count will show 0'),
            Text('✅ Only students who use your NEW codes will appear'),
            Text('✅ Previous quiz results will NOT be deleted'),
            SizedBox(height: 12),
            Text(
              'This action helps you verify that ONLY students using your 6-digit codes are being tracked.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _resetStudentLinks();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _showSavedReports() async {
    final savedResults = await PreferencesService.getSavedResults();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.bookmarks, color: Colors.purple),
            SizedBox(width: 8),
            Text('Saved Reports'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: savedResults.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      'No saved reports yet. Tap the bookmark icon on any result to save it here.'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: savedResults.length,
                  itemBuilder: (context, index) {
                    final report = savedResults[index];
                    final date = DateTime.parse(report['date']);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(report['studentName'] ?? 'Unknown',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${report['matricNumber']}'),
                            Text(
                                '${report['category']} • ${DateFormat('MMM d').format(date)}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${report['score']}/${report['total']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.purple),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red, size: 20),
                              onPressed: () async {
                                await PreferencesService.removeSavedResult(
                                    report['id']);
                                Navigator.pop(context);
                                _showSavedReports(); // Refresh
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close')),
        ],
      ),
    );
  }

  Future<void> _resetStudentLinks() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final teacherId = FirebaseAuth.instance.currentUser?.uid;
      if (teacherId == null) {
        if (mounted) Navigator.pop(context);
        return;
      }

      // Get all students currently linked
      final studentsSnapshot = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .collection('students')
          .get();

      print('🔄 Clearing ${studentsSnapshot.docs.length} student links...');

      // Delete all of them
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in studentsSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      print('✅ Successfully cleared all student links!');

      // Reload data
      await _loadData();

      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Student list reset! Cleared ${studentsSnapshot.docs.length} links. Only students using NEW codes will appear.',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      print('❌ Error clearing student links: $e');
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
