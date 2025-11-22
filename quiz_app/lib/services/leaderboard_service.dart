import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/models/leaderboard_entry.dart';
import 'package:quiz_app/settings.dart';

class LeaderboardService {
  static const String _leaderboardPrefix = 'leaderboard_';

  String _generateKey(Difficulty difficulty, String? category) {
    final categoryPart = category ?? 'All';
    return '$_leaderboardPrefix${difficulty.name.toLowerCase()}_$categoryPart';
  }

  Future<List<LeaderboardEntry>> getScores(
      Difficulty difficulty, String? category) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _generateKey(difficulty, category);
    final List<String> jsonList = prefs.getStringList(key) ?? [];

    return jsonList
        .map((jsonStr) => LeaderboardEntry.fromJson(jsonStr))
        .toList();
  }

  Future<void> addScore(LeaderboardEntry entry) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert difficulty string to enum for key generation
    Difficulty difficultyEnum = Difficulty.values.firstWhere(
      (d) => d.name.toLowerCase() == entry.difficulty.toLowerCase(),
      orElse: () => Difficulty.easy,
    );

    final key = _generateKey(difficultyEnum, entry.category);
    final List<String> jsonList = prefs.getStringList(key) ?? [];

    final List<LeaderboardEntry> entries =
        jsonList.map((jsonStr) => LeaderboardEntry.fromJson(jsonStr)).toList();

    entries.add(entry);

    // Sort by score (descending), then by date (newest first)
    entries.sort((a, b) {
      int scoreComp = b.score.compareTo(a.score);
      if (scoreComp != 0) return scoreComp;
      return b.date.compareTo(a.date);
    });

    // Keep top 10
    if (entries.length > 10) {
      entries.removeRange(10, entries.length);
    }

    final List<String> updatedJsonList =
        entries.map((e) => e.toJson()).toList();

    await prefs.setStringList(key, updatedJsonList);
  }

  Future<void> clearLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith(_leaderboardPrefix)) {
        await prefs.remove(key);
      }
    }
  }
}
