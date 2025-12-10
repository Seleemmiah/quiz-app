import 'package:quiz_app/settings.dart';

class Level {
  final String id;
  final String name;
  final String description;
  final int requiredScore; // Score needed to pass (e.g., 80%)
  final bool isUnlocked;
  final int stars; // 0, 1, 2, or 3
  final Difficulty difficulty;
  final String category;
  final int order; // To sort levels

  Level({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredScore,
    this.isUnlocked = false,
    this.stars = 0,
    required this.difficulty,
    required this.category,
    required this.order,
  });

  // Create a copy with updated status
  Level copyWith({
    bool? isUnlocked,
    int? stars,
  }) {
    return Level(
      id: id,
      name: name,
      description: description,
      requiredScore: requiredScore,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      stars: stars ?? this.stars,
      difficulty: difficulty,
      category: category,
      order: order,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isUnlocked': isUnlocked,
      'stars': stars,
    };
  }
}
