import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _themeKey = 'theme_mode';
  static const _oledKey = 'oled_mode';
  static const _hapticKey = 'haptic_enabled';
  static const _themePresetKey = 'theme_preset';

  late SharedPreferences _prefs;

  // Cache
  ThemeMode _themeMode = ThemeMode.system;
  bool _isOledMode = false;
  bool _hapticEnabled = true;
  String _themePreset = 'Default';

  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    final themeIndex = _prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[themeIndex];

    _isOledMode = _prefs.getBool(_oledKey) ?? false;
    _hapticEnabled = _prefs.getBool(_hapticKey) ?? true;
    _themePreset = _prefs.getString(_themePresetKey) ?? 'Default';
  }

  // Synchronous Getters
  ThemeMode getThemeMode() => _themeMode;
  bool getOledMode() => _isOledMode;
  bool getHapticEnabled() => _hapticEnabled;
  String getThemePreset() => _themePreset;

  // Async Setters
  Future<void> setThemeMode(ThemeMode theme) async {
    _themeMode = theme;
    await _prefs.setInt(_themeKey, theme.index);
  }

  Future<void> setOledMode(bool isOled) async {
    _isOledMode = isOled;
    await _prefs.setBool(_oledKey, isOled);
  }

  Future<void> setHapticEnabled(bool enabled) async {
    _hapticEnabled = enabled;
    await _prefs.setBool(_hapticKey, enabled);
  }

  Future<void> setThemePreset(String presetName) async {
    _themePreset = presetName;
    await _prefs.setString(_themePresetKey, presetName);
  }

  // High Score Reset (Keep existing)
  Future<void> resetHighScores() async {
    // Implementation depends on how high scores are stored.
    // If they are in SharedPreferences, clear them here.
    // If in a separate service/file, this might need to call that.
    // For now, assuming they might be in prefs with a prefix.
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('highscore_')) {
        await _prefs.remove(key);
      }
    }
  }
}
