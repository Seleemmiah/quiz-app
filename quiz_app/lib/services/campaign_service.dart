import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/level_model.dart';
import 'package:quiz_app/settings.dart';

class CampaignService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Hardcoded levels for now (could be moved to Firestore later)
  final List<Level> _allLevels = [
    Level(
      id: 'level_1',
      name: 'The Beginning',
      description: 'Start your journey with some easy General Knowledge.',
      requiredScore: 5, // 5/10 to pass
      difficulty: Difficulty.easy,
      category: 'General Knowledge',
      order: 1,
      isUnlocked: true, // First level always unlocked
    ),
    Level(
      id: 'level_2',
      name: 'Science Rookie',
      description: 'Test your basic Science skills.',
      requiredScore: 6,
      difficulty: Difficulty.easy,
      category: 'Science',
      order: 2,
    ),
    Level(
      id: 'level_3',
      name: 'History Buff',
      description: 'Travel back in time.',
      requiredScore: 6,
      difficulty: Difficulty.medium,
      category: 'History',
      order: 3,
    ),
    Level(
      id: 'level_4',
      name: 'Math Whiz',
      description: 'Crunch some numbers.',
      requiredScore: 7,
      difficulty: Difficulty.medium,
      category: 'Mathematics',
      order: 4,
    ),
    Level(
      id: 'level_5',
      name: 'Tech Master',
      description: 'Prove your computer knowledge.',
      requiredScore: 8,
      difficulty: Difficulty.hard,
      category: 'Computers',
      order: 5,
    ),
  ];

  // Get levels with user progress
  Future<List<Level>> getLevels() async {
    final user = _auth.currentUser;
    if (user == null) return _allLevels;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('campaign_progress')
          .get();

      final progressMap = {for (var doc in snapshot.docs) doc.id: doc.data()};

      return _allLevels.map((level) {
        if (progressMap.containsKey(level.id)) {
          final data = progressMap[level.id]!;
          return level.copyWith(
            isUnlocked: data['isUnlocked'] ?? false,
            stars: data['stars'] ?? 0,
          );
        }
        // Level 1 is always unlocked by default in the model
        return level;
      }).toList();
    } catch (e) {
      print('Error fetching campaign progress: $e');
      return _allLevels;
    }
  }

  // Update progress after a quiz
  Future<void> updateProgress(
      String levelId, int score, int totalQuestions) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final level = _allLevels.firstWhere((l) => l.id == levelId);

    // Calculate stars
    int stars = 0;
    final percentage = score / totalQuestions;
    if (percentage >= 0.9) {
      stars = 3;
    } else if (percentage >= 0.7) {
      stars = 2;
    } else if (percentage >= 0.5) {
      stars = 1;
    }

    // Only update if score is sufficient to pass
    if (score >= level.requiredScore) {
      // Save current level progress
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('campaign_progress')
          .doc(levelId)
          .set({
        'isUnlocked': true,
        'stars': stars, // You might want to keep the max stars
        'completedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Unlock NEXT level
      final nextLevelIndex = _allLevels.indexOf(level) + 1;
      if (nextLevelIndex < _allLevels.length) {
        final nextLevel = _allLevels[nextLevelIndex];
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('campaign_progress')
            .doc(nextLevel.id)
            .set({
          'isUnlocked': true,
        }, SetOptions(merge: true));
      }
    }
  }
}
