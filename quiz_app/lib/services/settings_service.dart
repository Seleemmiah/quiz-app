import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _themeKey = 'theme_mode';

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    return ThemeMode.values[themeIndex];
  }

  Future<void> setThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
  }

  static const _oledKey = 'oled_mode';

  Future<bool> getOledMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_oledKey) ?? false;
  }

  Future<void> setOledMode(bool isOled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_oledKey, isOled);
  }

  static const _hapticKey = 'haptic_enabled';

  Future<bool> getHapticEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hapticKey) ?? true; // Default to true
  }

  Future<void> setHapticEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticKey, enabled);
  }

  static const _themePresetKey = 'theme_preset';

  Future<String> getThemePreset() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themePresetKey) ?? 'Default';
  }

  Future<void> setThemePreset(String presetName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePresetKey, presetName);
  }

  Future<void> resetHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (String key in keys) {
      // We only remove keys that are for high scores
      if (key.startsWith('high_score_')) {
        await prefs.remove(key);
      }
    }
  }
}
