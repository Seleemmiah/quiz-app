import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/models/question_model.dart';

class ApiService {
  // This is the function we'll call to get the questions
  // It returns a "Future", meaning the data will come back later.
  Future<List<Question>> fetchQuestions() async {
    // We're asking for 10 multiple-choice questions
    const String apiUrl =
        'https://opentdb.com/api.php?amount=10&type=multiple';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // If the request was successful
        final body = json.decode(response.body);
        final results = body['results'] as List;

        // Convert the raw JSON (List<Map>) into our clean Question objects (List<Question>)
        return results.map((json) => Question.fromApiJson(json)).toList();
      } else {
        // If the server responded with an error
        throw Exception('Failed to load questions from API');
      }
    } catch (e) {
      // If something else went wrong (like no internet)
      throw Exception('Failed to connect to the network: ${e.toString()}');
    }
  }
}