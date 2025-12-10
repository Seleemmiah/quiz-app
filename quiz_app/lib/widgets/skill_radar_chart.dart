import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SkillRadarChart extends StatelessWidget {
  final Map<String, double> categoryScores;

  const SkillRadarChart({
    super.key,
    required this.categoryScores,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryScores.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'No data yet',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              'Complete quizzes to see your skill breakdown',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Take top 5 categories
    final topCategories = categoryScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final displayCategories = topCategories.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skill Breakdown',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: RadarChart(
            RadarChartData(
              radarShape: RadarShape.polygon,
              tickCount: 5,
              ticksTextStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 10,
              ),
              radarBorderData: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
              gridBorderData: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
              tickBorderData: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
              getTitle: (index, angle) {
                if (index >= displayCategories.length)
                  return RadarChartTitle(text: '');
                final category = displayCategories[index].key;
                // Shorten long category names
                final shortName = category.length > 12
                    ? '${category.substring(0, 10)}...'
                    : category;
                return RadarChartTitle(
                  text: shortName,
                  angle: angle,
                );
              },
              dataSets: [
                RadarDataSet(
                  fillColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderColor: Theme.of(context).primaryColor,
                  borderWidth: 2,
                  entryRadius: 3,
                  dataEntries: displayCategories
                      .map((e) => RadarEntry(value: e.value))
                      .toList(),
                ),
              ],
              titleTextStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: displayCategories.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${entry.key}: ${entry.value.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
