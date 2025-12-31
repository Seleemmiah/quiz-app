import 'package:flutter/material.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/utils/profile_validator.dart';

class JoinQuizScreen extends StatefulWidget {
  const JoinQuizScreen({super.key});

  @override
  State<JoinQuizScreen> createState() => _JoinQuizScreenState();
}

class _JoinQuizScreenState extends State<JoinQuizScreen> {
  final _codeController = TextEditingController();
  final _firestoreService = FirestoreService();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinQuiz() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.length != 6) {
      setState(() => _error = 'Code must be 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final quiz = await _firestoreService.getQuizByAccessCode(code);

      if (mounted) {
        setState(() => _isLoading = false);

        if (quiz != null) {
          // Check if user has already taken this quiz
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final hasTaken =
                await _firestoreService.hasUserTakenQuiz(user.uid, quiz.id);
            if (hasTaken) {
              setState(() {
                _isLoading = false;
                _error = 'You have already taken this quiz.';
              });
              return;
            }
          }

          // Navigate to quiz
          if (mounted) {
            // First, verify student has completed their profile
            final profileError =
                await ProfileValidator.validateProfileForExam();
            if (profileError != null) {
              if (mounted) {
                final success = await _showProfileCompletionDialog();
                if (!success) {
                  setState(() {
                    _isLoading = false;
                    _error = 'Profile completion is required for exams.';
                  });
                  return;
                }
              } else {
                return;
              }
            }

            // Link student to teacher (creator of the quiz)
            try {
              final teacherId = quiz.creatorId;
              if (teacherId.isNotEmpty && user != null) {
                await _firestoreService
                    .addStudentsToTeacher(teacherId, [user.uid]);
              }
            } catch (e) {
              print('Error linking student to teacher: $e');
            }

            Navigator.pushNamed(
              context,
              '/quiz',
              arguments: {
                'difficulty': quiz.difficulty,
                'category': quiz.category,
                'quizLength': quiz.questions.length,
                'customQuestions': quiz.questions,
                'quiz': quiz,
              },
            );
          }
        } else {
          setState(() => _error = 'Quiz not found');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Error joining quiz: $e';
        });
      }
    }
  }

  Future<bool> _showProfileCompletionDialog() async {
    final nameController = TextEditingController();
    final matricController = TextEditingController();
    final user = FirebaseAuth.instance.currentUser;

    // Load existing name if available
    try {
      final userData = await _firestoreService.getUser(user?.uid ?? '');
      nameController.text = userData?['username'] ?? '';
      matricController.text = userData?['matricNumber'] ?? '';
    } catch (_) {}

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Complete Your Profile 📋'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your teacher requires your name and matric number for this exam.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: matricController,
              decoration: const InputDecoration(
                labelText: 'Matriculation Number',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty ||
                  matricController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              try {
                if (user != null) {
                  await _firestoreService.saveUser(
                    user,
                    username: nameController.text.trim(),
                    matricNumber: matricController.text.trim(),
                  );
                  if (context.mounted) Navigator.pop(context, true);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving profile: $e')),
                  );
                }
              }
            },
            child: const Text('Save & Continue'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.groups,
              size: 80,
              color: Colors.indigo,
            ),
            const SizedBox(height: 32),
            Text(
              'Enter Access Code',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Ask your teacher or friend for the 6-character code',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                hintText: 'e.g. A1B2C3',
                border: const OutlineInputBorder(),
                errorText: _error,
                counterText: '',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
              maxLength: 6,
              textCapitalization: TextCapitalization.characters,
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _joinQuiz,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('JOIN QUIZ'),
            ),
          ],
        ),
      ),
    );
  }
}
