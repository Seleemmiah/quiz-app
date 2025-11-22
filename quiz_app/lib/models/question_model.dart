import 'dart:math';
import 'package:html_unescape/html_unescape.dart';

final _htmlUnescape = HtmlUnescape();

enum QuestionType {
  multipleChoice,
  trueFalse,
  // multiSelect, // Future enhancement
}

class Question {
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  String? explanation;
  final List<String> shuffledAnswers;
  final QuestionType questionType;

  Question._({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.questionType,
    this.explanation,
  }) : shuffledAnswers = _createShuffledAnswers(
            correctAnswer, incorrectAnswers, questionType);

  factory Question.fromLocalJson(Map<String, dynamic> json) {
    // Combine correct and incorrect answers into one list
    final rawIncorrect = json['incorrectAnswers'] ?? json['incorrect_answers'];
    final List<String> incorrect = (rawIncorrect as List)
        .map<String>((e) => _htmlUnescape.convert(e.toString()))
        .toList();

    final correct = _htmlUnescape.convert(
        json['correctAnswer']?.toString() ?? json['correct_answer'].toString());

    // Determine question type
    final typeStr = json['type']?.toString().toLowerCase() ?? 'multiple';
    QuestionType questionType;
    if (typeStr == 'boolean') {
      questionType = QuestionType.trueFalse;
    } else {
      questionType = QuestionType.multipleChoice;
    }

    return Question._(
      category: _htmlUnescape.convert(json['category'].toString()),
      difficulty: _htmlUnescape.convert(json['difficulty'].toString()),
      question: _htmlUnescape.convert(json['question'].toString()),
      correctAnswer: correct,
      incorrectAnswers: incorrect,
      questionType: questionType,
      explanation: json['explanation'] != null
          ? _htmlUnescape.convert(json['explanation'].toString())
          : null,
    );
  }

  // Helper method to create the shuffled list
  static List<String> _createShuffledAnswers(
    String correctAnswer,
    List<String> incorrectAnswers,
    QuestionType questionType,
  ) {
    // For True/False, don't shuffle - keep True/False order
    if (questionType == QuestionType.trueFalse) {
      return ['True', 'False'];
    }

    // For multiple choice, shuffle as before
    final allAnswers = [correctAnswer, ...incorrectAnswers];
    allAnswers.shuffle(Random());
    return allAnswers;
  }

  // Helper to check if this is a True/False question
  bool get isTrueFalse => questionType == QuestionType.trueFalse;

  // Serialization methods for saving/loading quiz state
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'difficulty': difficulty,
      'question': question,
      'correctAnswer': correctAnswer,
      'incorrectAnswers': incorrectAnswers,
      'explanation': explanation,
      'questionType':
          questionType == QuestionType.trueFalse ? 'boolean' : 'multiple',
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question.fromLocalJson(json);
  }
}
