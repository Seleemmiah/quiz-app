import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/utils/firestore_error_handler.dart';
import 'dart:math';

class GamificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // XP System
  Future<int> getTotalXP() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    final doc = await FirestoreErrorHandler.executeWithRetry(
      operation: () => _firestore.collection('users').doc(user.uid).get(),
      operationName: 'Fetch total XP',
    );

    if (doc != null && doc.exists) {
      return (doc.data()?['total_xp'] as int?) ?? 0;
    }
    return 0;
  }

  Future<void> addXP(int xp) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await FirestoreErrorHandler.executeWithRetry(
      operation: () => _firestore.collection('users').doc(user.uid).set({
        'total_xp': FieldValue.increment(xp),
      }, SetOptions(merge: true)),
      operationName: 'Add XP',
    );
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
    if (xpNeededForLevel == 0) return 1.0;
    return xpInCurrentLevel / xpNeededForLevel;
  }

  // Daily Challenges (Still using local storage for faster reset check, but could be Firestore)
  // For now, let's keep challenges local but Award XP to Firestore
  // Actually, let's just make the completion update Firestore XP

  Future<Map<String, dynamic>> getDailyChallenge() async {
    // In a real app, you might fetch this from a 'metadata' collection in Firestore
    // For simplicity, we'll keep the generation logic but Award XP to the cloud
    final challenges = [
      {'description': 'Score 7/10 or better on any quiz', 'targetScore': 7},
      {'description': 'Complete a Hard difficulty quiz', 'difficulty': 'hard'},
      {'description': 'Get a perfect score (10/10)', 'targetScore': 10},
      {'description': 'Complete 3 quizzes today', 'targetScore': 3},
    ];

    // Seed based on date so everyone gets the same challenge or at least it persists today
    final day = DateTime.now().day;
    return challenges[day % challenges.length];
  }

  Future<bool> isDailyChallengeCompleted() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc = await FirestoreErrorHandler.executeWithRetry(
      operation: () => _firestore.collection('users').doc(user.uid).get(),
      operationName: 'Check daily challenge status',
    );

    if (doc != null && doc.exists) {
      final lastCompleted = doc.data()?['last_challenge_completed'] as String?;
      final today = DateTime.now().toIso8601String().split('T')[0];
      return lastCompleted == today;
    }
    return false;
  }

  Future<void> completeDailyChallenge() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final today = DateTime.now().toIso8601String().split('T')[0];

    await FirestoreErrorHandler.executeWithRetry(
      operation: () => _firestore.collection('users').doc(user.uid).set({
        'total_xp': FieldValue.increment(100),
        'last_challenge_completed': today,
      }, SetOptions(merge: true)),
      operationName: 'Complete daily challenge',
    );
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

    bool isCompleted = false;
    if (description.contains('perfect score') && score == totalQuestions) {
      isCompleted = true;
    } else if (description.contains('Hard difficulty') &&
        difficulty == Difficulty.hard) {
      isCompleted = true;
    } else if (description.contains('Score') &&
        score >= (challenge['targetScore'] as int)) {
      isCompleted = true;
    }

    if (isCompleted) {
      await completeDailyChallenge();
      return true;
    }

    return false;
  }
}
