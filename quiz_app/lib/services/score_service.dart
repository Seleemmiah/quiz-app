import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/settings.dart';

class ScoreService {
  static const String _highScorePrefix = 'high_score_';

  // A key is generated based on difficulty and category to store unique high scores.
  String _generateKey(Difficulty difficulty, String? category) {
    final categoryPart = category ?? 'All';
    // e.g., 'high_score_easy_History' or 'high_score_medium_All'
    return '${_highScorePrefix}${difficulty.name.toLowerCase()}_$categoryPart';
  }

  Future<int> getHighScore({
    required Difficulty difficulty,
    String? category,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _generateKey(difficulty, category);
    return prefs.getInt(key) ?? 0; // Return 0 if no high score is set
  }

  Future<bool> updateHighScore({
    required Difficulty difficulty,
    String? category,
    required int score,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _generateKey(difficulty, category);
    final currentHighScore =
        await getHighScore(difficulty: difficulty, category: category);

    if (score > currentHighScore) {
      await prefs.setInt(key, score);
      return true; // Indicates a new high score was set
    }
    return false; // No new high score
  }
}
