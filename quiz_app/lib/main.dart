import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // --- 1. DEFINE LIGHT THEME ---
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.indigo,
      scaffoldBackgroundColor: Colors.grey.shade100, // Light background
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      ).apply(
        bodyColor: Colors.black, // Default text color for light mode
        displayColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo, // Button color
          foregroundColor: Colors.white, // Button text color
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.indigo,
      scaffoldBackgroundColor: Color(0xFF2D344A), // A nice dark blue
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      ).apply(
        bodyColor: Colors.white, // Default text color for dark mode
        displayColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo.shade400, // Button color
          foregroundColor: Colors.white, // Button text color
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          // --- FIX ---
          // You were missing the textStyle here
          textStyle: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          // --- FIX ---
        ),
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
