import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemePreset {
  final String name;
  final Color primaryColor;
  final Color accentColor;
  final String emoji;

  const ThemePreset({
    required this.name,
    required this.primaryColor,
    required this.accentColor,
    required this.emoji,
  });

  static const List<ThemePreset> presets = [
    ThemePreset(
      name: 'Default',
      primaryColor: Colors.indigo,
      accentColor: Colors.indigoAccent,
      emoji: '🎨',
    ),
    ThemePreset(
      name: 'Ocean',
      primaryColor: Color(0xFF006994),
      accentColor: Color(0xFF00B4D8),
      emoji: '🌊',
    ),
    ThemePreset(
      name: 'Forest',
      primaryColor: Color(0xFF2D6A4F),
      accentColor: Color(0xFF52B788),
      emoji: '🌲',
    ),
    ThemePreset(
      name: 'Sunset',
      primaryColor: Color(0xFFE63946),
      accentColor: Color(0xFFF77F00),
      emoji: '🌅',
    ),
    ThemePreset(
      name: 'Midnight',
      primaryColor: Color(0xFF1A1A2E),
      accentColor: Color(0xFF16213E),
      emoji: '🌙',
    ),
    ThemePreset(
      name: 'Lavender',
      primaryColor: Color(0xFF9D4EDD),
      accentColor: Color(0xFFC77DFF),
      emoji: '💜',
    ),
    // --- New Presets Below ---
    ThemePreset(
      name: 'Blush',
      primaryColor: Color(0xFFF08084),
      accentColor: Color(0xFFFFC3A0),
      emoji: '🌸',
    ),
    ThemePreset(
      name: 'Emerald',
      primaryColor: Color(0xFF009688),
      accentColor: Color(0xFF4DB6AC),
      emoji: '💎',
    ),
    ThemePreset(
      name: 'Tangerine',
      primaryColor: Color(0xFFF28500),
      accentColor: Color(0xFFFFAB40),
      emoji: '🍊',
    ),
    ThemePreset(
      name: 'Slate',
      primaryColor: Color(0xFF455A64),
      accentColor: Color(0xFF78909C),
      emoji: '🏙️',
    ),
  ];

  ThemeData createLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
      ),
      scaffoldBackgroundColor: Colors.grey.shade100,
      textTheme: GoogleFonts.latoTextTheme().apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.lato(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  ThemeData createDarkTheme({bool isOled = false}) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
      ),
      scaffoldBackgroundColor: isOled ? Colors.black : const Color(0xFF2D344A),
      cardColor: isOled ? const Color(0xFF121212) : null,
      textTheme: GoogleFonts.latoTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
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
  }
}
