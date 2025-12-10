import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:quiz_app/models/question_model.dart';

class AIService {
  // TODO: Move this to a secure storage or environment variable in production
  static const String _apiKey = 'AIzaSyDAqx8gzlIKNU0-WGwuo4XVG45T1GrTQLE';
  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: _apiKey,
    );
  }

  Future<List<Question>> generateQuizFromText(String text,
      {int numQuestions = 10, String difficulty = 'medium'}) async {
    if (text.trim().isEmpty) {
      throw Exception('Text is empty');
    }

    final prompt = '''
    You are a university professor creating an exam. 
    Generate $numQuestions multiple-choice questions based on the text provided below.
    The difficulty level should be $difficulty.
    
    Return the response strictly as a JSON list of objects. 
    Each object must have the following fields:
    - "question": The question text.
    - "correct_answer": The correct answer text.
    - "incorrect_answers": A list of 3 incorrect answer texts.
    - "difficulty": "$difficulty"
    - "category": "Generated"

    Do not include any markdown formatting (like ```json). Just the raw JSON string.
    
    Text:
    $text
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        throw Exception('No response from AI');
      }

      // Clean up the response if it contains markdown code blocks
      String jsonString = response.text!;
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7);
      }
      if (jsonString.startsWith('```')) {
        jsonString = jsonString.substring(3);
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(0, jsonString.length - 3);
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);

      return jsonList.map((json) {
        // Ensure incorrect_answers is a list of strings
        final incorrect = (json['incorrect_answers'] as List)
            .map((e) => e.toString())
            .toList();

        return Question.fromLocalJson({
          'question': json['question'],
          'correct_answer': json['correct_answer'],
          'incorrect_answers': incorrect,
          'difficulty': json['difficulty'],
          'category': json['category'],
          'type': 'multiple',
        });
      }).toList();
    } catch (e) {
      print('Error generating quiz: $e');
      throw Exception('Failed to generate quiz: $e');
    }
  }

  Future<String> getExplanation({
    required String question,
    required String correctAnswer,
    required String userAnswer,
  }) async {
    final prompt = '''
    You are a helpful tutor.
    Question: "$question"
    Correct Answer: "$correctAnswer"
    User's Answer: "$userAnswer"

    Explain simply why the correct answer is right and (if different) why the user's answer is wrong.
    Keep it under 3 sentences.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Could not generate explanation.';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
