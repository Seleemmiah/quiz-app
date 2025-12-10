import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/services/score_service.dart';
import 'package:quiz_app/services/bookmark_service.dart';
import 'package:quiz_app/services/preferences_service.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/services/notification_service.dart';
import 'package:quiz_app/services/recommendation_service.dart';
import 'package:quiz_app/services/api_service.dart';
import 'package:quiz_app/screens/video_library_screen.dart';
import 'package:quiz_app/screens/handwriting_screen.dart';
import 'package:quiz_app/services/achievement_service.dart';
import 'package:quiz_app/services/statistics_service.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:animate_do/animate_do.dart';
import 'package:quiz_app/widgets/smart_recommendations.dart';
import 'package:quiz_app/screens/teacher_dashboard_screen.dart';
import 'package:quiz_app/services/professional_notification_service.dart';
import 'package:intl/intl.dart';

class StartScreen extends StatefulWidget {
  final String? initialCategory;
  const StartScreen({super.key, this.initialCategory});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  // --- State Variables ---
  Difficulty _selectedDifficulty = Difficulty.easy;
  int _selectedTimeInMinutes = 5; // Default to 5 minutes, now non-nullable
  String? _selectedCategory;
  int _highScore = 0;
  int _currentStreak = 0;
  String _userAvatar = '👨‍🎓';
  String _username = 'Quiz Master';
  int _quizLength = 10;
  int _totalQuizzes = 0; // Track quizzes completed today
  List<SmartRecommendation> _smartRecommendations = [];
  String _userRole = 'student'; // Default to student

  // Future to hold categories from the API
  final ScoreService _scoreService = ScoreService();
  final BookmarkService _bookmarkService = BookmarkService();
  final PreferencesService _preferencesService = PreferencesService();
  final RecommendationService _recommendationService = RecommendationService();
  final ApiService _apiService = ApiService();
  final AchievementService _achievementService = AchievementService();
  final FirestoreService _firestoreService = FirestoreService();

