import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/settings.dart';
import 'dart:math';

class GamificationService {
  static const String _xpKey = 'total_xp';
  static const String _dailyChallengeKey = 'daily_challenge';
  static const String _dailyChallengeCompletedKey = 'daily_challenge_completed';
  static const String _lastChallengeResetKey = 'last_challenge_reset';

  // XP System
  Future<int> getTotalXP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_xpKey) ?? 0;
  }

  Future<void> addXP(int xp) async {
    final prefs = await SharedPreferences.getInstance();
    final currentXP = await getTotalXP();
    await prefs.setInt(_xpKey, currentXP + xp);
  }

  // Calculate XP earned from a quiz
  int calculateQuizXP({
    required int score,
    required int totalQuestions,
    required Difficulty difficulty,
    int? completionTimeSeconds,
  }) {
    // Base XP: 10 per correct answer
    int xp = score * 10;

    // Difficulty multiplier
    switch (difficulty) {
      case Difficulty.easy:
        xp = (xp * 1.0).round();
        break;
      case Difficulty.medium:
        xp = (xp * 1.5).round();
        break;
      case Difficulty.hard:
        xp = (xp * 2.0).round();
        break;
    }

    // Perfect score bonus
    if (score == totalQuestions) {
      xp += 50;
    }

    // Speed bonus (if completed in under 2 minutes)
    if (completionTimeSeconds != null && completionTimeSeconds < 120) {
      xp += 25;
    }

    return xp;
  }

  // Level System
  int getLevel(int totalXP) {
    // Level formula: level = sqrt(xp / 100)
    // Level 1: 0 XP, Level 2: 100 XP, Level 3: 400 XP, Level 4: 900 XP, etc.
    return sqrt(totalXP / 100).floor() + 1;
  }

  int getXPForNextLevel(int currentLevel) {
    // XP needed for next level
    return currentLevel * currentLevel * 100;
  }

  int getXPForCurrentLevel(int currentLevel) {
    // XP needed for current level
    return (currentLevel - 1) * (currentLevel - 1) * 100;
  }

  double getLevelProgress(int totalXP) {
    final level = getLevel(totalXP);
    final currentLevelXP = getXPForCurrentLevel(level);
    final nextLevelXP = getXPForNextLevel(level);
    final xpInCurrentLevel = totalXP - currentLevelXP;
    final xpNeededForLevel = nextLevelXP - currentLevelXP;
    return xpInCurrentLevel / xpNeededForLevel;
  }

  // Daily Challenges
  Future<Map<String, dynamic>> getDailyChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    await _checkAndResetDailyChallenge();

    final challengeJson = prefs.getString(_dailyChallengeKey);
    if (challengeJson != null) {
      // Parse stored challenge
      final parts = challengeJson.split('|');
      return {
        'description': parts[0],
        'category': parts.length > 1 ? parts[1] : null,
        'difficulty': parts.length > 2 ? parts[2] : null,
        'targetScore': parts.length > 3 ? int.parse(parts[3]) : 7,
      };
    }

    // Generate new challenge
    return await _generateDailyChallenge();
  }

  Future<bool> isDailyChallengeCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await _checkAndResetDailyChallenge();
    return prefs.getBool(_dailyChallengeCompletedKey) ?? false;
  }

  Future<void> completeDailyChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dailyChallengeCompletedKey, true);
    // Award bonus XP
    await addXP(100);
  }

  Future<void> _checkAndResetDailyChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString(_lastChallengeResetKey);
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastReset != today) {
      // New day, reset challenge
      await prefs.remove(_dailyChallengeKey);
      await prefs.remove(_dailyChallengeCompletedKey);
      await prefs.setString(_lastChallengeResetKey, today);
    }
  }

  Future<Map<String, dynamic>> _generateDailyChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    final challenges = [
      {'description': 'Score 7/10 or better on any quiz', 'targetScore': 7},
      {'description': 'Complete a Hard difficulty quiz', 'difficulty': 'hard'},
      {'description': 'Get a perfect score (10/10)', 'targetScore': 10},
      {'description': 'Complete 3 quizzes today', 'targetScore': 3},
    ];

    final challenge = challenges[DateTime.now().day % challenges.length];
    final challengeJson =
        '${challenge['description']}|${challenge['category'] ?? ''}|${challenge['difficulty'] ?? ''}|${challenge['targetScore'] ?? 7}';
    await prefs.setString(_dailyChallengeKey, challengeJson);

    return challenge;
  }

  // Check if quiz completes daily challenge
  Future<bool> checkDailyChallengeCompletion({
    required int score,
    required int totalQuestions,
    required Difficulty difficulty,
  }) async {
    if (await isDailyChallengeCompleted()) return false;

    final challenge = await getDailyChallenge();
    final description = challenge['description'] as String;

    if (description.contains('perfect score') && score == totalQuestions) {
      await completeDailyChallenge();
      return true;
    }

    if (description.contains('Hard difficulty') &&
        difficulty == Difficulty.hard) {
      await completeDailyChallenge();
      return true;
    }

    if (description.contains('Score') &&
        score >= (challenge['targetScore'] as int)) {
      await completeDailyChallenge();
      return true;
    }

    return false;
  }

  // Reset all gamification data
  Future<void> resetGamification() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_xpKey);
    await prefs.remove(_dailyChallengeKey);
    await prefs.remove(_dailyChallengeCompletedKey);
    await prefs.remove(_lastChallengeResetKey);
  }
}
