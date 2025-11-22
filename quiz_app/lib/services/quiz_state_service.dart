import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/settings.dart';

class QuizStateService {
  static const String _quizStateKey = 'saved_quiz_state';

  Future<void> saveQuizState({
    required List<Question> questions,
    required List<String?> selectedAnswers,
    required int currentIndex,
    required int remainingTime,
    required Difficulty difficulty,
    required String? category,
    required int lives,
    required int streak,
    required DateTime startTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final state = {
      'questions': questions.map((q) => q.toJson()).toList(),
      'selectedAnswers': selectedAnswers,
      'currentIndex': currentIndex,
      'remainingTime': remainingTime,
      'difficulty': difficulty.name,
      'category': category,
      'lives': lives,
      'streak': streak,
      'startTime': startTime.toIso8601String(),
    };

    await prefs.setString(_quizStateKey, jsonEncode(state));
  }

  Future<Map<String, dynamic>?> loadQuizState() async {
    final prefs = await SharedPreferences.getInstance();
    final stateJson = prefs.getString(_quizStateKey);

    if (stateJson == null) return null;

    try {
      final state = jsonDecode(stateJson) as Map<String, dynamic>;

      // Convert questions back from JSON
      final questionsJson = state['questions'] as List;
      final questions = questionsJson
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList();

      return {
        'questions': questions,
        'selectedAnswers': List<String?>.from(state['selectedAnswers'] as List),
        'currentIndex': state['currentIndex'] as int,
        'remainingTime': state['remainingTime'] as int,
        'difficulty': Difficulty.values.firstWhere(
          (d) => d.name == state['difficulty'],
          orElse: () => Difficulty.easy,
        ),
        'category': state['category'] as String?,
        'lives': state['lives'] as int,
        'streak': state['streak'] as int,
        'startTime': DateTime.parse(state['startTime'] as String),
      };
    } catch (e) {
      return null;
    }
  }

  Future<void> clearQuizState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_quizStateKey);
  }

  Future<bool> hasSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_quizStateKey);
  }
}
