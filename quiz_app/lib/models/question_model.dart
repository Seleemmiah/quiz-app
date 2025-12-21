import 'dart:math';
import 'package:html_unescape/html_unescape.dart';

final _htmlUnescape = HtmlUnescape();

enum QuestionType {
  multipleChoice,
  trueFalse,
  // multiSelect, // Future enhancement
}

class Question {
  final String id;
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  String? explanation;
  final String? imageUrl; // New field for image support
  final String? videoUrl; // New field for video explanations
  final List<String> shuffledAnswers;
  final QuestionType questionType;

  Question._({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.questionType,
    this.explanation,
    this.imageUrl,
    this.videoUrl,
  }) : shuffledAnswers = _createShuffledAnswers(
            correctAnswer, incorrectAnswers, questionType);

  factory Question.fromMap(Map<String, dynamic> map) =>
      Question.fromLocalJson(map);

  factory Question.fromLocalJson(Map<String, dynamic> json) {
    // Combine correct and incorrect answers into one list
    final rawIncorrect = json['incorrectAnswers'] ?? json['incorrect_answers'];
    final List<String> incorrect =
        (rawIncorrect as List).map<String>((e) => e.toString()).toList();

    final correct =
        json['correctAnswer']?.toString() ?? json['correct_answer'].toString();

    // Determine question type
    final typeStr = json['type']?.toString().toLowerCase() ?? 'multiple';
    QuestionType questionType;
    if (typeStr == 'boolean') {
      questionType = QuestionType.trueFalse;
    } else {
      questionType = QuestionType.multipleChoice;
    }

    return Question._(
      id: json['id']?.toString() ?? '',
      category: _htmlUnescape.convert(json['category'].toString()),
      difficulty: json['difficulty'].toString(),
      question: _htmlUnescape.convert(json['question'].toString()),
      correctAnswer: correct,
      incorrectAnswers: incorrect,
      questionType: questionType,
      explanation: json['explanation'] != null
          ? _htmlUnescape.convert(json['explanation'].toString())
          : null,
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
    );
  }

  // Helper method to create the shuffled list
  static List<String> _createShuffledAnswers(
    String correctAnswer,
    List<String> incorrectAnswers,
    QuestionType questionType,
  ) {
    final allAnswers = [correctAnswer, ...incorrectAnswers]
        .map((answer) => _htmlUnescape.convert(answer))
        .toList();

    // For True/False, don't shuffle - keep True/False order
    if (questionType == QuestionType.trueFalse) {
      return ['True', 'False'];
    }
    allAnswers.shuffle(Random());
    return allAnswers;
  }

  // Helper to check if this is a True/False question
  bool get isTrueFalse => questionType == QuestionType.trueFalse;

  // Serialization methods for saving/loading quiz state
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'difficulty': difficulty,
      'question': question,
      'correctAnswer': correctAnswer,
      'incorrectAnswers': incorrectAnswers,
      'explanation': explanation,
      'imageUrl': imageUrl,
      'questionType':
          questionType == QuestionType.trueFalse ? 'boolean' : 'multiple',
    };
  }

  // Helper to check if question contains LaTeX
  bool get isLatex {
    return question.contains(r'$') ||
        question.contains(r'\(') ||
        question.contains(r'\[');
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question.fromLocalJson(json);
  }
}
