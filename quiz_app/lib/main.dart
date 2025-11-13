import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/screens/start_screen.dart';

void main() {
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
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/results': (context) {
          // We get the arguments (the score AND total) passed by the Navigator
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, int>;

          return ResultScreen(
            score: args['score']!,
            // We now get the total from the arguments!
            totalQuestions: args['totalQuestions']!,
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
