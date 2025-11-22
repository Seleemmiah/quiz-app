import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/settings.dart';
import 'dart:convert';

class QuizHistory {
  final DateTime date;
  final int score;
  final int totalQuestions;
  final Difficulty difficulty;
  final String? category;

  QuizHistory({
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

  factory QuizHistory.fromJson(Map<String, dynamic> json) {
    return QuizHistory(
      date: DateTime.parse(json['date']),
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      difficulty:
          Difficulty.values.firstWhere((d) => d.name == json['difficulty']),
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
  });
}

class StatisticsService {
  static const String _totalQuizzesKey = 'total_quizzes';
  static const String _totalQuestionsKey = 'total_questions';
  static const String _totalCorrectKey = 'total_correct';
  static const String _categoryQuizzesPrefix = 'category_quizzes_';
  static const String _categoryCorrectPrefix = 'category_correct_';
  static const String _categoryQuestionsPrefix = 'category_questions_';
  static const String _difficultyQuizzesPrefix = 'difficulty_quizzes_';
  static const String _difficultyCorrectPrefix = 'difficulty_correct_';
  static const String _difficultyQuestionsPrefix = 'difficulty_questions_';
  static const String _quizHistoryKey = 'quiz_history';

  Future<void> recordQuizCompletion({
    required int score,
    required int totalQuestions,
    required Difficulty difficulty,
    String? category,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Save to quiz history
    final history = QuizHistory(
      date: DateTime.now(),
      score: score,
      totalQuestions: totalQuestions,
      difficulty: difficulty,
      category: category,
    );
    await _saveQuizHistory(history);

    // Update global stats
    final totalQuizzes = (prefs.getInt(_totalQuizzesKey) ?? 0) + 1;
    final globalQuestions =
        (prefs.getInt(_totalQuestionsKey) ?? 0) + totalQuestions;
    final globalCorrect = (prefs.getInt(_totalCorrectKey) ?? 0) + score;

    await prefs.setInt(_totalQuizzesKey, totalQuizzes);
    await prefs.setInt(_totalQuestionsKey, globalQuestions);
    await prefs.setInt(_totalCorrectKey, globalCorrect);

    // Update category stats
    if (category != null) {
      final categoryKey = _categoryQuizzesPrefix + category;
      final categoryQuestionsKey = _categoryQuestionsPrefix + category;
      final categoryCorrectKey = _categoryCorrectPrefix + category;

      final categoryQuizzes = (prefs.getInt(categoryKey) ?? 0) + 1;
      final categoryQuestions =
          (prefs.getInt(categoryQuestionsKey) ?? 0) + totalQuestions;
      final categoryCorrect = (prefs.getInt(categoryCorrectKey) ?? 0) + score;

      await prefs.setInt(categoryKey, categoryQuizzes);
      await prefs.setInt(categoryQuestionsKey, categoryQuestions);
      await prefs.setInt(categoryCorrectKey, categoryCorrect);
    }

    // Update difficulty stats
    final difficultyKey = _difficultyQuizzesPrefix + difficulty.name;
    final difficultyQuestionsKey = _difficultyQuestionsPrefix + difficulty.name;
    final difficultyCorrectKey = _difficultyCorrectPrefix + difficulty.name;

    final difficultyQuizzes = (prefs.getInt(difficultyKey) ?? 0) + 1;
    final difficultyQuestions =
        (prefs.getInt(difficultyQuestionsKey) ?? 0) + totalQuestions;
    final difficultyCorrect = (prefs.getInt(difficultyCorrectKey) ?? 0) + score;

    await prefs.setInt(difficultyKey, difficultyQuizzes);
    await prefs.setInt(difficultyQuestionsKey, difficultyQuestions);
    await prefs.setInt(difficultyCorrectKey, difficultyCorrect);
  }

  Future<QuizStatistics> getStatistics() async {
    final prefs = await SharedPreferences.getInstance();

    final totalQuizzes = prefs.getInt(_totalQuizzesKey) ?? 0;
    final totalQuestions = prefs.getInt(_totalQuestionsKey) ?? 0;
    final totalCorrect = prefs.getInt(_totalCorrectKey) ?? 0;

    final averageScore =
        totalQuestions > 0 ? (totalCorrect / totalQuestions) * 100 : 0.0;

    // Get all category stats
    final categoryQuizzes = <String, int>{};
    final categoryAverages = <String, double>{};
    String? bestCategory;
    double bestCategoryAverage = 0.0;

    final allKeys = prefs.getKeys();
    for (final key in allKeys) {
      if (key.startsWith(_categoryQuizzesPrefix)) {
        final category = key.substring(_categoryQuizzesPrefix.length);
        final quizzes = prefs.getInt(key) ?? 0;
        final questions =
            prefs.getInt(_categoryQuestionsPrefix + category) ?? 0;
        final correct = prefs.getInt(_categoryCorrectPrefix + category) ?? 0;

        categoryQuizzes[category] = quizzes;
        if (questions > 0) {
          final average = (correct / questions) * 100;
          categoryAverages[category] = average;
          if (average > bestCategoryAverage) {
            bestCategoryAverage = average;
            bestCategory = category;
          }
        }
      }
    }

    // Get all difficulty stats
    final difficultyQuizzes = <Difficulty, int>{};
    final difficultyAverages = <Difficulty, double>{};
    Difficulty? bestDifficulty;
    double bestDifficultyAverage = 0.0;

    for (final difficulty in Difficulty.values) {
      final quizzes =
          prefs.getInt(_difficultyQuizzesPrefix + difficulty.name) ?? 0;
      final questions =
          prefs.getInt(_difficultyQuestionsPrefix + difficulty.name) ?? 0;
      final correct =
          prefs.getInt(_difficultyCorrectPrefix + difficulty.name) ?? 0;

      difficultyQuizzes[difficulty] = quizzes;
      if (questions > 0) {
        final average = (correct / questions) * 100;
        difficultyAverages[difficulty] = average;
        if (average > bestDifficultyAverage) {
          bestDifficultyAverage = average;
          bestDifficulty = difficulty;
        }
      }
    }

    return QuizStatistics(
      totalQuizzes: totalQuizzes,
      averageScore: averageScore,
      totalQuestions: totalQuestions,
      totalCorrect: totalCorrect,
      categoryQuizzes: categoryQuizzes,
      categoryAverages: categoryAverages,
      difficultyQuizzes: difficultyQuizzes,
      difficultyAverages: difficultyAverages,
      bestCategory: bestCategory,
      bestDifficulty: bestDifficulty,
    );
  }

  // Quiz History Methods
  Future<void> _saveQuizHistory(QuizHistory history) async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = await getQuizHistory();
    historyList.add(history);

    // Keep only last 100 quizzes to avoid excessive storage
    if (historyList.length > 100) {
      historyList.removeRange(0, historyList.length - 100);
    }

    final jsonList = historyList.map((h) => h.toJson()).toList();
    await prefs.setString(_quizHistoryKey, jsonEncode(jsonList));
  }

  Future<List<QuizHistory>> getQuizHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_quizHistoryKey);

    if (historyJson == null) return [];

    final List<dynamic> jsonList = jsonDecode(historyJson);
    List<QuizHistory> history =
        jsonList.map((json) => QuizHistory.fromJson(json)).toList();

    // Filter by date range if provided
    if (startDate != null) {
      history = history
          .where((h) =>
              h.date.isAfter(startDate) || h.date.isAtSameMomentAs(startDate))
          .toList();
    }
    if (endDate != null) {
      history = history
          .where((h) =>
              h.date.isBefore(endDate) || h.date.isAtSameMomentAs(endDate))
          .toList();
    }

    return history;
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

  Future<void> resetStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    for (final key in allKeys) {
      if (key.startsWith(_totalQuizzesKey) ||
          key.startsWith(_totalQuestionsKey) ||
          key.startsWith(_totalCorrectKey) ||
          key.startsWith(_categoryQuizzesPrefix) ||
          key.startsWith(_categoryCorrectPrefix) ||
          key.startsWith(_categoryQuestionsPrefix) ||
          key.startsWith(_difficultyQuizzesPrefix) ||
          key.startsWith(_difficultyCorrectPrefix) ||
          key.startsWith(_difficultyQuestionsPrefix) ||
          key == _quizHistoryKey) {
        await prefs.remove(key);
      }
    }
  }
}
