import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/settings.dart';

enum AchievementType {
  perfectScore,
  speedDemon,
  quizMaster,
  categoryExpert,
  hardcorePlayer,
  streakWarrior,
  centurion,
}

class Achievement {
  final AchievementType type;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    this.unlockedAt,
  });

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  factory Achievement.fromJson(
      Map<String, dynamic> json, AchievementType type) {
    return Achievement(
      type: type,
      title: _getTitle(type),
      description: _getDescription(type),
      icon: _getIcon(type),
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
    );
  }

  static String _getTitle(AchievementType type) {
    switch (type) {
      case AchievementType.perfectScore:
        return 'Perfect Score';
      case AchievementType.speedDemon:
        return 'Speed Demon';
      case AchievementType.quizMaster:
        return 'Quiz Master';
      case AchievementType.categoryExpert:
        return 'Category Expert';
      case AchievementType.hardcorePlayer:
        return 'Hardcore Player';
      case AchievementType.streakWarrior:
        return 'Streak Warrior';
      case AchievementType.centurion:
        return 'Centurion';
    }
  }

  static String _getDescription(AchievementType type) {
    switch (type) {
      case AchievementType.perfectScore:
        return 'Score 100% on any quiz';
      case AchievementType.speedDemon:
        return 'Complete a quiz in under 2 minutes';
      case AchievementType.quizMaster:
        return 'Complete 10 quizzes';
      case AchievementType.categoryExpert:
        return 'Score 90%+ in 5 quizzes of the same category';
      case AchievementType.hardcorePlayer:
        return 'Complete 5 Hard difficulty quizzes';
      case AchievementType.streakWarrior:
        return 'Score 70%+ on 5 quizzes in a row';
      case AchievementType.centurion:
        return 'Complete 100 quizzes';
    }
  }

  static String _getIcon(AchievementType type) {
    switch (type) {
      case AchievementType.perfectScore:
        return '🏆';
      case AchievementType.speedDemon:
        return '⚡';
      case AchievementType.quizMaster:
        return '🎓';
      case AchievementType.categoryExpert:
        return '🎯';
      case AchievementType.hardcorePlayer:
        return '💪';
      case AchievementType.streakWarrior:
        return '🔥';
      case AchievementType.centurion:
        return '👑';
    }
  }
}

class AchievementService {
  static const String _achievementsKey = 'achievements';
  static const String _streakKey = 'current_streak';
  static const String _lastQuizDateKey = 'last_quiz_date';

  Future<List<Achievement>> checkAchievements({
    required int score,
    required int totalQuestions,
    required Difficulty difficulty,
    String? category,
    int? quizDurationSeconds,
    required int totalQuizzes,
    required Map<Difficulty, int> difficultyQuizzes,
    required Map<String, int> categoryQuizzes,
    required Map<String, double> categoryAverages,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = prefs.getString(_achievementsKey) ?? '{}';
    final achievementsData =
        Map<String, dynamic>.from(jsonDecode(achievementsJson));

    final newlyUnlocked = <Achievement>[];
    final percentage =
        totalQuestions > 0 ? (score / totalQuestions) * 100.0 : 0.0;

    // Update streak
    final currentStreak = await _updateStreak(prefs, percentage);

    // Check each achievement
    for (final type in AchievementType.values) {
      final key = type.name;
      final data = achievementsData[key] as Map<String, dynamic>?;
      final isCurrentlyUnlocked = data?['isUnlocked'] ?? false;

      if (!isCurrentlyUnlocked) {
        bool shouldUnlock = false;

        switch (type) {
          case AchievementType.perfectScore:
            shouldUnlock = percentage == 100;
            break;
          case AchievementType.speedDemon:
            shouldUnlock =
                quizDurationSeconds != null && quizDurationSeconds < 120;
            break;
          case AchievementType.quizMaster:
            shouldUnlock = totalQuizzes >= 10;
            break;
          case AchievementType.categoryExpert:
            if (category != null) {
              final catQuizzes = categoryQuizzes[category] ?? 0;
              final catAverage = categoryAverages[category] ?? 0;
              shouldUnlock = catQuizzes >= 5 && catAverage >= 90;
            }
            break;
          case AchievementType.hardcorePlayer:
            shouldUnlock = (difficultyQuizzes[Difficulty.hard] ?? 0) >= 5;
            break;
          case AchievementType.streakWarrior:
            shouldUnlock = currentStreak >= 5;
            break;
          case AchievementType.centurion:
            shouldUnlock = totalQuizzes >= 100;
            break;
        }

        if (shouldUnlock) {
          final achievement = Achievement(
            type: type,
            title: Achievement._getTitle(type),
            description: Achievement._getDescription(type),
            icon: Achievement._getIcon(type),
            isUnlocked: true,
            unlockedAt: DateTime.now(),
          );

          achievementsData[key] = achievement.toJson();
          newlyUnlocked.add(achievement);
        }
      }
    }

    if (newlyUnlocked.isNotEmpty) {
      await prefs.setString(_achievementsKey, jsonEncode(achievementsData));
    }

    return newlyUnlocked;
  }

  Future<int> _updateStreak(SharedPreferences prefs, double percentage) async {
    final lastQuizDateStr = prefs.getString(_lastQuizDateKey);
    final currentStreak = prefs.getInt(_streakKey) ?? 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int newStreak = currentStreak;

    if (lastQuizDateStr != null) {
      final lastQuizDate = DateTime.parse(lastQuizDateStr);
      final lastDay =
          DateTime(lastQuizDate.year, lastQuizDate.month, lastQuizDate.day);
      final daysDifference = today.difference(lastDay).inDays;

      if (daysDifference == 0) {
        // Same day, streak continues if score is good
        if (percentage >= 70) {
          newStreak = currentStreak;
        }
      } else if (daysDifference == 1) {
        // Next day, increment streak if score is good
        if (percentage >= 70) {
          newStreak = currentStreak + 1;
        } else {
          newStreak = 0;
        }
      } else {
        // Streak broken
        newStreak = percentage >= 70 ? 1 : 0;
      }
    } else {
      // First quiz
      newStreak = percentage >= 70 ? 1 : 0;
    }

    await prefs.setInt(_streakKey, newStreak);
    await prefs.setString(_lastQuizDateKey, today.toIso8601String());

    return newStreak;
  }

  Future<List<Achievement>> getAllAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = prefs.getString(_achievementsKey) ?? '{}';
    final achievementsData =
        Map<String, dynamic>.from(jsonDecode(achievementsJson));

    final achievements = <Achievement>[];
    for (final type in AchievementType.values) {
      final data = achievementsData[type.name] as Map<String, dynamic>?;
      if (data != null) {
        achievements.add(Achievement.fromJson(data, type));
      } else {
        achievements.add(Achievement(
          type: type,
          title: Achievement._getTitle(type),
          description: Achievement._getDescription(type),
          icon: Achievement._getIcon(type),
          isUnlocked: false,
        ));
      }
    }

    return achievements;
  }

  Future<int> getUnlockedCount() async {
    final achievements = await getAllAchievements();
    return achievements.where((a) => a.isUnlocked).length;
  }

  Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  Future<void> resetAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_achievementsKey);
    await prefs.remove(_streakKey);
    await prefs.remove(_lastQuizDateKey);
  }
}
