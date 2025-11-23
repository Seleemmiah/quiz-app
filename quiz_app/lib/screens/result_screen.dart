import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:quiz_app/services/score_service.dart';
import 'package:quiz_app/services/statistics_service.dart';
import 'package:quiz_app/services/achievement_service.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/settings.dart';
import 'package:share_plus/share_plus.dart';
import 'package:confetti/confetti.dart';

class ResultScreen extends StatefulWidget {
  // We need to receive the score and total from the navigator
  final int score;
  final int totalQuestions;
  final Difficulty difficulty;
  final String? category;
  final List<Question> questions;
  final List<String?> selectedAnswers;
  final int? timeTaken;
  final bool isBlindMode;

  // Constructor to receive the data
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
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScoreService _scoreService = ScoreService();
  final StatisticsService _statisticsService = StatisticsService();
  final AchievementService _achievementService = AchievementService();
  int _highScore = 0;
  bool _isNewHighScore = false;
  List<Achievement> _newAchievements = [];
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    // Only show confetti and update high score if NOT in blind mode
    if (!widget.isBlindMode) {
      _updateAndLoadHighScore();
      _recordStatisticsAndCheckAchievements();

      // Trigger confetti for high scores
      final percentage = widget.totalQuestions > 0
          ? (widget.score / widget.totalQuestions) * 100
          : 0;
      if (percentage >= 80) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _confettiController.play();
        });
      }
    } else {
      // Still record statistics but maybe don't show achievements yet?
      // For now, let's record it.
      _recordStatisticsAndCheckAchievements();
    }
  }

  @override
  void dispose() {
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
    );

    // Get updated statistics for achievement checking
    final stats = await _statisticsService.getStatistics();

    // Check for new achievements
    final newAchievements = await _achievementService.checkAchievements(
      score: widget.score,
      totalQuestions: widget.totalQuestions,
      difficulty: widget.difficulty,
      category: widget.category,
      totalQuizzes: stats.totalQuizzes,
      difficultyQuizzes: stats.difficultyQuizzes,
      categoryQuizzes: stats.categoryQuizzes,
      categoryAverages: stats.categoryAverages,
    );

    if (newAchievements.isNotEmpty && mounted) {
      setState(() {
        _newAchievements = newAchievements;
      });
    }
  }

  void _shareScore() {
    final percentage = widget.totalQuestions > 0
        ? (widget.score / widget.totalQuestions) * 100
        : 0;
    final message = 'I scored ${widget.score}/${widget.totalQuestions} '
        '(${percentage.toStringAsFixed(1)}%) on the Quiz App! '
        '${widget.category != null ? "Category: ${widget.category}" : ""}';
    Share.share(message);
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
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.amber.withValues(alpha: 0.2),
                              Colors.orange.withValues(alpha: 0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber, width: 2),
                        ),
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
                                      Text(achievement.icon,
                                          style: const TextStyle(fontSize: 24)),
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

                  const SizedBox(height: 40),
                  FadeInUp(
                    delay: const Duration(milliseconds: 1200),
                    child: ElevatedButton.icon(
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
                  const SizedBox(height: 10),
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
}
