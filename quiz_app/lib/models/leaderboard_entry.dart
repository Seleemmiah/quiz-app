import 'dart:convert';

class LeaderboardEntry {
  final String playerName;
  final int score;
  final int totalQuestions;
  final DateTime date;
  final String category;
  final String difficulty;

  LeaderboardEntry({
    required this.playerName,
    required this.score,
    required this.totalQuestions,
    required this.date,
    required this.category,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'score': score,
      'totalQuestions': totalQuestions,
      'date': date.toIso8601String(),
      'category': category,
      'difficulty': difficulty,
    };
  }

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      playerName: map['playerName'] ?? 'Player',
      score: map['score']?.toInt() ?? 0,
      totalQuestions: map['totalQuestions']?.toInt() ?? 0,
      date: DateTime.parse(map['date']),
      category: map['category'] ?? 'General',
      difficulty: map['difficulty'] ?? 'Easy',
    );
  }

  String toJson() => json.encode(toMap());

  factory LeaderboardEntry.fromJson(String source) =>
      LeaderboardEntry.fromMap(json.decode(source));
}
