import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/screens/splash_screen.dart';
import 'package:quiz_app/screens/start_screen.dart';
import 'package:quiz_app/settings.dart';
// import 'packagepackage:quiz_app/settings.dart';

void main() async {
  // Ensure that plugin services are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: _lightTheme, // Provide light theme.
      darkTheme: _darkTheme,
      themeMode: _themeMode, // Use state to control theme mode.
      initialRoute: '/splash', // Set the initial route to the splash screen
      routes: {
        '/splash': (context) => const SplashScreen(), // Add splash screen route
        '/': (context) => const StartScreen(), // Keep start screen route
        '/results': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;

          return ResultScreen(
            score: args['score']!,
            totalQuestions: args['totalQuestions']!,
            difficulty: args['difficulty'] as Difficulty,
            category: args['category'] as String?,
          );
        },
      },
    );
  }

  void changeTheme(ThemeMode themeMode) {
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
