// ignore_for_file: sort_child_properties_last

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/services/api_service.dart';
import 'package:quiz_app/models/question_model.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // This "Future" will hold our list of questions
  late Future<List<Question>> _questionFuture;

  // We now get our questions from the ApiService
  final ApiService _apiService = ApiService();

  // These variables will be initialized AFTER we get the data
  List<Question> _questions = [];
  int _questionIndex = 0;
  List<String?> _selectedAnswers = [];

  // --- VISUAL FEEDBACK STATE ---
  Map<String, Color> _answerColors = {};

  @override
  void initState() {
    super.initState();
    // When the widget is first created, we tell it to // start fetching the questions.
    // start fetching the questions.
    _questionFuture = _apiService.fetchQuestions().then((questions) {
      _questions = questions; // Assign questions here
      _selectedAnswers = List<String?>.filled(
          _questions.length, null); // Initialize selectedAnswers
      return questions;
    });
  }

  int get _totalScore {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i].correctAnswer) {
        score++;
      }
    }
    return score;
  }

  void _answerQuestion(String selectedAnswer) {
    if (_selectedAnswers[_questionIndex] != null) return;

    final currentQuestion = _questions[_questionIndex];
    final bool isCorrect = currentQuestion.correctAnswer == selectedAnswer;

    setState(() {
      _selectedAnswers[_questionIndex] = selectedAnswer;
      if (isCorrect) {
        _answerColors[selectedAnswer] = Colors.green;
      } else {
        _answerColors[selectedAnswer] = Colors.red;
        _answerColors[currentQuestion.correctAnswer] = Colors.green;
      }
    });
  }

  void _updateAnswerColors() {
    _answerColors = {};
    final selectedAnswer = _selectedAnswers[_questionIndex];
    if (selectedAnswer != null) {
      final currentQuestion = _questions[_questionIndex];
      final isCorrect = currentQuestion.correctAnswer == selectedAnswer;
      if (isCorrect) {
        _answerColors[selectedAnswer] = Colors.green;
      } else {
        _answerColors[selectedAnswer] = Colors.red;
        _answerColors[currentQuestion.correctAnswer] = Colors.green;
      }
    }
  }

  void _toggleTheme() {
    final newTheme = Theme.of(context).brightness == Brightness.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    final app = context.findAncestorStateOfType<MyAppState>();
    app?.changeTheme(newTheme);
  }

  void _showUnansweredQuestionDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Question Unanswered'),
          content: Text(message),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          actions: <Widget>[
            TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  void _goToQuestion(int index) {
    // Only check if moving forward and current question is unanswered
    if (index > _questionIndex && _selectedAnswers[_questionIndex] == null) {
      _showUnansweredQuestionDialog('Please select an answer to continue.');
      return;
    }
    setState(() {
      _questionIndex = index;
      _updateAnswerColors();
    });
  }

  void _finishQuiz() {
    // Check if any question is unanswered before finishing.
    if (_selectedAnswers.any((answer) => answer == null)) {
      _showUnansweredQuestionDialog(
          'Please answer all questions before finishing.');
      return;
    }
    // End of quiz: Navigate to results
    Navigator.pushReplacementNamed(
      context,
      '/results',
      arguments: {
        'score': _totalScore,
        'totalQuestions': _questions.length, // Pass the total here
      },
    );
  }

  // --- This is the new Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This Scaffold is the main one for the screen
      appBar: AppBar(
          title: const Text('Quiz App'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode),
              onPressed: _toggleTheme,
              tooltip: 'Toggle Theme', // This is the single theme toggle button
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              // Safely handle division by zero before questions are loaded
              value: _questions.isNotEmpty
                  ? (_questionIndex + 1) / _questions.length
                  : 0.0,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          )),
      // --- We use a FutureBuilder ---
      // It "builds" its UI based on the state of our "Future"
      body: FutureBuilder<List<Question>>(
        future: _questionFuture, // This is what it's waiting for
        builder: (context, snapshot) {
          // --- 1. LOADING STATE --- // While we're waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Check _questions.isEmpty for initial loading
            return Center(child: CircularProgressIndicator());
          }

          // --- 2. ERROR STATE ---
          // If something went wrong (no internet, API down)
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Failed to load quiz:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Try fetching again
                        setState(() {
                          _questionFuture = _apiService.fetchQuestions();
                        });
                      },
                      child: Text('Try Again'),
                    )
                  ],
                ),
              ),
            );
          }

          // --- 3. DATA STATE ---
          else if (snapshot.hasData) {
            if (_questions.isEmpty) {
              return Center(child: Text('No questions found.'));
            }
            // --- This is our main Quiz UI ---
            final currentQuestion = _questions[_questionIndex];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Question ${_questionIndex + 1} of ${_questions.length}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentQuestion.question,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                // Reduced font size
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ...List.generate(currentQuestion.shuffledAnswers.length,
                        (index) {
                      final answer = currentQuestion.shuffledAnswers[index];
                      final buttonColor = _answerColors[answer];
                      final label =
                          String.fromCharCode('A'.codeUnitAt(0) + index);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: _selectedAnswers[_questionIndex] != null
                              ? null
                              : () => _answerQuestion(answer),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('$label. $answer'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            disabledBackgroundColor: buttonColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                          ),
                        ),
                      );
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Previous Button
                        ElevatedButton(
                          onPressed: _questionIndex > 0
                              ? () => _goToQuestion(_questionIndex - 1)
                              : null,
                          child: const Text('Previous'),
                        ),
                        // Next / Finish Button
                        if (_questionIndex < _questions.length - 1)
                          ElevatedButton(
                            onPressed: () => _goToQuestion(_questionIndex + 1),
                            child: const Text('Next'),
                          )
                        else
                          ElevatedButton(
                            onPressed: _finishQuiz,
                            child: const Text('Finish'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Explanation Section
                    if (_selectedAnswers[_questionIndex] != null) ...[
                      const SizedBox(height: 20),
                      FadeIn(
                          child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explanation:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentQuestion.explanation ??
                                  'No explanation available for this question.',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ))
                    ],
                  ],
                ),
              ),
            );
          }

          // Fallback if snapshot has no data and is not waiting or in error.
          // This state should ideally not be reached with a well-formed Future.
          else {
            return Center(child: Text('Something went wrong.'));
          }
        },
      ),
    );
  }
}
