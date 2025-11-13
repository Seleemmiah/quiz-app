import 'dart:math';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/screens/local_questions.dart';
import 'package:quiz_app/settings.dart';



class ApiService {
  // This is the function we'll call to get the questions
  // It returns a "Future", meaning the data will come back later.
  Future<List<Question>> fetchQuestions(
      {Difficulty difficulty = Difficulty.easy}) async {
    try {
      // Simulate a network delay to make it feel like a real API call
      await Future.delayed(const Duration(seconds: 1));

      // Filter questions by the selected difficulty
      final filteredQuestions = localQuestions
          .where((q) => q['difficulty'] == difficulty.name.toLowerCase())
          .toList();

      final List<Map<String, dynamic>> shuffledQuestions = [
        ...filteredQuestions
      ];
      shuffledQuestions.shuffle(Random());
      // Convert the raw local data into our clean Question objects
      return shuffledQuestions
          .take(10) // Take up to 10 questions
          .map((json) => Question.fromApiJson(json))
          .toList();
    } catch (e) {
      // In case of any errors during model conversion
      throw Exception(
          'Failed to load questions from local data: ${e.toString()}');
    }
  }
}
