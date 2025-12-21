import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemePreset {
  final String name;
  final Color primaryColor;
  final Color accentColor;
  final String emoji;
  final int unlockLevel; // Level required to unlock (0 = free)
  final String description; // Description of the theme

  const ThemePreset({
    required this.name,
    required this.primaryColor,
    required this.accentColor,
    required this.emoji,
    this.unlockLevel = 0,
    this.description = 'Standard Theme',
  });

  static const List<ThemePreset> presets = [
    // SIGNATURE MINDLY THEME - Our Brand Identity
    ThemePreset(
      name: 'Mindly',
      primaryColor: Color(0xFF6366F1), // Indigo-500 - Our signature color
      accentColor: Color(0xFF8B5CF6), // Purple-500
      emoji: '🧠',
      description: 'The official Mindly experience',
    ),

    // FREE THEMES - VIBRANT & COOL! (Level 0)
    ThemePreset(
      name: 'Cosmic Purple',
      primaryColor: Color(0xFF7C3AED), // Vibrant purple
      accentColor: Color(0xFFA78BFA), // Light purple
      emoji: '🌌',
      description: 'Epic space vibes',
    ),
    ThemePreset(
      name: 'Neon Blue',
      primaryColor: Color(0xFF3B82F6), // Bright blue
      accentColor: Color(0xFF60A5FA), // Sky blue
      emoji: '💙',
      description: 'Electric and energetic',
    ),
    ThemePreset(
      name: 'Lime Burst',
      primaryColor: Color(0xFF84CC16), // Lime green
      accentColor: Color(0xFFA3E635), // Light lime
      emoji: '🍋',
      description: 'Fresh and zesty',
    ),
    ThemePreset(
      name: 'Hot Pink',
      primaryColor: Color(0xFFEC4899), // Hot pink
      accentColor: Color(0xFFF472B6), // Light pink
      emoji: '💖',
      description: 'Bold and playful',
    ),
    ThemePreset(
      name: 'Ocean Wave',
      primaryColor: Color(0xFF06B6D4), // Cyan
      accentColor: Color(0xFF22D3EE), // Light cyan
      emoji: '🌊',
      description: 'Cool and refreshing',
    ),
    ThemePreset(
      name: 'Fire Orange',
      primaryColor: Color(0xFFF97316), // Orange
      accentColor: Color(0xFFFB923C), // Light orange
      emoji: '🔥',
      description: 'Hot and intense',
    ),
    ThemePreset(
      name: 'Emerald Dream',
      primaryColor: Color(0xFF10B981), // Emerald
      accentColor: Color(0xFF34D399), // Light emerald
      emoji: '💚',
      description: 'Natural and calming',
    ),
    ThemePreset(
      name: 'Royal Violet',
      primaryColor: Color(0xFF8B5CF6), // Violet
      accentColor: Color(0xFFA78BFA), // Light violet
      emoji: '👑',
      description: 'Majestic and premium',
    ),

    // PROFESSIONAL THEMES - Subdued & Elegant (Level 0)
    ThemePreset(
      name: 'Slate',
      primaryColor: Color(0xFF475569), // Slate-600
      accentColor: Color(0xFF64748B), // Slate-500
      emoji: '🏢',
      description: 'Professional and neutral',
    ),
    ThemePreset(
      name: 'Navy',
      primaryColor: Color(0xFF1E3A8A), // Blue-900
      accentColor: Color(0xFF1E40AF), // Blue-800
      emoji: '⚓',
      description: 'Classic and trustworthy',
    ),
    ThemePreset(
      name: 'Forest',
      primaryColor: Color(0xFF065F46), // Emerald-800
      accentColor: Color(0xFF047857), // Emerald-700
      emoji: '🌲',
      description: 'Calm and focused',
    ),
    ThemePreset(
      name: 'Burgundy',
      primaryColor: Color(0xFF881337), // Rose-900
      accentColor: Color(0xFF9F1239), // Rose-800
      emoji: '🍷',
      description: 'Sophisticated and refined',
    ),

    // UNLOCKABLE THEMES (Level 5+)
    ThemePreset(
      name: 'Sunset',
      primaryColor: Color(0xFFF59E0B),
      accentColor: Color(0xFFF97316),
      emoji: '🌅',
      unlockLevel: 5,
      description: 'Warm and energetic',
    ),
    ThemePreset(
      name: 'Coral',
      primaryColor: Color(0xFFF43F5E),
      accentColor: Color(0xFFE11D48),
      emoji: '🪸',
      unlockLevel: 5,
      description: 'Vibrant and playful',
    ),
    ThemePreset(
      name: 'Forest Green',
      primaryColor: Color(0xFF14532D),
      accentColor: Color(0xFF166534),
      emoji: '🌲',
      unlockLevel: 8,
      description: 'Deep nature vibes',
    ),

    // PREMIUM THEMES (Level 10+)
    ThemePreset(
      name: 'Royal Gold',
      primaryColor: Color(0xFFEAB308),
      accentColor: Color(0xFFFBBF24),
      emoji: '👑',
      unlockLevel: 10,
      description: 'Luxurious and prestigious',
    ),
    ThemePreset(
      name: 'Cyberpunk',
      primaryColor: Color(0xFFEC4899),
      accentColor: Color(0xFFA855F7),
      emoji: '🎮',
      unlockLevel: 12,
      description: 'Futuristic neon style',
    ),
    ThemePreset(
      name: 'Electric',
      primaryColor: Color(0xFF0EA5E9),
      accentColor: Color(0xFF06B6D4),
      emoji: '⚡',
      unlockLevel: 15,
      description: 'High energy blue',
    ),

    // ELITE THEMES (Level 20+)
    ThemePreset(
      name: 'Midnight Violet',
      primaryColor: Color(0xFF4C1D95),
      accentColor: Color(0xFF6D28D9),
      emoji: '🔮',
      unlockLevel: 20,
      description: 'Mysterious and deep',
    ),
    ThemePreset(
      name: 'Ruby Red',
      primaryColor: Color(0xFF991B1B),
      accentColor: Color(0xFFDC2626),
      emoji: '❤️',
      unlockLevel: 25,
      description: 'Intense and bold',
    ),
    ThemePreset(
      name: 'Carbon',
      primaryColor: Color(0xFF18181B),
      accentColor: Color(0xFF71717A),
      emoji: '⚫',
      unlockLevel: 30,
      description: 'Ultimate dark mode',
    ),
    ThemePreset(
      name: 'Matrix',
      primaryColor: Color(0xFF00FF41),
      accentColor: Color(0xFF00D936),
      emoji: '💻',
      unlockLevel: 40,
      description: 'Hack the system',
    ),
    ThemePreset(
      name: 'Obsidian',
      primaryColor: Color(0xFF000000),
      accentColor: Color(0xFF333333),
      emoji: '🖤',
      unlockLevel: 50,
      description: 'Pure black OLED mastery',
    ),
  ];

  ThemeData createLightTheme() {
    final isDarkTheme = _isDarkColorScheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor:
          isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade50,
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDarkTheme
            ? Colors.grey.shade800.withOpacity(0.5)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Sleeker 12
        ),
        margin:
            const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Tighter
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        backgroundColor: isDarkTheme ? Colors.grey.shade900 : Colors.white,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      // Apply Google Fonts to ALL text in the app
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          // Display styles (large headings)
          displayLarge: GoogleFonts.inter(
            fontSize: 48, // Reduced from 57
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black87,
          ),
          displayMedium: GoogleFonts.inter(
            fontSize: 38, // Reduced from 45
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black87,
          ),
          displaySmall: GoogleFonts.inter(
            fontSize: 30, // Reduced from 36
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black87,
          ),
          // Headline styles
          headlineLarge: GoogleFonts.inter(
            fontSize: 26, // Reduced from 32
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black87,
          ),
          headlineMedium: GoogleFonts.inter(
            fontSize: 22, // Reduced from 28
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black87,
          ),
          headlineSmall: GoogleFonts.inter(
            fontSize: 19, // Reduced from 24
            fontWeight: FontWeight.w600,
            color: isDarkTheme ? Colors.white : Colors.black87,
          ),
          // Title styles
          titleLarge: GoogleFonts.inter(
            fontSize: 17, // Reduced from 22
            fontWeight: FontWeight.w600,
            color: isDarkTheme ? Colors.white : Colors.black87,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 14, // Reduced from 16
            fontWeight: FontWeight.w600,
            color: isDarkTheme ? Colors.white : Colors.black87,
          ),
          titleSmall: GoogleFonts.inter(
            fontSize: 12, // Reduced from 14
            fontWeight: FontWeight.w600,
            color: isDarkTheme ? Colors.white : Colors.black87,
          ),
          // Body styles
          bodyLarge: GoogleFonts.inter(
            fontSize: 14, // Reduced from 16
            color: isDarkTheme ? Colors.white : Colors.black87,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 13, // Reduced from 14
            color: isDarkTheme ? Colors.white : Colors.black87,
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 11, // Reduced from 12
            color: isDarkTheme ? Colors.white70 : Colors.black54,
          ),
          // Label styles
          labelLarge: GoogleFonts.inter(
            fontSize: 13, // Reduced from 14
            fontWeight: FontWeight.w600,
            color: isDarkTheme ? Colors.white : Colors.black87,
          ),
          labelMedium: GoogleFonts.inter(
            fontSize: 11, // Reduced from 12
            fontWeight: FontWeight.w600,
            color: isDarkTheme ? Colors.white : Colors.black87,
          ),
          labelSmall: GoogleFonts.inter(
            fontSize: 10, // Reduced from 11
            fontWeight: FontWeight.w600,
            color: isDarkTheme ? Colors.white70 : Colors.black54,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 20), // Reduced from 14, 28
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Reduced from 14
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14, // Reduced from 15
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2, // Reduced from 0.3
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 20), // Reduced
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Reduced from 14
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14, // Reduced from 15
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 16), // Reduced
          textStyle: GoogleFonts.inter(
            fontSize: 13, // Reduced from 14
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, // Ensures all text/icons are white
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Explicit white for title
        ),
      ),
    );
  }

  ThemeData createDarkTheme({bool isOled = false}) {
    final isGlassTheme = _isGlassTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: isOled
          ? Colors.black
          : (isGlassTheme ? const Color(0xFF0A0A0A) : const Color(0xFF0F172A)),
      cardColor: isOled
          ? const Color(0xFF0A0A0A)
          : (isGlassTheme
              ? const Color(0xFF1A1A1A).withOpacity(0.7)
              : const Color(0xFF1E293B)),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isOled
            ? const Color(0xFF0A0A0A)
            : (isGlassTheme
                ? const Color(0xFF1A1A1A).withOpacity(0.7)
                : const Color(0xFF1E293B)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Sleeker 12
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        backgroundColor: isOled ? Colors.black : const Color(0xFF1E293B),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      // Apply Google Fonts to ALL text in dark mode
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          displayLarge: GoogleFonts.inter(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          displayMedium: GoogleFonts.inter(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          displaySmall: GoogleFonts.inter(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineLarge: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineSmall: GoogleFonts.inter(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          titleSmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.white,
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.white70,
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          labelMedium: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          labelSmall: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, // Ensures all text/icons are white
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Explicit white for title
        ),
      ),
    );
  }

  // Helper to determine if this is a dark color scheme
  bool _isDarkColorScheme() {
    return name == 'Carbon' ||
        name == 'Obsidian' ||
        name == 'Matrix' ||
        name == 'Steel';
  }

  // Helper to determine if this should use glass effect
  bool _isGlassTheme() {
    return name == 'Carbon' ||
        name == 'Obsidian' ||
        name == 'Matrix' ||
        name == 'Arctic' ||
        name == 'Electric' ||
        name == 'Professional Navy' ||
        name == 'Deep Purple';
  }
}
