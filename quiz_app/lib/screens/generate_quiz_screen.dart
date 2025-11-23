import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/ai_service.dart';
import 'package:quiz_app/services/file_parsing_service.dart';

class GenerateQuizScreen extends StatefulWidget {
  const GenerateQuizScreen({super.key});

  @override
  State<GenerateQuizScreen> createState() => _GenerateQuizScreenState();
}

class _GenerateQuizScreenState extends State<GenerateQuizScreen> {
  final AIService _aiService = AIService();
  final FileParsingService _fileParsingService = FileParsingService();

  String? _fileName;
  String? _extractedText;
  bool _isGenerating = false;
  List<Question> _generatedQuestions = [];

  int _numberOfQuestions = 10;
  String _difficulty = 'medium';

  Future<void> _pickFile() async {
    try {
      final text = await _fileParsingService.pickAndParseFile();
      if (text != null && text.isNotEmpty) {
        setState(() {
          _extractedText = text;
          _fileName =
              'Document Loaded'; // Ideally get real filename if possible
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File loaded successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No text found in file or cancelled.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading file: $e')),
      );
    }
  }

  Future<void> _generateQuiz() async {
    if (_extractedText == null) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final questions = await _aiService.generateQuizFromText(
        _extractedText!,
        numQuestions: _numberOfQuestions,
        difficulty: _difficulty,
      );

      if (mounted) {
        setState(() {
          _generatedQuestions = questions;
          _isGenerating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating quiz: $e')),
        );
      }
    }
  }

  void _startQuiz() {
    Navigator.pushNamed(
      context,
      '/customQuiz',
      arguments: {'questions': _generatedQuestions},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Quiz Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // File Picker Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.upload_file, size: 48, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      _fileName ?? 'Upload PDF or TXT to generate quiz',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.add),
                      label: const Text('Select File'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Settings Section
            if (_extractedText != null) ...[
              Text('Settings', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _difficulty,
                      decoration:
                          const InputDecoration(labelText: 'Difficulty'),
                      items: ['easy', 'medium', 'hard']
                          .map((d) => DropdownMenuItem(
                                value: d,
                                child: Text(d.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _difficulty = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _numberOfQuestions,
                      decoration: const InputDecoration(labelText: 'Questions'),
                      items: [5, 10, 15, 20]
                          .map((n) => DropdownMenuItem(
                                value: n,
                                child: Text('$n Questions'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _numberOfQuestions = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Generate Button
              if (_isGenerating)
                const Center(child: CircularProgressIndicator())
              else if (_generatedQuestions.isEmpty)
                ElevatedButton(
                  onPressed: _generateQuiz,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Generate Quiz'),
                )
              else
                Column(
                  children: [
                    const Icon(Icons.check_circle,
                        size: 64, color: Colors.green),
                    const SizedBox(height: 8),
                    Text(
                      'Quiz Generated Successfully!',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${_generatedQuestions.length} questions created',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _startQuiz,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Start Quiz Now'),
                      ),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}
