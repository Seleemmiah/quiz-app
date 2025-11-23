import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/services/score_service.dart';
import 'package:quiz_app/services/bookmark_service.dart';
import 'package:quiz_app/services/preferences_service.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/services/notification_service.dart';
import 'package:quiz_app/services/recommendation_service.dart';
import 'package:quiz_app/services/api_service.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  // --- State Variables ---
  Difficulty _selectedDifficulty = Difficulty.easy;
  int _selectedTimeInMinutes = 5; // Default to 5 minutes, now non-nullable
  String? _selectedCategory;
  int _highScore = 0;
  String _userAvatar = '👨‍🎓';
  String _username = 'Quiz Master';
  int _quizLength = 10;

  // Future to hold categories from the API
  final ScoreService _scoreService = ScoreService();
  final BookmarkService _bookmarkService = BookmarkService();
  final PreferencesService _preferencesService = PreferencesService();
  final RecommendationService _recommendationService = RecommendationService();
  final ApiService _apiService = ApiService();

  List<Recommendation> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    // Check for username first
    final user = FirebaseAuth.instance.currentUser;
    if (user != null &&
        (user.displayName == null || user.displayName!.isEmpty)) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/username_setup');
        return;
      }
    }

    // Load preferences first
    final difficulty = await _preferencesService.getDefaultDifficulty();
    final category = await _preferencesService.getDefaultCategory();
    final timeLimit = await _preferencesService.getDefaultTimeLimit();
    final quizLength = await _preferencesService.getQuizLength();

    if (mounted) {
      setState(() {
        _selectedDifficulty = difficulty;
        _selectedCategory = category;
        _selectedTimeInMinutes = timeLimit;
        _quizLength = quizLength;
      });

      // Load high score and avatar
      _loadHighScore();
      _loadAvatar();
      _loadRecommendations();

      // Setup notifications
      _setupNotifications();
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
    final notificationService = NotificationService();
    await notificationService.requestPermissions();
    await notificationService.scheduleDailyNotification();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        centerTitle: true,
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Hero(
                    tag: 'app_icon',
                    child: Icon(
                      Icons.school,
                      color: Theme.of(context).primaryColor,
                      size: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  '${_getGreeting()} $_username!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight:
                            FontWeight.bold, // Keep bold, but remove size/color
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Test your knowledge.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 40),

                // --- Current Settings Summary ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Current Settings',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () => _showCategoryPicker(context),
                            child: _buildSettingItem(
                              context,
                              Icons.category,
                              _selectedCategory ?? 'All',
                              'Category',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showDifficultyPicker(context),
                            child: _buildSettingItem(
                              context,
                              Icons.speed,
                              _selectedDifficulty.name.toUpperCase(),
                              'Difficulty',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showTimeLimitPicker(context),
                            child: _buildSettingItem(
                              context,
                              Icons.timer,
                              _selectedTimeInMinutes == 0
                                  ? 'No Limit'
                                  : '$_selectedTimeInMinutes min',
                              'Time',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // --- High Score Display ---
                if (_highScore > 0)
                  Text(
                    'High Score: $_highScore',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                const SizedBox(height: 40),
                ElevatedButton(
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
                    final category =
                        _selectedCategory ?? 'General Knowledge'; // Fallback

                    Navigator.pushReplacementNamed(
                      context,
                      '/quiz',
                      arguments: {
                        'difficulty': _selectedDifficulty,
                        'category':
                            category == 'All' ? null : category, // Handle 'All'
                        'timeLimitInMinutes': _selectedTimeInMinutes,
                        'quizLength': _quizLength,
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
