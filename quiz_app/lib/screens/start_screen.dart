import 'package:flutter/material.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/settings.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  // Default difficulty
  Difficulty _selectedDifficulty = Difficulty.easy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons
                    .school, // Use the theme's primary color instead of a hard-coded one
                color: Colors
                    .deepPurple, // This color seems to be hardcoded, consider using Theme.of(context).primaryColor
                size: 100,
              ),
              const SizedBox(height: 30),
              Text(
                'Welcome to the Quiz!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight:
                          FontWeight.bold, // Keep bold, but remove size/color
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Test your knowledge.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40),
              Text(
                'Select Difficulty:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              SegmentedButton<Difficulty>(
                segments: const [
                  ButtonSegment(value: Difficulty.easy, label: Text('Easy')),
                  ButtonSegment(
                      value: Difficulty.medium, label: Text('Medium')),
                  ButtonSegment(value: Difficulty.hard, label: Text('Hard')),
                ],
                selected: {_selectedDifficulty},
                onSelectionChanged: (Set<Difficulty> newSelection) {
                  setState(() {
                    _selectedDifficulty = newSelection.first;
                  });
                },
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                  selectedForegroundColor: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                child: const Text('Start Quiz'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QuizScreen(difficulty: _selectedDifficulty)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
