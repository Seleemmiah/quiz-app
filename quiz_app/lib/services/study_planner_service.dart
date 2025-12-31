import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:quiz_app/models/study_plan.dart';
import 'package:quiz_app/services/shop_service.dart';
import 'package:quiz_app/services/professional_notification_service.dart';
import 'package:quiz_app/utils/firestore_error_handler.dart';

class StudyPlannerService {
  final ShopService _shopService = ShopService();
  final ProfessionalNotificationService _notificationService =
      ProfessionalNotificationService.instance;

  // Simplified getter that doesn't throw, for checking existence
  DocumentReference? get _safePlanRef {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('study_plans')
        .doc('current');
  }

  Future<StudyPlan?> getCurrentPlan() async {
    final ref = _safePlanRef;
    if (ref == null) return null;

    return await FirestoreErrorHandler.executeWithRetry<StudyPlan?>(
      operation: () async {
        final doc = await ref.get();
        if (!doc.exists) return null;
        return StudyPlan.fromMap(doc.data() as Map<String, dynamic>);
      },
    );
  }

  Future<void> createPlan({
    required String examName,
    required DateTime examDate,
    required List<String> topics,
  }) async {
    final ref = _safePlanRef;
    if (ref == null) throw Exception('User must be logged in to create a plan');

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

    await FirestoreErrorHandler.executeWithRetry(
      operation: () async {
        await ref.set(plan.toMap());
      },
    );

    // Schedule notifications for all sessions
    await _scheduleNotifications(sessions);
  }

  Future<void> _scheduleNotifications(List<StudySession> sessions) async {
    for (var session in sessions) {
      // Schedule only future sessions
      if (session.date.isAfter(DateTime.now())) {
        await _notificationService.scheduleStudySession(
          sessionDate: session.date,
          topic: session.topic,
          sessionId: session.id,
        );
      }
    }
  }

  List<StudySession> _generateSessions(DateTime examDate, List<String> topics) {
    final sessions = <StudySession>[];
    final now = DateTime.now();
    final days = examDate.difference(now).inDays;

    if (days <= 0) return [];

    // Create a session for each day until exam
    for (int i = 0; i < days; i++) {
      // Default to 10:00 AM if created now, or maybe just preserve time?
      // "date" here includes time.
      // Let's set it to 6:00 PM (18:00) which is a good study time
      final nextDay = now.add(Duration(days: i + 1));
      final date = DateTime(nextDay.year, nextDay.month, nextDay.day, 18, 0);

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

    bool newlyCompleted = false;

    final updatedSessions = plan.sessions.map((s) {
      if (s.id == sessionId) {
        if (!s.completed) newlyCompleted = true;
        return s.copyWith(completed: true);
      }
      return s;
    }).toList();

    // Reward coins if newly completed
    if (newlyCompleted) {
      await _shopService.addCoins(50);
    }

    final updatedPlan = StudyPlan(
      id: plan.id,
      examName: plan.examName,
      examDate: plan.examDate,
      topics: plan.topics,
      topicProgress: plan.topicProgress,
      sessions: updatedSessions,
      createdDate: plan.createdDate,
    );

    await _savePlan(updatedPlan);
  }

  Future<void> _savePlan(StudyPlan plan) async {
    final ref = _safePlanRef;
    if (ref == null) return;

    await FirestoreErrorHandler.executeWithRetry(
      operation: () async {
        await ref.set(plan.toMap());
      },
    );
  }

  Future<void> deletePlan() async {
    final ref = _safePlanRef;
    if (ref == null) return;

    await FirestoreErrorHandler.executeWithRetry(
      operation: () => ref.delete(),
    );
  }
}
