import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/settings.dart';

class PreferencesService {
  static const String _fontSizeKey = 'font_size';
  static const String _defaultDifficultyKey = 'default_difficulty';
  static const String _defaultCategoryKey = 'default_category';
  static const String _defaultTimeLimitKey = 'default_time_limit';
  static const String _quizLengthKey = 'quiz_length';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';
  static const String _avatarKey = 'user_avatar';

  // Avatar
  Future<String> getAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarKey) ?? '👨‍🎓'; // Default avatar
  }

  Future<void> setAvatar(String avatar) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarKey, avatar);
  }

  static const String _usernameKey = 'username';

  // Username
  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) ?? 'Quiz Master'; // Default name
  }

  Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  // Font Size
  Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_fontSizeKey) ?? 1.0; // 1.0 = medium (default)
  }

  Future<void> setFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
  }

  // Default Difficulty
  Future<Difficulty> getDefaultDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    final difficultyName = prefs.getString(_defaultDifficultyKey) ?? 'easy';
    return Difficulty.values.firstWhere(
      (d) => d.name == difficultyName,
      orElse: () => Difficulty.easy,
    );
  }

  Future<void> setDefaultDifficulty(Difficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultDifficultyKey, difficulty.name);
  }

  // Default Category
  Future<String?> getDefaultCategory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_defaultCategoryKey);
  }

  Future<void> setDefaultCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultCategoryKey, category);
  }

  // Default Time Limit
  Future<int> getDefaultTimeLimit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_defaultTimeLimitKey) ?? 5; // Default 5 minutes
  }

  Future<void> setDefaultTimeLimit(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_defaultTimeLimitKey, minutes);
  }

  // Quiz Length
  Future<int> getQuizLength() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_quizLengthKey) ?? 10; // Default 10 questions
  }

  Future<void> setQuizLength(int length) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_quizLengthKey, length);
  }

  // Sound Enabled
  Future<bool> getSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, enabled);
  }

  // Vibration Enabled
  Future<bool> getVibrationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vibrationEnabledKey) ?? true;
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationEnabledKey, enabled);
  }

  // Reset all preferences
  Future<void> resetPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_fontSizeKey);
    await prefs.remove(_defaultDifficultyKey);
    await prefs.remove(_defaultCategoryKey);
    await prefs.remove(_defaultTimeLimitKey);
    await prefs.remove(_quizLengthKey);
    await prefs.remove(_soundEnabledKey);
    await prefs.remove(_vibrationEnabledKey);
  }
}
