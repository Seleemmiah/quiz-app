import 'package:flutter/material.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/settings.dart';
import 'dart:math';

class QuickPlayScreen extends StatelessWidget {
  const QuickPlayScreen({super.key});

  void _startQuickPlay(BuildContext context) {
    final random = Random();

    // Random category from available categories
    final categories = [
      'General Knowledge',
      'Science',
      'History',
      'Mathematics',
      'Geography',
      'Sports',
      'Entertainment',
    ];

    final difficulties = [Difficulty.easy, Difficulty.medium, Difficulty.hard];

    final randomCategory = categories[random.nextInt(categories.length)];
    final randomDifficulty = difficulties[random.nextInt(difficulties.length)];

    // Navigate to quiz with random settings
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          difficulty: randomDifficulty,
          category: randomCategory,
          quizLength: 5, // Quick 5 questions
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Play'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bolt,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Quick Play',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Jump right into a random quiz!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '• Random category\n• Random difficulty\n• 5 quick questions\n• Instant start!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => _startQuickPlay(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.play_arrow, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'Start Quick Play',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
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
