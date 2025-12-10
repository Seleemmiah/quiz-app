import 'package:flutter/material.dart';
import 'package:quiz_app/models/level_model.dart';
import 'package:quiz_app/services/campaign_service.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:animate_do/animate_do.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  final CampaignService _campaignService = CampaignService();
  List<Level> _levels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    final levels = await _campaignService.getLevels();
    if (mounted) {
      setState(() {
        _levels = levels;
        _isLoading = false;
      });
    }
  }

  void _startLevel(Level level) {
    if (!level.isUnlocked) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          difficulty: level.difficulty,
          category: level.category,
          quizLength: 10, // Fixed length for campaign
          // We can pass a flag to QuizScreen to know it's a campaign level
          // But for now, we'll just handle the result logic separately or
          // pass the level ID via arguments if we modify QuizScreen.
          // A cleaner way is to pass 'customQuestions' if we had them,
          // or just rely on the category/difficulty.
        ),
        settings: RouteSettings(
          arguments: {
            'isCampaign': true,
            'levelId': level.id,
            'difficulty': level.difficulty,
            'category': level.category,
            'quizLength': 10,
          },
        ),
      ),
    ).then((_) => _loadLevels()); // Reload progress when returning
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campaign Map'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withValues(alpha: 0.1),
              accentColor.withValues(alpha: 0.1)
            ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _levels.length,
                itemBuilder: (context, index) {
                  final level = _levels[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 100),
                    child: _buildLevelCard(level, index, primaryColor),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildLevelCard(Level level, int index, Color primaryColor) {
    final isLocked = !level.isUnlocked;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLocked ? null : () => _startLevel(level),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isLocked ? Colors.grey.shade300 : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (!isLocked)
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
              ],
            ),
            child: Row(
              children: [
                // Level Number / Lock Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isLocked ? Colors.grey.shade400 : primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isLocked
                        ? const Icon(Icons.lock, color: Colors.white)
                        : Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 20),
                // Level Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              isLocked ? Colors.grey.shade600 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        level.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isLocked
                              ? Colors.grey.shade500
                              : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Stars
                      if (!isLocked)
                        Row(
                          children: List.generate(3, (starIndex) {
                            return Icon(
                              starIndex < level.stars
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                        ),
                    ],
                  ),
                ),
                // Play Button (if unlocked)
                if (!isLocked)
                  Icon(Icons.play_circle_fill, color: primaryColor, size: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
