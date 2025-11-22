import 'package:flutter/material.dart';
import 'package:quiz_app/services/custom_quiz_service.dart';
import 'package:quiz_app/screens/create_question_screen.dart';
import 'package:quiz_app/settings.dart';
import 'package:intl/intl.dart';

class MyQuizzesScreen extends StatefulWidget {
  const MyQuizzesScreen({super.key});

  @override
  State<MyQuizzesScreen> createState() => _MyQuizzesScreenState();
}

class _MyQuizzesScreenState extends State<MyQuizzesScreen> {
  final CustomQuizService _customQuizService = CustomQuizService();
  List<CustomQuestion> _questions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() => _isLoading = true);
    final questions = await _customQuizService.getQuestions();
    if (mounted) {
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteQuestion(CustomQuestion question) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content: const Text('Are you sure you want to delete this question?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _customQuizService.deleteQuestion(question.id);
      _loadQuestions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question deleted')),
        );
      }
    }
  }

  Future<void> _playCustomQuiz() async {
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Create some questions first!')),
      );
      return;
    }

    if (_questions.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need at least 5 questions to play')),
      );
      return;
    }

    final quizQuestions = await _customQuizService.getQuestionsForQuiz(
      amount: _questions.length < 10 ? _questions.length : 10,
    );

    if (mounted) {
      Navigator.pushNamed(
        context,
        '/customQuiz',
        arguments: {'questions': quizQuestions},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quizzes'),
        actions: [
          if (_questions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: _playCustomQuiz,
              tooltip: 'Play Quiz',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
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
                        'No custom questions yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to create your first question',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadQuestions,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      final question = _questions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            question.question,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          question.difficulty == Difficulty.easy
                                              ? Colors.green
                                              : question.difficulty ==
                                                      Difficulty.medium
                                                  ? Colors.orange
                                                  : Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      question.difficulty.name.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      question.category,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Created ${DateFormat.yMMMd().format(question.createdAt)}',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 20),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete,
                                        size: 20, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) async {
                              if (value == 'edit') {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateQuestionScreen(
                                      editQuestion: question,
                                    ),
                                  ),
                                );
                                if (result == true) _loadQuestions();
                              } else if (value == 'delete') {
                                _deleteQuestion(question);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateQuestionScreen(),
            ),
          );
          if (result == true) _loadQuestions();
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Question'),
      ),
    );
  }
}
