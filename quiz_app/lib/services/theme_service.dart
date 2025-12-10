import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Brightness brightness;

  const AppTheme({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    this.brightness = Brightness.light,
  });

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
        secondary: secondaryColor,
      ),
      scaffoldBackgroundColor: brightness == Brightness.light
          ? const Color(0xFFF5F7FA)
          : const Color(0xFF121212),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}

class ThemeService {
  static const String _themeKey = 'selected_theme';

  // Beautiful themes optimized for glass effects
  static const List<AppTheme> themes = [
    // Ocean Blue (Default) - Deep, calming blue
    AppTheme(
      name: 'Ocean Blue',
      primaryColor: Color(0xFF0077BE),
      secondaryColor: Color(0xFF00A8E8),
      accentColor: Color(0xFF00D9FF),
    ),

    // Purple Haze - Rich purple with pink accents
    AppTheme(
      name: 'Purple Haze',
      primaryColor: Color(0xFF6B46C1),
      secondaryColor: Color(0xFF9333EA),
      accentColor: Color(0xFFD946EF),
    ),

    // Emerald Dream - Vibrant green
    AppTheme(
      name: 'Emerald Dream',
      primaryColor: Color(0xFF059669),
      secondaryColor: Color(0xFF10B981),
      accentColor: Color(0xFF34D399),
    ),

    // Sunset Orange - Warm and energetic
    AppTheme(
      name: 'Sunset Orange',
      primaryColor: Color(0xFFEA580C),
      secondaryColor: Color(0xFFF97316),
      accentColor: Color(0xFFFB923C),
    ),

    // Rose Gold - Elegant pink
    AppTheme(
      name: 'Rose Gold',
      primaryColor: Color(0xFFE11D48),
      secondaryColor: Color(0xFFF43F5E),
      accentColor: Color(0xFFFB7185),
    ),

    // Midnight Blue - Deep, sophisticated
    AppTheme(
      name: 'Midnight Blue',
      primaryColor: Color(0xFF1E3A8A),
      secondaryColor: Color(0xFF3B82F6),
      accentColor: Color(0xFF60A5FA),
    ),

    // Teal Wave - Fresh and modern
    AppTheme(
      name: 'Teal Wave',
      primaryColor: Color(0xFF0D9488),
      secondaryColor: Color(0xFF14B8A6),
      accentColor: Color(0xFF2DD4BF),
    ),

    // Crimson Fire - Bold red
    AppTheme(
      name: 'Crimson Fire',
      primaryColor: Color(0xFFDC2626),
      secondaryColor: Color(0xFFEF4444),
      accentColor: Color(0xFFF87171),
    ),

    // Indigo Night - Deep indigo
    AppTheme(
      name: 'Indigo Night',
      primaryColor: Color(0xFF4F46E5),
      secondaryColor: Color(0xFF6366F1),
      accentColor: Color(0xFF818CF8),
    ),

    // Forest Green - Natural and calming
    AppTheme(
      name: 'Forest Green',
      primaryColor: Color(0xFF15803D),
      secondaryColor: Color(0xFF22C55E),
      accentColor: Color(0xFF4ADE80),
    ),
  ];

  Future<void> saveTheme(int themeIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, themeIndex);
  }

  Future<int> getThemeIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_themeKey) ?? 0; // Default to Ocean Blue
  }

  Future<AppTheme> getCurrentTheme() async {
    final index = await getThemeIndex();
    return themes[index];
  }
}
