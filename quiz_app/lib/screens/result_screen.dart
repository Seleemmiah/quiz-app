import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:quiz_app/services/score_service.dart';
import 'package:quiz_app/services/statistics_service.dart';
import 'package:quiz_app/services/achievement_service.dart';
import 'package:quiz_app/models/achievement.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/settings.dart';
import 'package:confetti/confetti.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/services/share_service.dart';
import 'package:quiz_app/models/quiz_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/services/sound_service.dart';
import 'package:quiz_app/services/gamification_service.dart';
import 'package:quiz_app/services/campaign_service.dart';
import 'package:quiz_app/services/shop_service.dart';
import 'package:quiz_app/services/ai_service.dart';
import 'package:quiz_app/services/quota_service.dart';
import 'package:quiz_app/widgets/glass_card.dart';
import 'package:quiz_app/models/theme_preset.dart';

class ResultScreen extends StatefulWidget {
  // ... (existing code)
  final int score;
  final int totalQuestions;
  final Difficulty difficulty;
  final String? category;
  final List<Question> questions;
  final List<String?> selectedAnswers;
  final int? timeTaken;
  final bool isBlindMode;
  final String? levelId;
  final bool streakIncreased;
  final String? quizId;
  final bool showAnswers;
  final bool isFlashcardMode;
  final int maxStreak;
  final bool isExam;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.difficulty,
    required this.category,
    required this.questions,
    required this.selectedAnswers,
    this.timeTaken,
    this.isBlindMode = false,
    this.levelId,
    this.streakIncreased = false,
    this.quizId,
    this.showAnswers = true,
    this.isFlashcardMode = false,
    this.maxStreak = 0,
    this.isExam = false,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScoreService _scoreService = ScoreService();
  final StatisticsService _statisticsService = StatisticsService();
  final AchievementService _achievementService = AchievementService();
  final GamificationService _gamificationService = GamificationService();

  int _highScore = 0;
  bool _isNewHighScore = false;
  List<Achievement> _newAchievements = [];
  late ConfettiController _confettiController;
  final GlobalKey _shareButtonKey = GlobalKey();
  StreamSubscription? _achievementSubscription;

  // --- AI SUMMARY STATE ---
  final AIService _aiService = AIService();
  final QuotaService _quotaService = QuotaService();
  String? _aiSummary;
  bool _isGeneratingSummary = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    // Listen for new achievements
    _achievementSubscription =
        _achievementService.achievementUnlocked.listen((achievement) {
      if (mounted) {
        setState(() {
          _newAchievements.add(achievement);
        });
        // Play sound for achievement
        SoundService().playHighScoreSound();
      }
    });

    // Save result to Firestore
    _saveQuizResult();

