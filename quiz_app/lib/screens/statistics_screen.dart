import 'package:flutter/material.dart';
import 'package:quiz_app/services/statistics_service.dart';
import 'package:quiz_app/settings.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final StatisticsService _statisticsService = StatisticsService();
  late Future<QuizStatistics> _statsFuture;
  int _selectedDays = 7; // 7, 30, or 0 (all time)

  @override
  void initState() {
    super.initState();
    _statsFuture = _statisticsService.getStatistics();
  }

  void _refreshStats() {
    setState(() {
      _statsFuture = _statisticsService.getStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshStats,
          ),
        ],
      ),
      body: FutureBuilder<QuizStatistics>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final stats = snapshot.data!;

          if (stats.totalQuizzes == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text(
                    'No statistics yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Complete a quiz to see your stats!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Time Range Selector
                _buildTimeRangeSelector(),
                const SizedBox(height: 20),

                // Performance Chart
                _buildPerformanceChart(),
                const SizedBox(height: 20),

                // Overall Stats Card
                _buildStatCard(
                  context,
                  icon: Icons.quiz,
                  title: 'Total Quizzes',
                  value: stats.totalQuizzes.toString(),
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                _buildStatCard(
                  context,
                  icon: Icons.percent,
                  title: 'Average Score',
                  value: '${stats.averageScore.toStringAsFixed(1)}%',
                  color: stats.averageScore >= 70
                      ? Colors.green
                      : (stats.averageScore >= 40 ? Colors.orange : Colors.red),
                ),
                const SizedBox(height: 12),
                _buildStatCard(
                  context,
                  icon: Icons.check_circle,
                  title: 'Total Correct',
                  value: '${stats.totalCorrect} / ${stats.totalQuestions}',
                  color: Colors.purple,
                ),
                const SizedBox(height: 24),

                // Category Performance Chart
                if (stats.categoryQuizzes.isNotEmpty) ...[
                  Text(
                    'Category Performance',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryChart(stats),
                  const SizedBox(height: 24),
                ],

                // Best Performance
                if (stats.bestCategory != null || stats.bestDifficulty != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Best Performance',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      if (stats.bestCategory != null)
                        _buildStatCard(
                          context,
                          icon: Icons.star,
                          title: 'Best Category',
                          value: stats.bestCategory!,
                          subtitle:
                              '${stats.categoryAverages[stats.bestCategory]?.toStringAsFixed(1)}%',
                          color: Colors.amber,
                        ),
                      if (stats.bestDifficulty != null) ...[
                        const SizedBox(height: 12),
                        _buildStatCard(
                          context,
                          icon: Icons.trending_up,
                          title: 'Best Difficulty',
                          value: _capitalize(stats.bestDifficulty!.name),
                          subtitle:
                              '${stats.difficultyAverages[stats.bestDifficulty]?.toStringAsFixed(1)}%',
                          color: Colors.teal,
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),

                // Difficulty Breakdown
                Text(
                  'By Difficulty',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                ...Difficulty.values.map((difficulty) {
                  final quizzes = stats.difficultyQuizzes[difficulty] ?? 0;
                  final average = stats.difficultyAverages[difficulty] ?? 0;
                  if (quizzes == 0) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildProgressCard(
                      context,
                      title: _capitalize(difficulty.name),
                      quizzes: quizzes,
                      average: average,
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTimeRangeButton('7 Days', 7),
            _buildTimeRangeButton('30 Days', 30),
            _buildTimeRangeButton('All Time', 0),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeButton(String label, int days) {
    final isSelected = _selectedDays == days;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedDays = days;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[300],
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            elevation: isSelected ? 4 : 1,
          ),
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Trend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, double>>(
              future: _statisticsService.getPerformanceTrend(
                  _selectedDays == 0 ? 365 : _selectedDays),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'No data for selected period',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  );
                }

                final trendData = snapshot.data!;
                final sortedDates = trendData.keys.toList()..sort();

                final spots = sortedDates.asMap().entries.map((entry) {
                  return FlSpot(
                    entry.key.toDouble(),
                    trendData[entry.value]!,
                  );
                }).toList();

                return SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 25,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey[300]!,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}%',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= sortedDates.length) {
                                return const Text('');
                              }
                              final date = sortedDates[value.toInt()];
                              final parts = date.split('-');
                              return Text(
                                '${parts[2]}/${parts[1]}',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minY: 0,
                      maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Theme.of(context).primaryColor,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChart(QuizStatistics stats) {
    final categories = stats.categoryQuizzes.keys.toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: categories.map((category) {
            final average = stats.categoryAverages[category] ?? 0;
            final color = average >= 70
                ? Colors.green
                : (average >= 40 ? Colors.orange : Colors.red);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${average.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: average / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context, {
    required String title,
    required int quizzes,
    required double average,
  }) {
    final color = average >= 70
        ? Colors.green
        : (average >= 40 ? Colors.orange : Colors.red);

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '$quizzes quiz${quizzes == 1 ? '' : 'es'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: average / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${average.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
