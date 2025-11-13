import 'dart:math';
import 'package:html_unescape/html_unescape.dart';

final _htmlUnescape = HtmlUnescape();

class Question {
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String? explanation;
  final List<String> shuffledAnswers;

  Question._({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    this.explanation,
  }) : shuffledAnswers =
            _createShuffledAnswers(correctAnswer, incorrectAnswers);

  factory Question.fromApiJson(Map<String, dynamic> json) {
    // Combine correct and incorrect answers into one list
    final incorrect = (json['incorrect_answers'] as List)
        .map((e) => _htmlUnescape.convert(e.toString()))
        .toList();

    final correct = _htmlUnescape.convert(json['correct_answer'].toString());

    return Question._(
      category: _htmlUnescape.convert(json['category'].toString()),
      difficulty: _htmlUnescape.convert(json['difficulty'].toString()),
      question: _htmlUnescape.convert(json['question'].toString()),
      correctAnswer: correct,
      incorrectAnswers: incorrect,
      explanation: json['explanation'] as String?,
    );
  }

  // Helper method to create the shuffled list
  static List<String> _createShuffledAnswers(
    String correctAnswer,
    List<String> incorrectAnswers,
  ) {
    // Create a new list combining all answers
    final allAnswers = [correctAnswer, ...incorrectAnswers];
    // Shuffle it randomly
    allAnswers.shuffle(Random());
    return allAnswers;
  }
}
