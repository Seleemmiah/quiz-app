import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/class_model.dart';
import 'package:quiz_app/models/class_member.dart';
import 'package:quiz_app/services/class_service.dart';
import 'package:quiz_app/services/pdf_service.dart';
import 'package:quiz_app/services/docx_service.dart';
import 'package:intl/intl.dart';

class ClassDetailScreen extends StatefulWidget {
  final ClassModel classModel;

  const ClassDetailScreen({
    super.key,
    required this.classModel,
  });

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen>
    with SingleTickerProviderStateMixin {
  final ClassService _classService = ClassService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  late TabController _tabController;
  ClassModel? _classModel;

  bool _isTeacher = false;
  List<ClassMember> _members = [];
  List<Map<String, dynamic>> _leaderboard = [];
  List<Map<String, dynamic>> _upcomingEvents = [];
  bool _isLoadingMembers = true;
  bool _isLoadingLeaderboard = true;
  bool _isLoadingEvents = true;

  String? _selectedCategory;
  String? _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    _classModel = widget.classModel;
    _checkTeacherStatus();
    _loadMembers();
    _loadLeaderboard();
    _loadUpcomingEvents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Logic moved to initState as we now have direct access to classModel
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {
        // Just trigger rebuild to update AppBar actions
      });
    }
  }

  Future<void> _exportResults({bool isPdf = true}) async {
    if (_leaderboard.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results available to export.')),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      if (isPdf) {
        await PdfService.generateResultsPdf(
          className: _classModel!.className,
          quizTitle: _selectedCategory ?? 'Class Performance',
          results: _leaderboard,
        );
      } else {
        // Calculate share origin for iPad / Mac
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        final Rect? rect =
            box != null ? box.localToGlobal(Offset.zero) & box.size : null;

        await DocxService.generateResultsDocx(
          className: _classModel!.className,
          quizTitle: _selectedCategory ?? 'Class Performance',
          results: _leaderboard,
          sharePositionOrigin: rect,
        );
      }

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('${isPdf ? 'PDF' : 'Word'} generated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating file: $e')),
        );
      }
    }
  }

  Future<void> _checkTeacherStatus() async {
    if (_classModel == null) return;
    if (_currentUser != null) {
      final isTeacher = await _classService.isTeacher(
        _classModel!.classId,
        _currentUser.uid,
      );
      if (mounted) {
        setState(() => _isTeacher = isTeacher);
      }
    }
  }

  Future<void> _loadMembers() async {
    if (_classModel == null) return;
    setState(() => _isLoadingMembers = true);
    try {
      final members = await _classService.getClassMembers(_classModel!.classId);
      if (mounted) {
        setState(() {
          _members = members;
          _isLoadingMembers = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingMembers = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading members: $e')),
        );
      }
    }
  }

  Future<void> _loadLeaderboard() async {
    if (_classModel == null) return;
    setState(() => _isLoadingLeaderboard = true);
    try {
      final leaderboard = await _classService.getClassLeaderboard(
        classId: _classModel!.classId,
        category: _selectedCategory,
        difficulty: _selectedDifficulty,
      );
      if (mounted) {
        setState(() {
          _leaderboard = leaderboard;
          _isLoadingLeaderboard = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLeaderboard = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading leaderboard: $e')),
        );
      }
    }
  }

  Future<void> _leaveClass() async {
    if (_classModel == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Class?'),
        content: Text(
          _isTeacher
              ? 'Are you sure you want to leave this class? As the teacher, this will affect all students.'
              : 'Are you sure you want to leave "${_classModel!.className}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirmed == true && _currentUser != null) {
      try {
        await _classService.leaveClass(
          classId: _classModel!.classId,
          userId: _currentUser.uid,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Left class successfully')),
          );
          Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    if (_classModel == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_classModel!.className),
        actions: [
          if (_isTeacher && _tabController.index == 0)
            PopupMenuButton<String>(
              icon: const Icon(Icons.download),
              tooltip: 'Export Results',
              onSelected: (value) {
                if (value == 'pdf') {
                  _exportResults(isPdf: true);
                } else if (value == 'word') {
                  _exportResults(isPdf: false);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'pdf',
                  child: Row(
                    children: [
                      Icon(Icons.picture_as_pdf, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Export as PDF'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'word',
                  child: Row(
                    children: [
                      Icon(Icons.description, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Export as Word (DOCX)'),
                    ],
                  ),
                ),
              ],
            ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _leaveClass,
            tooltip: 'Leave Class',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Leaderboard', icon: Icon(Icons.leaderboard)),
            Tab(text: 'Members', icon: Icon(Icons.people)),
            Tab(text: 'Schedule', icon: Icon(Icons.event)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Class Info Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Class Code: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _classModel!.classCode,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                if (_classModel!.subject != null) ...[
                  const SizedBox(height: 4),
                  Text('Subject: ${_classModel!.subject}'),
                ],
                if (_classModel!.description != null) ...[
                  const SizedBox(height: 4),
                  Text(_classModel!.description!),
                ],
                const SizedBox(height: 4),
                Text(
                  'Teacher: ${_classModel!.teacherName} • ${_classModel!.memberCount} members',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardTab(),
                _buildMembersTab(),
                _buildScheduleTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return Column(
      children: [
        // Filters
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: 'Science', child: Text('Science')),
                    DropdownMenuItem(value: 'Math', child: Text('Math')),
                    DropdownMenuItem(value: 'History', child: Text('History')),
                    DropdownMenuItem(value: 'Coding', child: Text('Coding')),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedCategory = value);
                    _loadLeaderboard();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedDifficulty,
                  decoration: const InputDecoration(
                    labelText: 'Difficulty',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: 'easy', child: Text('Easy')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'hard', child: Text('Hard')),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedDifficulty = value);
                    _loadLeaderboard();
                  },
                ),
              ),
            ],
          ),
        ),

        // Leaderboard List
        Expanded(
          child: _isLoadingLeaderboard
              ? const Center(child: CircularProgressIndicator())
              : _leaderboard.isEmpty
                  ? const Center(
                      child:
                          Text('No scores yet. Be the first to take a quiz!'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _leaderboard.length,
                      itemBuilder: (context, index) {
                        final score = _leaderboard[index];
                        final rank = index + 1;
                        final isCurrentUser =
                            score['userId'] == _currentUser?.uid;

                        Color? rankColor;
                        IconData? rankIcon;
                        if (rank == 1) {
                          rankColor = Colors.amber;
                          rankIcon = Icons.emoji_events;
                        } else if (rank == 2) {
                          rankColor = Colors.grey[400];
                          rankIcon = Icons.emoji_events;
                        } else if (rank == 3) {
                          rankColor = Colors.brown[300];
                          rankIcon = Icons.emoji_events;
                        }

                        final isExam = score['isExam'] ?? false;
                        final isTeacher =
                            _isTeacher; // Using the localized check
                        final canSeeScore =
                            !isExam || isTeacher || isCurrentUser;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 4),
                          color: isCurrentUser
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : null,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: rankColor ?? Colors.grey[300],
                              child: rankIcon != null
                                  ? Icon(rankIcon, color: Colors.white)
                                  : Text(
                                      '$rank',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            title: Text(
                              canSeeScore
                                  ? score['userName']
                                  : 'Private Student',
                              style: TextStyle(
                                fontWeight: isCurrentUser
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: canSeeScore ? null : Colors.grey,
                              ),
                            ),
                            subtitle: Text(
                              '${score['category']} • ${score['difficulty']}${isExam ? ' (Exam)' : ''}',
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  canSeeScore
                                      ? '${score['percentage'].toStringAsFixed(1)}%'
                                      : '🔒',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: canSeeScore
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                  ),
                                ),
                                if (canSeeScore)
                                  Text(
                                    '${score['score']}/${score['totalQuestions']}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildMembersTab() {
    return _isLoadingMembers
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _members.length,
            itemBuilder: (context, index) {
              final member = _members[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(member.userAvatar),
                  ),
                  title: Text(member.userName),
                  subtitle: Text(
                    member.isTeacher ? 'Teacher' : 'Student',
                  ),
                  trailing: member.isTeacher
                      ? const Icon(Icons.school, color: Colors.blue)
                      : null,
                ),
              );
            },
          );
  }

  Future<void> _loadUpcomingEvents() async {
    if (_classModel == null) return;
    debugPrint('Loading events for class: ${_classModel!.classId}');
    setState(() => _isLoadingEvents = true);
    try {
      final events = await _classService.getClassEvents(_classModel!.classId);
      debugPrint('Loaded ${events.length} events');
      for (var event in events) {
        debugPrint('Event: ${event['title']} - ${event['scheduledAt']}');
      }
      if (mounted) {
        setState(() {
          _upcomingEvents = events;
          _isLoadingEvents = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading events: $e');
      if (mounted) {
        setState(() => _isLoadingEvents = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading events: $e')),
        );
      }
    }
  }

  Widget _buildScheduleTab() {
    return Column(
      children: [
        if (_isTeacher)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/schedule_class',
                  arguments: _classModel,
                ).then((_) => _loadUpcomingEvents());
              },
              icon: const Icon(Icons.add),
              label: const Text('Schedule New Event'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        Expanded(
          child: _isLoadingEvents
              ? const Center(child: CircularProgressIndicator())
              : _upcomingEvents.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No upcoming events',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _upcomingEvents.length,
                      itemBuilder: (context, index) {
                        final event = _upcomingEvents[index];
                        final scheduledAt = DateTime.fromMillisecondsSinceEpoch(
                            event['scheduledAt'] as int);
                        return Card(
                          margin: const EdgeInsets.only(bottom: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child:
                                  const Icon(Icons.event, color: Colors.white),
                            ),
                            title: Text(
                              event['title'] as String,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (event['description'] != null)
                                  Text(event['description'] as String),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${DateFormat.yMMMd().format(scheduledAt)} at ${DateFormat.jm().format(scheduledAt)}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            isThreeLine: event['description'] != null,
                            trailing: _isTeacher
                                ? PopupMenuButton<String>(
                                    onSelected: (value) async {
                                      if (value == 'edit') {
                                        final eventId = event['id'] as String?;
                                        if (eventId != null) {
                                          Navigator.pushNamed(
                                            context,
                                            '/schedule_class',
                                            arguments: {
                                              'classModel': _classModel,
                                              'existingEvent': event,
                                              'eventId': eventId,
                                            },
                                          ).then((_) => _loadUpcomingEvents());
                                        }
                                      } else if (value == 'delete') {
                                        final confirmed =
                                            await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Delete Event?'),
                                            content: Text(
                                                'Are you sure you want to delete "${event['title']}"?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                                style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.red),
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirmed == true) {
                                          try {
                                            await _classService.deleteEvent(
                                              eventId: event['id'] as String,
                                              classId: _classModel!.classId,
                                              eventTitle:
                                                  event['title'] as String,
                                            );
                                            _loadUpcomingEvents();
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Event deleted successfully')),
                                              );
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text('Error: $e')),
                                              );
                                            }
                                          }
                                        }
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 20),
                                            SizedBox(width: 8),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete,
                                                size: 20, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
