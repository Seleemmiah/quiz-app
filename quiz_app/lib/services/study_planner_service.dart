import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:quiz_app/models/study_plan.dart';

class StudyPlannerService {
  static const String _studyPlanKey = 'current_study_plan';

  Future<StudyPlan?> getCurrentPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_studyPlanKey);
    if (jsonStr == null) return null;
    return StudyPlan.fromJson(jsonStr);
  }

  Future<void> createPlan({
    required String examName,
    required DateTime examDate,
    required List<String> topics,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Generate sessions (simple algorithm for now)
    final sessions = _generateSessions(examDate, topics);

    final plan = StudyPlan(
      id: const Uuid().v4(),
      examName: examName,
      examDate: examDate,
      topics: topics,
      topicProgress: {for (var t in topics) t: 0},
      sessions: sessions,
      createdDate: DateTime.now(),
    );

    await prefs.setString(_studyPlanKey, plan.toJson());
  }

  List<StudySession> _generateSessions(DateTime examDate, List<String> topics) {
    final sessions = <StudySession>[];
    final now = DateTime.now();
    final days = examDate.difference(now).inDays;

    if (days <= 0) return [];

    // Create a session for each day until exam
    for (int i = 0; i < days; i++) {
      final date = now.add(Duration(days: i + 1));
      final topic = topics[i % topics.length]; // Rotate topics

      sessions.add(StudySession(
        id: const Uuid().v4(),
        date: date,
        topic: topic,
        durationMinutes: 30, // Default 30 mins
      ));
    }

    return sessions;
  }

  Future<void> completeSession(String sessionId) async {
    final plan = await getCurrentPlan();
    if (plan == null) return;

    final updatedSessions = plan.sessions.map((s) {
      if (s.id == sessionId) {
        return s.copyWith(completed: true);
      }
      return s;
    }).toList();

    // Update progress logic could be more complex, but for now just count completed sessions
    // We could also update topicProgress based on quiz results in the future

    final updatedPlan = StudyPlan(
      id: plan.id,
      examName: plan.examName,
      examDate: plan.examDate,
      topics: plan.topics,
      topicProgress: plan.topicProgress,
      sessions: updatedSessions,
      createdDate: plan.createdDate,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_studyPlanKey, updatedPlan.toJson());
  }

  Future<void> deletePlan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_studyPlanKey);
  }
}
