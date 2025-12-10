import 'package:cloud_firestore/cloud_firestore.dart';

class QuizResult {
  final String id;
  final String userId;
  final int score;
  final int totalQuestions;
  final String category;
  final String difficulty;
  final int timeTakenSeconds;
  final DateTime date;
  final String? quizId; // Optional, for custom quizzes

  QuizResult({
    required this.id,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.category,
    required this.difficulty,
    required this.timeTakenSeconds,
    required this.date,
    this.quizId,
  });

  double get percentage =>
      totalQuestions > 0 ? (score / totalQuestions) * 100 : 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'score': score,
      'totalQuestions': totalQuestions,
      'category': category,
      'difficulty': difficulty,
      'timeTakenSeconds': timeTakenSeconds,
      'date': Timestamp.fromDate(date),
      'quizId': quizId,
    };
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      category: json['category'] ?? 'General',
      difficulty: json['difficulty'] ?? 'Medium',
      timeTakenSeconds: json['timeTakenSeconds'] ?? 0,
      date: (json['date'] as Timestamp).toDate(),
      quizId: json['quizId'],
    );
  }
}
