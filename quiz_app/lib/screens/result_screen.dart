import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:quiz_app/services/score_service.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/settings.dart';

class ResultScreen extends StatefulWidget {
  // We need to receive the score and total from the navigator
  final int score;
  final int totalQuestions;
  final Difficulty difficulty;
  final String? category;
  final List<Question> questions;
  final List<String?> selectedAnswers;

  // Constructor to receive the data
  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions, // This now comes from the arguments
    required this.difficulty,
    required this.category,
    required this.questions,
    required this.selectedAnswers,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScoreService _scoreService = ScoreService();
  int _highScore = 0;
  bool _isNewHighScore = false;

  @override
  void initState() {
    super.initState();
    _updateAndLoadHighScore();
  }

  Future<void> _updateAndLoadHighScore() async {
    final isNew = await _scoreService.updateHighScore(
      difficulty: widget.difficulty,
      category: widget.category,
      score: widget.score,
    );
    final score = await _scoreService.getHighScore(
      difficulty: widget.difficulty,
      category: widget.category,
    );
    setState(() {
      _isNewHighScore = isNew;
      _highScore = score;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double percentage = widget.totalQuestions > 0
        ? (widget.score / widget.totalQuestions) * 100
        : 0;
    final String message = percentage >= 70
        ? 'Excellent Work!'
        : percentage >= 40
            ? 'Good Effort!'
            : 'Keep Practicing!';

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeInDown(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              FadeIn(
                delay: const Duration(milliseconds: 500),
                child: Text(
                  'Your Score:',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 10),
              Pulse(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 500),
                child: Text(
                  '${widget.score} / ${widget.totalQuestions}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: percentage >= 70
                            ? Colors.green
                            : (percentage >= 40 ? Colors.orange : Colors.red),
                      ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isNewHighScore)
                FadeIn(
                  delay: const Duration(milliseconds: 1000),
                  child: const Text(
                    '🎉 New High Score! 🎉',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              Text(
                'High Score: $_highScore',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 40),
              FadeInUp(
                delay: const Duration(milliseconds: 1200),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Restart Quiz'),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                delay: const Duration(milliseconds: 1400),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.rate_review_outlined),
                  label: const Text('Review Answers'),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/review',
                      arguments: {
                        'questions': widget.questions,
                        'selectedAnswers': widget.selectedAnswers,
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
