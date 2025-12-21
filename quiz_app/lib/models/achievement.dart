import 'package:flutter/material.dart';

enum AchievementType {
  firstQuiz,
  perfectScore,
  streak7,
  streak30,
  speed100,
  master50,
  examAce,
  socialButterfly,
  nightOwl,
  earlyBird,
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final AchievementType type;
  final int requiredCount;
  final DateTime? unlockedAt;
  final bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.type,
    this.requiredCount = 1,
    this.unlockedAt,
    this.isUnlocked = false,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    Color? color,
    AchievementType? type,
    int? requiredCount,
    DateTime? unlockedAt,
    bool? isUnlocked,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      requiredCount: requiredCount ?? this.requiredCount,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString(),
      'requiredCount': requiredCount,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'isUnlocked': isUnlocked,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: Icons.emoji_events, // Default, will be set by type
      color: Colors.amber, // Default
      type: AchievementType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => AchievementType.firstQuiz,
      ),
      requiredCount: json['requiredCount'] ?? 1,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }

  static List<Achievement> getDefaultAchievements() {
    return [
      Achievement(
        id: 'first_quiz',
        title: 'First Steps',
        description: 'Complete your first quiz',
        icon: Icons.rocket_launch,
        color: Colors.blue,
        type: AchievementType.firstQuiz,
      ),
      Achievement(
        id: 'perfect_score',
        title: 'Perfectionist',
        description: 'Score 100% on any quiz',
        icon: Icons.stars,
        color: Colors.amber,
        type: AchievementType.perfectScore,
      ),
      Achievement(
        id: 'streak_7',
        title: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        type: AchievementType.streak7,
        requiredCount: 7,
      ),
      Achievement(
        id: 'streak_30',
        title: 'Month Master',
        description: 'Maintain a 30-day streak',
        icon: Icons.whatshot,
        color: Colors.deepOrange,
        type: AchievementType.streak30,
        requiredCount: 30,
      ),
      Achievement(
        id: 'speed_100',
        title: 'Speed Demon',
        description: 'Complete 100 questions',
        icon: Icons.flash_on,
        color: Colors.yellow,
        type: AchievementType.speed100,
        requiredCount: 100,
      ),
      Achievement(
        id: 'master_50',
        title: 'Quiz Master',
        description: 'Complete 50 quizzes',
        icon: Icons.school,
        color: Colors.purple,
        type: AchievementType.master50,
        requiredCount: 50,
      ),
      Achievement(
        id: 'exam_ace',
        title: 'Exam Ace',
        description: 'Score above 90% in an exam',
        icon: Icons.workspace_premium,
        color: Colors.green,
        type: AchievementType.examAce,
      ),
      Achievement(
        id: 'social_butterfly',
        title: 'Social Butterfly',
        description: 'Join 5 multiplayer games',
        icon: Icons.people,
        color: Colors.pink,
        type: AchievementType.socialButterfly,
        requiredCount: 5,
      ),
      Achievement(
        id: 'night_owl',
        title: 'Night Owl',
        description: 'Complete a quiz after 10 PM',
        icon: Icons.nightlight_round,
        color: Colors.indigo,
        type: AchievementType.nightOwl,
      ),
      Achievement(
        id: 'early_bird',
        title: 'Early Bird',
        description: 'Complete a quiz before 6 AM',
        icon: Icons.wb_sunny,
        color: Colors.cyan,
        type: AchievementType.earlyBird,
      ),
    ];
  }
}
