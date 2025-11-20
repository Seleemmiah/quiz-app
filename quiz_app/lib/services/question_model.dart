import 'dart:math';
import 'package:html_unescape/html_unescape.dart';

final _htmlUnescape = HtmlUnescape();

class Question {
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String? explanation; // Made this nullable, as it should be
  final List<String> shuffledAnswers;

  // Private constructor
  Question._({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    this.explanation,
  }) : shuffledAnswers =
            _createShuffledAnswers(correctAnswer, incorrectAnswers);

  // This factory constructor is now 100% NULL-SAFE
  factory Question.fromLocalJson(Map<String, dynamic> json) {
    // Safely parse the incorrect answers
    final incorrect = (json['incorrect_answers'] as List?)
            ?.map((e) => _htmlUnescape.convert(e?.toString() ?? ''))
            .toList() ??
        []; // Default to empty list if null

    // Safely parse the correct answer
    final correct = _htmlUnescape
        .convert(json['correct_answer']?.toString() ?? 'No Correct Answer');

    return Question._(
      // Use '??' to provide a default value if the field is null
      category:
          _htmlUnescape.convert(json['category']?.toString() ?? 'Unknown'),
      difficulty:
          _htmlUnescape.convert(json['difficulty']?.toString() ?? 'easy'),
      question: _htmlUnescape
          .convert(json['question']?.toString() ?? 'No Question Text'),
      correctAnswer: correct,
      incorrectAnswers: incorrect,

      // Explanation is nullable, so this is safe.
      explanation: json['explanation'] != null
          ? _htmlUnescape.convert(json['explanation'].toString())
          : null,
    );
  }

  // Helper method to create the shuffled list (this was already fine)
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