  List<Recommendation> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    // Check for username first
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.displayName == null || user.displayName!.isEmpty) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/username_setup');
          return;
        }
      }

      // Fetch user role
      final role = await _firestoreService.getUserRole(user.uid);
      if (mounted && role != null) {
        setState(() {
          _userRole = role;
        });
      }
    }

    // Load preferences first
    final difficulty = await _preferencesService.getDefaultDifficulty();
    final category = await _preferencesService.getDefaultCategory();
    final timeLimit = await _preferencesService.getDefaultTimeLimit();
    final quizLength = await _preferencesService.getQuizLength();
    final loginStreak =
        await _achievementService.getLoginStreak(); // Changed to login streak

    // Load total quizzes from statistics
    final stats = await StatisticsService().getStatistics();

    if (mounted) {
      setState(() {
        _selectedDifficulty = difficulty;
        _selectedCategory = widget.initialCategory ?? category;
        _selectedTimeInMinutes = timeLimit;
        _quizLength = quizLength;
        _currentStreak = loginStreak; // Now shows login streak
        _totalQuizzes = stats.totalQuizzes;
      });

      // Load high score and avatar
      _loadHighScore();
      _loadAvatar();
      _loadRecommendations();
      _generateSmartRecommendations(); // Generate personalized recommendations

      // Setup notifications
      _setupNotifications();

      // If initialCategory was provided, show time picker automatically
      if (widget.initialCategory != null) {
        // Small delay to allow UI to settle
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _showTimeLimitPicker(context);
          }
        });
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  Future<void> _loadAvatar() async {
    final avatar = await _preferencesService.getAvatar();
    final username = await _preferencesService.getUsername();
    if (mounted) {
      setState(() {
        _userAvatar = avatar;
        _username = username;
      });
    }
  }

  Future<void> _loadRecommendations() async {
    final recommendations = await _recommendationService.getRecommendations();
    if (mounted) {
      setState(() {
        _recommendations = recommendations.take(3).toList(); // Show top 3
      });
    }
  }

  Future<void> _setupNotifications() async {
    final notificationService = ProfessionalNotificationService();
    await notificationService.initialize();
  }

  Future<void> _refreshDashboard() async {
    await _initializeScreen();
    // Refresh unread count if triggered
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 800)); // nice delay
  }

  Stream<int> _getUnreadNotificationCount() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value(0);
    }

    return FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: user.uid)
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> _generateSmartRecommendations() async {
    final stats = await StatisticsService().getStatistics();
    final recommendations = <SmartRecommendation>[];

    // Recommendation 1: Weak category (lowest score)
    if (stats.categoryAverages.isNotEmpty) {
      final weakest = stats.categoryAverages.entries
          .reduce((a, b) => a.value < b.value ? a : b);

      if (weakest.value < 70) {
        recommendations.add(SmartRecommendation(
          title: 'Practice ${weakest.key}',
          subtitle:
              'Your score: ${weakest.value.toStringAsFixed(0)}% - Let\'s improve!',
          icon: Icons.trending_up,
          color: Colors.red,
          onTap: () {
            setState(() {
              _selectedCategory = weakest.key;
            });
            _showTimeLimitPicker(context);
          },
        ));
      }
    }

    // Recommendation 2: Best time of day
    final timePerf = await StatisticsService().getPerformanceByTimeOfDay();
    if (timePerf.isNotEmpty) {
      final bestTime =
          timePerf.entries.reduce((a, b) => a.value > b.value ? a : b);

      recommendations.add(SmartRecommendation(
        title: 'Best Performance Time',
        subtitle:
            'You score ${bestTime.value.toStringAsFixed(0)}% during ${bestTime.key}',
        icon: Icons.access_time,
        color: Colors.blue,
        onTap: () {
          // Just informational
        },
      ));
    }

    // Recommendation 3: Streak motivation
    if (_currentStreak > 0) {
      recommendations.add(SmartRecommendation(
        title: 'Keep Your Streak!',
        subtitle: '$_currentStreak day streak - Don\'t break it!',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        onTap: () {
          _showTimeLimitPicker(context);
        },
      ));
    }

    if (mounted) {
      setState(() {
        _smartRecommendations = recommendations.take(2).toList(); // Show max 2
      });
    }
  }

  // --- New method to load the high score ---
  Future<void> _loadHighScore() async {
    // Ensure a category is selected before trying to load a score
    final category = _selectedCategory;
    if (category == null) return;

    final score = await _scoreService.getHighScore(
      difficulty: _selectedDifficulty,
      // Use the local non-nullable variable
      category: category,
    );

    // Check if the widget is still mounted before calling setState
    if (mounted) setState(() => _highScore = score);
  }

  Future<void> _showCategoryPicker(BuildContext context) async {
    try {
      final categories = await _apiService.fetchCategories();

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Category'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == _selectedCategory;

                  return ListTile(
                    title: Text(category),
                    leading: Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                    selected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                      Navigator.pop(context);
                      _loadHighScore(); // Reload high score for new category
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading categories: $e')),
        );
      }
    }
  }

  Future<void> _showDifficultyPicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Difficulty'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: Difficulty.values.map((difficulty) {
              final isSelected = difficulty == _selectedDifficulty;
              return ListTile(
                title: Text(difficulty.name.toUpperCase()),
                leading: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? Theme.of(context).primaryColor : null,
                ),
                selected: isSelected,
                onTap: () async {
                  setState(() {
                    _selectedDifficulty = difficulty;
                  });
                  // Save to preferences
                  await _preferencesService.setDefaultDifficulty(difficulty);
                  Navigator.pop(context);
                  _loadHighScore(); // Reload high score for new difficulty
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showTimeLimitPicker(BuildContext context) async {
    final timeLimits = [0, 1, 2, 3, 5, 10, 15, 20, 30]; // 0 means no limit

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Time Limit'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: timeLimits.length,
              itemBuilder: (context, index) {
                final timeLimit = timeLimits[index];
                final isSelected = timeLimit == _selectedTimeInMinutes;
                final displayText =
                    timeLimit == 0 ? 'No Limit' : '$timeLimit minutes';

                return ListTile(
                  title: Text(displayText),
                  leading: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected ? Theme.of(context).primaryColor : null,
                  ),
                  selected: isSelected,
                  onTap: () async {
                    setState(() {
                      _selectedTimeInMinutes = timeLimit;
                    });
                    // Save to preferences
                    await _preferencesService.setDefaultTimeLimit(timeLimit);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showExamCodeDialog() {
    final TextEditingController codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Exam Code 📝'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter the code provided by your teacher to start the exam.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Exam Code',
                hintText: 'e.g., MATH101',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.vpn_key),
              ),
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
              if (code.isNotEmpty) {
                Navigator.pop(context);
                _startExam(code);
              }
            },
            child: const Text('Start Exam'),
          ),
        ],
      ),
    );
  }

  Future<void> _startExam(String code) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final examData = await _firestoreService.getExamByCode(code);

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
      }

      if (examData != null) {
        // Check if exam is within time window
        final now = DateTime.now();
        final startTime = DateTime.parse(examData['startTime']);
        final endTime = DateTime.parse(examData['endTime']);

        if (now.isBefore(startTime)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Exam hasn\'t started yet. It begins at ${DateFormat('MMM d, h:mm a').format(startTime)}'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Notify Me',
                  textColor: Colors.white,
                  onPressed: () {
                    NotificationService().scheduleEventReminder(
                      eventId: examData['code'],
                      title: 'Exam Started: ${examData['subject']}',
                      body:
                          'The exam "${examData['subject']}" has started! Tap to begin.',
                      scheduledAt: startTime,
                      reminderBefore:
                          Duration.zero, // Notify exactly at start time
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification scheduled!')),
                    );
                  },
                ),
              ),
            );
          }
          return;
        }

        if (now.isAfter(endTime)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Exam has ended. You can no longer take this exam.'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          }
          return;
        }

        // Validate matric number if restrictions exist
        final matricYear = examData['matricYear'];
        final allowedDeptCodes = examData['allowedDeptCodes'];

        if (matricYear != null || allowedDeptCodes != null) {
          // Get current user's matric number
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please log in to access this exam'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }

          // Fetch user's matric number from Firestore
          final userData = await _firestoreService.getUser(user.uid);
          final userMatricNumber = userData?['matricNumber'] as String?;

          if (userMatricNumber == null || userMatricNumber.isEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Matric number required. Please update your profile.'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 5),
                ),
              );
            }
            return;
          }

          // Parse matric number (format: 200/221/017)
          final parts = userMatricNumber.split('/');
          if (parts.length < 2) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Invalid matric number format. Expected: YEAR/DEPT/NUMBER'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 5),
                ),
              );
            }
            return;
          }

          final userYear = parts[0];
          final userDept = parts[1];

          // Check year restriction
          if (matricYear != null && userYear != matricYear) {
            // Check if user is a carry-over student
            final carryOverMatrics = examData['carryOverMatrics'];
            bool isCarryOver = false;

            if (carryOverMatrics != null && carryOverMatrics is List) {
              final carryOverList = carryOverMatrics.cast<String>();
              isCarryOver = carryOverList.contains(userMatricNumber);
            }

            if (!isCarryOver) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Access Denied: This exam is for $matricYear entry students only'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
              return;
            }
          }

          // Check department restriction
          if (allowedDeptCodes != null && allowedDeptCodes is List) {
            final deptList = allowedDeptCodes.cast<String>();

            // Check if user is a carry-over student (bypass dept check)
            final carryOverMatrics = examData['carryOverMatrics'];
            bool isCarryOver = false;

            if (carryOverMatrics != null && carryOverMatrics is List) {
              final carryOverList = carryOverMatrics.cast<String>();
              isCarryOver = carryOverList.contains(userMatricNumber);
            }

            if (!isCarryOver && !deptList.contains(userDept)) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Access Denied: This exam is only for department(s): ${deptList.join(", ")}'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
              return;
            }
          }
        }

        // Parse difficulty string to enum
        Difficulty difficulty = Difficulty.medium;
        if (examData['difficulty'] == 'Easy') difficulty = Difficulty.easy;
        if (examData['difficulty'] == 'Hard') difficulty = Difficulty.hard;

        final durationMinutes = examData['durationMinutes'] ?? 20;
        final subject = examData['subject'] ?? 'General Knowledge';

        // Show exam details confirmation dialog
        if (mounted) {
          final shouldStart = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '📝 Exam Details',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _buildCompactDetailRow(Icons.subject, 'Subject', subject),
                    const SizedBox(height: 8),
                    _buildCompactDetailRow(
                        Icons.timer, 'Duration', '$durationMinutes mins'),
                    const SizedBox(height: 8),
                    _buildCompactDetailRow(
                        Icons.quiz, 'Questions', '10'), // Or dynamic count
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.orange.shade700, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Timer starts immediately!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Start Exam'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );

          if (shouldStart == true && mounted) {
            // Check if exam has custom questions
            final quizId = examData['quizId'];
            dynamic customQuiz;

            if (quizId != null) {
              // Load custom quiz from Firestore
              try {
                customQuiz = await _firestoreService.getQuiz(quizId);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error loading exam questions: $e')),
                  );
                }
                return;
              }
            }

            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(
                    difficulty: difficulty,
                    category: subject,
                    quizLength: 10,
                    isExamMode: true,
                    timeLimitInMinutes: durationMinutes,
                    quiz: customQuiz, // Pass custom quiz if it exists
                  ),
                ),
              );
            }
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid Exam Code ❌'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildCompactDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Mindly'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Theme.of(context).primaryColor.withOpacity(0.7),
            ),
          ),
        ),
        actions: [
          // Streak Display
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department,
                    color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$_currentStreak',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    // Use theme color if background is light, or white if dark/glassy
                    // Since AppBar is primaryColor.withOpacity(0.7), white is safer
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Notification bell with badge
          StreamBuilder<int>(
            stream: _getUnreadNotificationCount(),
            builder: (context, snapshot) {
              final unreadCount = snapshot.data ?? 0;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            unreadCount > 99 ? '99+' : '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            _userAvatar,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _username,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics_outlined),
              title: const Text('Statistics'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/statistics');
              },
            ),
            ListTile(
              leading: const Icon(Icons.leaderboard_outlined),
              title: const Text('Leaderboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/leaderboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.school_outlined),
              title: const Text('My Classes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/classes');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border),
              title: const Text('Bookmarks'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/bookmarks');
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: const Text('Achievements'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/achievements');
              },
            ),
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('My Quizzes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/myQuizzes');
              },
            ),
            ListTile(
              leading: const Icon(Icons.groups),
              title: const Text('Join Quiz'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/joinQuiz');
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: const Text('AI Quiz Generator'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/generateQuiz');
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Video Library'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VideoLibraryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Document Library'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/documents');
              },
            ),
            ListTile(
              leading: const Icon(Icons.gesture),
              title: const Text('Math Solver'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HandwritingScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings').then((_) {
                  // Reload preferences when returning from settings
                  _initializeScreen();
                });
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Center(
            child: RefreshIndicator(
              onRefresh: _refreshDashboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Animated Icon
                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: ElasticIn(
                          duration: const Duration(milliseconds: 1000),
                          child: Hero(
                            tag: 'app_icon',
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.school,
                                size: 60,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Animated Greeting
                      FadeIn(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          '${_getGreeting()} $_username!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeIn(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 400),
                        child: Text(
                          'Test your knowledge.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // --- Daily Goal Card ---
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 600),
                        child: Container(
                          padding: const EdgeInsets.all(16), // Reduced from 20
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColor.withOpacity(0.7),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(16), // Reduced from 20
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Daily Goal',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_totalQuizzes % 3}/3 Quizzes',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Trophy icon without circle
                                  const Icon(
                                    Icons.emoji_events,
                                    color: Colors.white,
                                    size: 28, // Slightly larger since no circle
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12), // Reduced from 16
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: (_totalQuizzes % 3) / 3,
                                  minHeight: 6, // Reduced from 8
                                  backgroundColor:
                                      Colors.white.withOpacity(0.3),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ), // Close FadeInUp
                      const SizedBox(height: 24),

                      // --- Teacher Dashboard (Only for Teachers) ---
                      if (_userRole == 'teacher')
                        FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 700),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TeacherDashboardScreen(),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple.shade700,
                                      Colors.purple.shade500,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple.withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.dashboard,
                                          color: Colors.white, size: 28),
                                    ),
                                    const SizedBox(width: 16),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Teacher Dashboard',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'View student progress & results',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios,
                                        color: Colors.white70, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      // --- Enter Exam Code (For Students/Everyone) ---
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 750),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          child: InkWell(
                            onTap: _showExamCodeDialog,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.indigo.shade700,
                                    Colors.indigo.shade500,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.indigo.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.vpn_key,
                                        color: Colors.white, size: 28),
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Enter Exam Code',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Start a secure exam session',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios,
                                      color: Colors.white70, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // --- Quick Actions ---
                      Row(
                        children: [
                          Expanded(
                            child: FadeInLeft(
                              duration: const Duration(milliseconds: 600),
                              delay: const Duration(milliseconds: 800),
                              child: _buildQuickActionCard(
                                context,
                                icon: Icons.play_circle_outline,
                                title: 'Daily\nChallenge',
                                color: Colors.orange,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/daily_challenge');
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FadeInRight(
                              duration: const Duration(milliseconds: 600),
                              delay: const Duration(milliseconds: 800),
                              child: _buildQuickActionCard(
                                context,
                                icon: Icons.video_library,
                                title: 'Video\nLibrary',
                                color: Colors.blue,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const VideoLibraryScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // --- Smart Recommendations ---
                      if (_smartRecommendations.isNotEmpty)
                        FadeIn(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 1000),
                          child: SmartRecommendationsCard(
                            recommendations: _smartRecommendations,
                          ),
                        ),

                      if (_smartRecommendations.isNotEmpty)
                        const SizedBox(height: 30),

                      // --- Current Settings Summary ---
                      FadeIn(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 1000),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Current Settings',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _showCategoryPicker(context),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(Icons.category,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            const SizedBox(height: 4),
                                            Text(
                                              _selectedCategory ?? 'All',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'Category',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            const SizedBox(height: 2),
                                            Icon(Icons.expand_more,
                                                size: 14, color: Colors.grey),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          _showDifficultyPicker(context),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(Icons.speed,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            const SizedBox(height: 4),
                                            Text(
                                              _selectedDifficulty.name
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'Difficulty',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            const SizedBox(height: 2),
                                            Icon(Icons.expand_more,
                                                size: 14, color: Colors.grey),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          _showTimeLimitPicker(context),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(Icons.timer,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            const SizedBox(height: 4),
                                            Text(
                                              _selectedTimeInMinutes == 0
                                                  ? 'No Limit'
                                                  : '$_selectedTimeInMinutes min',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'Time',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            const SizedBox(height: 2),
                                            Icon(Icons.expand_more,
                                                size: 14, color: Colors.grey),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- High Score Display ---
                      if (_highScore > 0)
                        FadeIn(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 1200),
                          child: Text(
                            'High Score: $_highScore',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),

                      const SizedBox(height: 40),
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 1400),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text('Start Quiz'),
                          onPressed: () {
                            // Haptic Feedback
                            final myAppState =
                                context.findAncestorStateOfType<MyAppState>();
                            if (myAppState?.hapticEnabled ?? true) {
                              HapticFeedback.lightImpact();
                            }

                            // Use defaults if null
                            final category = _selectedCategory ??
                                'General Knowledge'; // Fallback

                            Navigator.pushReplacementNamed(
                              context,
                              '/quiz',
                              arguments: {
                                'difficulty': _selectedDifficulty,
                                'category': category == 'All'
                                    ? null
                                    : category, // Handle 'All'
                                'timeLimitInMinutes': _selectedTimeInMinutes,
                                'quizLength': _quizLength,
                              },
                            );
                          },
                        ),
                      ), // Close FadeInUp for Start Quiz
                      const SizedBox(height: 12),
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 1500),
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          icon: const Icon(Icons.fitness_center, size: 20),
                          label: const Text('Practice Mode'),
                          onPressed: () async {
                            // Import needed
                            final bookmarkService = BookmarkService();
                            final bookmarks =
                                await bookmarkService.getBookmarkedQuestions();

                            if (!mounted) return;

                            if (bookmarks.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'No bookmarked questions yet! Bookmark questions during quizzes.'),
                                ),
                              );
                              return;
                            }

                            Navigator.pushNamed(
                              context,
                              '/practice',
                              arguments: {
                                'questions': bookmarks,
                                'title': 'Practice: Bookmarked Questions',
                              },
                            );
                          },
                        ),
                      ), // Close FadeInUp for Practice Mode
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
