import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class ResultScreen extends StatelessWidget {
  // We need to receive the score and total from the navigator
  final int score;
  final int totalQuestions;

  // Constructor to receive the data
  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions, // This now comes from the arguments
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percentage = (score / totalQuestions) * 100;
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 10),
              Pulse(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 500),
                child: Text(
                  '$score / $totalQuestions',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: percentage >= 70
                            ? Colors.green
                            : (percentage >= 40 ? Colors.orange : Colors.red),
                      ),
                ),
              ),
              const SizedBox(height: 50),
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
            ],
          ),
        ),
      ),
    );
  }
}
