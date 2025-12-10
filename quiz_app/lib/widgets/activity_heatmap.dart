import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityHeatmap extends StatelessWidget {
  final Map<DateTime, int> activity;
  final int maxQuizzes;

  const ActivityHeatmap({
    super.key,
    required this.activity,
    this.maxQuizzes = 5,
  });

  Color _getColorForCount(int count, BuildContext context) {
    // GitHub's exact green color palette
    if (count == 0) return const Color(0xFFEBEDF0); // Light gray
    if (count == 1) return const Color(0xFF9BE9A8); // Light green
    if (count == 2) return const Color(0xFF40C463); // Medium green
    if (count == 3) return const Color(0xFF30A14E); // Dark green
    return const Color(0xFF216E39); // Darkest green (4+)
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(
      49, // 7 weeks
      (index) => DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 48 - index)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        // Day labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Mon', 'Wed', 'Fri']
              .map((day) => SizedBox(
                    width: 30,
                    child: Text(
                      day,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        // Heatmap grid
        SizedBox(
          height: 120,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final count = activity[day] ?? 0;
              final color = _getColorForCount(count, context);

              return Tooltip(
                message:
                    '${DateFormat('MMM d').format(day)}: $count quiz${count == 1 ? '' : 'zes'}',
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Less', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(width: 4),
            ...List.generate(
              5,
              (i) => Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: _getColorForCount(i, context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text('More', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
