import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/utils/firestore_error_handler.dart';

class PreferencesService {
  static const String _fontSizeKey = 'font_size';
  static const String _defaultDifficultyKey = 'default_difficulty';
  static const String _defaultCategoryKey = 'default_category';
  static const String _defaultTimeLimitKey = 'default_time_limit';
  static const String _quizLengthKey = 'quiz_length';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';
  static const String _avatarKey = 'user_avatar';
  static const String _usernameKey = 'username';
  static const String _studyRemindersKey = 'study_reminders_enabled';
  static const String _autoSaveKey = 'auto_save_enabled';
  static const String _offlineModeKey = 'offline_mode_enabled';
  static const String _analyticsEnabledKey = 'analytics_enabled';
  static const String _savedResultsKey = 'saved_results';

  // Validation constants
  static const double _minFontSize = 0.5;
  static const double _maxFontSize = 2.0;
  static const int _minQuizLength = 5;
  static const int _maxQuizLength = 50;
  static const int _minTimeLimit = 1;
  static const int _maxTimeLimit = 60;

  // Avatar
  static Future<String> getAvatar() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final prefs = await SharedPreferences.getInstance();

      // Locally cached value
      String avatar = prefs.getString(_avatarKey) ?? '👨‍🎓';

      if (user != null) {
        // Try to fetch from Firestore for sync
        final doc = await FirestoreErrorHandler.executeWithRetry(
          operation: () => FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          operationName: 'Fetch avatar from cloud',
        );
        if (doc != null && doc.exists) {
          final cloudAvatar = doc.data()?['avatar'] as String?;
          if (cloudAvatar != null && cloudAvatar != avatar) {
            avatar = cloudAvatar;
            await prefs.setString(_avatarKey, avatar);
          }
        }
      }
      return avatar;
    } catch (e) {
      return '👨‍🎓';
    }
  }

  static Future<void> setAvatar(String avatar) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_avatarKey, avatar);

      if (user != null) {
        await FirestoreErrorHandler.executeWithRetry(
          operation: () =>
              FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'avatar': avatar,
          }, SetOptions(merge: true)),
          operationName: 'Save avatar to cloud',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Username
  static Future<String> getUsername() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final prefs = await SharedPreferences.getInstance();

      String username = prefs.getString(_usernameKey) ?? 'Mindly User';

      if (user != null) {
        final doc = await FirestoreErrorHandler.executeWithRetry(
          operation: () => FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          operationName: 'Fetch username from cloud',
        );
        if (doc != null && doc.exists) {
          final cloudName = doc.data()?['username'] as String?;
          if (cloudName != null && cloudName != username) {
            username = cloudName;
            await prefs.setString(_usernameKey, username);
          }
        }
      }
      return username;
    } catch (e) {
      return 'Mindly User';
    }
  }

  static Future<void> setUsername(String username) async {
    if (username.trim().isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }
    try {
      final user = FirebaseAuth.instance.currentUser;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usernameKey, username.trim());

      if (user != null) {
        await FirestoreErrorHandler.executeWithRetry(
          operation: () =>
              FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'username': username.trim(),
          }, SetOptions(merge: true)),
          operationName: 'Save username to cloud',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Font Size with validation
  static Future<double> getFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final size = prefs.getDouble(_fontSizeKey) ?? 1.0;
      return size.clamp(_minFontSize, _maxFontSize);
    } catch (e) {
      return 1.0;
    }
  }

  static Future<void> setFontSize(double size) async {
    if (size < _minFontSize || size > _maxFontSize) {
      throw ArgumentError(
          'Font size must be between $_minFontSize and $_maxFontSize');
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeKey, size);
    } catch (e) {
      rethrow;
    }
  }

  // Default Difficulty
  static Future<Difficulty> getDefaultDifficulty() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final difficultyName = prefs.getString(_defaultDifficultyKey) ?? 'easy';
      return Difficulty.values.firstWhere(
        (d) => d.name == difficultyName,
        orElse: () => Difficulty.easy,
      );
    } catch (e) {
      return Difficulty.easy;
    }
  }

  static Future<void> setDefaultDifficulty(Difficulty difficulty) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_defaultDifficultyKey, difficulty.name);
    } catch (e) {
      rethrow;
    }
  }

  // Default Category
  static Future<String?> getDefaultCategory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_defaultCategoryKey);
    } catch (e) {
      return null;
    }
  }

  static Future<void> setDefaultCategory(String? category) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (category == null) {
        await prefs.remove(_defaultCategoryKey);
      } else {
        await prefs.setString(_defaultCategoryKey, category);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Default Time Limit with validation
  static Future<int> getDefaultTimeLimit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final limit = prefs.getInt(_defaultTimeLimitKey) ?? 5;
      return limit.clamp(_minTimeLimit, _maxTimeLimit);
    } catch (e) {
      return 5;
    }
  }

  static Future<void> setDefaultTimeLimit(int minutes) async {
    if (minutes < _minTimeLimit || minutes > _maxTimeLimit) {
      throw ArgumentError(
          'Time limit must be between $_minTimeLimit and $_maxTimeLimit minutes');
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_defaultTimeLimitKey, minutes);
    } catch (e) {
      rethrow;
    }
  }

  // Quiz Length with validation
  static Future<int> getQuizLength() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final length = prefs.getInt(_quizLengthKey) ?? 10;
      return length.clamp(_minQuizLength, _maxQuizLength);
    } catch (e) {
      return 10;
    }
  }

  static Future<void> setQuizLength(int length) async {
    if (length < _minQuizLength || length > _maxQuizLength) {
      throw ArgumentError(
          'Quiz length must be between $_minQuizLength and $_maxQuizLength questions');
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_quizLengthKey, length);
    } catch (e) {
      rethrow;
    }
  }

  // Sound Enabled
  static Future<bool> getSoundEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_soundEnabledKey) ?? true;
    } catch (e) {
      return true;
    }
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_soundEnabledKey, enabled);
    } catch (e) {
      rethrow;
    }
  }

  // Vibration Enabled
  static Future<bool> getVibrationEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_vibrationEnabledKey) ?? true;
    } catch (e) {
      return true;
    }
  }

  static Future<void> setVibrationEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_vibrationEnabledKey, enabled);
    } catch (e) {
      rethrow;
    }
  }

  // Study Reminders Enabled
  static Future<bool> getStudyRemindersEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_studyRemindersKey) ?? true;
    } catch (e) {
      return true;
    }
  }

  static Future<void> setStudyRemindersEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_studyRemindersKey, enabled);
    } catch (e) {
      rethrow;
    }
  }

  // Auto Save Enabled
  static Future<bool> getAutoSaveEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_autoSaveKey) ?? true;
    } catch (e) {
      return true;
    }
  }

  static Future<void> setAutoSaveEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_autoSaveKey, enabled);
    } catch (e) {
      rethrow;
    }
  }

  // Offline Mode Enabled
  static Future<bool> getOfflineModeEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_offlineModeKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> setOfflineModeEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_offlineModeKey, enabled);
    } catch (e) {
      rethrow;
    }
  }

  // Analytics Enabled
  static Future<bool> getAnalyticsEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_analyticsEnabledKey) ?? true;
    } catch (e) {
      return true;
    }
  }

  static Future<void> setAnalyticsEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_analyticsEnabledKey, enabled);
    } catch (e) {
      rethrow;
    }
  }

  // Saved Results Management
  static Future<List<Map<String, dynamic>>> getSavedResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> savedInfo =
          prefs.getStringList(_savedResultsKey) ?? [];
      return savedInfo
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveResult(Map<String, dynamic> resultData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> savedInfo =
          prefs.getStringList(_savedResultsKey) ?? [];

      // Check for duplicates based on 'id'
      final String newItem = jsonEncode(resultData);
      bool exists = false;
      if (resultData['id'] != null) {
        for (var item in savedInfo) {
          final map = jsonDecode(item) as Map<String, dynamic>;
          if (map['id'] == resultData['id']) {
            exists = true;
            break;
          }
        }
      }

      if (!exists) {
        savedInfo.add(newItem);
        await prefs.setStringList(_savedResultsKey, savedInfo);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> removeSavedResult(String resultId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> savedInfo =
          prefs.getStringList(_savedResultsKey) ?? [];

      savedInfo.removeWhere((item) {
        final map = jsonDecode(item) as Map<String, dynamic>;
        return map['id'] == resultId;
      });

      await prefs.setStringList(_savedResultsKey, savedInfo);
    } catch (e) {
      rethrow;
    }
  }

  // Batch operations
  static Future<void> setMultiplePreferences(
      Map<String, dynamic> preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final entry in preferences.entries) {
        switch (entry.key) {
          case _fontSizeKey:
            if (entry.value is double) {
              await prefs.setDouble(entry.key, entry.value);
            }
            break;
          case _defaultDifficultyKey:
            if (entry.value is Difficulty) {
              await prefs.setString(entry.key, entry.value.name);
            }
            break;
          case _defaultCategoryKey:
            if (entry.value is String?) {
              if (entry.value == null) {
                await prefs.remove(entry.key);
              } else {
                await prefs.setString(entry.key, entry.value);
              }
            }
            break;
          case _defaultTimeLimitKey:
          case _quizLengthKey:
            if (entry.value is int) {
              await prefs.setInt(entry.key, entry.value);
            }
            break;
          case _soundEnabledKey:
          case _vibrationEnabledKey:
          case _studyRemindersKey:
          case _autoSaveKey:
          case _offlineModeKey:
          case _analyticsEnabledKey:
            if (entry.value is bool) {
              await prefs.setBool(entry.key, entry.value);
            }
            break;
          case _avatarKey:
          case _usernameKey:
            if (entry.value is String) {
              await prefs.setString(entry.key, entry.value);
            }
            break;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get all preferences as a map
  static Future<Map<String, dynamic>> getAllPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'avatar': await getAvatar(),
        'username': await getUsername(),
        'fontSize': await getFontSize(),
        'defaultDifficulty': await getDefaultDifficulty(),
        'defaultCategory': await getDefaultCategory(),
        'defaultTimeLimit': await getDefaultTimeLimit(),
        'quizLength': await getQuizLength(),
        'soundEnabled': await getSoundEnabled(),
        'vibrationEnabled': await getVibrationEnabled(),
        'studyRemindersEnabled': await getStudyRemindersEnabled(),
        'autoSaveEnabled': await getAutoSaveEnabled(),
        'offlineModeEnabled': await getOfflineModeEnabled(),
        'analyticsEnabled': await getAnalyticsEnabled(),
      };
    } catch (e) {
      return {};
    }
  }

  // Export preferences to JSON
  static Future<String> exportPreferences() async {
    try {
      final allPrefs = await getAllPreferences();
      return jsonEncode(allPrefs);
    } catch (e) {
      throw Exception('Failed to export preferences: $e');
    }
  }

  // Import preferences from JSON
  static Future<void> importPreferences(String jsonString) async {
    try {
      final Map<String, dynamic> preferences = jsonDecode(jsonString);
      await setMultiplePreferences(preferences);
    } catch (e) {
      throw Exception('Failed to import preferences: $e');
    }
  }

  // Reset all preferences
  static Future<void> resetPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.remove(_fontSizeKey),
        prefs.remove(_defaultDifficultyKey),
        prefs.remove(_defaultCategoryKey),
        prefs.remove(_defaultTimeLimitKey),
        prefs.remove(_quizLengthKey),
        prefs.remove(_soundEnabledKey),
        prefs.remove(_vibrationEnabledKey),
        prefs.remove(_avatarKey),
        prefs.remove(_usernameKey),
        prefs.remove(_studyRemindersKey),
        prefs.remove(_autoSaveKey),
        prefs.remove(_offlineModeKey),
        prefs.remove(_analyticsEnabledKey),
      ]);
    } catch (e) {
      rethrow;
    }
  }

  // Check if preferences are initialized
  static Future<bool> arePreferencesInitialized() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_usernameKey);
    } catch (e) {
      return false;
    }
  }
}
