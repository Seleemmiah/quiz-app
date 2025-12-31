import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/services/cache_service.dart';
import 'package:quiz_app/utils/firestore_error_handler.dart';

class QuizHistory {
  final String? id;
  final DateTime date;
  final int score;
  final int totalQuestions;
  final Difficulty difficulty;
  final String? category;

  QuizHistory({
    this.id,
    required this.date,
    required this.score,
    required this.totalQuestions,
    required this.difficulty,
    this.category,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'score': score,
        'totalQuestions': totalQuestions,
        'difficulty': difficulty.name,
        'category': category,
      };

  factory QuizHistory.fromJson(Map<String, dynamic> json, [String? id]) {
    return QuizHistory(
      id: id,
      date: DateTime.parse(json['date']),
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == json['difficulty'],
        orElse: () => Difficulty.medium,
      ),
      category: json['category'],
    );
  }

  double get percentage =>
      totalQuestions > 0 ? (score / totalQuestions) * 100 : 0;
}

class QuizStatistics {
  final int totalQuizzes;
  final double averageScore;
  final int totalQuestions;
  final int totalCorrect;
  final Map<String, int> categoryQuizzes;
  final Map<String, double> categoryAverages;
  final Map<Difficulty, int> difficultyQuizzes;
  final Map<Difficulty, double> difficultyAverages;
  final String? bestCategory;
  final Difficulty? bestDifficulty;
  final int flashcardSessions;
  final int spacedReviews;
  final int aiExplanationsRead;
  final int ttsUsedCount;
  final int handwritingUsedCount;
  final int manualExplanationsRead;
  final int maxCorrectRow;

  QuizStatistics({
    required this.totalQuizzes,
    required this.averageScore,
    required this.totalQuestions,
    required this.totalCorrect,
    required this.categoryQuizzes,
    required this.categoryAverages,
    required this.difficultyQuizzes,
    required this.difficultyAverages,
    this.bestCategory,
    this.bestDifficulty,
    this.flashcardSessions = 0,
    this.spacedReviews = 0,
    this.aiExplanationsRead = 0,
    this.ttsUsedCount = 0,
    this.handwritingUsedCount = 0,
    this.manualExplanationsRead = 0,
    this.maxCorrectRow = 0,
  });

  factory QuizStatistics.fromMap(Map<String, dynamic> data) {
    final totalQuizzes = (data['total_quizzes'] as int?) ?? 0;
    final totalQuestions = (data['total_all_questions'] as int?) ?? 0;
    final totalCorrect = (data['total_correct'] as int?) ?? 0;

    final categoryQuizzes =
        Map<String, int>.from(data['category_quizzes'] ?? {});
    final categoryCorrect =
        Map<String, int>.from(data['category_correct'] ?? {});
    final categoryQuestions =
        Map<String, int>.from(data['category_questions'] ?? {});

    final difficultyQuizzesData =
        Map<String, int>.from(data['difficulty_quizzes'] ?? {});
    final difficultyCorrectData =
        Map<String, int>.from(data['difficulty_correct'] ?? {});
    final difficultyQuestionsData =
        Map<String, int>.from(data['difficulty_questions'] ?? {});

    final categoryAverages = <String, double>{};
    categoryQuestions.forEach((cat, questions) {
      if (questions > 0) {
        categoryAverages[cat] = (categoryCorrect[cat]! / questions) * 100;
      }
    });

    final difficultyQuizzes = <Difficulty, int>{};
    final difficultyAverages = <Difficulty, double>{};
    for (var diff in Difficulty.values) {
      final quizzes = difficultyQuizzesData[diff.name] ?? 0;
      final questions = difficultyQuestionsData[diff.name] ?? 0;
      final correct = difficultyCorrectData[diff.name] ?? 0;

      difficultyQuizzes[diff] = quizzes;
      if (questions > 0) {
        difficultyAverages[diff] = (correct / questions) * 100;
      }
    }

    String? bestCategory;
    double bestCategoryAverage = -1;
    categoryAverages.forEach((cat, avg) {
      if (avg > bestCategoryAverage) {
        bestCategoryAverage = avg;
        bestCategory = cat;
      }
    });

    Difficulty? bestDifficulty;
    double bestDifficultyAverage = -1;
    difficultyAverages.forEach((diff, avg) {
      if (avg > bestDifficultyAverage) {
        bestDifficultyAverage = avg;
        bestDifficulty = diff;
      }
    });

    return QuizStatistics(
      totalQuizzes: totalQuizzes,
      averageScore:
          totalQuestions > 0 ? (totalCorrect / totalQuestions) * 100 : 0,
      totalQuestions: totalQuestions,
      totalCorrect: totalCorrect,
      categoryQuizzes: categoryQuizzes,
      categoryAverages: categoryAverages,
      difficultyQuizzes: difficultyQuizzes,
      difficultyAverages: difficultyAverages,
      bestCategory: bestCategory,
      bestDifficulty: bestDifficulty,
      flashcardSessions: (data['flashcard_sessions'] as int?) ?? 0,
      spacedReviews: (data['spaced_reviews'] as int?) ?? 0,
      aiExplanationsRead: (data['ai_explanations_read'] as int?) ?? 0,
      ttsUsedCount: (data['tts_used_count'] as int?) ?? 0,
      handwritingUsedCount: (data['handwriting_used_count'] as int?) ?? 0,
      manualExplanationsRead: (data['manual_explanations_read'] as int?) ?? 0,
      maxCorrectRow: (data['max_correct_row'] as int?) ?? 0,
    );
  }
}

class StatisticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> recordQuizCompletion({
    required int score,
    required int totalQuestions,
    required Difficulty difficulty,
    String? category,
    int maxStreak = 0,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final statsRef = _firestore.collection('users').doc(user.uid);
    final historyRef = statsRef.collection('quizHistory');

    // Create history entry
    final history = QuizHistory(
      date: DateTime.now(),
      score: score,
      totalQuestions: totalQuestions,
      difficulty: difficulty,
      category: category,
    );

    await FirestoreErrorHandler.executeWithRetry(
      operation: () async {
        final doc = await statsRef.get();
        final currentMaxCorrectRow =
            (doc.data()?['max_correct_row'] as int?) ?? 0;

        final batch = _firestore.batch();

        // Add to history subcollection
        batch.set(historyRef.doc(), history.toJson());

        // Update main stats
        final Map<String, dynamic> updates = {
          'total_quizzes': FieldValue.increment(1),
          'total_all_questions': FieldValue.increment(totalQuestions),
          'total_correct': FieldValue.increment(score),
          'difficulty_quizzes.${difficulty.name}': FieldValue.increment(1),
          'difficulty_questions.${difficulty.name}':
              FieldValue.increment(totalQuestions),
          'difficulty_correct.${difficulty.name}': FieldValue.increment(score),
        };

        if (maxStreak > currentMaxCorrectRow) {
          updates['max_correct_row'] = maxStreak;
        }

        if (category != null) {
          updates['category_quizzes.$category'] = FieldValue.increment(1);
          updates['category_questions.$category'] =
              FieldValue.increment(totalQuestions);
          updates['category_correct.$category'] = FieldValue.increment(score);
        }

        batch.set(statsRef, updates, SetOptions(merge: true));
        await batch.commit();
      },
      operationName: 'Record quiz completion',
    );
    await CacheService.remove('user_stats');
  }

  Future<void> _incrementMetric(String field) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await FirestoreErrorHandler.executeWithRetry(
      operation: () => _firestore.collection('users').doc(user.uid).set(
        {field: FieldValue.increment(1)},
        SetOptions(merge: true),
      ),
      operationName: 'Increment $field',
    );
    await CacheService.remove('user_stats');
  }

  Future<void> recordFlashcardSession() =>
      _incrementMetric('flashcard_sessions');
  Future<void> recordSpacedReview() => _incrementMetric('spaced_reviews');
  Future<void> recordAIExplanationRead() =>
      _incrementMetric('ai_explanations_read');
  Future<void> recordTTSUsage() => _incrementMetric('tts_used_count');
  Future<void> recordHandwritingUsage() =>
      _incrementMetric('handwriting_used_count');
  Future<void> recordManualExplanationRead() =>
      _incrementMetric('manual_explanations_read');

  Future<QuizStatistics> getStatistics() async {
    final user = _auth.currentUser;
    if (user == null) {
      return QuizStatistics(
        totalQuizzes: 0,
        averageScore: 0,
        totalQuestions: 0,
        totalCorrect: 0,
        categoryQuizzes: {},
        categoryAverages: {},
        difficultyQuizzes: {},
        difficultyAverages: {},
      );
    }

    // Try to get from cache first
    final cachedData = await CacheService.getCachedUserStats();
    if (cachedData != null) {
      return QuizStatistics.fromMap(cachedData);
    }

    final doc = await FirestoreErrorHandler.executeWithRetry(
      operation: () => _firestore.collection('users').doc(user.uid).get(),
      operationName: 'Fetch statistics',
    );

    if (doc != null && doc.exists) {
      final data = doc.data()!;
      await CacheService.cacheUserStats(data);
      return QuizStatistics.fromMap(data);
    }

    return QuizStatistics(
      totalQuizzes: 0,
      averageScore: 0,
      totalQuestions: 0,
      totalCorrect: 0,
      categoryQuizzes: {},
      categoryAverages: {},
      difficultyQuizzes: {},
      difficultyAverages: {},
    );
  }

  Future<List<QuizHistory>> getQuizHistory({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    Query query = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('quizHistory')
        .orderBy('date', descending: true)
        .limit(limit);

    if (startDate != null) {
      query = query.where('date',
          isGreaterThanOrEqualTo: startDate.toIso8601String());
    }
    if (endDate != null) {
      query =
          query.where('date', isLessThanOrEqualTo: endDate.toIso8601String());
    }

    final snapshot = await FirestoreErrorHandler.executeWithRetry(
      operation: () => query.get(),
      operationName: 'Fetch quiz history',
    );

    if (snapshot == null) return [];

    return snapshot.docs
        .map((doc) =>
            QuizHistory.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<Map<String, double>> getPerformanceTrend(int days) async {
    final startDate = DateTime.now().subtract(Duration(days: days));
    final history = await getQuizHistory(startDate: startDate);

    final Map<String, List<double>> dailyScores = {};

    for (final quiz in history) {
      final dateKey =
          '${quiz.date.year}-${quiz.date.month.toString().padLeft(2, '0')}-${quiz.date.day.toString().padLeft(2, '0')}';
      if (!dailyScores.containsKey(dateKey)) {
        dailyScores[dateKey] = [];
      }
      dailyScores[dateKey]!.add(quiz.percentage);
    }

    // Calculate average for each day
    final Map<String, double> trend = {};
    dailyScores.forEach((date, scores) {
      final average = scores.reduce((a, b) => a + b) / scores.length;
      trend[date] = average;
    });

    return trend;
  }

  // Get performance by time of day (Morning, Afternoon, Evening, Night)
  Future<Map<String, double>> getPerformanceByTimeOfDay() async {
    final history = await getQuizHistory();

    final Map<String, List<double>> timeSlots = {
      'Morning (6-12)': [],
      'Afternoon (12-18)': [],
      'Evening (18-22)': [],
      'Night (22-6)': [],
    };

    for (final quiz in history) {
      final hour = quiz.date.hour;
      final percentage = quiz.percentage;

      if (hour >= 6 && hour < 12) {
        timeSlots['Morning (6-12)']!.add(percentage);
      } else if (hour >= 12 && hour < 18) {
        timeSlots['Afternoon (12-18)']!.add(percentage);
      } else if (hour >= 18 && hour < 22) {
        timeSlots['Evening (18-22)']!.add(percentage);
      } else {
        timeSlots['Night (22-6)']!.add(percentage);
      }
    }

    // Calculate averages
    final Map<String, double> averages = {};
    timeSlots.forEach((timeSlot, scores) {
      if (scores.isNotEmpty) {
        averages[timeSlot] = scores.reduce((a, b) => a + b) / scores.length;
      }
    });

    return averages;
  }

  // Get best and worst performing times
  Future<Map<String, String>> getBestAndWorstTimes() async {
    final timePerformance = await getPerformanceByTimeOfDay();

    if (timePerformance.isEmpty) {
      return {'best': 'N/A', 'worst': 'N/A'};
    }

    final sorted = timePerformance.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return {
      'best': sorted.first.key,
      'worst': sorted.last.key,
    };
  }

  Future<Map<DateTime, int>> getLast7DaysActivity() async {
    final now = DateTime.now();
    final sevenDaysAgo = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 7));

    final history = await getQuizHistory(startDate: sevenDaysAgo);
    final activity = <DateTime, int>{};

    // Initialize last 7 days with 0
    for (int i = 0; i < 7; i++) {
      final date =
          DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      activity[date] = 0;
    }

    for (var quiz in history) {
      final quizDate = DateTime(quiz.date.year, quiz.date.month, quiz.date.day);
      if (activity.containsKey(quizDate)) {
        activity[quizDate] = (activity[quizDate] ?? 0) + 1;
      }
    }

    return activity;
  }

  Future<Map<String, double>> getCategoryPerformance() async {
    final stats = await getStatistics();
    return stats.categoryAverages;
  }

  Future<Map<String, int>> getSpacedRepetitionStats() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {'due': 0, 'total': 0, 'mastered': 0};

    try {
      final snapshot = await FirestoreErrorHandler.executeWithRetry(
        operation: () => _firestore
            .collection('users')
            .doc(user.uid)
            .collection('spacedRepetition')
            .get(),
        operationName: 'Fetch spaced repetition stats',
      );

      if (snapshot == null) return {'due': 0, 'total': 0, 'mastered': 0};

      int due = 0;
      int mastered = 0;
      final now = DateTime.now();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final nextReview = DateTime.parse(data['nextReview']);
        final interval = data['interval'] as int;

        if (nextReview.isBefore(now)) {
          due++;
        }
        if (interval > 21) {
          mastered++;
        }
      }

      return {
        'due': due,
        'total': snapshot.docs.length,
        'mastered': mastered,
      };
    } catch (e) {
      return {'due': 0, 'total': 0, 'mastered': 0};
    }
  }

  Future<void> resetStatistics() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await FirestoreErrorHandler.executeWithRetry(
      operation: () async {
        final statsRef = _firestore.collection('users').doc(user.uid);

        // Clearing stats fields
        await statsRef.update({
          'total_quizzes': FieldValue.delete(),
          'total_all_questions': FieldValue.delete(),
          'total_correct': FieldValue.delete(),
          'category_quizzes': FieldValue.delete(),
          'category_questions': FieldValue.delete(),
          'category_correct': FieldValue.delete(),
          'difficulty_quizzes': FieldValue.delete(),
          'difficulty_questions': FieldValue.delete(),
          'difficulty_correct': FieldValue.delete(),
        });

        // Delete history subcollection (Requires manual iteration in Firestore client SDK)
        final history = await statsRef.collection('quizHistory').get();
        final batch = _firestore.batch();
        for (var doc in history.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      },
      operationName: 'Reset statistics',
    );
  }
}
