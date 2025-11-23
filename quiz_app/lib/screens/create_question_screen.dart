import 'package:flutter/material.dart';
import 'package:quiz_app/services/custom_quiz_service.dart';
import 'package:quiz_app/settings.dart';

import 'package:quiz_app/models/question_model.dart';

class CreateQuestionScreen extends StatefulWidget {
  final CustomQuestion? editQuestion;
  final bool returnQuestion;

  const CreateQuestionScreen({
    super.key,
    this.editQuestion,
    this.returnQuestion = false,
  });

  @override
  State<CreateQuestionScreen> createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  // ... (keep existing variables)
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _correctAnswerController = TextEditingController();
  final _wrong1Controller = TextEditingController();
  final _wrong2Controller = TextEditingController();
  final _wrong3Controller = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();

  Difficulty _selectedDifficulty = Difficulty.easy;
  final CustomQuizService _customQuizService = CustomQuizService();

  // ... (keep existing initState and dispose)
  @override
  void initState() {
    super.initState();
    if (widget.editQuestion != null) {
      _questionController.text = widget.editQuestion!.question;
      _correctAnswerController.text = widget.editQuestion!.correctAnswer;
      _categoryController.text = widget.editQuestion!.category;
      _selectedDifficulty = widget.editQuestion!.difficulty;

      final incorrectAnswers = widget.editQuestion!.incorrectAnswers;
      if (incorrectAnswers.isNotEmpty)
        _wrong1Controller.text = incorrectAnswers[0];
      if (incorrectAnswers.length > 1)
        _wrong2Controller.text = incorrectAnswers[1];
      if (incorrectAnswers.length > 2)
        _wrong3Controller.text = incorrectAnswers[2];

      if (widget.editQuestion?.imageUrl != null) {
        _imageUrlController.text = widget.editQuestion!.imageUrl!;
      }
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _correctAnswerController.dispose();
    _wrong1Controller.dispose();
    _wrong2Controller.dispose();
    _wrong3Controller.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveQuestion() async {
    if (_formKey.currentState!.validate()) {
      if (widget.returnQuestion) {
        // Create Question object for Firestore
        final question = Question.fromLocalJson({
          'category': _categoryController.text.trim(),
          'difficulty': _selectedDifficulty.name, // Use string name
          'question': _questionController.text.trim(),
          'correct_answer': _correctAnswerController.text.trim(),
          'incorrect_answers': [
            _wrong1Controller.text.trim(),
            _wrong2Controller.text.trim(),
            _wrong3Controller.text.trim(),
          ],
          'type': 'multiple',
          'imageUrl': _imageUrlController.text.trim().isNotEmpty
              ? _imageUrlController.text.trim()
              : null,
        });

        Navigator.pop(context, question);
        return;
      }

      // Existing logic for local storage
      final question = CustomQuestion(
        id: widget.editQuestion?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        question: _questionController.text.trim(),
        correctAnswer: _correctAnswerController.text.trim(),
        incorrectAnswers: [
          _wrong1Controller.text.trim(),
          _wrong2Controller.text.trim(),
          _wrong3Controller.text.trim(),
        ],
        category: _categoryController.text.trim(),
        difficulty: _selectedDifficulty,
        createdAt: widget.editQuestion?.createdAt ?? DateTime.now(),
        imageUrl: _imageUrlController.text.trim().isNotEmpty
            ? _imageUrlController.text.trim()
            : null,
      );

      if (widget.editQuestion != null) {
        await _customQuizService.updateQuestion(question);
      } else {
        await _customQuizService.addQuestion(question);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.editQuestion != null ? 'Edit Question' : 'Create Question'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveQuestion,
            tooltip: 'Save',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Question
            TextFormField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                hintText: 'Enter your question',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a question';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Image URL Field
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL (Optional)',
                hintText: 'https://example.com/image.jpg',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
              onChanged: (value) {
                setState(() {}); // Rebuild to show preview
              },
            ),
            if (_imageUrlController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            Text('Invalid Image URL'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Correct Answer
            TextFormField(
              controller: _correctAnswerController,
              decoration: const InputDecoration(
                labelText: 'Correct Answer',
                hintText: 'Enter the correct answer',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.check_circle, color: Colors.green),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the correct answer';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Wrong Answers
            Text(
              'Incorrect Answers',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _wrong1Controller,
              decoration: const InputDecoration(
                labelText: 'Wrong Answer 1',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.cancel, color: Colors.red),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a wrong answer';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _wrong2Controller,
              decoration: const InputDecoration(
                labelText: 'Wrong Answer 2',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.cancel, color: Colors.red),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a wrong answer';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _wrong3Controller,
              decoration: const InputDecoration(
                labelText: 'Wrong Answer 3',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.cancel, color: Colors.red),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a wrong answer';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'e.g., Science, History, Sports',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Difficulty
            DropdownButtonFormField<Difficulty>(
              value: _selectedDifficulty,
              decoration: const InputDecoration(
                labelText: 'Difficulty',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.speed),
              ),
              items: Difficulty.values.map((difficulty) {
                return DropdownMenuItem(
                  value: difficulty,
                  child: Text(difficulty.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDifficulty = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton.icon(
              onPressed: _saveQuestion,
              icon: const Icon(Icons.save),
              label: Text(widget.editQuestion != null
                  ? 'Update Question'
                  : 'Create Question'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
