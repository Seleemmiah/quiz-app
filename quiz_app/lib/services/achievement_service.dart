import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/achievement.dart';

class AchievementService {
  static final AchievementService _instance = AchievementService._internal();
  factory AchievementService() => _instance;
  AchievementService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _achievementController = StreamController<Achievement>.broadcast();

  Stream<Achievement> get achievementUnlocked => _achievementController.stream;

  // Login streak data structure
  Future<Map<String, dynamic>> trackDailyLogin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {'streak': 0, 'streakIncreased': false};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayString = today.toIso8601String().split('T')[0];

    try {
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('loginStreak')
          .doc('current');

      final doc = await docRef.get();
      Map<String, dynamic> data = doc.exists ? doc.data()! : {};

      List<String> loginDates = List<String>.from(data['loginDates'] ?? []);
      int currentStreak = data['currentStreak'] ?? 0;
      int longestStreak = data['longestStreak'] ?? 0;

      // Check if already logged in today
      if (loginDates.contains(todayString)) {
        return {'streak': currentStreak, 'streakIncreased': false};
      }

      // Add today's login
      loginDates.add(todayString);

      // Calculate new streak
      bool streakIncreased = false;
      if (loginDates.length == 1) {
        // First login
        currentStreak = 1;
        streakIncreased = true;
      } else {
        // Check if consecutive
        final sortedDates = loginDates.map((d) => DateTime.parse(d)).toList()
          ..sort();
        final yesterday = DateTime(now.year, now.month, now.day - 1);
        final yesterdayString = yesterday.toIso8601String().split('T')[0];

        if (sortedDates.last.isAtSameMomentAs(today) &&
            sortedDates.contains(DateTime.parse(yesterdayString))) {
          currentStreak++;
          streakIncreased = true;
        } else if (sortedDates.length >= 2 &&
            sortedDates[sortedDates.length - 2].isBefore(yesterday)) {
          // Streak broken, restart
          currentStreak = 1;
          streakIncreased = true;
        } else {
          currentStreak = 1;
          streakIncreased = true;
        }
      }

      // Update longest streak
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }

      // Keep only recent dates (last 60 days to prevent bloat)
      final cutoffDate = DateTime(now.year, now.month, now.day - 60);
      loginDates = loginDates.where((dateStr) {
        final date = DateTime.parse(dateStr);
        return date.isAfter(cutoffDate);
      }).toList();

      // Save updated data
      await docRef.set({
        'loginDates': loginDates,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastLoginDate': todayString,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      return {'streak': currentStreak, 'streakIncreased': streakIncreased};
    } catch (e) {
      debugPrint('Error tracking daily login: $e');
      return {'streak': 0, 'streakIncreased': false};
    }
  }

  // Get current login streak
  Future<int> getLoginStreak() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('loginStreak')
          .doc('current')
          .get();

      if (doc.exists) {
        return doc.data()?['currentStreak'] ?? 0;
      }
      return 0;
    } catch (e) {
      debugPrint('Error getting login streak: $e');
      return 0;
    }
  }

  Future<List<Achievement>> getUserAchievements() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Achievement.getDefaultAchievements();

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('achievements')
          .doc('unlocked')
          .get();

      if (!doc.exists) {
        return Achievement.getDefaultAchievements();
      }

      final data = doc.data()!;
      final unlockedIds = Set<String>.from(data['achievements'] ?? []);
      final unlockedDates = Map<String, DateTime>.from(
        (data['dates'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(key, DateTime.parse(value)),
        ),
      );

      return Achievement.getDefaultAchievements().map((achievement) {
        final isUnlocked = unlockedIds.contains(achievement.id);
        return achievement.copyWith(
          isUnlocked: isUnlocked,
          unlockedAt: isUnlocked ? unlockedDates[achievement.id] : null,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error loading achievements: $e');
      return Achievement.getDefaultAchievements();
    }
  }

  Future<void> checkAndUnlockAchievements({
    int? quizCount,
    int? questionCount,
    int? streak,
    double? lastScore,
    bool? isExam,
    bool? isMultiplayer,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final achievements = await getUserAchievements();
    final now = DateTime.now();

    for (var achievement in achievements) {
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;

      switch (achievement.type) {
        case AchievementType.firstQuiz:
          shouldUnlock = quizCount != null && quizCount >= 1;
          break;
        case AchievementType.perfectScore:
          shouldUnlock = lastScore != null && lastScore >= 100.0;
          break;
        case AchievementType.streak7:
          shouldUnlock = streak != null && streak >= 7;
          break;
        case AchievementType.streak30:
          shouldUnlock = streak != null && streak >= 30;
          break;
        case AchievementType.speed100:
          shouldUnlock = questionCount != null && questionCount >= 100;
          break;
        case AchievementType.master50:
          shouldUnlock = quizCount != null && quizCount >= 50;
          break;
        case AchievementType.examAce:
          shouldUnlock =
              isExam == true && lastScore != null && lastScore >= 90.0;
          break;
        case AchievementType.socialButterfly:
          shouldUnlock = isMultiplayer == true;
          break;
        case AchievementType.nightOwl:
          shouldUnlock = now.hour >= 22 || now.hour < 4;
          break;
        case AchievementType.earlyBird:
          shouldUnlock = now.hour >= 4 && now.hour < 6;
          break;
      }

      if (shouldUnlock) {
        await _unlockAchievement(achievement);
      }
    }
  }

  Future<void> _unlockAchievement(Achievement achievement) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final now = DateTime.now();
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('achievements')
          .doc('unlocked');

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);

        List<String> achievements = [];
        Map<String, String> dates = {};

        if (doc.exists) {
          final data = doc.data()!;
          achievements = List<String>.from(data['achievements'] ?? []);
          dates = Map<String, String>.from(data['dates'] ?? {});
        }

        if (!achievements.contains(achievement.id)) {
          achievements.add(achievement.id);
          dates[achievement.id] = now.toIso8601String();

          transaction.set(docRef, {
            'achievements': achievements,
            'dates': dates,
            'lastUpdated': FieldValue.serverTimestamp(),
          });

          // Notify listeners
          _achievementController.add(achievement.copyWith(
            isUnlocked: true,
            unlockedAt: now,
          ));
        }
      });
    } catch (e) {
      debugPrint('Error unlocking achievement: $e');
    }
  }

  Future<void> resetAchievements() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('achievements')
          .doc('unlocked')
          .delete();

      // Optionally reset streak too if considered part of achievements
      // For now just achievements as requested
    } catch (e) {
      debugPrint('Error resetting achievements: $e');
    }
  }

  void dispose() {
    _achievementController.close();
  }
}
