import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/services/professional_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AchievementType {
  perfectScore,
  speedDemon,
  quizMaster,
  categoryExpert,
  hardcorePlayer,
  streakWarrior,
  centurion,
  // NEW ACHIEVEMENTS
  novice,
  dedicated,
  veteran,
  legend,
  impossible,
  nightOwl,
  earlyBird,
  marathoner,
  sharpshooter,
  brainiac,
  genius,
  grandmaster,
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
        return 'Mindly Master';
      case AchievementType.categoryExpert:
        return 'Category Expert';
      case AchievementType.hardcorePlayer:
        return 'Hardcore Player';
      case AchievementType.streakWarrior:
        return 'Streak Warrior';
      case AchievementType.centurion:
        return 'Centurion';
      case AchievementType.novice:
        return 'Novice Learner';
      case AchievementType.dedicated:
        return 'Dedicated Student';
      case AchievementType.veteran:
        return 'Quiz Veteran';
      case AchievementType.legend:
        return 'Living Legend';
      case AchievementType.impossible:
        return 'The Impossible';
      case AchievementType.nightOwl:
        return 'Night Owl';
      case AchievementType.earlyBird:
        return 'Early Bird';
      case AchievementType.marathoner:
        return 'Marathon Runner';
      case AchievementType.sharpshooter:
        return 'Sharpshooter';
      case AchievementType.brainiac:
        return 'Brainiac';
      case AchievementType.genius:
        return 'Genius';
      case AchievementType.grandmaster:
        return 'Grandmaster';
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
      case AchievementType.novice:
        return 'Complete your first quiz';
      case AchievementType.dedicated:
        return 'Complete 50 quizzes';
      case AchievementType.veteran:
        return 'Complete 500 quizzes';
      case AchievementType.legend:
        return 'Complete 1,000 quizzes';
      case AchievementType.impossible:
        return 'Complete 5,000 quizzes (You can do it!)';
      case AchievementType.nightOwl:
        return 'Complete a quiz between 12 AM and 4 AM';
      case AchievementType.earlyBird:
        return 'Complete a quiz between 5 AM and 8 AM';
      case AchievementType.marathoner:
        return 'Complete 5 quizzes in a single day';
      case AchievementType.sharpshooter:
        return 'Get 5 perfect scores in a row';
      case AchievementType.brainiac:
        return 'Reach Level 10';
      case AchievementType.genius:
        return 'Reach Level 50';
      case AchievementType.grandmaster:
        return 'Reach Level 100 (The Ultimate Goal)';
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
      case AchievementType.novice:
        return '🌱';
      case AchievementType.dedicated:
        return '📚';
      case AchievementType.veteran:
        return '🎖️';
      case AchievementType.legend:
        return '🦁';
      case AchievementType.impossible:
        return '🚀';
      case AchievementType.nightOwl:
        return '🦉';
      case AchievementType.earlyBird:
        return '🌅';
      case AchievementType.marathoner:
        return '🏃';
      case AchievementType.sharpshooter:
        return '🎯';
      case AchievementType.brainiac:
        return '🧠';
      case AchievementType.genius:
        return '💡';
      case AchievementType.grandmaster:
        return '🧘';
    }
  }
}

class AchievementService {
  static const String _achievementsKey = 'achievements';
  static const String _streakKey = 'current_streak';
  static const String _lastQuizDateKey = 'last_quiz_date';
  static const String _loginStreakKey = 'login_streak';
  static const String _lastLoginDateKey = 'last_login_date';

  // Track daily login and update login streak
  Future<Map<String, dynamic>> trackDailyLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoginStr = prefs.getString(_lastLoginDateKey);
    final currentLoginStreak = prefs.getInt(_loginStreakKey) ?? 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int newStreak = currentLoginStreak;
    bool streakIncreased = false;
    bool isFirstLoginToday = false;

    if (lastLoginStr != null) {
      final lastLogin = DateTime.parse(lastLoginStr);
      final lastDay = DateTime(lastLogin.year, lastLogin.month, lastLogin.day);
      final daysDifference = today.difference(lastDay).inDays;

      if (daysDifference == 0) {
        // Already logged in today, no change
        newStreak = currentLoginStreak;
      } else if (daysDifference == 1) {
        // Logged in yesterday, increment streak
        newStreak = currentLoginStreak + 1;
        streakIncreased = true;
        isFirstLoginToday = true;
      } else {
        // Streak broken, start over
        newStreak = 1;
        isFirstLoginToday = true;
      }
    } else {
      // First time login
      newStreak = 1;
      isFirstLoginToday = true;
    }

    // Save new streak and login date
    await prefs.setInt(_loginStreakKey, newStreak);
    await prefs.setString(_lastLoginDateKey, today.toIso8601String());

    return {
      'streak': newStreak,
      'streakIncreased': streakIncreased,
      'isFirstLoginToday': isFirstLoginToday,
    };
  }

  Future<int> getLoginStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_loginStreakKey) ?? 0;
  }

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
    int currentLevel = 1, // Added currentLevel
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

    // Update Perfect Score Streak
    int perfectScoreStreak = prefs.getInt('perfect_score_streak') ?? 0;
    if (percentage == 100) {
      perfectScoreStreak++;
    } else {
      perfectScoreStreak = 0;
    }
    await prefs.setInt('perfect_score_streak', perfectScoreStreak);

    // Check time for Night Owl / Early Bird
    final now = DateTime.now();
    final hour = now.hour;

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
          // NEW ACHIEVEMENTS LOGIC
          case AchievementType.novice:
            shouldUnlock = totalQuizzes >= 1;
            break;
          case AchievementType.dedicated:
            shouldUnlock = totalQuizzes >= 50;
            break;
          case AchievementType.veteran:
            shouldUnlock = totalQuizzes >= 500;
            break;
          case AchievementType.legend:
            shouldUnlock = totalQuizzes >= 1000;
            break;
          case AchievementType.impossible:
            shouldUnlock = totalQuizzes >= 5000;
            break;
          case AchievementType.nightOwl:
            shouldUnlock = hour >= 0 && hour < 4;
            break;
          case AchievementType.earlyBird:
            shouldUnlock = hour >= 5 && hour < 8;
            break;
          case AchievementType.marathoner:
            // Simplified: Check if user did 5 quizzes today (requires tracking daily quizzes)
            // For now, we'll skip complex tracking and assume false or implement later
            // Let's use a simple session counter if possible, or skip
            shouldUnlock = false;
            break;
          case AchievementType.sharpshooter:
            shouldUnlock = perfectScoreStreak >= 5;
            break;
          case AchievementType.brainiac:
            shouldUnlock = currentLevel >= 10;
            break;
          case AchievementType.genius:
            shouldUnlock = currentLevel >= 50;
            break;
          case AchievementType.grandmaster:
            shouldUnlock = currentLevel >= 100;
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

      // Send notifications for unlocked achievements
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final notificationService = ProfessionalNotificationService();
        for (final achievement in newlyUnlocked) {
          try {
            await notificationService.sendAchievementNotification(
              userId: user.uid,
              achievementTitle: achievement.title,
              achievementDescription: achievement.description,
            );
          } catch (e) {
            print('Failed to send achievement notification: $e');
          }
        }
      }
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
