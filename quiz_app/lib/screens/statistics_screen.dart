import 'package:flutter/material.dart';
import 'package:quiz_app/services/statistics_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final StatisticsService _statisticsService = StatisticsService();
  bool _isLoading = true;
  Map<DateTime, int> _activityData = {};
  Map<String, double> _categoryPerformance = {};
  Map<String, int> _srStats = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final activity = await _statisticsService.getLast7DaysActivity();
      final performance = await _statisticsService.getCategoryPerformance();
      final srStats = await _statisticsService.getSpacedRepetitionStats();

      if (mounted) {
        setState(() {
          _activityData = activity;
          _categoryPerformance = performance;
          _srStats = srStats;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading stats: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCards(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Last 7 Days Activity'),
                    const SizedBox(height: 16),
                    _buildActivityChart(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Category Performance'),
                    const SizedBox(height: 16),
                    _buildCategoryChart(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Spaced Repetition Progress'),
                    const SizedBox(height: 16),
                    _buildSRProgress(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildSummaryCards() {
    final totalReviews = _srStats['total'] ?? 0;
    final mastered = _srStats['mastered'] ?? 0;
    final due = _srStats['due'] ?? 0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Cards',
            totalReviews.toString(),
            Icons.style,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Mastered',
            mastered.toString(),
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Due Now',
            due.toString(),
            Icons.notifications_active,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityChart() {
    final sortedKeys = _activityData.keys.toList()..sort();
    final maxY = _activityData.values.isEmpty
        ? 10.0
        : (_activityData.values.reduce((a, b) => a > b ? a : b) + 2).toDouble();

    return SizedBox(
      height: 200,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => Colors.blueGrey,
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < sortedKeys.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('E').format(sortedKeys[value.toInt()]),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: sortedKeys.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: _activityData[entry.value]!.toDouble(),
                      color: Theme.of(context).primaryColor,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChart() {
    if (_categoryPerformance.isEmpty) {
      return const Center(child: Text('No quiz data yet'));
    }

    final sortedEntries = _categoryPerformance.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Sort by score desc

    return Column(
      children: sortedEntries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text('${entry.value.toStringAsFixed(1)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: entry.value / 100,
                backgroundColor: Colors.grey[200],
                color: _getColorForScore(entry.value),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getColorForScore(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildSRProgress() {
    final total = _srStats['total'] ?? 0;
    final mastered = _srStats['mastered'] ?? 0;

    if (total == 0) {
      return const Center(child: Text('Start studying to see progress!'));
    }

    final percentage = (mastered / total) * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${percentage.toStringAsFixed(1)}% Mastered',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '$mastered out of $total cards',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 12,
              backgroundColor: Colors.grey[200],
              color: Colors.purple,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
      ),
    );
  }
}
