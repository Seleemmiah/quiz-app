import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/screens/review_screen.dart';
import 'package:quiz_app/screens/settings_screen.dart';
import 'package:quiz_app/screens/splash_screen.dart';
import 'package:quiz_app/screens/start_screen.dart';
import 'package:quiz_app/screens/statistics_screen.dart';
import 'package:quiz_app/screens/bookmarks_screen.dart';
import 'package:quiz_app/screens/achievements_screen.dart';
import 'package:quiz_app/screens/practice_screen.dart';
import 'package:quiz_app/screens/profile_screen.dart';
import 'package:quiz_app/screens/leaderboard_screen.dart';
import 'package:quiz_app/screens/my_quizzes_screen.dart';
import 'package:quiz_app/screens/generate_quiz_screen.dart';
import 'package:quiz_app/screens/join_quiz_screen.dart';
import 'package:quiz_app/screens/auth/login_screen.dart';
import 'package:quiz_app/screens/auth/signup_screen.dart';
import 'package:quiz_app/screens/username_setup_screen.dart';
import 'package:quiz_app/screens/welcome_screen.dart';
import 'package:quiz_app/services/settings_service.dart';
import 'package:quiz_app/services/notification_service.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/models/theme_preset.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/screens/classes_screen.dart';
import 'package:quiz_app/screens/create_class_screen.dart';
import 'package:quiz_app/screens/join_class_screen.dart';
import 'package:quiz_app/screens/class_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  await NotificationService().init();

  final settingsService = SettingsService();
  await settingsService.loadSettings();

  runApp(MyApp(settingsService: settingsService));
}

// AuthWrapper to determine initial screen based on auth state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If user is logged in, go to home
        if (snapshot.hasData) {
          return const StartScreen();
        }

        // Otherwise show welcome screen
        return const WelcomeScreen();
      },
    );
  }
}

class MyApp extends StatefulWidget {
  final SettingsService settingsService;

  const MyApp({super.key, required this.settingsService});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late ThemePreset _currentThemePreset;
  bool _isOledMode = false;
  bool _hapticEnabled = true;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    final presetName = widget.settingsService.getThemePreset();
    _currentThemePreset = ThemePreset.presets.firstWhere(
      (p) => p.name == presetName,
      orElse: () => ThemePreset.presets.first,
    );
    _isOledMode = widget.settingsService.getOledMode();
    _hapticEnabled = widget.settingsService.getHapticEnabled();
    _themeMode = widget.settingsService.getThemeMode();
  }

  // Public methods for SettingsScreen to call
  void changeThemePreset(ThemePreset preset) {
    setState(() {
      _currentThemePreset = preset;
      widget.settingsService.setThemePreset(preset.name);
    });
  }

  void toggleOledMode(bool value) {
    setState(() {
      _isOledMode = value;
      widget.settingsService.setOledMode(value);
    });
  }

  void toggleHaptic(bool value) {
    setState(() {
      _hapticEnabled = value;
      widget.settingsService.setHapticEnabled(value);
    });
  }

  void changeThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
      widget.settingsService.setThemeMode(mode);
    });
  }

  // Public getters
  ThemePreset get currentThemePreset => _currentThemePreset;
  bool get isOledMode => _isOledMode;
  bool get hapticEnabled => _hapticEnabled;
  ThemeMode get themeMode => _themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: _currentThemePreset.createLightTheme(),
      darkTheme: _currentThemePreset.createDarkTheme(isOled: _isOledMode),
      themeMode: _themeMode,
      home: const AuthWrapper(), // Use AuthWrapper to determine initial screen
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/welcome':
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignupScreen());
          case '/username_setup':
            return MaterialPageRoute(
                builder: (_) => const UsernameSetupScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const StartScreen());
          case '/quiz':
            final args = (settings.arguments ?? {}) as Map<String, dynamic>;
            Difficulty difficulty;
            if (args['difficulty'] is String) {
              difficulty = Difficulty.values.firstWhere(
                (d) =>
                    d.name.toLowerCase() ==
                    (args['difficulty'] as String).toLowerCase(),
                orElse: () => Difficulty.easy,
              );
            } else {
              difficulty = args['difficulty'] ?? Difficulty.easy;
            }

            return MaterialPageRoute(
              builder: (_) => QuizScreen(
                difficulty: difficulty,
                category: args['category'],
                timeLimitInMinutes: args['timeLimitInMinutes'],
                quizLength: args['quizLength'] ?? 10,
                customQuestions: args['customQuestions'] != null
                    ? List<Question>.from(args['customQuestions'])
                    : null,
                quiz: args['quiz'],
              ),
            );
          case '/result':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => ResultScreen(
                score: args['score'],
                totalQuestions: args['totalQuestions'],
                questions: args['questions'],
                selectedAnswers: args['selectedAnswers'],
                difficulty: args['difficulty'],
                category: args['category'],
                timeTaken: args['timeTaken'],
                isBlindMode: args['isBlindMode'] ?? false,
              ),
            );
          case '/review':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => ReviewScreen(
                questions: List<Question>.from(args['questions'] ?? []),
                selectedAnswers:
                    List<String?>.from(args['selectedAnswers'] ?? []),
              ),
            );
          case '/statistics':
            return MaterialPageRoute(builder: (_) => const StatisticsScreen());
          case '/bookmarks':
            return MaterialPageRoute(builder: (_) => const BookmarksScreen());
          case '/achievements':
            return MaterialPageRoute(
                builder: (_) => const AchievementsScreen());
          case '/practice':
            final args = (settings.arguments ?? {}) as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => PracticeScreen(
                questions: List<Question>.from(args['questions'] ?? []),
                title: args['title'] ?? 'Practice Mode',
              ),
            );
          case '/myQuizzes':
            return MaterialPageRoute(builder: (_) => const MyQuizzesScreen());
          case '/joinQuiz':
            return MaterialPageRoute(builder: (_) => const JoinQuizScreen());
          case '/customQuiz':
            final args = (settings.arguments ?? {}) as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => QuizScreen(
                difficulty: Difficulty.easy,
                category: 'Custom',
                quizLength: (args['questions'] as List).length,
                customQuestions: List<Question>.from(args['questions']),
              ),
            );
          case '/generateQuiz':
            return MaterialPageRoute(
                builder: (_) => const GenerateQuizScreen());
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case '/leaderboard':
            return MaterialPageRoute(builder: (_) => const LeaderboardScreen());
          case '/classes':
            return MaterialPageRoute(builder: (_) => const ClassesScreen());
          case '/create_class':
            return MaterialPageRoute(builder: (_) => const CreateClassScreen());
          case '/join_class':
            return MaterialPageRoute(builder: (_) => const JoinClassScreen());
          case '/class_detail':
            return MaterialPageRoute(builder: (_) => const ClassDetailScreen());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          default:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
      },
    );
  }
}
