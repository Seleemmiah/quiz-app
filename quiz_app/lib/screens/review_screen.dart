import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';

class ReviewScreen extends StatefulWidget {
  final List<Question> questions;
  final List<String?> selectedAnswers;

  const ReviewScreen({
    super.key,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _reviewIndex = 0;
  bool _showIncorrectOnly = false;
  List<int> _filteredIndices = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredIndices();
  }

  void _updateFilteredIndices() {
    if (_showIncorrectOnly) {
      _filteredIndices = [];
      for (int i = 0; i < widget.questions.length; i++) {
        if (widget.selectedAnswers[i] != widget.questions[i].correctAnswer) {
          _filteredIndices.add(i);
        }
      }
    } else {
      _filteredIndices = List.generate(widget.questions.length, (i) => i);
    }
    _reviewIndex = 0;
  }

  void _goToQuestion(int index) {
    setState(() {
      _reviewIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_filteredIndices.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Review Answers'),
          actions: [
            FilterChip(
              label: const Text('Incorrect Only'),
              selected: _showIncorrectOnly,
              onSelected: (bool value) {
                setState(() {
                  _showIncorrectOnly = value;
                  _updateFilteredIndices();
                });
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 80, color: Colors.green),
              const SizedBox(height: 20),
              Text(
                _showIncorrectOnly
                    ? 'Great job! No incorrect answers.'
                    : 'No questions to review.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (_showIncorrectOnly)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showIncorrectOnly = false;
                      _updateFilteredIndices();
                    });
                  },
                  child: const Text('Show All Questions'),
                ),
            ],
          ),
        ),
      );
    }

    final realIndex = _filteredIndices[_reviewIndex];
    final currentQuestion = widget.questions[realIndex];
    final selectedAnswer = widget.selectedAnswers[realIndex];
    final isCorrect = selectedAnswer == currentQuestion.correctAnswer;

    return Scaffold(
      appBar: AppBar(
        title: Text('Review (${_reviewIndex + 1}/${_filteredIndices.length})'),
        actions: [
          FilterChip(
            label: const Text('Incorrect Only'),
            selected: _showIncorrectOnly,
            onSelected: (bool value) {
              setState(() {
                _showIncorrectOnly = value;
                _updateFilteredIndices();
              });
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (_reviewIndex + 1) / _filteredIndices.length,
            backgroundColor:
                Theme.of(context).primaryColor.withValues(alpha: 0.2),
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${realIndex + 1} of ${widget.questions.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text(
                currentQuestion.question,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ...currentQuestion.shuffledAnswers.map((answer) {
                final isCorrectAnswer = answer == currentQuestion.correctAnswer;
                final isSelectedAnswer = answer == selectedAnswer;

                Color borderColor = Colors.transparent;
                Icon? trailingIcon;
                String? subtitle;

                // Case 1: The user's answer was correct.
                if (isSelectedAnswer && isCorrect) {
                  borderColor = Colors.green;
                  trailingIcon =
                      const Icon(Icons.check_circle, color: Colors.green);
                  subtitle = 'Your Answer (Correct)';
                }
                // Case 2: The user's answer was incorrect.
                else if (isSelectedAnswer && !isCorrect) {
                  borderColor = Colors.red;
                  trailingIcon = const Icon(Icons.cancel, color: Colors.red);
                  subtitle = 'Your Answer (Incorrect)';
                }
                // Case 3: This is the correct answer, which the user did NOT pick.
                else if (isCorrectAnswer) {
                  borderColor = Colors.green;
                  trailingIcon = const Icon(Icons.check_circle_outline,
                      color: Colors.green);
                  subtitle = 'Correct Answer';
                }

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: borderColor, width: 2),
                  ),
                  child: ListTile(
                    title: Text(answer),
                    subtitle: subtitle != null
                        ? Text(subtitle,
                            style: TextStyle(
                                color: borderColor,
                                fontWeight: FontWeight.bold))
                        : null,
                    trailing: trailingIcon,
                  ),
                );
              }),
              const SizedBox(height: 30),
              // Explanation Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.8),
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
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Button
            TextButton.icon(
              icon: const Icon(Icons.arrow_back_ios),
              label: const Text('Previous'),
              onPressed: _reviewIndex > 0
                  ? () => _goToQuestion(_reviewIndex - 1)
                  : null,
            ),
            // Next Button
            TextButton.icon(
              icon: const Icon(Icons.arrow_forward_ios),
              label: const Text('Next'),
              onPressed: _reviewIndex < _filteredIndices.length - 1
                  ? () => _goToQuestion(_reviewIndex + 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
