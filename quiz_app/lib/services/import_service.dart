import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:quiz_app/services/ai_service.dart';

class ImportService {
  final AIService _aiService = AIService();

  Future<List<Question>> importQuestions() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'txt', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        final file = File(path);
        final extension = result.files.single.extension?.toLowerCase();

        if (extension == 'pdf') {
          // AI Generation from PDF
          String text = '';
          try {
            text = await ReadPdfText.getPDFtext(path);
          } catch (e) {
            print('PDF Read Error: $e');
            throw Exception('Could not read PDF text.');
          }

          if (text.length > 50000) {
            // Truncate to avoid token limits
            text = text.substring(0, 50000);
          }

          if (text.trim().isEmpty) throw Exception('PDF appears empty.');

          return await _aiService.generateQuizFromText(text);
        } else {
          // JSON Parse
          final content = await file.readAsString();
          final List<dynamic> data = jsonDecode(content);
          final List<Question> questions = [];

          for (var item in data) {
            // Mapping Logic
            String questionText = item['question'] ?? item['q'] ?? '';
            String correctAnswer =
                item['answer'] ?? item['correct_answer'] ?? item['a'] ?? '';
            List<String> incorrectAnswers = [];

            if (item['incorrect_answers'] != null) {
              incorrectAnswers = List<String>.from(item['incorrect_answers']);
            } else if (item['options'] != null) {
              List<String> options = List<String>.from(item['options']);
              incorrectAnswers =
                  options.where((o) => o != correctAnswer).toList();
            }

            if (questionText.isNotEmpty && correctAnswer.isNotEmpty) {
              questions.add(Question.fromMap({
                'question': questionText,
                'correctAnswer': correctAnswer,
                'incorrectAnswers': incorrectAnswers,
                'type': item['type'] ??
                    (incorrectAnswers.isNotEmpty ? 'multiple' : 'boolean'),
                'difficulty': item['difficulty'] ?? 'medium',
                'category': item['category'] ?? 'General',
              }));
            }
          }
          return questions;
        }
      }
    } catch (e) {
      print('Error importing: $e');
      throw Exception('Import Failed: $e');
    }
    return [];
  }
}
