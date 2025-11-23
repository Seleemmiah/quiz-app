import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/screens/create_question_screen.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _firestoreService = FirestoreService();
  final _authService = AuthService();

  String _difficulty = 'Easy';
  String _category = 'General';
  bool _isPublic = true;
  bool _isBlindMode = false;
  int? _timeLimitMinutes;
  final List<Question> _questions = [];
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addQuestion() async {
    // Navigate to CreateQuestionScreen and wait for result
    // We need to update CreateQuestionScreen to return a Question object
    // For now, let's assume we can adapt it or create a new dialog
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const CreateQuestionScreen(returnQuestion: true)),
    );

    if (result != null && result is Question) {
      setState(() {
        _questions.add(result);
      });
    }
  }

  String _generateAccessCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  Future<void> _saveQuiz() async {
    if (!_formKey.currentState!.validate()) return;
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one question')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = _authService.currentUser;
      if (user == null) throw Exception('User not logged in');

      final quiz = Quiz(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        creatorId: user.uid,
        creatorName: user.displayName ?? 'Anonymous',
        createdAt: DateTime.now(),
        questions: _questions,
        difficulty: _difficulty,
        category: _category,
        isPublic: _isPublic,
        accessCode: _generateAccessCode(),
        isBlindMode: _isBlindMode,
        timeLimitMinutes: _timeLimitMinutes,
      );

      await _firestoreService.createQuiz(quiz);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quiz created successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving quiz: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Quiz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveQuiz,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Quiz Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _difficulty,
                    decoration: const InputDecoration(labelText: 'Difficulty'),
                    items: ['Easy', 'Medium', 'Hard']
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (value) => setState(() => _difficulty = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: ['General', 'Science', 'History', 'Math', 'Coding']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) => setState(() => _category = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Public Quiz'),
              subtitle:
                  const Text('Allow other users to find and play this quiz'),
              value: _isPublic,
              onChanged: (value) => setState(() => _isPublic = value),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Blind Mode'),
              subtitle: const Text(
                  'Students won\'t see correct/incorrect answers during quiz'),
              value: _isBlindMode,
              onChanged: (value) => setState(() => _isBlindMode = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int?>(
              value: _timeLimitMinutes,
              decoration: const InputDecoration(
                labelText: 'Time Limit (Teacher-Set)',
                border: OutlineInputBorder(),
                helperText: 'Set a specific time limit for this quiz',
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('No Limit')),
                DropdownMenuItem(value: 5, child: Text('5 minutes')),
                DropdownMenuItem(value: 10, child: Text('10 minutes')),
                DropdownMenuItem(value: 15, child: Text('15 minutes')),
                DropdownMenuItem(value: 20, child: Text('20 minutes')),
                DropdownMenuItem(value: 30, child: Text('30 minutes')),
                DropdownMenuItem(value: 45, child: Text('45 minutes')),
                DropdownMenuItem(value: 60, child: Text('60 minutes')),
              ],
              onChanged: (value) => setState(() => _timeLimitMinutes = value),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Questions (${_questions.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: _addQuestion,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Question'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_questions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No questions added yet'),
                ),
              )
            else
              ..._questions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(question.question),
                    subtitle: Text(question.correctAnswer),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _questions.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
