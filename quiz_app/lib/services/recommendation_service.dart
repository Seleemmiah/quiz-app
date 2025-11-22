import 'package:quiz_app/services/statistics_service.dart';
import 'package:quiz_app/settings.dart';

class Recommendation {
  final String title;
  final String description;
  final String? category;
  final Difficulty? difficulty;
  final String icon;

  Recommendation({
    required this.title,
    required this.description,
    this.category,
    this.difficulty,
    required this.icon,
  });
}

class RecommendationService {
  final StatisticsService _statisticsService = StatisticsService();

  Future<List<Recommendation>> getRecommendations() async {
    final recommendations = <Recommendation>[];
    final stats = await _statisticsService.getStatistics();

    // No quizzes yet - recommend starting
    if (stats.totalQuizzes == 0) {
      recommendations.add(Recommendation(
        title: 'Start Your First Quiz!',
        description: 'Begin your learning journey with an easy quiz',
        difficulty: Difficulty.easy,
        icon: '🎯',
      ));
      return recommendations;
    }

    // Check average score and recommend difficulty
    if (stats.averageScore >= 85) {
      recommendations.add(Recommendation(
        title: 'Challenge Yourself!',
        description: 'You\'re doing great! Try a harder difficulty',
        difficulty: Difficulty.hard,
        icon: '🔥',
      ));
    } else if (stats.averageScore < 60) {
      recommendations.add(Recommendation(
        title: 'Build Confidence',
        description: 'Practice with easier questions to improve',
        difficulty: Difficulty.easy,
        icon: '💪',
      ));
    }

    // Find weakest category
    if (stats.categoryAverages.isNotEmpty) {
      final weakestCategory = stats.categoryAverages.entries
          .reduce((a, b) => a.value < b.value ? a : b);

      recommendations.add(Recommendation(
        title: 'Improve in ${weakestCategory.key}',
        description:
            'Your score: ${weakestCategory.value.toStringAsFixed(1)}% - Practice to improve!',
        category: weakestCategory.key,
        icon: '📚',
      ));

      // Find strongest category
      final strongestCategory = stats.categoryAverages.entries
          .reduce((a, b) => a.value > b.value ? a : b);

      if (strongestCategory.key != weakestCategory.key) {
        recommendations.add(Recommendation(
          title: 'Master ${strongestCategory.key}',
          description:
              'You\'re strong here (${strongestCategory.value.toStringAsFixed(1)}%)! Go for a perfect score',
          category: strongestCategory.key,
          difficulty: Difficulty.hard,
          icon: '⭐',
        ));
      }
    }

    // Time-based recommendation
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      recommendations.add(Recommendation(
        title: 'Morning Brain Boost',
        description: 'Start your day with a quick quiz',
        icon: '☀️',
      ));
    } else if (hour >= 18 && hour < 22) {
      recommendations.add(Recommendation(
        title: 'Evening Challenge',
        description: 'Wind down with an evening quiz',
        icon: '🌙',
      ));
    }

    return recommendations;
  }

  MapEntry<String, Map<String, dynamic>>? _findWeakestCategory(
      Map<String, Map<String, dynamic>> categoryStats) {
    if (categoryStats.isEmpty) return null;

    return categoryStats.entries.reduce((a, b) {
      final aScore = a.value['averageScore'] as double? ?? 0;
      final bScore = b.value['averageScore'] as double? ?? 0;
      return aScore < bScore ? a : b;
    });
  }

  MapEntry<String, Map<String, dynamic>>? _findStrongestCategory(
      Map<String, Map<String, dynamic>> categoryStats) {
    if (categoryStats.isEmpty) return null;

    return categoryStats.entries.reduce((a, b) {
      final aScore = a.value['averageScore'] as double? ?? 0;
      final bScore = b.value['averageScore'] as double? ?? 0;
      return aScore > bScore ? a : b;
    });
  }
}
