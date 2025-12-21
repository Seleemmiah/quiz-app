import 'package:flutter/material.dart';
import 'package:quiz_app/services/achievement_service.dart';
import 'package:quiz_app/models/achievement.dart';
import 'package:quiz_app/widgets/glass_card.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final AchievementService _achievementService = AchievementService();
  late Future<List<Achievement>> _achievementsFuture;

  @override
  void initState() {
    super.initState();
    _achievementsFuture = _achievementService.getUserAchievements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: FutureBuilder<List<Achievement>>(
        future: _achievementsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final achievements = snapshot.data ?? [];
          final unlockedCount = achievements.where((a) => a.isUnlocked).length;

          return Column(
            children: [
              // Progress Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '$unlockedCount / ${achievements.length}',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Achievements Unlocked',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: achievements.isEmpty
                          ? 0
                          : unlockedCount / achievements.length,
                      backgroundColor: Colors.white30,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),

              // Achievements Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    final achievement = achievements[index];
                    return _buildAchievementCard(achievement);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final isLocked = !achievement.isUnlocked;

    return GlassCard(
      padding: EdgeInsets.zero,
      borderColor: isLocked
          ? Colors.grey.withOpacity(0.3)
          : Theme.of(context).primaryColor.withOpacity(0.4),
      child: InkWell(
        onTap: () {
          if (achievement.isUnlocked) {
            _showAchievementDetails(achievement);
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLocked
                      ? Colors.grey[300]
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                  border: Border.all(
                    color: isLocked
                        ? Colors.grey[400]!
                        : Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: isLocked
                      ? const Icon(Icons.lock, size: 32, color: Colors.grey)
                      : Icon(achievement.icon,
                          size: 32, color: achievement.color),
                ),
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isLocked ? Colors.grey[600] : null,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isLocked ? Colors.grey[500] : Colors.grey[700],
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              if (achievement.isUnlocked && achievement.unlockedAt != null) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Unlocked',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(achievement.icon, size: 32, color: achievement.color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                achievement.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(achievement.description),
            if (achievement.unlockedAt != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Unlocked on ${_formatDate(achievement.unlockedAt!)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
