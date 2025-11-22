import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/settings.dart';

class CustomQuestion {
  final String id;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String category;
  final Difficulty difficulty;
  final DateTime createdAt;

  CustomQuestion({
    required this.id,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.category,
    required this.difficulty,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'correctAnswer': correctAnswer,
      'incorrectAnswers': incorrectAnswers,
      'category': category,
      'difficulty': difficulty.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CustomQuestion.fromJson(Map<String, dynamic> json) {
    return CustomQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      correctAnswer: json['correctAnswer'] as String,
      incorrectAnswers: List<String>.from(json['incorrectAnswers'] as List),
      category: json['category'] as String,
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == json['difficulty'],
        orElse: () => Difficulty.easy,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Convert to Question model for quiz gameplay
  Question toQuestion() {
    return Question.fromLocalJson({
      'question': question,
      'correct_answer': correctAnswer,
      'incorrect_answers': incorrectAnswers,
      'category': category,
      'difficulty': difficulty.name,
      'type': 'multiple',
    });
  }
}

class CustomQuizService {
  static const String _customQuestionsKey = 'custom_questions';

  Future<void> addQuestion(CustomQuestion question) async {
    final prefs = await SharedPreferences.getInstance();
    final questions = await getQuestions();
    questions.add(question);

    final questionsJson = questions.map((q) => q.toJson()).toList();
    await prefs.setString(_customQuestionsKey, jsonEncode(questionsJson));
  }

  Future<List<CustomQuestion>> getQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final questionsJson = prefs.getString(_customQuestionsKey);

    if (questionsJson == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(questionsJson);
      return decoded
          .map((json) => CustomQuestion.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteQuestion(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final questions = await getQuestions();
    questions.removeWhere((q) => q.id == id);

    final questionsJson = questions.map((q) => q.toJson()).toList();
    await prefs.setString(_customQuestionsKey, jsonEncode(questionsJson));
  }

  Future<void> updateQuestion(CustomQuestion question) async {
    final prefs = await SharedPreferences.getInstance();
    final questions = await getQuestions();
    final index = questions.indexWhere((q) => q.id == question.id);

    if (index != -1) {
      questions[index] = question;
      final questionsJson = questions.map((q) => q.toJson()).toList();
      await prefs.setString(_customQuestionsKey, jsonEncode(questionsJson));
    }
  }

  Future<List<Question>> getQuestionsForQuiz({
    int amount = 10,
    Difficulty? difficulty,
    String? category,
  }) async {
    var questions = await getQuestions();

    // Filter by difficulty
    if (difficulty != null) {
      questions = questions.where((q) => q.difficulty == difficulty).toList();
    }

    // Filter by category
    if (category != null && category != 'All') {
      questions = questions.where((q) => q.category == category).toList();
    }

    // Shuffle and take amount
    questions.shuffle();
    return questions.take(amount).map((q) => q.toQuestion()).toList();
  }

  Future<List<String>> getCustomCategories() async {
    final questions = await getQuestions();
    final categories = questions.map((q) => q.category).toSet().toList();
    categories.sort();
    return categories;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_customQuestionsKey);
  }
}
