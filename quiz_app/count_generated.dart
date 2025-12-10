import 'dart:io';

void main() {
  final file = File('lib/screens/generated_questions.dart');
  if (!file.existsSync()) {
    print('File not found');
    return;
  }

  final content = file.readAsStringSync();

  final categoryRegex = RegExp(r"'category':\s*'([^']+)'");
  final difficultyRegex = RegExp(r"'difficulty':\s*'([^']+)'");

  final blocks = content.split('{');

  final Map<String, Map<String, int>> counts = {};

  for (final block in blocks) {
    final categoryMatch = categoryRegex.firstMatch(block);
    final difficultyMatch = difficultyRegex.firstMatch(block);

    if (categoryMatch != null && difficultyMatch != null) {
      final category = categoryMatch.group(1)!;
      final difficulty = difficultyMatch.group(1)!;

      counts.putIfAbsent(category, () => {'easy': 0, 'medium': 0, 'hard': 0});
      counts[category]![difficulty] = (counts[category]![difficulty] ?? 0) + 1;
    }
  }

  print('=== Generated Questions Summary ===\n');
  var totalQuestions = 0;
  counts.forEach((category, diffs) {
    var categoryTotal = 0;
    print('$category:');
    diffs.forEach((diff, count) {
      print('  $diff: $count');
      categoryTotal += count;
      totalQuestions += count;
    });
    print('  Total: $categoryTotal\n');
  });
  print('GRAND TOTAL: $totalQuestions questions');
}
