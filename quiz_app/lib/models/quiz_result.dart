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
  final bool isExam;

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
    this.isExam = false,
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
      'isExam': isExam,
    };
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    DateTime dateValue;
    if (json['date'] != null) {
      dateValue = (json['date'] as Timestamp).toDate();
    } else if (json['completedAt'] != null) {
      dateValue = (json['completedAt'] as Timestamp).toDate();
    } else {
      dateValue = DateTime.now();
    }

    return QuizResult(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      category: json['category'] ?? 'General',
      difficulty: json['difficulty'] ?? 'Medium',
      timeTakenSeconds: json['timeTakenSeconds'] ?? 0,
      date: dateValue,
      quizId: json['quizId'],
      isExam: json['isExam'] ?? false,
    );
  }
}
