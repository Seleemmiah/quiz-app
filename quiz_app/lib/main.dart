import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/screens/review_screen.dart';
import 'package:quiz_app/screens/settings_screen.dart';
import 'package:quiz_app/screens/splash_screen.dart';
import 'package:quiz_app/screens/start_screen.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/services/settings_service.dart';
// import 'packagepackage:quiz_app/settings.dart';

void main() async {
  // Ensure that plugin services are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system; // Initialize directly
  ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);
  final SettingsService _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    try {
      // Load settings in background without blocking UI
      final savedThemeMode = await _settingsService.getThemeMode().timeout(
            const Duration(seconds: 5),
            onTimeout: () => ThemeMode.system,
          );
      if (mounted) {
        setState(() {
          _themeMode = savedThemeMode;
        });
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  @override
  void dispose() {
    themeModeNotifier.dispose();
    super.dispose();
  }

  // Public getter to expose the private themeMode state
  ThemeMode get themeMode => _themeMode;

  @override
  Widget build(BuildContext context) {
    // App is always ready to render now
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: _lightTheme, // Provide light theme.
      darkTheme: _darkTheme,
      themeMode: _themeMode,
      initialRoute: '/splash', // Set the initial route to the splash screen.
      // Use onGenerateRoute for routes that need arguments for better safety.
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/':
            return MaterialPageRoute(builder: (_) => const StartScreen());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/quiz':
            final args = (settings.arguments ?? {}) as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => QuizScreen(
                difficulty: args['difficulty'] ?? Difficulty.easy,
                category: args['category'] as String?,
                // Explicitly cast to int? to ensure type safety.
                timeLimitInMinutes: args['timeLimitInMinutes'] as int?,
              ),
            );
          case '/results':
            final args = (settings.arguments ?? {}) as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => ResultScreen(
                score: args['score'] ?? 0,
                totalQuestions: args['totalQuestions'] ?? 0,
                difficulty: args['difficulty'] ?? Difficulty.easy,
                category: args['category'] as String?,
                // Safely cast the lists to their expected types.
                questions: List<Question>.from(args['questions'] ?? []),
                selectedAnswers:
                    List<String?>.from(args['selectedAnswers'] ?? []),
              ),
            );
          case '/review':
            final args = (settings.arguments ?? {}) as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => ReviewScreen(
                // Safely cast the lists to their expected types.
                questions: List<Question>.from(args['questions'] ?? []),
                selectedAnswers:
                    List<String?>.from(args['selectedAnswers'] ?? []),
              ),
            );
          default:
            // If no route matches, default to the start screen.
            return MaterialPageRoute(builder: (_) => const StartScreen());
        }
      },
    );
  }

  void changeTheme(ThemeMode themeMode) {
    _settingsService.setThemeMode(themeMode);
    setState(() {
      _themeMode = themeMode;
    });
  }
}

// --- 1. DEFINE LIGHT THEME ---
final _lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.indigo,
  scaffoldBackgroundColor: Colors.grey.shade100, // Light background
  textTheme: GoogleFonts.latoTextTheme().apply(
    bodyColor: Colors.black, // Default text color for light mode
    displayColor: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor:
          Colors.indigo, // Button color (reverted as per user request)
      foregroundColor: Colors.white, // Button text color
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: GoogleFonts.lato(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);

// --- 2. DEFINE DARK THEME ---
final _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  scaffoldBackgroundColor: const Color(0xFF2D344A), // A nice dark blue
  textTheme: GoogleFonts.latoTextTheme().apply(
    bodyColor: Colors.white, // Default text color for dark mode
    displayColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.indigo.shade400, // Button color
      foregroundColor: Colors.white, // Button text color
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: GoogleFonts.lato(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);
