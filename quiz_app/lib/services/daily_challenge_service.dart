import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app/models/daily_challenge.dart';
import 'package:quiz_app/models/streak_data.dart';
import '../screens/local_questions.dart' as local_q;

class DailyChallengeService {
  static final DailyChallengeService _instance =
      DailyChallengeService._internal();
  factory DailyChallengeService() => _instance;
  DailyChallengeService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Random _random = Random();

  // Categories for daily challenges
  final List<String> _categories = [
    'General',
    'Science',
    'History',
    'Mathematics',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Chemical Engineering',
    'Computer Engineering',
    'Technology',
    'Sports',
    'Geography',
  ];

  // Get today's challenge (creates if doesn't exist)
  Future<DailyChallenge?> getTodaysChallenge() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final today = _getTodayDateString();

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dailyChallenges')
          .doc(today)
          .get();

      if (doc.exists) {
        return DailyChallenge.fromMap(doc.data()!);
      } else {
        // Generate new challenge for today
        return await _generateTodaysChallenge(user.uid);
      }
    } catch (e) {
      debugPrint('Error getting today\'s challenge: $e');
      return null;
    }
  }

  // Generate a new daily challenge
  Future<DailyChallenge> _generateTodaysChallenge(String userId) async {
    final today = DateTime.now();
    final todayString = _getTodayDateString();

    // Pick random category
    final category = _categories[_random.nextInt(_categories.length)];

    // Get questions for this category
    final allQuestions = local_q.getLocalQuestions();
    final categoryQuestions =
        allQuestions.where((q) => q.category == category).toList();

    // Shuffle and take 10 questions
    categoryQuestions.shuffle(_random);
    final selectedQuestions = categoryQuestions.take(10).toList();

    // Determine difficulty-based targets
    final targetScore = 70 + _random.nextInt(21); // 70-90%
    final bonusPoints = targetScore >= 85
        ? 100
        : targetScore >= 80
            ? 75
            : 50;

    final challenge = DailyChallenge(
      id: todayString,
      date: today,
      category: category,
      questionCount: selectedQuestions.length,
      targetScore: targetScore,
      bonusPoints: bonusPoints,
      questionIds: selectedQuestions.map((q) => q.question).toList(),
    );

    // Save to Firestore
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('dailyChallenges')
        .doc(todayString)
        .set(challenge.toMap());

    return challenge;
  }

  // Complete today's challenge
  Future<void> completeChallenge(int score) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final today = _getTodayDateString();
    final challenge = await getTodaysChallenge();
    if (challenge == null) return;

    final updatedChallenge = challenge.copyWith(
      isCompleted: true,
      userScore: score,
      completedAt: DateTime.now(),
    );

    // Update challenge
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dailyChallenges')
        .doc(today)
        .update(updatedChallenge.toMap());

    // Update streak
    await _updateStreak(user.uid, updatedChallenge);
  }

  // Update user's streak
  Future<void> _updateStreak(String userId, DailyChallenge challenge) async {
    final streakData = await getStreakData();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int newStreak = streakData.currentStreak;

    // Check if this continues the streak
    if (streakData.lastCompletionDate != null) {
      final lastDate = DateTime(
        streakData.lastCompletionDate!.year,
        streakData.lastCompletionDate!.month,
        streakData.lastCompletionDate!.day,
      );

      final yesterday = DateTime(now.year, now.month, now.day - 1);

      if (lastDate.isAtSameMomentAs(yesterday)) {
        // Continues streak
        newStreak++;
      } else if (lastDate.isBefore(yesterday)) {
        // Streak broken, restart
        newStreak = 1;
      }
      // If same day, don't change streak
    } else {
      // First challenge
      newStreak = 1;
    }

    final newLongest = max(newStreak, streakData.longestStreak);
    final bonusEarned = challenge.isSuccessful ? challenge.bonusPoints : 0;

    final updatedStreak = streakData.copyWith(
      currentStreak: newStreak,
      longestStreak: newLongest,
      lastCompletionDate: today,
      totalChallengesCompleted: streakData.totalChallengesCompleted + 1,
      totalBonusPointsEarned: streakData.totalBonusPointsEarned + bonusEarned,
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('streakData')
        .doc('current')
        .set(updatedStreak.toMap());
  }

  // Get current streak data
  Future<StreakData> getStreakData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return StreakData();

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('streakData')
          .doc('current')
          .get();

      if (doc.exists) {
        return StreakData.fromMap(doc.data()!);
      }
      return StreakData();
    } catch (e) {
      debugPrint('Error getting streak data: $e');
      return StreakData();
    }
  }

  // Get challenge history
  Future<List<DailyChallenge>> getChallengeHistory({int limit = 30}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dailyChallenges')
          .orderBy('date', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => DailyChallenge.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting challenge history: $e');
      return [];
    }
  }

  // Helper to get today's date as string
  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // Check if user has completed today's challenge
  Future<bool> hasCompletedToday() async {
    final challenge = await getTodaysChallenge();
    return challenge?.isCompleted ?? false;
  }
}
