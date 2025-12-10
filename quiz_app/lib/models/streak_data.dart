class StreakData {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletionDate;
  final int totalChallengesCompleted;
  final int totalBonusPointsEarned;

  StreakData({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletionDate,
    this.totalChallengesCompleted = 0,
    this.totalBonusPointsEarned = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastCompletionDate': lastCompletionDate?.toIso8601String(),
      'totalChallengesCompleted': totalChallengesCompleted,
      'totalBonusPointsEarned': totalBonusPointsEarned,
    };
  }

  factory StreakData.fromMap(Map<String, dynamic> map) {
    return StreakData(
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      lastCompletionDate: map['lastCompletionDate'] != null
          ? DateTime.parse(map['lastCompletionDate'])
          : null,
      totalChallengesCompleted: map['totalChallengesCompleted'] ?? 0,
      totalBonusPointsEarned: map['totalBonusPointsEarned'] ?? 0,
    );
  }

  StreakData copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCompletionDate,
    int? totalChallengesCompleted,
    int? totalBonusPointsEarned,
  }) {
    return StreakData(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletionDate: lastCompletionDate ?? this.lastCompletionDate,
      totalChallengesCompleted:
          totalChallengesCompleted ?? this.totalChallengesCompleted,
      totalBonusPointsEarned:
          totalBonusPointsEarned ?? this.totalBonusPointsEarned,
    );
  }

  // Check if streak is at risk (last completion was yesterday or earlier)
  bool get isStreakAtRisk {
    if (lastCompletionDate == null) return false;
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final lastDate = DateTime(
      lastCompletionDate!.year,
      lastCompletionDate!.month,
      lastCompletionDate!.day,
    );
    return lastDate.isBefore(yesterday);
  }

  // Check if user completed challenge today
  bool get completedToday {
    if (lastCompletionDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(
      lastCompletionDate!.year,
      lastCompletionDate!.month,
      lastCompletionDate!.day,
    );
    return lastDate.isAtSameMomentAs(today);
  }
}
