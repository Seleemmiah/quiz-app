import 'package:flutter/material.dart';
import 'package:quiz_app/services/gamification_service.dart';
import 'package:quiz_app/services/achievement_service.dart';
import 'package:quiz_app/services/statistics_service.dart';
import 'package:quiz_app/services/preferences_service.dart';
import 'package:quiz_app/widgets/glass_card.dart';
import 'package:quiz_app/services/mistakes_service.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/widgets/activity_heatmap.dart';
import 'package:quiz_app/widgets/skill_radar_chart.dart';
import 'package:quiz_app/widgets/circular_progress_ring.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GamificationService _gamificationService = GamificationService();
  final AchievementService _achievementService = AchievementService();
  final StatisticsService _statisticsService = StatisticsService();
  final PreferencesService _preferencesService = PreferencesService();

  static const List<String> _availableAvatars = [
    '👨‍🎓',
    '👩‍🎓',
    '👨‍🏫',
    '👩‍🏫',
    '👨‍🔬',
    '👩‍🔬',
    '👨‍🚀',
    '👩‍🚀',
    '🦸‍♂️',
    '🦸‍♀️',
    '🧙‍♂️',
    '🧙‍♀️',
    '🥷',
    '🤓',
    '😎',
    '🤠'
  ];

  int _totalXP = 0;
  int _level = 1;
  double _levelProgress = 0.0;
  Map<String, dynamic>? _dailyChallenge;
  bool _challengeCompleted = false;
  int _currentStreak = 0;
  int _totalQuizzes = 0;
  String _currentAvatar = '👨‍🎓';
  String _username = 'Mindly User';
  Map<DateTime, int> _activityData = {};
  Map<String, double> _categoryPerformance = {};
  double _averageScore = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final xp = await _gamificationService.getTotalXP();
    final level = _gamificationService.getLevel(xp);
    final progress = _gamificationService.getLevelProgress(xp);
    final challenge = await _gamificationService.getDailyChallenge();
    final completed = await _gamificationService.isDailyChallengeCompleted();
    final streak = await _achievementService.getCurrentStreak();
    final stats = await _statisticsService.getStatistics();
    final avatar = await _preferencesService.getAvatar();
    final username = await _preferencesService.getUsername();
    final activity = await _statisticsService.getLast7DaysActivity();
    final categoryPerf = await _statisticsService.getCategoryPerformance();

    if (mounted) {
      setState(() {
        _totalXP = xp;
        _level = level;
        _levelProgress = progress;
        _dailyChallenge = challenge;
        _challengeCompleted = completed;
        _currentStreak = streak;
        _totalQuizzes = stats.totalQuizzes;
        _currentAvatar = avatar;
        _username = username;
        _activityData = activity;
        _categoryPerformance = categoryPerf;
        _averageScore = stats.averageScore;
      });
    }
  }

  void _showUsernameEditor() {
    final controller = TextEditingController(text: _username);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Username'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your name',
          ),
          maxLength: 20,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                await _preferencesService.setUsername(newName);
                setState(() {
                  _username = newName;
                });
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAvatarPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Your Avatar'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _availableAvatars.length,
            itemBuilder: (context, index) {
              final avatar = _availableAvatars[index];
              final isSelected = avatar == _currentAvatar;
              return InkWell(
                onTap: () async {
                  await _preferencesService.setAvatar(avatar);
                  setState(() {
                    _currentAvatar = avatar;
                  });
                  if (mounted) Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.withValues(alpha: 0.3),
                      width: isSelected ? 3 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      avatar,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nextLevelXP = _gamificationService.getXPForNextLevel(_level);
    final xpNeeded = nextLevelXP - _totalXP;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProfileData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfileData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar Section
              Center(
                child: GestureDetector(
                  onTap: _showAvatarPicker,
                  child: Stack(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _currentAvatar,
                            style: const TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _showUsernameEditor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _username,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.edit,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Level Card
              GlassCard(
                padding: EdgeInsets.zero,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Level $_level',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_totalXP XP',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _levelProgress,
                          minHeight: 12,
                          backgroundColor: Colors.white30,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$xpNeeded XP to Level ${_level + 1}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Daily Challenge Card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: _challengeCompleted
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Daily Challenge',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (_challengeCompleted)
                          const Icon(Icons.check_circle, color: Colors.green)
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '+100 XP',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _dailyChallenge?['description'] ?? 'Loading...',
                      style: TextStyle(
                        fontSize: 16,
                        decoration: _challengeCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: _challengeCompleted ? Colors.grey : null,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Activity Heatmap
              GlassCard(
                child: ActivityHeatmap(
                  activity: _activityData,
                  maxQuizzes: 5,
                ),
              ),

              const SizedBox(height: 20),

              // Skill Radar Chart
              if (_categoryPerformance.isNotEmpty)
                GlassCard(
                  child: SkillRadarChart(
                    categoryScores: _categoryPerformance,
                  ),
                ),

              if (_categoryPerformance.isNotEmpty) const SizedBox(height: 20),

              // Circular Progress Rings
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularProgressRing(
                    progress: _averageScore / 100,
                    label: 'Avg Score',
                    value: '${_averageScore.toStringAsFixed(0)}%',
                    color: Colors.blue,
                    size: 90,
                  ),
                  CircularProgressRing(
                    progress: _currentStreak / 30, // Max 30 days
                    label: 'Streak',
                    value: '$_currentStreak',
                    color: Colors.orange,
                    size: 90,
                  ),
                  CircularProgressRing(
                    progress:
                        (_totalQuizzes % 100) / 100, // Progress to next 100
                    label: 'Quizzes',
                    value: '$_totalQuizzes',
                    color: Colors.green,
                    size: 90,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.history_edu, color: Colors.redAccent),
                title: const Text('Review Mistakes'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final mistakes = await MistakesService().getMistakes();
                  if (mistakes.isEmpty) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('No mistakes to review! Great job!')),
                      );
                    }
                    return;
                  }
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(
                          customQuestions: mistakes,
                        ),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.amber),
                title: const Text('View Achievements'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/achievements'),
              ),
              ListTile(
                leading: const Icon(Icons.analytics, color: Colors.blue),
                title: const Text('View Statistics'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/statistics'),
              ),
              ListTile(
                leading: const Icon(Icons.bookmark, color: Colors.green),
                title: const Text('Bookmarked Questions'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/bookmarks'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
