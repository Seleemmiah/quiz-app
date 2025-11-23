import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/services/api_service.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/services/leaderboard_service.dart';
import 'package:quiz_app/models/leaderboard_entry.dart';
import 'package:quiz_app/services/quiz_state_service.dart';
import 'package:quiz_app/services/class_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    this.difficulty = Difficulty.easy,
    this.category,
    this.timeLimitInMinutes,
    this.quizLength = 10,
    this.customQuestions,
    this.quiz,
  });
  final Difficulty difficulty;
  final String? category;
  final int? timeLimitInMinutes;
  final int quizLength;
  final List<Question>? customQuestions;
  final Quiz?
      quiz; // Quiz object for custom quizzes (to access isBlindMode, timeLimitMinutes)

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with WidgetsBindingObserver {
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

  // --- TIMER STATE ---
  Timer? _timer;
  int _remainingTime = 0;

  // --- STREAK STATE ---
  int _currentStreak = 0;

  // --- LIVES STATE ---
  int _lives = 3;

  // --- TIME TRACKING ---
  DateTime? _quizStartTime;
  int? _quizCompletionTimeSeconds;

  final QuizStateService _quizStateService = QuizStateService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.customQuestions != null && widget.customQuestions!.isNotEmpty) {
      _questionFuture = Future.value(widget.customQuestions);
    } else {
      _questionFuture = _apiService.fetchQuestions(
          amount: widget.quizLength,
          difficulty: widget.difficulty,
          category: widget.category);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel(); // Always cancel timers when the widget is removed
    // Save state if quiz is incomplete
    if (_questions.isNotEmpty && !_selectedAnswers.every((a) => a != null)) {
      _saveQuizState();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Auto-submit quiz when app is minimized or goes to background
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      if (_questions.isNotEmpty && mounted) {
        // Check if quiz is in progress
        final hasAnsweredAny = _selectedAnswers.any((a) => a != null);
        if (hasAnsweredAny) {
          // Auto-submit the quiz
          _finishQuiz(timeUp: false, outOfLives: false);
        }
      }
    }
  }

  Future<void> _saveQuizState() async {
    if (_questions.isEmpty) return;
    await _quizStateService.saveQuizState(
      questions: _questions,
      selectedAnswers: _selectedAnswers,
      currentIndex: _questionIndex,
      remainingTime: _remainingTime,
      difficulty: widget.difficulty,
      category: widget.category,
      lives: _lives,
      streak: _currentStreak,
      startTime: _quizStartTime ?? DateTime.now(),
    );
  }

  void _startTimer() {
    // Track quiz start time
    _quizStartTime = DateTime.now();

    // Determine time limit: explicit argument takes precedence, then quiz object
    final timeLimit =
        widget.timeLimitInMinutes ?? widget.quiz?.timeLimitMinutes;

    // Set the remaining time from the widget property or start at 0 for stopwatch
    if (timeLimit != null) {
      _remainingTime = timeLimit * 60;
    } else {
      _remainingTime = 0; // Start at 0 for stopwatch mode
    }

    // Start a periodic timer
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLimit != null) {
          // Countdown mode
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            timer.cancel();
            _finishQuiz(timeUp: true); // End the quiz when time is up
          }
        } else {
          // Stopwatch mode - count up
          _remainingTime++;
        }
      });
    });
  }

  String get _formattedTime {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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

    // Haptic Feedback check
    final myAppState = context.findAncestorStateOfType<MyAppState>();
    final hapticEnabled = myAppState?.hapticEnabled ?? true;
    if (hapticEnabled) HapticFeedback.selectionClick();

    final currentQuestion = _questions[_questionIndex];
    final bool isCorrect = currentQuestion.correctAnswer == selectedAnswer;

    // Check if this is a blind mode quiz
    final isBlindMode =
        widget.customQuestions != null && widget.quiz?.isBlindMode == true;

    setState(() {
      _selectedAnswers[_questionIndex] = selectedAnswer;
      if (isCorrect) {
        if (hapticEnabled) HapticFeedback.mediumImpact();
        _currentStreak++;
        if (!isBlindMode) {
          _answerColors[selectedAnswer] = Colors.green;
        } else {
          _answerColors[selectedAnswer] = Colors.grey.shade300;
        }
      } else {
        if (hapticEnabled) HapticFeedback.heavyImpact();
        _lives--;
        if (_lives == 0) {
          _finishQuiz(outOfLives: true);
          return; // Return early to prevent further state changes
        }
        if (!isBlindMode) {
          _answerColors[selectedAnswer] = Colors.red;
          _answerColors[currentQuestion.correctAnswer] = Colors.green;
        } else {
          _answerColors[selectedAnswer] = Colors.grey;
        }
        _currentStreak = 0; // Reset streak on incorrect answer
      }
    });
  }

  void _updateAnswerColors() {
    _answerColors = {};
    final selectedAnswer = _selectedAnswers[_questionIndex];
    if (selectedAnswer != null) {
      final currentQuestion = _questions[_questionIndex];
      final isCorrect = currentQuestion.correctAnswer == selectedAnswer;

      // Check if this is a blind mode quiz
      final isBlindMode =
          widget.customQuestions != null && widget.quiz?.isBlindMode == true;

      if (!isBlindMode) {
        if (isCorrect) {
          _answerColors[selectedAnswer] = Colors.green;
        } else {
          _answerColors[selectedAnswer] = Colors.red;
          _answerColors[currentQuestion.correctAnswer] = Colors.green;
        }
      } else {
        // Blind mode: just show selection without color feedback
        _answerColors[selectedAnswer] = Colors.grey.shade300;
      }
    }
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

  void _finishQuiz({bool timeUp = false, bool outOfLives = false}) async {
    _timer?.cancel(); // Stop the timer

    // Calculate completion time
    if (_quizStartTime != null) {
      _quizCompletionTimeSeconds =
          DateTime.now().difference(_quizStartTime!).inSeconds;
    }

    // Check if any question is unanswered before finishing.
    if (!timeUp &&
        !outOfLives &&
        _selectedAnswers.any((answer) => answer == null)) {
      _showUnansweredQuestionDialog(
          'Please answer all questions before finishing.');
      return;
    }
    // Save to Leaderboard
    final leaderboardService = LeaderboardService();
    leaderboardService.addScore(LeaderboardEntry(
      playerName: 'You', // Default name for now
      score: _totalScore,
      totalQuestions: _questions.length,
      date: DateTime.now(),
      category: widget.category ?? 'General',
      difficulty: widget.difficulty.name,
    ));

    // Submit score to all user's classes
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final classService = ClassService();
        await classService.submitScoreToClasses(
          userId: currentUser.uid,
          userName: currentUser.displayName ?? 'Student',
          score: _totalScore,
          totalQuestions: _questions.length,
          category: widget.category ?? 'General',
          difficulty: widget.difficulty.name,
        );
      } catch (e) {
        debugPrint('Failed to submit score to classes: $e');
      }
    }

    // End of quiz: Navigate to results
    Navigator.pushReplacementNamed(
      context,
      '/result',
      arguments: {
        'score': _totalScore,
        'totalQuestions': _questions.length, // Pass the total here
        'difficulty': widget.difficulty,
        'category': widget.category,
        'questions': _questions,
        'selectedAnswers': _selectedAnswers,
        'quizDurationSeconds': _quizCompletionTimeSeconds,
        'isBlindMode': widget.quiz?.isBlindMode ?? false,
      },
    );
  }

  // --- This is the new Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This Scaffold is the main one for the screen
      appBar: AppBar(
          title: Row(
            children: [
              const Hero(
                tag: 'app_icon',
                child: Icon(Icons.school, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.category ?? 'Quiz App',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // const Spacer(), // Removed Spacer as Expanded takes available space
              // --- Lives Counter ---
              Row(
                children: List.generate(3, (index) {
                  return Icon(
                    index < _lives ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 20, // Reduced size
                  );
                }),
              ),
              const SizedBox(width: 16),
              // --- Animated Streak Counter ---
              if (_questions.isNotEmpty && _currentStreak > 1)
                Pulse(
                  key: ValueKey<int>(
                      _currentStreak), // Animate when streak changes
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: Colors.orange, size: 20),
                      const SizedBox(width: 4),
                      Text('$_currentStreak',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              // Always show the timer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _remainingTime <= 30
                      ? Colors.red.withValues(alpha: 0.2)
                      : _remainingTime <= 60
                          ? Colors.orange.withValues(alpha: 0.2)
                          : Colors.blue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _remainingTime <= 30
                        ? Colors.red
                        : _remainingTime <= 60
                            ? Colors.orange
                            : Colors.blue,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer,
                      color: _remainingTime <= 30
                          ? Colors.red
                          : _remainingTime <= 60
                              ? Colors.orange
                              : Colors.blue,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    TweenAnimationBuilder<double>(
                      duration: _remainingTime <= 30
                          ? const Duration(milliseconds: 500)
                          : const Duration(milliseconds: 0),
                      tween: Tween(
                          begin: 1.0, end: _remainingTime <= 30 ? 1.2 : 1.0),
                      curve: Curves.easeInOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Text(
                            _formattedTime,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _remainingTime <= 30
                                  ? Colors.red
                                  : _remainingTime <= 60
                                      ? Colors.orange
                                      : Colors.blue,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          automaticallyImplyLeading:
              false, // We are providing a custom leading widget
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the StartScreen
              Navigator.pushReplacementNamed(context, '/');
            },
            tooltip: 'Back to Start',
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              // Safely handle division by zero before questions are loaded
              value: _questions.isNotEmpty
                  ? (_questionIndex + 1) / _questions.length
                  : 0.0,
              backgroundColor:
                  Theme.of(context).primaryColor.withValues(alpha: 0.2),
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
                          // Reset state before fetching again
                          _questions = [];
                          _selectedAnswers = [];
                          _questionIndex = 0;
                          _questionFuture = _apiService.fetchQuestions(
                              difficulty: widget.difficulty,
                              category: widget.category);
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
            // This is the safest place to initialize our state from the future's data.
            // The check for `_questions.isEmpty` ensures we only do this once,
            // preventing state resets on rebuilds (e.g., from theme changes).
            if (_questions.isEmpty && (snapshot.data ?? []).isNotEmpty) {
              // Use a post-frame callback to safely update the state after the build.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _questions = snapshot.data ?? [];
                    _selectedAnswers =
                        List<String?>.filled(_questions.length, null);
                    _startTimer(); // Start timer after state is set
                  });
                }
              });
              // For this frame, show a loading indicator while we wait for the
              // post-frame callback to set the state. This prevents a flash of
              // the "No questions found" text.
              return const Center(child: CircularProgressIndicator());
            }

            // Now that we're sure we have questions, we can proceed.
            if (_questions.isEmpty) {
              return Center(child: Text('No questions found.'));
            }
            // --- This is our main Quiz UI ---
            final currentQuestion = _questions[_questionIndex];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    // Add a fade and slight slide-up effect
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    // The key is crucial for AnimatedSwitcher to detect a change
                    key: ValueKey<int>(_questionIndex),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Question ${_questionIndex + 1} of ${_questions.length}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      // Image Display
                      if (currentQuestion.imageUrl != null &&
                          currentQuestion.imageUrl!.isNotEmpty) ...[
                        Container(
                          height: 200,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              currentQuestion.imageUrl!,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.broken_image,
                                          size: 40, color: Colors.grey),
                                      Text('Image failed to load',
                                          style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
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
                      // Different UI for True/False vs Multiple Choice
                      if (currentQuestion.isTrueFalse)
                        // True/False Buttons
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ElevatedButton.icon(
                                  onPressed:
                                      _selectedAnswers[_questionIndex] != null
                                          ? null
                                          : () => _answerQuestion('True'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _answerColors['True'],
                                    disabledBackgroundColor:
                                        _answerColors['True'],
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  icon:
                                      const Icon(Icons.check_circle, size: 20),
                                  label: const Text('True',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ElevatedButton.icon(
                                  onPressed:
                                      _selectedAnswers[_questionIndex] != null
                                          ? null
                                          : () => _answerQuestion('False'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _answerColors['False'],
                                    disabledBackgroundColor:
                                        _answerColors['False'],
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  icon: const Icon(Icons.cancel, size: 20),
                                  label: const Text('False',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        // Multiple Choice Buttons
                        ...List.generate(currentQuestion.shuffledAnswers.length,
                            (index) {
                          final answer = currentQuestion.shuffledAnswers[index];
                          final buttonColor = _answerColors[answer];
                          final label =
                              String.fromCharCode('A'.codeUnitAt(0) + index);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              onPressed:
                                  _selectedAnswers[_questionIndex] != null
                                      ? null
                                      : () => _answerQuestion(answer),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                disabledBackgroundColor: buttonColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('$label. $answer',
                                    style: const TextStyle(fontSize: 16)),
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
                              onPressed: () =>
                                  _goToQuestion(_questionIndex + 1),
                              child: const Text('Next'),
                            )
                          else
                            ElevatedButton(
                              onPressed: _finishQuiz,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Finish'),
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
                            color: Theme.of(context)
                                .cardColor
                                .withValues(alpha: 0.8),
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
