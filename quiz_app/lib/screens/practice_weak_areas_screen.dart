import 'package:flutter/material.dart';
import 'package:quiz_app/services/statistics_service.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/widgets/loading_skeleton.dart';
import 'package:quiz_app/widgets/empty_state.dart';

class PracticeWeakAreasScreen extends StatefulWidget {
  const PracticeWeakAreasScreen({super.key});

  @override
  State<PracticeWeakAreasScreen> createState() =>
      _PracticeWeakAreasScreenState();
}

class _PracticeWeakAreasScreenState extends State<PracticeWeakAreasScreen> {
  final StatisticsService _statisticsService = StatisticsService();
  bool _isLoading = true;
  List<MapEntry<String, double>> _weakAreas = [];

  @override
  void initState() {
    super.initState();
    _loadWeakAreas();
  }

  Future<void> _loadWeakAreas() async {
    setState(() => _isLoading = true);
    try {
      final performance = await _statisticsService.getCategoryPerformance();

      // Filter for categories with < 60% accuracy, but ignore 0% (no data)
      // Or maybe include 0% if we want to encourage trying new things?
      // Let's focus on actual weak areas (where they tried and failed)
      // So > 0 questions but < 60% accuracy.
      // Wait, getCategoryPerformance returns 0.0 for no data.
      // I need to know if they actually played.
      // For now, let's just show low scores.

      final sorted = performance.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      // Take bottom 5, filtering out those with 0 if we assume 0 means "not played much"
      // But 0 could also mean "played and got 0 correct".
      // Let's just take the lowest scores.

      _weakAreas = sorted.where((e) => e.value < 60).take(5).toList();

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading stats: $e')),
        );
      }
    }
  }

  void _startPractice(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          category: category,
          difficulty: Difficulty.easy, // Start easy for practice
          quizLength: 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Weak Areas'),
      ),
      body: _isLoading
          ? const ListLoadingSkeleton()
          : _weakAreas.isEmpty
              ? const EmptyState(
                  icon: Icons.check_circle_outline,
                  title: 'No Weak Areas!',
                  message:
                      'You are doing great! All your category scores are above 60%.\nTry a harder difficulty or a new category.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _weakAreas.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          'Focus on these categories to improve your overall score.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    final area = _weakAreas[index - 1];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                          child: const Icon(Icons.trending_down,
                              color: Colors.red),
                        ),
                        title: Text(
                          area.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: area.value / 100,
                              backgroundColor: Colors.grey[200],
                              color: _getColorForScore(area.value),
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Accuracy: ${area.value.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _startPractice(area.key),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          child: const Text('Practice'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Color _getColorForScore(double score) {
    if (score < 30) return Colors.red;
    if (score < 50) return Colors.orange;
    return Colors.yellow[700]!;
  }
}
