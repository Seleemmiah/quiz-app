import 'dart:math';
import 'package:quiz_app/models/question_model.dart';
import '../screens/local_questions.dart';

class ApiService {
  // This is the function we'll call to get the questions
  // It returns a "Future", meaning the data will come back later.
  Future<List<Question>> fetchQuestions() async {
    try {
      // Simulate a network delay to make it feel like a real API call
      await Future.delayed(const Duration(seconds: 1));

      final List<Map<String, dynamic>> shuffledQuestions = [...localQuestions];
      shuffledQuestions.shuffle(Random());
      // Convert the raw local data into our clean Question objects
      return shuffledQuestions
          .sublist(0, 10)
          .map((json) => Question.fromApiJson(json))
          .toList();
    } catch (e) {
      // In case of any errors during model conversion
      throw Exception(
          'Failed to load questions from local data: ${e.toString()}');
    }
  }
}
