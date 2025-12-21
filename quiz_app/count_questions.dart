import 'dart:io';

void main() {
  final files = [
    'lib/screens/local_questions.dart',
    'lib/screens/additional_questions.dart',
    'lib/screens/generated_questions.dart'
  ];

  final Map<String, Map<String, int>> counts = {};

  for (final filePath in files) {
    final file = File(filePath);
    if (!file.existsSync()) {
      print('File not found: $filePath');
      continue;
    }

    final content = file.readAsStringSync();

    // Regex to capture category and difficulty (supporting single or double quotes)
    final categoryRegex =
        RegExp(r'["' ']category["' ']:s*["' ']([^"' ']+)["' ']');
    final difficultyRegex =
        RegExp(r'["' ']difficulty["' ']:s*["' ']([^"' ']+)["' ']');

    // We need to iterate through the file and match pairs.
    // Since it's a list of maps, we can split by "{" to get individual question blocks roughly.
    final blocks = content.split('{');

    for (final block in blocks) {
      final categoryMatch = categoryRegex.firstMatch(block);
      final difficultyMatch = difficultyRegex.firstMatch(block);

      if (categoryMatch != null && difficultyMatch != null) {
        final category = categoryMatch.group(1)!;
        final difficulty = difficultyMatch.group(1)!;

        counts.putIfAbsent(category, () => {'easy': 0, 'medium': 0, 'hard': 0});
        counts[category]![difficulty] =
            (counts[category]![difficulty] ?? 0) + 1;
      }
    }
  }

  print('--- Question Counts ---');
  counts.forEach((category, diffs) {
    print('\nCategory: $category');
    diffs.forEach((diff, count) {
      print('  $diff: $count');
      if (count < 20) {
        print('    [WARNING] Less than 20 questions!');
      }
    });
  });
}
