import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/class_model.dart';
import 'package:quiz_app/models/class_member.dart';
import 'package:quiz_app/services/class_service.dart';

class ClassDetailScreen extends StatefulWidget {
  const ClassDetailScreen({super.key});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen>
    with SingleTickerProviderStateMixin {
  final ClassService _classService = ClassService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  late TabController _tabController;
  late ClassModel _classModel;

  bool _isTeacher = false;
  List<ClassMember> _members = [];
  List<Map<String, dynamic>> _leaderboard = [];
  bool _isLoadingMembers = true;
  bool _isLoadingLeaderboard = true;

  String? _selectedCategory;
  String? _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _classModel = ModalRoute.of(context)!.settings.arguments as ClassModel;
    _checkTeacherStatus();
    _loadMembers();
    _loadLeaderboard();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkTeacherStatus() async {
    if (_currentUser != null) {
      final isTeacher = await _classService.isTeacher(
        _classModel.classId,
        _currentUser!.uid,
      );
      if (mounted) {
        setState(() => _isTeacher = isTeacher);
      }
    }
  }

  Future<void> _loadMembers() async {
    setState(() => _isLoadingMembers = true);
    try {
      final members = await _classService.getClassMembers(_classModel.classId);
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
    setState(() => _isLoadingLeaderboard = true);
    try {
      final leaderboard = await _classService.getClassLeaderboard(
        classId: _classModel.classId,
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Class?'),
        content: Text(
          _isTeacher
              ? 'Are you sure you want to leave this class? As the teacher, this will affect all students.'
              : 'Are you sure you want to leave "${_classModel.className}"?',
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
          classId: _classModel.classId,
          userId: _currentUser!.uid,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_classModel.className),
        actions: [
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
          ],
        ),
      ),
      body: Column(
        children: [
          // Class Info Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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
                      _classModel.classCode,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                if (_classModel.subject != null) ...[
                  const SizedBox(height: 4),
                  Text('Subject: ${_classModel.subject}'),
                ],
                if (_classModel.description != null) ...[
                  const SizedBox(height: 4),
                  Text(_classModel.description!),
                ],
                const SizedBox(height: 4),
                Text(
                  'Teacher: ${_classModel.teacherName} • ${_classModel.memberCount} members',
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
                  value: _selectedCategory,
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
                  value: _selectedDifficulty,
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

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          color: isCurrentUser
                              ? Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1)
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
                              score['userName'],
                              style: TextStyle(
                                fontWeight: isCurrentUser
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(
                              '${score['category']} • ${score['difficulty']}',
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${score['percentage'].toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
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
                margin: const EdgeInsets.only(bottom: 8),
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
}
