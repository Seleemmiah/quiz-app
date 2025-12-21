import 'package:flutter/material.dart';

class AppThemes {
  // Modern Gradient Purple Theme (Vibrant)
  static ThemeData get defaultTheme => _buildTheme(
        const Color(0xFF6366F1),
        Brightness.light,
      );

  // Cyberpunk Theme (Neon Pink/Purple)
  static ThemeData get cyberpunkTheme => _buildTheme(
        const Color(0xFFEC4899),
        Brightness.light,
      );

  // Ocean Breeze Theme (Modern Teal/Cyan)
  static ThemeData get oceanTheme => _buildTheme(
        const Color(0xFF06B6D4),
        Brightness.light,
      );

  // Emerald Forest Theme (Vibrant Green)
  static ThemeData get forestTheme => _buildTheme(
        const Color(0xFF10B981),
        Brightness.light,
      );

  // Sunset Glow Theme (Orange/Amber)
  static ThemeData get sunsetTheme => _buildTheme(
        const Color(0xFFF59E0B),
        Brightness.light,
      );

  // Royal Blue Theme
  static ThemeData get royalTheme => _buildTheme(
        const Color(0xFF3B82F6),
        Brightness.light,
      );

  // Lavender Dream Theme
  static ThemeData get lavenderTheme => _buildTheme(
        const Color(0xFF8B5CF6),
        Brightness.light,
      );

  // Coral Reef Theme
  static ThemeData get coralTheme => _buildTheme(
        const Color(0xFFF43F5E),
        Brightness.light,
      );

  // Mint Fresh Theme
  static ThemeData get mintTheme => _buildTheme(
        const Color(0xFF14B8A6),
        Brightness.light,
      );

  // Midnight Blue Theme
  static ThemeData get midnightTheme => _buildTheme(
        const Color(0xFF1E40AF),
        Brightness.light,
      );

  // Dark Themes
  static ThemeData get defaultDarkTheme => _buildTheme(
        const Color(0xFF6366F1),
        Brightness.dark,
      );

  static ThemeData get cyberpunkDarkTheme => _buildTheme(
        const Color(0xFFEC4899),
        Brightness.dark,
      );

  static ThemeData get oceanDarkTheme => _buildTheme(
        const Color(0xFF06B6D4),
        Brightness.dark,
      );

  static ThemeData get forestDarkTheme => _buildTheme(
        const Color(0xFF10B981),
        Brightness.dark,
      );

  static ThemeData get sunsetDarkTheme => _buildTheme(
        const Color(0xFFF59E0B),
        Brightness.dark,
      );

  static ThemeData get royalDarkTheme => _buildTheme(
        const Color(0xFF3B82F6),
        Brightness.dark,
      );

  static ThemeData get lavenderDarkTheme => _buildTheme(
        const Color(0xFF8B5CF6),
        Brightness.dark,
      );

  static ThemeData get coralDarkTheme => _buildTheme(
        const Color(0xFFF43F5E),
        Brightness.dark,
      );

  static ThemeData get mintDarkTheme => _buildTheme(
        const Color(0xFF14B8A6),
        Brightness.dark,
      );

  static ThemeData get midnightDarkTheme => _buildTheme(
        const Color(0xFF1E40AF),
        Brightness.dark,
      );

  // Helper method to build consistent themes
  static ThemeData _buildTheme(Color seedColor, Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: isDark ? const Color(0xFF0F172A) : null,
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: isDark ? Colors.white : Colors.black87,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
          color: isDark ? Colors.white : Colors.black87,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: isDark ? Colors.white : Colors.black87,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.2,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.2,
          color: isDark ? Colors.white60 : Colors.black87,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  // Get theme by name
  static ThemeData getTheme(String themeName, bool isDark) {
    switch (themeName) {
      case 'cyberpunk':
        return isDark ? cyberpunkDarkTheme : cyberpunkTheme;
      case 'ocean':
        return isDark ? oceanDarkTheme : oceanTheme;
      case 'forest':
        return isDark ? forestDarkTheme : forestTheme;
      case 'sunset':
        return isDark ? sunsetDarkTheme : sunsetTheme;
      case 'royal':
        return isDark ? royalDarkTheme : royalTheme;
      case 'lavender':
        return isDark ? lavenderDarkTheme : lavenderTheme;
      case 'coral':
        return isDark ? coralDarkTheme : coralTheme;
      case 'mint':
        return isDark ? mintDarkTheme : mintTheme;
      case 'midnight':
        return isDark ? midnightDarkTheme : midnightTheme;
      default:
        return isDark ? defaultDarkTheme : defaultTheme;
    }
  }

  // Theme options for UI
  static const List<Map<String, dynamic>> themeOptions = [
    {
      'name': 'default',
      'label': 'Indigo',
      'color': Color(0xFF6366F1),
      'gradient': [Color(0xFF6366F1), Color(0xFF8B5CF6)]
    },
    {
      'name': 'cyberpunk',
      'label': 'Cyberpunk',
      'color': Color(0xFFEC4899),
      'gradient': [Color(0xFFEC4899), Color(0xFFA855F7)]
    },
    {
      'name': 'ocean',
      'label': 'Ocean',
      'color': Color(0xFF06B6D4),
      'gradient': [Color(0xFF06B6D4), Color(0xFF3B82F6)]
    },
    {
      'name': 'forest',
      'label': 'Emerald',
      'color': Color(0xFF10B981),
      'gradient': [Color(0xFF10B981), Color(0xFF059669)]
    },
    {
      'name': 'sunset',
      'label': 'Sunset',
      'color': Color(0xFFF59E0B),
      'gradient': [Color(0xFFF59E0B), Color(0xFFF97316)]
    },
    {
      'name': 'royal',
      'label': 'Royal Blue',
      'color': Color(0xFF3B82F6),
      'gradient': [Color(0xFF3B82F6), Color(0xFF2563EB)]
    },
    {
      'name': 'lavender',
      'label': 'Lavender',
      'color': Color(0xFF8B5CF6),
      'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)]
    },
    {
      'name': 'coral',
      'label': 'Coral',
      'color': Color(0xFFF43F5E),
      'gradient': [Color(0xFFF43F5E), Color(0xFFE11D48)]
    },
    {
      'name': 'mint',
      'label': 'Mint',
      'color': Color(0xFF14B8A6),
      'gradient': [Color(0xFF14B8A6), Color(0xFF0D9488)]
    },
    {
      'name': 'midnight',
      'label': 'Midnight',
      'color': Color(0xFF1E40AF),
      'gradient': [Color(0xFF1E40AF), Color(0xFF1E3A8A)]
    },
  ];
}
