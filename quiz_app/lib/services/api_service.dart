// import 'dart:math';
import 'dart:math';

import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/screens/local_questions.dart';
import 'package:quiz_app/settings.dart';

class ApiService {
  // This function extracts all unique categories from the local data.
  Future<List<String>> fetchCategories() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      final categories =
          localQuestions.map((q) => q['category'] as String).toSet().toList();
      categories.sort();
      return ['All', ...categories]; // Add 'All' to allow for any category
    } catch (e) {
      // Re-throw the original exception to preserve stack trace and error type
      throw Exception('Failed to load categories: ${e.toString()}');
    }
  }

  Future<List<Question>> fetchQuestions(
      {int amount = 30,
      String? category, // Category is now directly used for filtering
      Difficulty difficulty = Difficulty.easy}) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      // Filter questions by the selected difficulty
      final filteredQuestions = localQuestions
          .where((q) => q['difficulty'] == difficulty.name.toLowerCase())
          .toList();

      final List<Map<String, dynamic>> shuffledQuestions = [
        ...filteredQuestions
      ];

      // If a category is chosen (and it's not 'All'), filter by it
      if (category != null && category != 'All') {
        shuffledQuestions.retainWhere((q) => q['category'] == category);
      }

      shuffledQuestions.shuffle(Random());
      // Convert the raw local data into our clean Question objects
      // Now correctly using fromLocalJson
      return shuffledQuestions
          .take(amount) // Take up to the specified amount of questions
          .map((json) => Question.fromLocalJson(json))
          .toList();
    } catch (e) {
      // In case of any errors during model conversion
      throw Exception(
          'Failed to load questions from local data: ${e.toString()}');
    }
  }
}
