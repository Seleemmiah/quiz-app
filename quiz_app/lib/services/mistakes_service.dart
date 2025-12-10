import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/models/question_model.dart';

class MistakesService {
  static const String _mistakesKey = 'mistakes_bank';

  Future<void> addMistake(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> mistakes = prefs.getStringList(_mistakesKey) ?? [];

    // Create a unique map for the question
    final questionMap = {
      'category': question.category,
      'type': question.questionType == QuestionType.multipleChoice
          ? 'multiple'
          : 'boolean',
      'difficulty': question.difficulty,
      'question': question.question,
      'correct_answer': question.correctAnswer,
      'incorrect_answers': question.incorrectAnswers,
      'explanation': question.explanation,
      'imageUrl': question.imageUrl,
    };

    final jsonString = jsonEncode(questionMap);

    // Avoid duplicates
    if (!mistakes.contains(jsonString)) {
      mistakes.add(jsonString);
      await prefs.setStringList(_mistakesKey, mistakes);
    }
  }

  Future<List<Question>> getMistakes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> mistakes = prefs.getStringList(_mistakesKey) ?? [];

    return mistakes.map((jsonString) {
      final map = jsonDecode(jsonString);
      return Question.fromMap(map);
    }).toList();
  }

  Future<void> removeMistake(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> mistakes = prefs.getStringList(_mistakesKey) ?? [];

    // Reconstruct the JSON to find it
    final questionMap = {
      'category': question.category,
      'type': question.questionType == QuestionType.multipleChoice
          ? 'multiple'
          : 'boolean',
      'difficulty': question.difficulty,
      'question': question.question,
      'correct_answer': question.correctAnswer,
      'incorrect_answers': question.incorrectAnswers,
      'explanation': question.explanation,
      'imageUrl': question.imageUrl,
    };
    final jsonString = jsonEncode(questionMap);

    mistakes.remove(jsonString);
    await prefs.setStringList(_mistakesKey, mistakes);
  }

  Future<void> clearMistakes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mistakesKey);
  }

  Future<int> getMistakeCount() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> mistakes = prefs.getStringList(_mistakesKey) ?? [];
    return mistakes.length;
  }
}
