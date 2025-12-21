import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/bookmark_service.dart';
import 'package:quiz_app/services/sound_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:quiz_app/widgets/question_display.dart';

class StudyModeScreen extends StatefulWidget {
  final List<Question> questions;
  final String category;

  const StudyModeScreen({
    super.key,
    required this.questions,
    required this.category,
  });

  @override
  State<StudyModeScreen> createState() => _StudyModeScreenState();
}

class _StudyModeScreenState extends State<StudyModeScreen> {
  // --- State Variables ---
  late List<Question> _studyQueue;
  int _currentIndex = 0;
  bool _showExplanation = false;
  int? _selectedAnswerIndex;
  final BookmarkService _bookmarkService = BookmarkService();
  final SoundService _soundService = SoundService();
  bool _isBookmarked = false;
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Flashcard Mode State
  bool _isFlashcardMode = false;
  GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();
    // Initialize the study queue with the provided questions
    _studyQueue = List.from(widget.questions);

    if (_studyQueue.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No questions to study.')),
        );
      });
      return;
    }
    _checkIfBookmarked();
  }

  Future<void> _checkIfBookmarked() async {
    if (_userId.isEmpty) return;
    final isBookmarked = await _bookmarkService.isBookmarked(
      _userId,
      _studyQueue[_currentIndex].question,
    );
    if (mounted) {
      setState(() {
        _isBookmarked = isBookmarked;
      });
    }
  }

  // --- Quiz Mode Logic ---
  void _handleAnswer(int index) {
    if (_showExplanation) return; // Already answered

    setState(() {
      _selectedAnswerIndex = index;
      _showExplanation = true;
    });

    // Play sound and haptic feedback
    HapticFeedback.mediumImpact();

    final question = _studyQueue[_currentIndex];
    final isCorrect = question.shuffledAnswers[index] == question.correctAnswer;

    if (isCorrect) {
      _soundService.playCorrectSound();
    } else {
      _soundService.playWrongSound();
    }
  }

  // --- Smart Shuffle Logic ---
  void _handleFlashcardRating(bool knewIt) {
    HapticFeedback.lightImpact();

    if (!knewIt) {
      // Smart Shuffle: Re-queue the question to see it again later
      setState(() {
        _studyQueue.add(_studyQueue[_currentIndex]);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Got it. We\'ll show this card again later.'),
          duration: Duration(milliseconds: 1500),
        ),
      );
    }

    // Move to next card automatically after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _nextQuestion();
    });
  }

  Future<void> _toggleBookmark() async {
    if (_userId.isEmpty) return;

    HapticFeedback.lightImpact();
    final question = _studyQueue[_currentIndex];

    if (_isBookmarked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Go to Bookmarks to remove items')),
      );
    } else {
      await _bookmarkService.bookmarkQuestion(
        userId: _userId,
        questionText: question.question,
        options: question.shuffledAnswers,
        correctAnswerIndex:
            question.shuffledAnswers.indexOf(question.correctAnswer),
        explanation: question.explanation,
        category: question.category,
        difficulty: question.difficulty,
      );
      setState(() {
        _isBookmarked = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question bookmarked!')),
        );
      }
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _studyQueue.length - 1) {
      setState(() {
        _currentIndex++;
        _showExplanation = false;
        _selectedAnswerIndex = null;
        _isBookmarked = false;
        // Reset card state if in flashcard mode
        if (_isFlashcardMode && _cardKey.currentState?.isFront == false) {
          _cardKey.currentState?.toggleCard();
        }
        // Create a new key to force rebuild/reset of FlipCard
        if (_isFlashcardMode) {
          _cardKey = GlobalKey<FlipCardState>();
        }
      });
      _checkIfBookmarked();
    } else {
      _finishSession();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showExplanation = false;
        _selectedAnswerIndex = null;
        _isBookmarked = false;
        if (_isFlashcardMode) {
          _cardKey = GlobalKey<FlipCardState>();
        }
      });
      _checkIfBookmarked();
    }
  }

  void _finishSession() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Session Complete! 🎉'),
        content: Text(
          'You have reviewed all ${_studyQueue.length} cards in this session.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit screen
            },
            child: const Text('Finish'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _studyQueue.shuffle(); // Shuffle for a fresh start
                _showExplanation = false;
                _selectedAnswerIndex = null;
              });
            },
            child: const Text('Restart Session'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _studyQueue[_currentIndex];

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        // Show confirmation dialog before leaving
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Leave Study Mode?'),
            content: const Text(
              'Are you sure you want to leave? Your progress will be saved.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Leave'),
              ),
            ],
          ),
        );

        if (shouldPop == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.category} Study'),
          actions: [
            // Mode Toggle
            IconButton(
              icon:
                  Icon(_isFlashcardMode ? Icons.view_carousel : Icons.list_alt),
              tooltip: _isFlashcardMode
                  ? 'Switch to Quiz View'
                  : 'Switch to Flashcard View',
              onPressed: () {
                setState(() {
                  _isFlashcardMode = !_isFlashcardMode;
                  _showExplanation = false;
                  _selectedAnswerIndex = null;
                });
              },
            ),
            IconButton(
              icon:
                  Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
              color: _isBookmarked ? Colors.amber : null,
              onPressed: _toggleBookmark,
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _studyQueue.length,
              backgroundColor: Colors.grey[200],
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),

            Expanded(
              child: _isFlashcardMode
                  ? _buildFlashcardView(question)
                  : _buildQuizView(question),
            ),
          ],
        ), // Close body Column
      ), // Close Scaffold
    ); // Close WillPopScope
  }

  // --- Flashcard View ---
  Widget _buildFlashcardView(Question question) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Card ${_currentIndex + 1} of ${_studyQueue.length}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FlipCard(
              key: _cardKey,
              direction: FlipDirection.HORIZONTAL,
              front: _buildCardFace(
                title: 'Question',
                content: question.question,
                color: Colors.white,
                textColor: Colors.black87,
                icon: Icons.help_outline,
              ),
              back: _buildCardFace(
                title: 'Answer',
                content:
                    '${question.correctAnswer}\n\n${question.explanation ?? ""}',
                color: Colors.blue.shade50,
                textColor: Colors.blue.shade900,
                icon: Icons.lightbulb_outline,
                isBack: true,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Self-Rating Buttons (Only visible in Flashcard mode)
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _handleFlashcardRating(false),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Study Again'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _handleFlashcardRating(true),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Got It'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardFace({
    required String title,
    required String content,
    required Color color,
    required Color textColor,
    required IconData icon,
    bool isBack = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: textColor.withOpacity(0.5)),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor.withOpacity(0.6),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: QuestionDisplay(
              questionText: content,
              imageUrl:
                  null, // Flashcards might be too small for images, or we can add support later
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
                height: 1.4,
              ),
            ),
          ),
          if (!isBack) ...[
            const SizedBox(height: 40),
            Text(
              'Tap to flip',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- Quiz View (Original) ---
  Widget _buildQuizView(Question question) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Counter
                Text(
                  'Question ${_currentIndex + 1} of ${_studyQueue.length}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Question Text
                QuestionDisplay(
                  questionText: question.question,
                  imageUrl: question.imageUrl,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Options
                ...List.generate(question.shuffledAnswers.length, (index) {
                  final option = question.shuffledAnswers[index];
                  final isSelected = _selectedAnswerIndex == index;
                  final isCorrect = option == question.correctAnswer;

                  Color? cardColor;
                  Color? textColor;

                  if (_showExplanation) {
                    if (isCorrect) {
                      cardColor = Colors.green.shade100;
                      textColor = Colors.green.shade900;
                    } else if (isSelected) {
                      cardColor = Colors.red.shade100;
                      textColor = Colors.red.shade900;
                    }
                  }

                  return Card(
                    color: cardColor,
                    elevation: isSelected ? 4 : 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: _showExplanation && isCorrect
                          ? BorderSide(color: Colors.green.shade500, width: 2)
                          : BorderSide.none,
                    ),
                    child: InkWell(
                      onTap: () => _handleAnswer(index),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: textColor ?? Colors.grey,
                                  width: 2,
                                ),
                                color: _showExplanation && isCorrect
                                    ? Colors.green
                                    : (isSelected ? textColor : null),
                              ),
                              child: _showExplanation && isCorrect
                                  ? const Icon(Icons.check,
                                      size: 16, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: QuestionDisplay(
                                questionText: option,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColor,
                                  fontWeight: isSelected ||
                                          (_showExplanation && isCorrect)
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // Explanation Section
                if (_showExplanation) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb, color: Colors.amber.shade700),
                            const SizedBox(width: 8),
                            const Text(
                              'Explanation',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          question.explanation ??
                              'No explanation available for this question.',
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Navigation Buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentIndex > 0)
                OutlinedButton.icon(
                  onPressed: _previousQuestion,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                )
              else
                const SizedBox(width: 100), // Spacer

              ElevatedButton.icon(
                onPressed: _nextQuestion,
                icon: Icon(_currentIndex < _studyQueue.length - 1
                    ? Icons.arrow_forward
                    : Icons.check),
                label: Text(
                    _currentIndex < _studyQueue.length - 1 ? 'Next' : 'Finish'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