    // Show streak celebration if applicable
    if (widget.streakIncreased) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _showStreakCelebration();
      });
    }

    // Only show confetti and update high score if NOT in blind mode
    if (!widget.isBlindMode) {
      _updateAndLoadHighScore();
      _recordStatisticsAndCheckAchievements();

      // Trigger confetti for high scores
      final percentage = widget.totalQuestions > 0
          ? (widget.score / widget.totalQuestions) * 100
          : 0;

      // Play sound based on performance
      if (percentage >= 80) {
        SoundService().playHighScoreSound();
      } else if (percentage >= 50) {
        SoundService().playAverageScoreSound();
      } else {
        SoundService().playLowScoreSound();
      }

      if (percentage >= 80) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _confettiController.play();
        });
      }

      // Update Campaign Progress
      if (widget.levelId != null) {
        CampaignService().updateProgress(
          widget.levelId!,
          widget.score,
          widget.totalQuestions,
        );
      }

      // Award Coins
      ShopService().addCoins(widget.score);
    }
  }

  Future<void> _generateAISummary() async {
    final remaining = await _quotaService.getRemainingQuota('ai_explanation');
    if (remaining <= 0) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Daily Limit Reached'),
            content: const Text(
                'You have reached your daily limit for AI-powered explanations and summaries. Please try again tomorrow!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return;
    }

    setState(() => _isGeneratingSummary = true);

    try {
      final summary = await _aiService.getExplanation(
        question: _buildSummaryPrompt(),
        correctAnswer: '', // No specific answer
        userAnswer: '', // No specific answer
      );

      if (mounted) {
        setState(() {
          _aiSummary = summary;
          _isGeneratingSummary = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isGeneratingSummary = false);
    }
  }

  String _buildSummaryPrompt() {
    final percentage = (widget.score / widget.totalQuestions) * 100;
    return "Analyze my quiz performance: I scored ${widget.score}/${widget.totalQuestions} ($percentage%) in ${widget.category}. "
        "The difficulty was ${widget.difficulty.name}. Give me a 3-sentence summary of my strengths and what topics I should focus on next based on this result.";
  }

  Future<void> _saveQuizResult() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final result = QuizResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        score: widget.score,
        totalQuestions: widget.totalQuestions,
        category: widget.category ?? 'General',
        difficulty: widget.difficulty.name,
        timeTakenSeconds: widget.timeTaken ?? 0,
        date: DateTime.now(),
        quizId: widget.quizId,
        isExam: widget.isExam,
      );

      await FirestoreService().saveQuizResult(result);
    }
  }

  @override
  void dispose() {
    _achievementSubscription?.cancel();
    _confettiController.dispose();
    super.dispose();
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

  Future<void> _recordStatisticsAndCheckAchievements() async {
    // Record statistics
    await _statisticsService.recordQuizCompletion(
      score: widget.score,
      totalQuestions: widget.totalQuestions,
      difficulty: widget.difficulty,
      category: widget.category,
      maxStreak: widget.maxStreak,
    );

    if (widget.isFlashcardMode) {
      await _statisticsService.recordFlashcardSession();
    }

    // Calculate and award XP
    final earnedXP = _gamificationService.calculateQuizXP(
      score: widget.score,
      totalQuestions: widget.totalQuestions,
      difficulty: widget.difficulty,
      completionTimeSeconds: widget.timeTaken,
    );

    // Get level before adding XP
    final xpBefore = await _gamificationService.getTotalXP();
    final levelBefore = _gamificationService.getLevel(xpBefore);

    // Add the earned XP
    await _gamificationService.addXP(earnedXP);

    // Get level after adding XP
    final xpAfter = await _gamificationService.getTotalXP();
    final levelAfter = _gamificationService.getLevel(xpAfter);

    // Check if user leveled up
    if (levelAfter > levelBefore && mounted) {
      _showLevelUpDialog(levelBefore, levelAfter);
    }

    // Get updated statistics for achievement checking
    final stats = await _statisticsService.getStatistics();

    // Get current streak
    final streak = await _achievementService.getLoginStreak();

    // Check for new achievements
    await _achievementService.checkAndUnlockAchievements(
      stats: stats,
      loginStreak: streak,
      lastScore: widget.totalQuestions > 0
          ? (widget.score / widget.totalQuestions) * 100
          : 0,
      isExam: widget.category == 'Exam',
    );
  }

  void _shareScore() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Rect? rect;

      // Try to get the rect from the share button
      final BuildContext? buttonContext = _shareButtonKey.currentContext;
      if (buttonContext != null) {
        final RenderBox? renderBox =
            buttonContext.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          final offset = renderBox.localToGlobal(Offset.zero);
          final size = renderBox.size;

          // Ensure we have valid dimensions and position
          if (size.width > 0 &&
              size.height > 0 &&
              offset.dx >= 0 &&
              offset.dy >= 0) {
            rect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
          }
        }
      }

      // If we couldn't get a valid rect, provide a fallback for iOS
      if (rect == null) {
        // Create a default rect in the center-bottom area of the screen
        // Use a safe way to get screen size
        final screenSize =
            MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
        final defaultWidth = 120.0;
        final defaultHeight = 60.0;
        rect = Rect.fromLTWH(
          (screenSize.width - defaultWidth) / 2,
          screenSize.height - 120,
          defaultWidth,
          defaultHeight,
        );
      }

      ShareService.shareQuizResult(
        quizTitle: widget.category ?? 'General Quiz',
        score: widget.score,
        totalQuestions: widget.totalQuestions,
        category: widget.category ?? 'General',
        sharePositionOrigin: rect,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBlindMode) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 80, color: Colors.green),
                const SizedBox(height: 20),
                Text(
                  'Quiz Submitted!',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your answers have been recorded.\nScores will be released by your teacher.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const Text('Return to Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final double percentage = widget.totalQuestions > 0
        ? (widget.score / widget.totalQuestions) * 100
        : 0;
    final String message = percentage >= 70
        ? 'Excellent Work!'
        : percentage >= 40
            ? 'Good Effort!'
            : 'Keep Practicing!';

    return Scaffold(
      body: Stack(
        children: [
          Center(
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
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                    child: Column(
                      children: [
                        Text(
                          '${widget.score} / ${widget.totalQuestions}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: percentage >= 70
                                    ? Colors.green
                                    : (percentage >= 40
                                        ? Colors.orange
                                        : Colors.red),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: percentage >= 70
                                    ? Colors.green
                                    : (percentage >= 40
                                        ? Colors.orange
                                        : Colors.red),
                              ),
                        ),
                      ],
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

                  // New Achievements
                  if (_newAchievements.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    FadeIn(
                      delay: const Duration(milliseconds: 1000),
                      child: GlassCard(
                        borderColor: Colors.amber.withOpacity(0.5),
                        borderWidth: 2,
                        child: Column(
                          children: [
                            Text(
                              '🎉 New Achievement${_newAchievements.length > 1 ? 's' : ''} Unlocked! 🎉',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ..._newAchievements.map((achievement) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(achievement.icon,
                                          size: 24, color: achievement.color),
                                      const SizedBox(width: 8),
                                      Text(
                                        achievement.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  if (_aiSummary != null)
                    FadeIn(
                      child: GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.psychology,
                                      color: Colors.blue, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'AI Brain Summary 🧠',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _aiSummary!,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (_aiSummary == null &&
                      !widget.isExam &&
                      !widget.isBlindMode)
                    FadeInUp(
                      child: TextButton.icon(
                        onPressed:
                            _isGeneratingSummary ? null : _generateAISummary,
                        icon: _isGeneratingSummary
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.auto_awesome, size: 18),
                        label: Text(_isGeneratingSummary
                            ? 'Analyzing Performance...'
                            : 'Get AI Performance Analysis'),
                      ),
                    ),

                  const SizedBox(height: 40),
                  FadeInUp(
                    delay: const Duration(milliseconds: 1200),
                    child: ElevatedButton.icon(
                      key: _shareButtonKey,
                      icon: const Icon(Icons.share),
                      label: const Text('Share Score'),
                      onPressed: _shareScore,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    delay: const Duration(milliseconds: 1200),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Restart Quiz'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
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
                  // Only show Review Answers button if showAnswers is true
                  if (widget.showAnswers)
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
                  // Show message for students when answers are hidden
                  if (!widget.showAnswers)
                    FadeInUp(
                      delay: const Duration(milliseconds: 1400),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your submission has been recorded. Your teacher will review your answers.',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Confetti Widget
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStreakCelebration() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_fire_department,
                      color: Colors.orange, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Streak Increased!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Keep it up!',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLevelUpDialog(int oldLevel, int newLevel) {
    // Play confetti for level up
    _confettiController.play();

    // Check if any themes were unlocked
    final unlockedThemes = ThemePreset.presets
        .where((theme) => theme.unlockLevel == newLevel)
        .toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Level up icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_upward,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              // Level up text
              const Text(
                '🎉 LEVEL UP! 🎉',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Text(
                'Level $oldLevel → Level $newLevel',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Unlocked themes
              if (unlockedThemes.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_open, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'New Theme Unlocked!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...unlockedThemes.map((theme) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              '${theme.emoji} ${theme.name}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Motivational message
              Text(
                'Keep up the great work!',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Awesome!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
