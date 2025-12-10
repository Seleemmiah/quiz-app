import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/widgets/glass_card.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _leaderboard = [];
  Map<String, dynamic>? _currentUserStats;
  int _currentUserRank = -1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final leaderboard = await _firestoreService.getLeaderboard(limit: 10);
      final rank = await _firestoreService.getUserRank(user.uid);
      final userData = await _firestoreService.getUser(user.uid);

      setState(() {
        _leaderboard = leaderboard;
        _currentUserRank = rank;
        _currentUserStats = {
          'username': userData?['username'] ?? 'You',
          'multiplayerWins': userData?['multiplayerWins'] ?? 0,
          'multiplayerPoints': userData?['multiplayerPoints'] ?? 0,
        };
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Leaderboard'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadLeaderboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Podium for Top 3
                      if (_leaderboard.length >= 3) _buildPodium(),
                      const SizedBox(height: 24),

                      // Current User Stats
                      if (_currentUserStats != null) _buildCurrentUserCard(),
                      const SizedBox(height: 16),

                      // Rest of Leaderboard
                      _buildLeaderboardList(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildPodium() {
    final first = _leaderboard[0];
    final second = _leaderboard.length > 1 ? _leaderboard[1] : null;
    final third = _leaderboard.length > 2 ? _leaderboard[2] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 2nd Place
        if (second != null)
          _buildPodiumPlace(
            rank: 2,
            username: second['username'],
            points: second['multiplayerPoints'],
            height: 100,
            color: Colors.grey,
          ),
        const SizedBox(width: 8),

        // 1st Place
        _buildPodiumPlace(
          rank: 1,
          username: first['username'],
          points: first['multiplayerPoints'],
          height: 140,
          color: Colors.amber,
        ),
        const SizedBox(width: 8),

        // 3rd Place
        if (third != null)
          _buildPodiumPlace(
            rank: 3,
            username: third['username'],
            points: third['multiplayerPoints'],
            height: 80,
            color: Colors.brown,
          ),
      ],
    );
  }

  Widget _buildPodiumPlace({
    required int rank,
    required String username,
    required int points,
    required double height,
    required Color color,
  }) {
    final medals = ['🥇', '🥈', '🥉'];
    return Column(
      children: [
        Text(
          medals[rank - 1],
          style: const TextStyle(fontSize: 40),
        ),
        const SizedBox(height: 4),
        Text(
          username,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '$points pts',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentUserCard() {
    return GlassCard(
      borderColor: Theme.of(context).primaryColor.withOpacity(0.5),
      borderWidth: 2,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              '#$_currentUserRank',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentUserStats!['username'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_currentUserStats!['multiplayerWins']} wins',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '${_currentUserStats!['multiplayerPoints']} pts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList() {
    final startIndex = _leaderboard.length >= 3 ? 3 : 0;
    final remainingPlayers = _leaderboard.sublist(startIndex);

    if (remainingPlayers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: remainingPlayers.asMap().entries.map((entry) {
        final index = entry.key + startIndex;
        final player = entry.value;
        final user = FirebaseAuth.instance.currentUser;
        final isCurrentUser = user?.uid == player['uid'];

        return GlassCard(
          padding: EdgeInsets.zero,
          borderColor: isCurrentUser
              ? Theme.of(context).primaryColor.withOpacity(0.4)
              : null,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: Text(
                '#${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            title: Text(
              player['username'],
              style: TextStyle(
                fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text('${player['multiplayerWins']} wins'),
            trailing: Text(
              '${player['multiplayerPoints']} pts',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
