import 'dart:math';

import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/screens/local_questions.dart';
import 'package:quiz_app/screens/additional_questions.dart';
import 'package:quiz_app/screens/generated_questions.dart';
import 'package:quiz_app/screens/questions/batch_1_questions.dart';
import 'package:quiz_app/screens/questions/batch_2_questions.dart';
import 'package:quiz_app/screens/questions/batch_3_questions.dart';
import 'package:quiz_app/screens/questions/batch_4_questions.dart';
import 'package:quiz_app/screens/questions/image_questions.dart';
import 'package:quiz_app/screens/questions/organic_chemistry_questions.dart';
import 'package:quiz_app/screens/questions/circuit_questions.dart';
import 'package:quiz_app/settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // This function extracts all unique categories from the local data.
  Future<List<String>> fetchCategories() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      // Combine local, additional, and generated questions
      final allQuestions = [
        ...localQuestions,
        ...additionalQuestions,
        ...generatedQuestions,
        ...batch1Questions,
        ...batch2Questions,
        ...batch3Questions,
        ...batch4Questions,
        ...imageQuestions,
        ...organicQuestions,
        ...circuitQuestions,
      ];
      final categories =
          allQuestions.map((q) => q['category'] as String).toSet().toList();
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

      // Check connectivity status
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOnline = connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet);

      // Filter questions by the selected difficulty
      // Combine local, additional, and generated questions
      var allQuestions = [
        ...localQuestions,
        ...additionalQuestions,
        ...generatedQuestions,
        ...batch1Questions,
        ...batch2Questions,
        ...batch3Questions,
        ...batch4Questions,
        ...imageQuestions,
        ...organicQuestions,
        ...circuitQuestions,
      ];

      // Filter out image questions if offline
      if (!isOnline) {
        allQuestions = allQuestions
            .where((q) => q['imageUrl'] == null || q['imageUrl'] == '')
            .toList();
        debugPrint(
            '📵 Offline mode: Filtered out ${imageQuestions.length} image-based questions');
      }

      // Filter questions by the selected difficulty
      final filteredQuestions = allQuestions
          .where((q) => q['difficulty'] == difficulty.name.toLowerCase())
          .toList();

      List<Map<String, dynamic>> shuffledQuestions = [...filteredQuestions];

      // If a category is chosen (and it's not 'All'), filter by it
      if (category != null && category != 'All') {
        shuffledQuestions.retainWhere((q) => q['category'] == category);
      }

      shuffledQuestions.shuffle(Random());

      // Take up to the specified amount of questions
      final questionsToReturn = shuffledQuestions.take(amount).toList();

      // Log if we don't have enough questions
      if (questionsToReturn.length < amount) {
        print(
            '⚠️ Only ${questionsToReturn.length} questions available for "$category" at $difficulty difficulty (requested $amount)');
      }

      // Convert the raw local data into our clean Question objects
      return questionsToReturn
          .map((json) => Question.fromLocalJson(json))
          .toList();
    } catch (e) {
      // In case of any errors during model conversion
      throw Exception(
          'Failed to load questions from local data: ${e.toString()}');
    }
  }
}
