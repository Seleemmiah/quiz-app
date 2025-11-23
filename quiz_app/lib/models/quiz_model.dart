import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/models/question_model.dart';

class Quiz {
  final String id;
  final String title;
  final String description;
  final String creatorId;
  final String creatorName;
  final DateTime createdAt;
  final List<Question> questions;
  final String difficulty;
  final String category;
  final bool isPublic;
  final String? accessCode;
  final bool isBlindMode; // No answer feedback during quiz
  final int? timeLimitMinutes; // Teacher-set time limit

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.creatorId,
    required this.creatorName,
    required this.createdAt,
    required this.questions,
    required this.difficulty,
    required this.category,
    this.isPublic = true,
    this.accessCode,
    this.isBlindMode = false,
    this.timeLimitMinutes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'createdAt': Timestamp.fromDate(createdAt),
      'questions': questions.map((q) => q.toJson()).toList(),
      'difficulty': difficulty,
      'category': category,
      'isPublic': isPublic,
      'accessCode': accessCode,
      'isBlindMode': isBlindMode,
      'timeLimitMinutes': timeLimitMinutes,
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      creatorId: json['creatorId'] ?? '',
      creatorName: json['creatorName'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
      difficulty: json['difficulty'] ?? 'Easy',
      category: json['category'] ?? 'General',
      isPublic: json['isPublic'] ?? true,
      accessCode: json['accessCode'],
      isBlindMode: json['isBlindMode'] ?? false,
      timeLimitMinutes: json['timeLimitMinutes'],
    );
  }

  // Helper to create a copy with modified fields
  Quiz copyWith({
    String? id,
    String? title,
    String? description,
    String? creatorId,
    String? creatorName,
    DateTime? createdAt,
    List<Question>? questions,
    String? difficulty,
    String? category,
    bool? isPublic,
    String? accessCode,
    bool? isBlindMode,
    int? timeLimitMinutes,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      createdAt: createdAt ?? this.createdAt,
      questions: questions ?? this.questions,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      isPublic: isPublic ?? this.isPublic,
      accessCode: accessCode ?? this.accessCode,
      isBlindMode: isBlindMode ?? this.isBlindMode,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
    );
  }
}
