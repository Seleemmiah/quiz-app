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
import 'package:quiz_app/services/shop_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/widgets/question_display.dart';
import 'package:quiz_app/services/sound_service.dart';
import 'package:quiz_app/services/mistakes_service.dart';
import 'package:quiz_app/services/voice_service.dart';
import 'package:quiz_app/services/streak_service.dart';
import 'package:quiz_app/services/professional_notification_service.dart';
import 'package:quiz_app/screens/video_player_screen.dart';
import 'package:quiz_app/widgets/handwriting_input_widget.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:quiz_app/services/exam_session_service.dart';
import 'package:quiz_app/services/scalable_firestore_service.dart';
import 'package:quiz_app/widgets/glass_dialog.dart';
import 'package:quiz_app/services/ai_service.dart';
import 'package:quiz_app/services/spaced_repetition_service.dart';
import 'package:quiz_app/services/statistics_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    this.difficulty = Difficulty.easy,
    this.category,
    this.timeLimitInMinutes,
    this.quizLength = 10,
    this.customQuestions,
    this.quiz,
    this.isDailyChallenge = false,
    this.levelId,
    this.isExamMode = false,
    this.isSpacedRepetition = false,
  });
  final Difficulty difficulty;
  final String? category;
  final int? timeLimitInMinutes;
  final int quizLength;
  final List<Question>? customQuestions;
  final Quiz?
      quiz; // Quiz object for custom quizzes (to access isBlindMode, timeLimitMinutes)
  final bool isDailyChallenge;
  final String? levelId; // For Campaign Mode
  final bool isExamMode; // New: Enable anti-cheating measures
  final bool isSpacedRepetition; // New: For Memory Refresh mission

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

  // --- ANTI-CHEATING STATE ---
  int _violationCount = 0;
  static const int _maxViolations = 3;

  // --- VISUAL FEEDBACK STATE ---
  Map<String, Color> _answerColors = {};

  // --- TIMER STATE ---
  Timer? _timer;
  final ValueNotifier<int> _remainingTimeNotifier = ValueNotifier<int>(0);
  int _remainingTime = 0;

  // --- STREAK STATE ---
  int _currentStreak = 0;
  int _maxStreak = 0;

  // --- LIVES STATE ---
  int _lives = 3;

  // --- TIME TRACKING ---
  DateTime? _quizStartTime;
  int? _quizCompletionTimeSeconds;

  final QuizStateService _quizStateService = QuizStateService();
  final ExamSessionService _examSessionService = ExamSessionService();
  final ScalableFirestoreService _scalableFirestore =
      ScalableFirestoreService();

  // --- VOICE MODE STATE ---
  bool _isVoiceMode = false;
  final VoiceService _voiceService = VoiceService();
  final AIService _aiService = AIService();
  final SpacedRepetitionService _srService = SpacedRepetitionService();

  // --- LEARNING MODE STATE ---
  bool _isFlashcardMode = false;
  bool _showExplanation = false;
  String? _explanationText;
  bool _isLoadingExplanation = false;

  // --- POWER-UPS STATE ---
  final ShopService _shopService = ShopService();
  Map<String, int> _ownedPowerUps = {};
  final List<String> _hiddenAnswers = [];
  bool _isUsingPowerUp = false;

  Future<void> _toggleVoiceMode() async {
    setState(() {
      _isVoiceMode = !_isVoiceMode;
    });

    if (_isVoiceMode) {
      await _voiceService.initialize();
      _readCurrentQuestion();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice Mode Enabled 🎙️'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      _voiceService.stop();
    }
  }

  Future<void> _readCurrentQuestion() async {
    if (!_isVoiceMode || _questions.isEmpty) return;

    final question = _questions[_questionIndex];

    // Construct text to read
    final sb = StringBuffer();
    sb.write("Question ${_questionIndex + 1}. ");
    sb.write(question.question);
    sb.write(". ");

    // Read options
    final options = question.shuffledAnswers;
    sb.write("Option A. ${options[0]}. ");
    sb.write("Option B. ${options[1]}. ");
    if (options.length > 2) sb.write("Option C. ${options[2]}. ");
    if (options.length > 3) sb.write("Option D. ${options[3]}. ");

    await _voiceService.speak(sb.toString());
    StatisticsService().recordTTSUsage();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Enable Screen Protection and Session Management for Exam Mode
    if (widget.isExamMode) {
      _initializeExamMode();
    } else {
      _loadPowerUps();
    }

    if (widget.customQuestions != null && widget.customQuestions!.isNotEmpty) {
      _questionFuture = Future.value(widget.customQuestions);
    } else if (widget.isSpacedRepetition) {
      _questionFuture = _srService.getDueQuestions();
    } else {
      _questionFuture = _apiService.fetchQuestions(
          amount: widget.quizLength,
          difficulty: widget.difficulty,
          category: widget.category);
    }
  }

  Future<void> _initializeExamMode() async {
    // Enable screen protection
    await _enableScreenProtection();

    // Start exam session with device fingerprint validation
    final sessionStarted = await _examSessionService.startExamSession(
      examId:
          widget.quiz?.id ?? 'exam_${DateTime.now().millisecondsSinceEpoch}',
      quizId: widget.quiz?.id,
    );

    if (!sessionStarted) {
      // Session blocked - concurrent access detected
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                '⚠️ Concurrent exam session detected! You cannot take this exam on multiple devices.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _enableScreenProtection() async {
    // Prevent screenshots and screen recording (Android)
    await ScreenProtector.preventScreenshotOn();
    // Protect data leakage (iOS - blurs screen in background)
    await ScreenProtector.protectDataLeakageOn();
  }

  Future<void> _disableScreenProtection() async {
    await ScreenProtector.preventScreenshotOff();
    await ScreenProtector.protectDataLeakageOff();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel(); // Always cancel timers when the widget is removed
    _voiceService.stop(); // Stop speaking

    // Disable Screen Protection and End Exam Session
    if (widget.isExamMode) {
      _disableScreenProtection();
      _examSessionService.endExamSession(
        examId: widget.quiz?.id ?? '',
      );
    }

    // Dispose services
    _examSessionService.dispose();

    _remainingTimeNotifier.dispose();

    // Save state if quiz is incomplete
    if (_questions.isNotEmpty && !_selectedAnswers.every((a) => a != null)) {
      _saveQuizState();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Only enforce anti-cheating in Exam Mode
    if (!widget.isExamMode) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      // Increment violation count
      _violationCount++;

      if (_violationCount >= _maxViolations) {
        // Auto-submit if max violations reached
        if (mounted) {
          _finishQuiz(timeUp: false, outOfLives: false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Exam submitted due to multiple violations! 🚫'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
      } else {
        // Show warning dialog when they return
        // We can't show dialog while in background, so we set a flag or show it on resume
        // But since we are in 'paused', we can prepare to show it when 'resumed'
      }
    } else if (state == AppLifecycleState.resumed) {
      // Show warning if violation occurred
      if (_violationCount > 0 && _violationCount < _maxViolations) {
        _showCheatingWarning();
      }
    }
  }

  void _showCheatingWarning() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Warning: Exam Violation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded,
                size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'You left the exam app! This has been recorded.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            const SizedBox(height: 12),
            Text(
              'Strike $_violationCount of $_maxViolations',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you leave again, your exam will be automatically submitted.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadPowerUps() async {
    final powerups = await _shopService.getOwnedPowerUps();
    if (mounted) {
      setState(() {
        _ownedPowerUps = powerups;
      });
    }
  }

  Future<void> _usePowerUp(String id) async {
    if (_isUsingPowerUp) return;
    if ((_ownedPowerUps[id] ?? 0) <= 0) return;

    setState(() => _isUsingPowerUp = true);

    final success = await _shopService.usePowerUp(id);
    if (success) {
      if (mounted) {
        setState(() {
          _ownedPowerUps[id] = (_ownedPowerUps[id] ?? 1) - 1;
          _isUsingPowerUp = false;
        });

        // Apply effect
        _applyPowerUpEffect(id);
      }
    } else {
      if (mounted) setState(() => _isUsingPowerUp = false);
    }
  }

  void _applyPowerUpEffect(String id) {
    switch (id) {
      case '50:50':
        final currentQuestion = _questions[_questionIndex];
        final wrongAnswers = currentQuestion.shuffledAnswers
            .where((a) => a != currentQuestion.correctAnswer)
            .toList();
        wrongAnswers.shuffle();
        setState(() {
          _hiddenAnswers.addAll(wrongAnswers.take(2));
        });
        break;
      case 'Extra Time':
        setState(() {
          _remainingTime += 30; // Add 30 seconds
          _remainingTimeNotifier.value = _remainingTime;
        });
        break;
      case 'Skip':
        _goToQuestion(_questionIndex + 1);
        break;
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
      if (timeLimit != null) {
        // Countdown mode
        if (_remainingTime > 0) {
          _remainingTime--;
          _remainingTimeNotifier.value = _remainingTime;
        } else {
          timer.cancel();
          _finishQuiz(timeUp: true); // End the quiz when time is up
        }
      } else {
        // Stopwatch mode - count up
        _remainingTime++;
        _remainingTimeNotifier.value = _remainingTime;
      }
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
        if (hapticEnabled) {
          HapticFeedback.lightImpact(); // Gentle vibration for correct
        }
        SoundService().playCorrectSound(); // Play correct sound
        _currentStreak++;
        if (_currentStreak > _maxStreak) {
          _maxStreak = _currentStreak;
        }
        if (!isBlindMode) {
          _answerColors[selectedAnswer] = Colors.green;
        } else {
          _answerColors[selectedAnswer] = Colors.grey.shade300;
        }
      } else {
        _currentStreak = 0;
        if (hapticEnabled) HapticFeedback.heavyImpact();
        SoundService().playWrongSound(); // Play wrong sound

        // Save to Spaced Repetition Service (Cloud Synced)
        _srService.recordReview(currentQuestion, false);

        // Also save to legacy Mistakes Bank for compatibility
        MistakesService().addMistake(currentQuestion);

        _lives--;
        if (_lives == 0) {
          // Immediately finish quiz without showing explanation
          // Use Future.microtask to ensure this happens after the build cycle
          Future.microtask(() => _finishQuiz(outOfLives: true));
          return;
        }
        if (!isBlindMode) {
          _answerColors[selectedAnswer] = Colors.red;
          _answerColors[currentQuestion.correctAnswer] = Colors.green;
        } else {
          _answerColors[selectedAnswer] = Colors.grey;
        }
        _currentStreak = 0; // Reset streak on incorrect answer
      }

      // Record positive review if correct
      if (isCorrect) {
        _srService.recordReview(currentQuestion, true);
      }

      // Automatically fetch AI explanation for incorrect answers
      if (!isCorrect && !widget.isExamMode) {
        _fetchAIExplanation(selectedAnswer);
      }
      StatisticsService().recordManualExplanationRead();
    });
  }

  Future<void> _fetchAIExplanation(String userAnswer) async {
    setState(() {
      _isLoadingExplanation = true;
      _showExplanation = true;
      _explanationText = null;
    });

    try {
      final question = _questions[_questionIndex];
      final explanation = await _aiService.getExplanation(
        question: question.question,
        correctAnswer: question.correctAnswer,
        userAnswer: userAnswer,
      );
      if (mounted) {
        setState(() {
          _explanationText = explanation;
          _isLoadingExplanation = false;
        });
        StatisticsService().recordAIExplanationRead();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _explanationText =
              "Could not load tutoring explanation at this time.";
          _isLoadingExplanation = false;
        });
      }
    }
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
      _hiddenAnswers.clear(); // Clear hidden answers for new question
      _updateAnswerColors();
    });

    // Read the new question if voice mode is enabled
    _voiceService.stop(); // Stop reading previous question
    _readCurrentQuestion();
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

    final currentUser = FirebaseAuth.instance.currentUser;
    final String category = widget.category ?? 'General';
    final String difficulty = widget.difficulty.name;

    // Save to Leaderboard (Background)
    LeaderboardService().addScore(LeaderboardEntry(
      playerName: 'You',
      score: _totalScore,
      totalQuestions: _questions.length,
      date: DateTime.now(),
      category: category,
      difficulty: difficulty,
    ));

    // Submit score to classes (Background)
    if (currentUser != null) {
      ClassService()
          .submitScoreToClasses(
            userId: currentUser.uid,
            userName: currentUser.displayName ?? 'Student',
            score: _totalScore,
            totalQuestions: _questions.length,
            category: category,
            difficulty: difficulty,
            isExam: widget.isExamMode,
          )
          .catchError((e) => debugPrint('Class score submission error: $e'));
    }

    // Record Streak Activity (Wait for this as it's quick and needed for ResultScreen)
    final streakService = StreakService();
    final bool streakIncreased = await streakService.recordActivity();

    // Send Notification (Background)
    if (currentUser != null) {
      final notificationService = ProfessionalNotificationService();
      notificationService
          .sendQuizScoreNotification(
            userId: currentUser.uid,
            score: _totalScore,
            totalQuestions: _questions.length,
            quizTitle: category,
          )
          .catchError((e) => debugPrint('Notification error: $e'));

      if (_totalScore == _questions.length) {
        notificationService
            .sendPerfectScoreNotification(
              userId: currentUser.uid,
              quizTitle: category,
            )
            .catchError(
                (e) => debugPrint('Perfect score notification error: $e'));
      }
    }

    // End of quiz: Navigate to results
    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      '/result',
      arguments: {
        'score': _totalScore,
        'totalQuestions': _questions.length,
        'difficulty': widget.difficulty,
        'category': widget.category,
        'questions': _questions,
        'selectedAnswers': _selectedAnswers,
        'timeTaken': _quizCompletionTimeSeconds, // Note: param name check
        'isBlindMode': widget.quiz?.isBlindMode ?? false,
        'levelId': widget.levelId,
        'streakIncreased': streakIncreased,
        'quizId': widget.quiz?.id,
        'showAnswers': widget.quiz?.resultsReleased ?? true,
        'isFlashcardMode': _isFlashcardMode,
        'maxStreak': _maxStreak,
        'isExam': widget.isExamMode,
      },
    );
  }

  void _handleHandwritingInput(String text) {
    StatisticsService().recordHandwritingUsage();
    final cleanText = text.trim().toUpperCase();
    if (_questions.isEmpty) return;
    final question = _questions[_questionIndex];

    int? selectedIndex;
    if (cleanText == 'A') {
      selectedIndex = 0;
    } else if (cleanText == 'B')
      selectedIndex = 1;
    else if (cleanText == 'C')
      selectedIndex = 2;
    else if (cleanText == 'D')
      selectedIndex = 3;
    else if (cleanText == 'T' || cleanText == 'TRUE') {
      // Handle True/False
      if (question.isTrueFalse) {
        _answerQuestion('True');
        Navigator.pop(context);
      }
      return;
    } else if (cleanText == 'F' || cleanText == 'FALSE') {
      if (question.isTrueFalse) {
        _answerQuestion('False');
        Navigator.pop(context);
      }
      return;
    }

    if (selectedIndex != null &&
        selectedIndex < question.shuffledAnswers.length) {
      final answer = question.shuffledAnswers[selectedIndex];
      _answerQuestion(answer);
      Navigator.pop(context); // Close sheet

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Selected Option $cleanText via Handwriting! ✍️')),
      );
    }
  }

  // --- This is the new Build Method ---
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        // Show confirmation dialog before leaving
        final shouldPop = await GlassDialog.show<bool>(
          context: context,
          title: widget.isExamMode ? 'Submit Exam?' : 'Leave Quiz?',
          content: Text(
            widget.isExamMode
                ? 'You cannot pause an exam. Leaving will submit your current answers.'
                : 'Are you sure you want to leave? Your progress will be saved.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                widget.isExamMode ? 'Submit' : 'Leave',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );

        if (shouldPop == true) {
          if (widget.isExamMode) {
            // For exam mode, submit instead of just leaving
            _finishQuiz(timeUp: false, outOfLives: false);
          } else {
            if (mounted) {
              Navigator.of(context).pop();
            }
          }
        }
      },
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
              bottom:
                  60.0), // Move up to avoid overlapping with navigation if any
          child: FloatingActionButton(
            onPressed: _toggleVoiceMode,
            backgroundColor:
                _isVoiceMode ? Theme.of(context).primaryColor : Colors.grey,
            mini: true,
            child: Icon(_isVoiceMode ? Icons.volume_up : Icons.volume_off,
                color: Colors.white),
          ),
        ),
        // This Scaffold is the main one for the screen
        appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Scratchpad',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        height: 400,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('Scratchpad & Handwriting Input',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            Expanded(
                              child: HandwritingInputWidget(
                                onRecognized: (text) {
                                  _handleHandwritingInput(text);
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Hero(
                    tag: 'app_icon',
                    child: Icon(Icons.school, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: 80, maxWidth: 120),
                    child: Text(
                      widget.category ?? 'Mindly',
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
                        size: 18, // Further reduced size
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  // --- Animated Streak Counter ---
                  if (_questions.isNotEmpty && _currentStreak > 1)
                    Pulse(
                      key: ValueKey<int>(
                          _currentStreak), // Animate when streak changes
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department,
                              color: Colors.orange, size: 18),
                          const SizedBox(width: 2),
                          Text('$_currentStreak',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  // Always show the timer
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: _remainingTime <= 30
                          ? Colors.red.withOpacity(0.2)
                          : _remainingTime <= 60
                              ? Colors.orange.withOpacity(0.2)
                              : Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _remainingTime <= 30
                            ? Colors.red
                            : _remainingTime <= 60
                                ? Colors.orange
                                : Colors.blue,
                        width: 1.5,
                      ),
                    ),
                    child: ValueListenableBuilder<int>(
                      valueListenable: _remainingTimeNotifier,
                      builder: (context, time, child) {
                        final color = time <= 30
                            ? Colors.red
                            : time <= 60
                                ? Colors.orange
                                : Colors.blue;
                        final minutes = (time ~/ 60).toString().padLeft(2, '0');
                        final seconds = (time % 60).toString().padLeft(2, '0');
                        final formattedTime = '$minutes:$seconds';

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              color: color,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            TweenAnimationBuilder<double>(
                              duration: time <= 30
                                  ? const Duration(milliseconds: 500)
                                  : Duration.zero,
                              tween: Tween(
                                  begin: 1.0, end: time <= 30 ? 1.1 : 1.0),
                              curve: Curves.easeInOut,
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Flashcard Mode Toggle
                  if (!widget.isExamMode)
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Center(
                        child: Tooltip(
                          message: 'Flashcard Mode',
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isFlashcardMode = !_isFlashcardMode;
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _isFlashcardMode
                                    ? Colors.orange.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _isFlashcardMode
                                      ? Colors.orange
                                      : Colors.blue.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.style,
                                    size: 14,
                                    color: _isFlashcardMode
                                        ? Colors.orange
                                        : Colors.blue,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Flash',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _isFlashcardMode
                                          ? Colors.orange
                                          : Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            automaticallyImplyLeading:
                false, // We are providing a custom leading widget
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                // Show confirmation dialog before leaving
                final shouldLeave = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Leave Quiz?'),
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

                if (shouldLeave == true && context.mounted) {
                  // Navigate back to the StartScreen
                  Navigator.pushReplacementNamed(context, '/home');
                }
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
                    Theme.of(context).primaryColor.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
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
                    child: _isFlashcardMode
                        ? _buildFlashcardView(currentQuestion)
                        : _buildStandardQuizView(currentQuestion),
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
      ), // Close WillPopScope child (Scaffold)
    ); // Close WillPopScope
  }

  Widget _buildFlashcardView(Question question) {
    return Column(
      key: ValueKey<String>('flash_${_questionIndex}_$_showExplanation'),
      children: [
        FadeInDown(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showExplanation = !_showExplanation;
              });
            },
            child: AspectRatio(
              aspectRatio: 0.8,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: _showExplanation
                        ? Colors.blue.shade200
                        : Colors.orange.shade200,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _showExplanation ? 'ANSWER 🧠' : 'QUESTION 📝',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _showExplanation ? Colors.blue : Colors.orange,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Text(
                              _showExplanation
                                  ? question.correctAnswer
                                  : question.question,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      if (!_showExplanation)
                        const Text(
                          'Tap to reveal answer',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      if (_showExplanation && question.explanation != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            question.explanation!,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        if (_showExplanation)
          FadeInUp(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFlashcardFeedbackButton(
                  icon: Icons.refresh,
                  label: 'Again',
                  color: Colors.red,
                  onTap: () {
                    _srService.recordReview(question, false);
                    _goToQuestion((_questionIndex + 1) % _questions.length);
                  },
                ),
                _buildFlashcardFeedbackButton(
                  icon: Icons.check,
                  label: 'Got it',
                  color: Colors.green,
                  onTap: () {
                    _srService.recordReview(question, true);
                    _goToQuestion((_questionIndex + 1) % _questions.length);
                  },
                ),
              ],
            ),
          )
        else
          const Text(
            'Think about the answer before tapping!',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
      ],
    );
  }

  Widget _buildFlashcardFeedbackButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardQuizView(Question currentQuestion) {
    return Column(
      key: ValueKey<int>(_questionIndex),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Question ${_questionIndex + 1} of ${_questions.length}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        QuestionDisplay(
          questionText: currentQuestion.question,
          imageUrl: currentQuestion.imageUrl,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        if (currentQuestion.isTrueFalse)
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: _selectedAnswers[_questionIndex] != null
                        ? null
                        : () => _answerQuestion('True'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _answerColors['True'],
                      disabledBackgroundColor: _answerColors['True'],
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(Icons.check_circle, size: 20),
                    label: const Text('True', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: _selectedAnswers[_questionIndex] != null
                        ? null
                        : () => _answerQuestion('False'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _answerColors['False'],
                      disabledBackgroundColor: _answerColors['False'],
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(Icons.cancel, size: 20),
                    label: const Text('False', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          )
        else
          ...List.generate(currentQuestion.shuffledAnswers.length, (index) {
            final answer = currentQuestion.shuffledAnswers[index];
            if (_hiddenAnswers.contains(answer)) return const SizedBox.shrink();

            final buttonColor = _answerColors[answer];
            final label = String.fromCharCode('A'.codeUnitAt(0) + index);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _selectedAnswers[_questionIndex] != null
                    ? null
                    : () => _answerQuestion(answer),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  disabledBackgroundColor: buttonColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text('$label. ', style: const TextStyle(fontSize: 16)),
                      Expanded(
                        child: QuestionDisplay(
                          questionText: answer,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        if (_showExplanation && !widget.isExamMode)
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: Container(
              margin: const EdgeInsets.only(top: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'AI Tutor Explanation',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_isLoadingExplanation)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else
                    Text(
                      _explanationText ?? '',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          height: 1.4),
                    ),
                ],
              ),
            ),
          ),
        if (_selectedAnswers[_questionIndex] != null &&
            currentQuestion.videoUrl != null &&
            currentQuestion.videoUrl!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(
                      videoUrl: currentQuestion.videoUrl!,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_circle_fill),
              label: const Text('Watch Explanation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        const SizedBox(height: 20),
        if (!widget.isExamMode) _buildPowerUpBar(),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _questionIndex > 0
                  ? () => _goToQuestion(_questionIndex - 1)
                  : null,
              child: const Text('Previous'),
            ),
            if (_questionIndex < _questions.length - 1)
              ElevatedButton(
                onPressed: () => _goToQuestion(_questionIndex + 1),
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
                QuestionDisplay(
                  questionText: currentQuestion.explanation ??
                      'No explanation available for this question.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ))
        ],
      ],
    );
  }

  Widget _buildPowerUpBar() {
    final powerUps = [
      {'id': '50:50', 'icon': Icons.exposure_minus_1, 'color': Colors.orange},
      {'id': 'Extra Time', 'icon': Icons.timer, 'color': Colors.blue},
      {'id': 'Skip', 'icon': Icons.skip_next, 'color': Colors.purple},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: powerUps.map((pu) {
          final count = _ownedPowerUps[pu['id']] ?? 0;
          final isAvailable = count > 0;
          final color = pu['color'] as Color;

          return InkWell(
            onTap: isAvailable ? () => _usePowerUp(pu['id'] as String) : null,
            child: Opacity(
              opacity: isAvailable ? 1.0 : 0.3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(pu['icon'] as IconData, color: color, size: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pu['id']} ($count)',
                    style: TextStyle(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
