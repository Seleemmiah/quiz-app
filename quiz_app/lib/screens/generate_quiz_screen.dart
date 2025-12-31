import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/ai_service.dart';
import 'package:quiz_app/services/file_parsing_service.dart';
import 'package:quiz_app/services/offline_cache_service.dart';
import 'package:quiz_app/services/quota_service.dart';
import 'package:quiz_app/utils/profile_validator.dart';

class GenerateQuizScreen extends StatefulWidget {
  const GenerateQuizScreen({super.key});

  @override
  State<GenerateQuizScreen> createState() => _GenerateQuizScreenState();
}

class _GenerateQuizScreenState extends State<GenerateQuizScreen> {
  final AIService _aiService = AIService();
  final FileParsingService _fileParsingService = FileParsingService();
  final QuotaService _quotaService = QuotaService();

  String? _fileName;
  String? _extractedText;
  bool _isGenerating = false;
  bool _isSaving = false;
  List<Question> _generatedQuestions = [];

  int _numberOfQuestions = 10;
  String _difficulty = 'medium';

  Future<void> _pickFile() async {
    try {
      final text = await _fileParsingService.pickAndParseFile();
      if (text != null && text.isNotEmpty) {
        setState(() {
          _extractedText = text;
          _fileName = 'Document Loaded';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File loaded successfully!')),
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

    // Check quota before generating
    final hasQuota =
        await _quotaService.hasRemainingQuota('ai_quiz_generation');
    if (!hasQuota) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Daily Limit Reached 🛑'),
            content: const Text(
              'You have used up your ${QuotaService.DAILY_AI_LIMIT} AI generations for today. This limit helps us keep the service free for everyone. Please try again tomorrow!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return;
    }

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

  Future<void> _saveForOffline() async {
    if (_generatedQuestions.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      await OfflineCacheService.saveQuiz(
        title: 'Quiz from ${_fileName ?? "AI"}',
        category: 'Generated',
        questions: _generatedQuestions,
        isGenerated: true,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quiz saved to offline library!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _startQuiz() async {
    final profileError = await ProfileValidator.validateProfileForExam();
    if (profileError != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(profileError),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return;
    }

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
      body: SingleChildScrollView(
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
              FutureBuilder<int>(
                future: _quotaService.getRemainingQuota('ai_quiz_generation'),
                builder: (context, snapshot) {
                  final remaining = snapshot.data ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 20, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Daily Allowance: $remaining / ${QuotaService.DAILY_AI_LIMIT} generations left',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _startQuiz,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Quiz Now'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isSaving ? null : _saveForOffline,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.download_for_offline),
                        label:
                            Text(_isSaving ? 'Saving...' : 'Save for Offline'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _generatedQuestions = [];
                        });
                      },
                      child: const Text('Discard and Start Over'),
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
