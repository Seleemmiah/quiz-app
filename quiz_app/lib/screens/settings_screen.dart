import 'package:flutter/material.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/services/settings_service.dart';
import 'package:quiz_app/services/statistics_service.dart';
import 'package:quiz_app/services/achievement_service.dart';
import 'package:quiz_app/services/bookmark_service.dart';
import 'package:quiz_app/services/preferences_service.dart';
import 'package:quiz_app/services/api_service.dart';
import 'package:quiz_app/settings.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quiz_app/models/theme_preset.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  final StatisticsService _statisticsService = StatisticsService();
  final AchievementService _achievementService = AchievementService();
  final BookmarkService _bookmarkService = BookmarkService();
  final PreferencesService _preferencesService = PreferencesService();
  final ApiService _apiService = ApiService();

  double _fontSize = 1.0;
  Difficulty _defaultDifficulty = Difficulty.easy;
  int _quizLength = 10;
  String? _defaultCategory;
  int _defaultTimeLimit = 5;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load categories first
    try {
      final categories = await _apiService.fetchCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
        });
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }

    await _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final fontSize = await _preferencesService.getFontSize();
    final difficulty = await _preferencesService.getDefaultDifficulty();
    final length = await _preferencesService.getQuizLength();
    final category = await _preferencesService.getDefaultCategory();
    final timeLimit = await _preferencesService.getDefaultTimeLimit();

    if (mounted) {
      setState(() {
        _fontSize = fontSize;
        _defaultDifficulty = difficulty;
        _quizLength = length;
        _defaultCategory = category;
        _defaultTimeLimit = timeLimit;
      });
    }
  }

  void _showResetConfirmationDialog(
      String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _resetHighScores() {
    _settingsService.resetHighScores();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All high scores have been reset')),
    );
  }

  void _resetStatistics() {
    _statisticsService.resetStatistics();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All statistics have been reset')),
    );
  }

  void _resetAchievements() {
    _achievementService.resetAchievements();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All achievements have been reset')),
    );
  }

  void _clearBookmarks() {
    _bookmarkService.clearAllBookmarks();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All bookmarks have been cleared')),
    );
  }

  void _resetAllData() {
    _settingsService.resetHighScores();
    _statisticsService.resetStatistics();
    _achievementService.resetAchievements();
    _bookmarkService.clearAllBookmarks();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All app data has been reset'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Quiz App',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.school, size: 48, color: Colors.indigo),
      children: [
        const Text(
            'A comprehensive quiz application with statistics tracking, achievements, and bookmarking features.'),
        const SizedBox(height: 16),
        const Text('Features:'),
        const Text('• Multiple difficulty levels'),
        const Text('• Category selection'),
        const Text('• Statistics dashboard'),
        const Text('• Achievement system'),
        const Text('• Question bookmarking'),
        const Text('• Share functionality'),
      ],
    );
  }

  void _shareApp() {
    Share.share(
      'Check out Quiz App! Test your knowledge across multiple categories and difficulty levels. Track your progress and unlock achievements!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final myAppState = context.findAncestorStateOfType<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 32),
        children: [
          // Appearance Section
          _buildSectionCard(
            context,
            'Appearance',
            [
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Theme'),
                subtitle: const Text('Choose your preferred theme'),
                trailing: DropdownButton<ThemeMode>(
                  value: myAppState == null
                      ? ThemeMode.system
                      : myAppState.themeMode,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                  onChanged: (ThemeMode? theme) {
                    if (theme != null) {
                      myAppState?.changeTheme(theme);
                    }
                  },
                ),
              ),
              if (myAppState != null &&
                  (myAppState.themeMode == ThemeMode.dark ||
                      (myAppState.themeMode == ThemeMode.system &&
                          MediaQuery.of(context).platformBrightness ==
                              Brightness.dark)))
                SwitchListTile(
                  title: const Text('OLED Dark Mode'),
                  subtitle: const Text('Use true black background'),
                  value: myAppState.isOledMode,
                  onChanged: (bool value) {
                    myAppState.toggleOledMode(value);
                  },
                  secondary: const Icon(Icons.dark_mode),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Color Theme'),
                subtitle: Text(myAppState?.currentThemePreset ?? 'Default'),
                trailing: DropdownButton<String>(
                  value: myAppState?.currentThemePreset ?? 'Default',
                  underline: const SizedBox(),
                  items: ThemePreset.presets.map((preset) {
                    return DropdownMenuItem(
                      value: preset.name,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(preset.emoji),
                          const SizedBox(width: 8),
                          Text(preset.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      myAppState?.changeThemePreset(value);
                    }
                  },
                ),
              ),
            ],
          ),

          // Preferences Section
          _buildSectionCard(
            context,
            'Preferences',
            [
              SwitchListTile(
                title: const Text('Haptic Feedback'),
                subtitle: const Text('Vibrate on interactions'),
                value: myAppState?.hapticEnabled ?? true,
                onChanged: (bool value) {
                  myAppState?.toggleHaptic(value);
                },
                secondary: const Icon(Icons.vibration),
                activeColor: Theme.of(context).primaryColor,
              ),
              ListTile(
                leading: const Icon(Icons.format_size, color: Colors.purple),
                title: const Text('Font Size'),
                subtitle: Text(_fontSize == 0.8
                    ? 'Small'
                    : _fontSize == 1.0
                        ? 'Medium'
                        : 'Large'),
                trailing: SegmentedButton<double>(
                  segments: const [
                    ButtonSegment(value: 0.8, label: Text('S')),
                    ButtonSegment(value: 1.0, label: Text('M')),
                    ButtonSegment(value: 1.2, label: Text('L')),
                  ],
                  selected: {_fontSize},
                  onSelectionChanged: (Set<double> newSelection) async {
                    final newSize = newSelection.first;
                    await _preferencesService.setFontSize(newSize);
                    setState(() {
                      _fontSize = newSize;
                    });
                  },
                  style: SegmentedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.quiz, color: Colors.indigo),
                title: const Text('Quiz Length'),
                subtitle: Text('$_quizLength questions per quiz'),
                trailing: DropdownButton<int>(
                  value: _quizLength,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 5, child: Text('5')),
                    DropdownMenuItem(value: 10, child: Text('10')),
                    DropdownMenuItem(value: 15, child: Text('15')),
                    DropdownMenuItem(value: 20, child: Text('20')),
                  ],
                  onChanged: (int? value) async {
                    if (value != null) {
                      await _preferencesService.setQuizLength(value);
                      setState(() {
                        _quizLength = value;
                      });
                    }
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.category, color: Colors.teal),
                title: const Text('Default Category'),
                subtitle: Text(_defaultCategory ?? 'All Categories'),
                trailing: DropdownButton<String>(
                  value: _categories.contains(_defaultCategory)
                      ? _defaultCategory
                      : null,
                  hint: const Text('All'),
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All Categories'),
                    ),
                    ..._categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: SizedBox(
                          width: 120,
                          child: Text(
                            category,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }),
                  ],
                  onChanged: (String? value) async {
                    if (value != null) {
                      await _preferencesService.setDefaultCategory(value);
                    }
                    setState(() {
                      _defaultCategory = value;
                    });
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.timer, color: Colors.redAccent),
                title: const Text('Time Limit'),
                subtitle: Text('$_defaultTimeLimit minutes'),
                trailing: DropdownButton<int>(
                  value: _defaultTimeLimit,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 2, child: Text('2 min')),
                    DropdownMenuItem(value: 5, child: Text('5 min')),
                    DropdownMenuItem(value: 10, child: Text('10 min')),
                    DropdownMenuItem(value: 15, child: Text('15 min')),
                    DropdownMenuItem(value: 30, child: Text('30 min')),
                  ],
                  onChanged: (int? value) async {
                    if (value != null) {
                      await _preferencesService.setDefaultTimeLimit(value);
                      setState(() {
                        _defaultTimeLimit = value;
                      });
                    }
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.speed, color: Colors.orange),
                title: const Text('Default Difficulty'),
                subtitle: Text(_capitalize(_defaultDifficulty.name)),
                trailing: DropdownButton<Difficulty>(
                  value: _defaultDifficulty,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                        value: Difficulty.easy, child: Text('Easy')),
                    DropdownMenuItem(
                        value: Difficulty.medium, child: Text('Medium')),
                    DropdownMenuItem(
                        value: Difficulty.hard, child: Text('Hard')),
                  ],
                  onChanged: (Difficulty? value) async {
                    if (value != null) {
                      await _preferencesService.setDefaultDifficulty(value);
                      setState(() {
                        _defaultDifficulty = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),

          // Data Management Section
          _buildSectionCard(
            context,
            'Data Management',
            [
              ListTile(
                leading:
                    const Icon(Icons.analytics_outlined, color: Colors.blue),
                title: const Text('Reset Statistics'),
                subtitle: const Text('Clear all quiz statistics'),
                onTap: () => _showResetConfirmationDialog(
                  'Reset Statistics?',
                  'This will clear all your quiz statistics including total quizzes, averages, and category data.',
                  _resetStatistics,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.emoji_events_outlined,
                    color: Colors.amber),
                title: const Text('Reset Achievements'),
                subtitle: const Text('Reset all unlocked achievements'),
                onTap: () => _showResetConfirmationDialog(
                  'Reset Achievements?',
                  'This will reset all your unlocked achievements and streaks.',
                  _resetAchievements,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_border, color: Colors.green),
                title: const Text('Clear Bookmarks'),
                subtitle: const Text('Remove all bookmarked questions'),
                onTap: () => _showResetConfirmationDialog(
                  'Clear Bookmarks?',
                  'This will remove all your bookmarked questions.',
                  _clearBookmarks,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.leaderboard, color: Colors.purple),
                title: const Text('Reset High Scores'),
                subtitle: const Text('Clear all high scores'),
                onTap: () => _showResetConfirmationDialog(
                  'Reset High Scores?',
                  'This will reset all your high scores across all categories and difficulties.',
                  _resetHighScores,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  'Reset All Data',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                    'Clear everything (scores, stats, achievements, bookmarks)'),
                onTap: () => _showResetConfirmationDialog(
                  'Reset All Data?',
                  'This will permanently delete ALL your data including high scores, statistics, achievements, and bookmarks. This action cannot be undone!',
                  _resetAllData,
                ),
              ),
            ],
          ),

          // App Info Section
          _buildSectionCard(
            context,
            'About',
            [
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.blue),
                title: const Text('About Quiz App'),
                subtitle: const Text('Version 1.0.0'),
                onTap: _showAboutDialog,
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.green),
                title: const Text('Share App'),
                subtitle: const Text('Tell your friends about Quiz App'),
                onTap: _shareApp,
              ),
              ListTile(
                leading:
                    const Icon(Icons.bug_report_outlined, color: Colors.orange),
                title: const Text('Report a Bug'),
                subtitle: const Text('Help us improve'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bug reporting feature coming soon!'),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Footer
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Made with ❤️ for learners',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
      BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
