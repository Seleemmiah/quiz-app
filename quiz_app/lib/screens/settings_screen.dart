import 'package:flutter/material.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/services/settings_service.dart';
import 'package:quiz_app/services/statistics_service.dart';
import 'package:quiz_app/services/achievement_service.dart';
import 'package:quiz_app/services/bookmark_service.dart';
import 'package:quiz_app/services/preferences_service.dart';
import 'package:quiz_app/services/api_service.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/settings.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quiz_app/models/theme_preset.dart';
import 'package:quiz_app/widgets/glass_card.dart';
import 'package:quiz_app/widgets/glass_dialog.dart';

import 'package:quiz_app/services/gamification_service.dart';
import 'package:quiz_app/services/voice_service.dart';

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
  final GamificationService _gamificationService = GamificationService();

  double _fontSize = 1.0;
  Difficulty _defaultDifficulty = Difficulty.easy;
  int _quizLength = 10;
  String? _defaultCategory;
  int _defaultTimeLimit = 5;
  List<String> _categories = [];
  int _userLevel = 1;

  // Voice Settings
  double _voiceSpeed = 0.5;
  double _voicePitch = 1.0;
  double _voiceVolume = 1.0;
  final VoiceService _voiceService = VoiceService();

  bool _studyRemindersEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load categories first
    try {
      final categories = await _apiService.fetchCategories();
      final xp = await _gamificationService.getTotalXP();
      final level = _gamificationService.getLevel(xp);

      if (mounted) {
        setState(() {
          _categories = categories;
          _userLevel = level;

          // Initialize voice settings
          _voiceSpeed = _voiceService.speechRate;
          _voicePitch = _voiceService.pitch;
          _voiceVolume = _voiceService.volume;
        });
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    }

    await _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final fontSize = await _preferencesService.getFontSize();
    final difficulty = await _preferencesService.getDefaultDifficulty();
    final length = await _preferencesService.getQuizLength();
    final category = await _preferencesService.getDefaultCategory();
    int timeLimit = await _preferencesService.getDefaultTimeLimit();
    final studyReminders = await _preferencesService.getStudyRemindersEnabled();

    // Define valid time limits
    const validTimeLimits = [2, 5, 10, 30];
    // If the loaded time limit is not in our valid list, reset to a default.
    if (!validTimeLimits.contains(timeLimit)) {
      timeLimit = 5; // Default to 5 minutes
    }

    if (mounted) {
      setState(() {
        _fontSize = fontSize;
        _defaultDifficulty = difficulty;
        _quizLength = length;
        _defaultCategory = category;
        _defaultTimeLimit = timeLimit;
        _studyRemindersEnabled = studyReminders;
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
      applicationName: 'Mindly',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.school, size: 48, color: Colors.indigo),
      children: [
        const Text(
            'A comprehensive quiz application with statistics tracking, achievements, and bookmarking features. Test your knowledge and track your progress!'),
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
      'Check out Mindly! Test your knowledge across multiple categories and difficulty levels. Track your progress and unlock achievements!',
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
              SwitchListTile(
                title: const Text('OLED Dark Mode'),
                subtitle:
                    const Text('Use true black background (dark mode only)'),
                value: myAppState?.isOledMode ?? false,
                onChanged: (bool value) {
                  myAppState?.toggleOledMode(value);
                },
                secondary: const Icon(Icons.dark_mode),
                activeColor: Theme.of(context).primaryColor,
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Theme Mode'),
                subtitle: Text(_getThemeModeLabel(
                    myAppState?.themeMode ?? ThemeMode.system)),
                trailing: DropdownButton<ThemeMode>(
                  value: myAppState?.themeMode ?? ThemeMode.system,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.light_mode, size: 18),
                          SizedBox(width: 8),
                          Text('Light'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.brightness_auto, size: 18),
                          SizedBox(width: 8),
                          Text('System'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.dark_mode, size: 18),
                          SizedBox(width: 8),
                          Text('Dark'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (ThemeMode? newValue) {
                    if (newValue != null) {
                      myAppState?.changeThemeMode(newValue);
                    }
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Color Theme'),
                subtitle: Text(
                  '${myAppState?.currentThemePreset.emoji ?? ''} ${myAppState?.currentThemePreset.name ?? 'Default'}',
                ),
                trailing: PopupMenuButton<ThemePreset>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (ThemePreset preset) {
                    final requiredLevel = preset.unlockLevel;
                    if (_userLevel < requiredLevel) {
                      GlassDialog.show(
                        context: context,
                        title: '🔒 Theme Locked',
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 64,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Reach Level $requiredLevel to unlock',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${preset.emoji} ${preset.name} Theme',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Keep playing quizzes to earn XP and level up!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Got it!',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                      return;
                    }
                    myAppState?.changeThemePreset(preset);
                  },
                  itemBuilder: (BuildContext context) {
                    return ThemePreset.presets.map((preset) {
                      final requiredLevel = preset.unlockLevel;
                      final isLocked = _userLevel < requiredLevel;
                      final isSelected =
                          myAppState?.currentThemePreset == preset;

                      return PopupMenuItem<ThemePreset>(
                        value: preset,
                        enabled: !isLocked,
                        child: Row(
                          children: [
                            Text(
                              preset.emoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        preset.name,
                                        style: TextStyle(
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isLocked ? Colors.grey : null,
                                        ),
                                      ),
                                      if (isLocked) ...[
                                        const SizedBox(width: 8),
                                        const Icon(Icons.lock,
                                            size: 14, color: Colors.grey),
                                      ],
                                      if (isSelected) ...[
                                        const SizedBox(width: 8),
                                        Icon(Icons.check,
                                            size: 16,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isLocked
                                        ? 'Unlock at Level $requiredLevel'
                                        : preset.description,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isLocked
                                          ? Colors.grey
                                          : Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
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
              SwitchListTile(
                secondary: const Icon(Icons.notifications_active,
                    color: Colors.orange),
                title: const Text('Study Reminders'),
                subtitle: const Text('Get notified when cards are due'),
                value: _studyRemindersEnabled,
                onChanged: (bool value) async {
                  await _preferencesService.setStudyRemindersEnabled(value);
                  setState(() {
                    _studyRemindersEnabled = value;
                  });
                },
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
              ListTile(
                leading: const Icon(Icons.notifications_outlined,
                    color: Colors.deepPurple),
                title: const Text('Notification Preferences'),
                subtitle: const Text('Manage notification settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pushNamed(context, '/notification_preferences');
                },
              ),
            ],
          ),

          // Voice Settings Section
          _buildSectionCard(
            context,
            'Voice Settings',
            [
              ListTile(
                leading: const Icon(Icons.speed, color: Colors.purple),
                title: const Text('Speech Rate'),
                subtitle: Slider(
                  value: _voiceSpeed,
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                  label: _voiceSpeed.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _voiceSpeed = value;
                    });
                    _voiceService.setSpeed(value);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.music_note, color: Colors.pink),
                title: const Text('Pitch'),
                subtitle: Slider(
                  value: _voicePitch,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  label: _voicePitch.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _voicePitch = value;
                    });
                    _voiceService.setPitch(value);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.volume_up, color: Colors.teal),
                title: const Text('Volume'),
                subtitle: Slider(
                  value: _voiceVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: _voiceVolume.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _voiceVolume = value;
                    });
                    _voiceService.setVolume(value);
                  },
                ),
              ),
              ListTile(
                title: const Text('Test Voice'),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    _voiceService
                        .speak('This is a test of the voice settings.');
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
                title: const Text('About Mindly'),
                subtitle: const Text('Version 1.0.0'),
                onTap: _showAboutDialog,
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.green),
                title: const Text('Share App'),
                subtitle: const Text('Tell your friends about Mindly'),
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
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Sign out of your account'),
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          style:
                              TextButton.styleFrom(foregroundColor: Colors.red),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && mounted) {
                    final authService = AuthService();
                    await authService.signOut();
                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/welcome',
                        (route) => false,
                      );
                    }
                  }
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

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  Widget _buildSectionCard(
      BuildContext context, String title, List<Widget> children) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.zero,
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
