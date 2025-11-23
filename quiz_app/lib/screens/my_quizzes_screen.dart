import 'package:flutter/material.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/screens/create_quiz_screen.dart';

class MyQuizzesScreen extends StatefulWidget {
  const MyQuizzesScreen({super.key});

  @override
  State<MyQuizzesScreen> createState() => _MyQuizzesScreenState();
}

class _MyQuizzesScreenState extends State<MyQuizzesScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  List<Quiz> _quizzes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    setState(() => _isLoading = true);
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final quizzes = await _firestoreService.getUserQuizzes(user.uid);
        if (mounted) {
          setState(() {
            _quizzes = quizzes;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading quizzes: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _playQuiz(Quiz quiz) {
    Navigator.pushNamed(
      context,
      '/quiz',
      arguments: {
        'difficulty': quiz
            .difficulty, // This needs to be mapped to enum if needed, or QuizScreen updated
        'category': quiz.category,
        'quizLength': quiz.questions.length,
        'customQuestions': quiz.questions,
        'quiz': quiz,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quizzes'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _quizzes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.quiz,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No quizzes created yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to create your first quiz',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadQuizzes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _quizzes.length,
                    itemBuilder: (context, index) {
                      final quiz = _quizzes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            quiz.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quiz.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      quiz.difficulty,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${quiz.questions.length} Questions',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (quiz.isPublic)
                                    const Icon(Icons.public,
                                        size: 16, color: Colors.blue)
                                  else
                                    const Icon(Icons.lock,
                                        size: 16, color: Colors.grey),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () => _playQuiz(quiz),
                            tooltip: 'Play Quiz',
                          ),
                          onTap: () {
                            // Show details or edit
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateQuizScreen(),
            ),
          );
          _loadQuizzes();
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Quiz'),
      ),
    );
  }
}
