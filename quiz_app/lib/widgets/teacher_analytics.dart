import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:quiz_app/models/quiz_result.dart';

class TeacherAnalytics extends StatelessWidget {
  final List<QuizResult> results;
  final List<Map<String, dynamic>> students;

  const TeacherAnalytics({
    super.key,
    required this.results,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Data Yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Analytics will appear after students complete exams',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final avgScore = _calculateAverageScore();
    final passRate = _calculatePassRate();
    final topStudent = _getTopStudent();
    final scoreDistribution = _getScoreDistribution();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Cards
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Average Score',
                '${avgScore.toStringAsFixed(1)}%',
                Icons.trending_up,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Pass Rate',
                '${passRate.toStringAsFixed(1)}%',
                Icons.check_circle,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Attempts',
                '${results.length}',
                Icons.assignment,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Active Students',
                '${students.length}',
                Icons.people,
                Colors.purple,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Top Student
        if (topStudent != null) ...[
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber.shade400, Colors.amber.shade600],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.emoji_events,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Top Performer',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          topStudent['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Avg: ${topStudent['avgScore'].toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Score Distribution Chart
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Score Distribution',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: scoreDistribution.values
                              .reduce((a, b) => a > b ? a : b)
                              .toDouble() +
                          2,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const ranges = [
                                '0-20',
                                '21-40',
                                '41-60',
                                '61-80',
                                '81-100'
                              ];
                              if (value.toInt() >= 0 &&
                                  value.toInt() < ranges.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    ranges[value.toInt()],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: scoreDistribution.entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.toDouble(),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.indigo.shade400,
                                  Colors.indigo.shade600,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              width: 20,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Recent Performance Trend
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Performance Trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 &&
                                  value.toInt() < results.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Q${value.toInt() + 1}',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
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
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _getTrendData(),
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600
                            ],
                          ),
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Colors.white,
                                strokeWidth: 2,
                                strokeColor: Colors.green.shade600,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade400.withOpacity(0.3),
                                Colors.green.shade600.withOpacity(0.1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateAverageScore() {
    if (results.isEmpty) return 0;
    final total =
        results.fold<double>(0, (sum, result) => sum + result.percentage);
    return total / results.length;
  }

  double _calculatePassRate() {
    if (results.isEmpty) return 0;
    final passed = results.where((r) => r.percentage >= 60).length;
    return (passed / results.length) * 100;
  }

  Map<String, dynamic>? _getTopStudent() {
    if (results.isEmpty || students.isEmpty) return null;

    final studentScores = <String, List<double>>{};

    for (var result in results) {
      studentScores.putIfAbsent(result.userId, () => []).add(result.percentage);
    }

    String? topStudentId;
    double topAvg = 0;

    studentScores.forEach((userId, scores) {
      final avg = scores.reduce((a, b) => a + b) / scores.length;
      if (avg > topAvg) {
        topAvg = avg;
        topStudentId = userId;
      }
    });

    if (topStudentId == null) return null;

    final student = students.firstWhere(
      (s) => s['uid'] == topStudentId,
      orElse: () => {'username': 'Unknown'},
    );

    return {
      'name': student['username'] ?? 'Unknown',
      'avgScore': topAvg,
    };
  }

  Map<int, int> _getScoreDistribution() {
    final distribution = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0};

    for (var result in results) {
      final score = result.percentage;
      if (score <= 20) {
        distribution[0] = distribution[0]! + 1;
      } else if (score <= 40) {
        distribution[1] = distribution[1]! + 1;
      } else if (score <= 60) {
        distribution[2] = distribution[2]! + 1;
      } else if (score <= 80) {
        distribution[3] = distribution[3]! + 1;
      } else {
        distribution[4] = distribution[4]! + 1;
      }
    }

    return distribution;
  }

  List<FlSpot> _getTrendData() {
    if (results.isEmpty) return [];

    // Take last 10 results for trend
    final recentResults = results.take(10).toList();
    return recentResults.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.percentage);
    }).toList();
  }
}
