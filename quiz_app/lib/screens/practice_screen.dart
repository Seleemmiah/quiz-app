import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';

class PracticeScreen extends StatefulWidget {
  final List<Question> questions;
  final String title;

  const PracticeScreen({
    super.key,
    required this.questions,
    required this.title,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _showExplanation = false;

  void _answerQuestion(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _showExplanation = true;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showExplanation = false;
      });
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _selectedAnswer = null;
        _showExplanation = false;
      });
    }
  }

  void _restartPractice() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswer = null;
      _showExplanation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.quiz_outlined, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 20),
              Text(
                'No questions available for practice',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              const Text('Bookmark some questions during quizzes!'),
            ],
          ),
        ),
      );
    }

    final currentQuestion = widget.questions[_currentIndex];
    final isCorrect = _selectedAnswer == currentQuestion.correctAnswer;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartPractice,
            tooltip: 'Restart Practice',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.questions.length,
            backgroundColor:
                Theme.of(context).primaryColor.withOpacity(0.2),
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question counter
            Text(
              'Question ${_currentIndex + 1} of ${widget.questions.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),

            // Question text
            Text(
              currentQuestion.question,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Answer buttons
            if (currentQuestion.isTrueFalse)
              // True/False buttons
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: _selectedAnswer != null
                            ? null
                            : () => _answerQuestion('True'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedAnswer == 'True'
                              ? (isCorrect ? Colors.green : Colors.red)
                              : null,
                          padding: const EdgeInsets.all(20),
                        ),
                        icon: const Icon(Icons.check_circle, size: 28),
                        label:
                            const Text('True', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: _selectedAnswer != null
                            ? null
                            : () => _answerQuestion('False'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedAnswer == 'False'
                              ? (isCorrect ? Colors.green : Colors.red)
                              : null,
                          padding: const EdgeInsets.all(20),
                        ),
                        icon: const Icon(Icons.cancel, size: 28),
                        label:
                            const Text('False', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              )
            else
              // Multiple choice buttons
              ...List.generate(currentQuestion.shuffledAnswers.length, (index) {
                final answer = currentQuestion.shuffledAnswers[index];
                final label = String.fromCharCode('A'.codeUnitAt(0) + index);
                Color? buttonColor;

                if (_selectedAnswer != null) {
                  if (answer == currentQuestion.correctAnswer) {
                    buttonColor = Colors.green;
                  } else if (answer == _selectedAnswer) {
                    buttonColor = Colors.red;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: _selectedAnswer != null
                        ? null
                        : () => _answerQuestion(answer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      disabledBackgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('$label. $answer'),
                    ),
                  ),
                );
              }),

            // Explanation
            if (_showExplanation) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCorrect ? Colors.green : Colors.red,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isCorrect ? 'Correct!' : 'Incorrect',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    if (!isCorrect) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Correct Answer: ${currentQuestion.correctAnswer}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                    if (currentQuestion.explanation != null) ...[
                      const SizedBox(height: 12),
                      Text(currentQuestion.explanation!),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),

            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentIndex > 0 ? _previousQuestion : null,
                  child: const Text('Previous'),
                ),
                if (_currentIndex < widget.questions.length - 1)
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    child: const Text('Next'),
                  )
                else
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Finish'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
