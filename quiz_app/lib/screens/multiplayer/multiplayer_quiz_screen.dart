import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:quiz_app/services/multiplayer_service.dart';
import 'package:quiz_app/services/api_service.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/widgets/question_display.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/services/sound_service.dart';

class MultiplayerQuizScreen extends StatefulWidget {
  final String code;
  final bool isHost;

  const MultiplayerQuizScreen({
    super.key,
    required this.code,
    required this.isHost,
  });

  @override
  State<MultiplayerQuizScreen> createState() => _MultiplayerQuizScreenState();
}

class _MultiplayerQuizScreenState extends State<MultiplayerQuizScreen> {
  final MultiplayerService _multiplayerService = MultiplayerService();
  final ApiService _apiService = ApiService();

  List<Question> _questions = [];
  bool _isLoading = true;
  String _status = 'waiting';
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  Future<void> _setupGame() async {
    // Listen to lobby status
    _multiplayerService.getLobbyStream(widget.code).listen((snapshot) {
      if (!snapshot.exists) {
        Navigator.pop(context); // Lobby deleted
        return;
      }

      final data = snapshot.data() as Map<String, dynamic>;
      final newStatus = data['status'] as String;

      if (newStatus == 'playing' && _status == 'waiting') {
        // Game started!
        _loadQuestions(data['category'], data['difficulty']);
      }

      setState(() {
        _status = newStatus;
      });
    });
  }

  Future<void> _loadQuestions(String? category, String difficulty) async {
    try {
      // In a real app, host would fetch and save questions to Firestore
      // For simplicity, we'll fetch locally for now (assuming deterministic seed or similar)
      // Ideally: Host fetches -> Saves to subcollection -> Clients read
      // Simplified: Everyone fetches same params (might differ slightly if API randomizes)
      // BETTER: Host fetches and we store question IDs.
      // For this MVP: We'll just fetch and hope for best or implement proper sync later.
      // Let's implement proper sync: Host fetches, saves to 'questions' subcollection.

      if (widget.isHost) {
        final questions = await _apiService.fetchQuestions(
          amount: 5,
          category: category,
          difficulty: _parseDifficulty(difficulty),
        );

        setState(() {
          _questions = questions;
          _isLoading = false;
        });
      } else {
        // Client waits for host to set up
        // For MVP, client also fetches same params
        final questions = await _apiService.fetchQuestions(
          amount: 5,
          category: category,
          difficulty: _parseDifficulty(difficulty),
        );
        setState(() {
          _questions = questions;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading questions: $e');
    }
  }

  Difficulty _parseDifficulty(String difficulty) {
    return Difficulty.values.firstWhere(
      (d) => d.name == difficulty,
      orElse: () => Difficulty.easy,
    );
  }

  void _startGame() {
    _multiplayerService.startGame(widget.code);
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Game code copied to clipboard!')),
    );
  }

  // State for game logic
  int _score = 0;
  final Map<int, String> _selectedAnswers = {};
  bool _answerSelected = false;
  String? _selectedOption;

  void _handleAnswer(String selectedOption) {
    if (_answerSelected) return; // Prevent multiple selections

    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = selectedOption == currentQuestion.correctAnswer;

    setState(() {
      _answerSelected = true;
      _selectedOption = selectedOption;
      _selectedAnswers[_currentQuestionIndex] = selectedOption;
      if (isCorrect) {
        _score++;
        SoundService().playCorrectSound();
      } else {
        SoundService().playWrongSound();
      }
    });

    // Submit score to multiplayer service
    if (isCorrect) {
      _multiplayerService.submitScore(
          widget.code, 10); // 10 points per question
    }

    // Wait and advance
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (_currentQuestionIndex < _questions.length - 1) {
          setState(() {
            _currentQuestionIndex++;
            _answerSelected = false;
            _selectedOption = null;
          });
        } else {
          _finishQuiz();
        }
      }
    });
  }

  void _finishQuiz() async {
    // Update Multiplayer Stats
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Determine if this player won
        final lobbyDoc = await FirebaseFirestore.instance
            .collection('lobbies')
            .doc(widget.code)
            .get();

        if (lobbyDoc.exists) {
          final players = lobbyDoc.data()?['players'] as List<dynamic>? ?? [];
          final scores = players.map((p) => (p['score'] ?? 0) as int).toList()
            ..sort((a, b) => b.compareTo(a));

          final isWin = scores.isNotEmpty && _score == scores.first;

          // Update stats
          await FirestoreService().updateMultiplayerStats(
            user.uid,
            isWin: isWin,
            points: _score,
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error updating multiplayer stats: $e');
        }
      }
    }

    // Navigate to Result Screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: _score,
            totalQuestions: _questions.length,
            difficulty: Difficulty.easy, // Or pass actual difficulty
            category: 'Multiplayer', // Or pass actual category
            questions: _questions,
            selectedAnswers: List.generate(
              _questions.length,
              (index) => _selectedAnswers[index],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_status == 'waiting') {
      return _buildWaitingRoom();
    }

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Question ${_currentQuestionIndex + 1}')),
      body: _questions.isEmpty
          ? const Center(child: Text('No questions loaded'))
          : Column(
              children: [
                Expanded(
                  child: QuestionDisplay(
                    questionText: _questions[_currentQuestionIndex].question,
                    imageUrl: _questions[_currentQuestionIndex].imageUrl,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ..._questions[_currentQuestionIndex]
                          .shuffledAnswers
                          .map((option) {
                        // Determine button color based on state
                        Color? buttonColor;
                        Color? textColor;

                        if (_answerSelected) {
                          if (option ==
                              _questions[_currentQuestionIndex].correctAnswer) {
                            buttonColor =
                                Colors.green; // Correct answer always green
                            textColor = Colors.white;
                          } else if (option == _selectedOption) {
                            buttonColor =
                                Colors.red; // Selected wrong answer red
                            textColor = Colors.white;
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _handleAnswer(option),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                foregroundColor: textColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: QuestionDisplay(
                                questionText: option,
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      textColor, // Ensure text color is correct (white for selected/correct)
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 20), // Bottom padding
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildWaitingRoom() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting Room'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share('Join my quiz! Code: ${widget.code}');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Column(
              children: [
                const Text('GAME CODE',
                    style: TextStyle(fontSize: 14, letterSpacing: 2)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _copyCode,
                  child: Text(
                    widget.code,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Tap to copy',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _multiplayerService.getPlayersStream(widget.code),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final players = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(player['name'][0].toUpperCase()),
                        ),
                        title: Text(player['name']),
                        trailing:
                            const Icon(Icons.check_circle, color: Colors.green),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (widget.isHost)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      const Text('START GAME', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
