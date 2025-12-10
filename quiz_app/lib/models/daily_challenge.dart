class DailyChallenge {
  final String id;
  final DateTime date;
  final String category;
  final int questionCount;
  final int targetScore; // Percentage (0-100)
  final int bonusPoints;
  final List<String> questionIds;
  final bool isCompleted;
  final int? userScore;
  final DateTime? completedAt;

  DailyChallenge({
    required this.id,
    required this.date,
    required this.category,
    required this.questionCount,
    required this.targetScore,
    required this.bonusPoints,
    required this.questionIds,
    this.isCompleted = false,
    this.userScore,
    this.completedAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'category': category,
      'questionCount': questionCount,
      'targetScore': targetScore,
      'bonusPoints': bonusPoints,
      'questionIds': questionIds,
      'isCompleted': isCompleted,
      'userScore': userScore,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  // Create from Firestore document
  factory DailyChallenge.fromMap(Map<String, dynamic> map) {
    return DailyChallenge(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date']),
      category: map['category'] ?? '',
      questionCount: map['questionCount'] ?? 10,
      targetScore: map['targetScore'] ?? 80,
      bonusPoints: map['bonusPoints'] ?? 50,
      questionIds: List<String>.from(map['questionIds'] ?? []),
      isCompleted: map['isCompleted'] ?? false,
      userScore: map['userScore'],
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
    );
  }

  // Copy with method for updates
  DailyChallenge copyWith({
    String? id,
    DateTime? date,
    String? category,
    int? questionCount,
    int? targetScore,
    int? bonusPoints,
    List<String>? questionIds,
    bool? isCompleted,
    int? userScore,
    DateTime? completedAt,
  }) {
    return DailyChallenge(
      id: id ?? this.id,
      date: date ?? this.date,
      category: category ?? this.category,
      questionCount: questionCount ?? this.questionCount,
      targetScore: targetScore ?? this.targetScore,
      bonusPoints: bonusPoints ?? this.bonusPoints,
      questionIds: questionIds ?? this.questionIds,
      isCompleted: isCompleted ?? this.isCompleted,
      userScore: userScore ?? this.userScore,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // Check if challenge was successful
  bool get isSuccessful {
    if (!isCompleted || userScore == null) return false;
    return userScore! >= targetScore;
  }

  // Get progress percentage
  double get progressPercentage {
    if (userScore == null) return 0.0;
    return userScore! / 100.0;
  }
}
