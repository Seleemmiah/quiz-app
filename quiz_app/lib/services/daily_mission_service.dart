import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/services/daily_challenge_service.dart';
import 'package:quiz_app/services/spaced_repetition_service.dart';
import 'package:quiz_app/services/study_planner_service.dart';
import 'package:quiz_app/services/gamification_service.dart';

class DailyMission {
  final String title;
  final String description;
  final double progress; // 0.0 to 1.0
  final bool isCompleted;
  final String icon;
  final String actionLabel;
  final String route;
  final Map<String, dynamic>? arguments;

  DailyMission({
    required this.title,
    required this.description,
    required this.progress,
    required this.isCompleted,
    required this.icon,
    required this.actionLabel,
    required this.route,
    this.arguments,
  });
}

class DailyMissionService {
  final DailyChallengeService _challengeService = DailyChallengeService();
  final SpacedRepetitionService _srService = SpacedRepetitionService();
  final StudyPlannerService _plannerService = StudyPlannerService();
  final GamificationService _gamificationService = GamificationService();

  Future<List<DailyMission>> getTodaysMissions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final List<DailyMission> missions = [];

    // 1. Spaced Repetition Mission
    final dueCount = await _srService.getDueCount();
    if (dueCount > 0) {
      missions.add(DailyMission(
        title: 'Memory Refresh',
        description: 'You have $dueCount topics due for review!',
        progress: 0.0,
        isCompleted: false,
        icon: '🧠',
        actionLabel: 'Review Now',
        route: '/quiz', // We'll need to pass special args for SR quiz
        arguments: {'category': 'Review', 'isSpacedRepetition': true},
      ));
    }

    // 2. Daily Challenge Mission
    final challenge = await _challengeService.getTodaysChallenge();
    final hasCompletedChallenge = await _challengeService.hasCompletedToday();
    if (challenge != null) {
      missions.add(DailyMission(
        title: 'Daily Challenge',
        description: challenge.category,
        progress: hasCompletedChallenge ? 1.0 : 0.0,
        isCompleted: hasCompletedChallenge,
        icon: '🎯',
        actionLabel: hasCompletedChallenge ? 'Completed' : 'Start',
        route: '/daily_challenge',
      ));
    }

    // 3. Study Planner Mission (Today's session)
    final plan = await _plannerService.getCurrentPlan();
    if (plan != null) {
      final today = DateTime.now();
      final todaySession = plan.sessions.firstWhere(
        (s) =>
            s.date.year == today.year &&
            s.date.month == today.month &&
            s.date.day == today.day,
        orElse: () => plan.sessions
            .firstWhere((s) => !s.completed, orElse: () => plan.sessions.last),
      );

      if (!todaySession.completed) {
        missions.add(DailyMission(
          title: 'Study Goal',
          description: 'Focus on: ${todaySession.topic}',
          progress: 0.0,
          isCompleted: false,
          icon: '📅',
          actionLabel: 'Study',
          route: '/study_planner',
        ));
      }
    }

    // 4. XP / Level Up Mission
    final xp = await _gamificationService.getTotalXP();
    final level = _gamificationService.getLevel(xp);
    final progress = _gamificationService.getLevelProgress(xp);
    final xpNeeded = _gamificationService.getXPForNextLevel(level) - xp;

    missions.add(DailyMission(
      title: 'Level $level',
      description: '$xpNeeded XP to Level ${level + 1}',
      progress: progress,
      isCompleted: false,
      icon: '🚀',
      actionLabel: 'Play More',
      route: '/',
    ));

    return missions;
  }
}
