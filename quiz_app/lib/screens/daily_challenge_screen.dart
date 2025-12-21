import 'package:flutter/material.dart';
import 'package:quiz_app/models/daily_challenge.dart';
import 'package:quiz_app/models/streak_data.dart';
import 'package:quiz_app/services/daily_challenge_service.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/settings.dart';

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  final DailyChallengeService _challengeService = DailyChallengeService();
  DailyChallenge? _todaysChallenge;
  StreakData? _streakData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final challenge = await _challengeService.getTodaysChallenge();
    final streak = await _challengeService.getStreakData();

    setState(() {
      _todaysChallenge = challenge;
      _streakData = streak;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Challenge'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _todaysChallenge == null
              ? _buildErrorState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildStreakCard(),
                      const SizedBox(height: 20),
                      _buildChallengeCard(),
                      const SizedBox(height: 20),
                      if (!_todaysChallenge!.isCompleted) _buildStartButton(),
                      if (_todaysChallenge!.isCompleted) _buildCompletionCard(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStreakCard() {
    final streak = _streakData!;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_fire_department,
                    color: Colors.white, size: 40),
                const SizedBox(width: 12),
                Text(
                  '${streak.currentStreak} Day Streak',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStreakStat(
                  'Longest',
                  '${streak.longestStreak} days',
                  Icons.emoji_events,
                ),
                _buildStreakStat(
                  'Completed',
                  '${streak.totalChallengesCompleted}',
                  Icons.check_circle,
                ),
                _buildStreakStat(
                  'Bonus Points',
                  '${streak.totalBonusPointsEarned}',
                  Icons.star,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeCard() {
    final challenge = _todaysChallenge!;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Challenge',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        challenge.category,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildChallengeDetail(
              Icons.quiz,
              'Questions',
              '${challenge.questionCount} questions',
            ),
            const SizedBox(height: 12),
            _buildChallengeDetail(
              Icons.track_changes,
              'Target Score',
              '${challenge.targetScore}% accuracy',
            ),
            const SizedBox(height: 12),
            _buildChallengeDetail(
              Icons.star,
              'Bonus Reward',
              '+${challenge.bonusPoints} points',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeDetail(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton(
      onPressed: _startChallenge,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Start Challenge',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCompletionCard() {
    final challenge = _todaysChallenge!;
    final isSuccess = challenge.isSuccessful;

    return Card(
      elevation: 4,
      color: isSuccess ? Colors.green.shade50 : Colors.orange.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.info,
              color: isSuccess ? Colors.green : Colors.orange,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              isSuccess ? 'Challenge Completed!' : 'Challenge Attempted',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:
                    isSuccess ? Colors.green.shade700 : Colors.orange.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your Score: ${challenge.userScore}%',
              style: const TextStyle(fontSize: 18),
            ),
            if (isSuccess) ...[
              const SizedBox(height: 8),
              Text(
                '+${challenge.bonusPoints} Bonus Points Earned!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Come back tomorrow for a new challenge!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Unable to load challenge',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _startChallenge() async {
    if (_todaysChallenge == null) return;

    // Navigate to quiz screen with challenge questions
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          category: _todaysChallenge!.category,
          difficulty: Difficulty.medium,
          quizLength: _todaysChallenge!.questionCount,
          isDailyChallenge: true,
        ),
      ),
    );

    // Reload data after completing challenge
    if (result != null && mounted) {
      _loadData();
    }
  }
}
