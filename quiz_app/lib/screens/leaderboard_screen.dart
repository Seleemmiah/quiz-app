import 'package:flutter/material.dart';
import 'package:quiz_app/models/leaderboard_entry.dart';
import 'package:quiz_app/services/api_service.dart';
import 'package:quiz_app/services/leaderboard_service.dart';
import 'package:quiz_app/settings.dart';
import 'package:intl/intl.dart';

import 'package:quiz_app/services/firestore_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final LeaderboardService _leaderboardService = LeaderboardService();
  final ApiService _apiService = ApiService();
  final FirestoreService _firestoreService = FirestoreService();

  Difficulty _selectedDifficulty = Difficulty.easy;
  String? _selectedCategory;
  List<String> _categories = [];
  List<LeaderboardEntry> _localScores = [];
  List<Map<String, dynamic>> _globalScores = [];
  bool _isLoadingLocal = true;
  bool _isLoadingGlobal = true;

  @override
  void initState() {
    super.initState();
    _loadLocalData();
    _loadGlobalData();
  }

  Future<void> _loadLocalData() async {
    setState(() => _isLoadingLocal = true);
    try {
      if (_categories.isEmpty) {
        _categories = await _apiService.fetchCategories();
        if (_categories.isNotEmpty && _selectedCategory == null) {
          _selectedCategory = _categories.first;
        }
      }

      if (_selectedCategory != null) {
        _localScores = await _leaderboardService.getScores(
            _selectedDifficulty, _selectedCategory);
      }
    } catch (e) {
      debugPrint('Error loading local leaderboard: $e');
    } finally {
      if (mounted) setState(() => _isLoadingLocal = false);
    }
  }

  Future<void> _loadGlobalData() async {
    setState(() => _isLoadingGlobal = true);
    try {
      _globalScores = await _firestoreService.getLeaderboard();
    } catch (e) {
      debugPrint('Error loading global leaderboard: $e');
    } finally {
      if (mounted) setState(() => _isLoadingGlobal = false);
    }
  }

  void _onDifficultyChanged(Set<Difficulty> newSelection) {
    setState(() {
      _selectedDifficulty = newSelection.first;
    });
    _loadLocalData();
  }

  void _onCategoryChanged(String? newValue) {
    setState(() {
      _selectedCategory = newValue;
    });
    _loadLocalData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Local'),
              Tab(text: 'Global (Multiplayer)'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLocalLeaderboard(),
            _buildGlobalLeaderboard(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalLeaderboard() {
    return Column(
      children: [
        // --- Filters Section ---
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Difficulty Selector
              SegmentedButton<Difficulty>(
                segments: const [
                  ButtonSegment(value: Difficulty.easy, label: Text('Easy')),
                  ButtonSegment(
                      value: Difficulty.medium, label: Text('Medium')),
                  ButtonSegment(value: Difficulty.hard, label: Text('Hard')),
                ],
                selected: {_selectedDifficulty},
                onSelectionChanged: _onDifficultyChanged,
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(height: 12),
              // Category Selector
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: _onCategoryChanged,
              ),
            ],
          ),
        ),

        // --- Scores List ---
        Expanded(
          child: _isLoadingLocal
              ? const Center(child: CircularProgressIndicator())
              : _localScores.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.emoji_events_outlined,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No scores yet!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          const Text('Play a quiz to set a high score.'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _localScores.length,
                      itemBuilder: (context, index) {
                        final entry = _localScores[index];
                        final isTop3 = index < 3;

                        return Card(
                          elevation: isTop3 ? 4 : 1,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: isTop3
                                ? BorderSide(
                                    color: _getRankColor(index), width: 2)
                                : BorderSide.none,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getRankColor(index),
                              foregroundColor: Colors.white,
                              child: Text('#${index + 1}'),
                            ),
                            title: Text(
                              entry.playerName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              DateFormat.yMMMd().format(entry.date),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${entry.score}/${entry.totalQuestions}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  '${((entry.score / entry.totalQuestions) * 100).round()}%',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildGlobalLeaderboard() {
    if (_isLoadingGlobal) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_globalScores.isEmpty) {
      return const Center(child: Text('No global scores yet.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _globalScores.length,
      itemBuilder: (context, index) {
        final entry = _globalScores[index];
        final isTop3 = index < 3;

        return Card(
          elevation: isTop3 ? 4 : 1,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isTop3
                ? BorderSide(color: _getRankColor(index), width: 2)
                : BorderSide.none,
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getRankColor(index),
              foregroundColor: Colors.white,
              child: Text('#${index + 1}'),
            ),
            title: Text(
              entry['username'] ?? 'Anonymous',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Wins: ${entry['multiplayerWins']}'),
            trailing: Text(
              '${entry['multiplayerPoints']} pts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber; // Gold
      case 1:
        return Colors.grey; // Silver
      case 2:
        return Colors.brown; // Bronze
      default:
        return Colors.blueGrey;
    }
  }
}
