import 'dart:convert';

class StudyPlan {
  final String id;
  final String examName;
  final DateTime examDate;
  final List<String> topics;
  final Map<String, int> topicProgress;
  final List<StudySession> sessions;
  final DateTime createdDate;

  StudyPlan({
    required this.id,
    required this.examName,
    required this.examDate,
    required this.topics,
    required this.topicProgress,
    required this.sessions,
    required this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'examName': examName,
      'examDate': examDate.toIso8601String(),
      'topics': topics,
      'topicProgress': topicProgress,
      'sessions': sessions.map((x) => x.toMap()).toList(),
      'createdDate': createdDate.toIso8601String(),
    };
  }

  factory StudyPlan.fromMap(Map<String, dynamic> map) {
    return StudyPlan(
      id: map['id'] ?? '',
      examName: map['examName'] ?? '',
      examDate: DateTime.tryParse(map['examDate'] ?? '') ?? DateTime.now(),
      topics: List<String>.from(map['topics'] ?? []),
      topicProgress: Map<String, int>.from(map['topicProgress'] ?? {}),
      sessions: (map['sessions'] as List<dynamic>?)
              ?.map((x) => StudySession.fromMap(x))
              .toList() ??
          [],
      createdDate:
          DateTime.tryParse(map['createdDate'] ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory StudyPlan.fromJson(String source) =>
      StudyPlan.fromMap(json.decode(source));

  // Calculate overall readiness
  double get readiness {
    if (topicProgress.isEmpty) return 0.0;
    final total = topicProgress.values.fold(0, (sum, val) => sum + val);
    return total / topicProgress.length;
  }

  // Get days until exam
  int get daysUntilExam {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final exam = DateTime(examDate.year, examDate.month, examDate.day);
    return exam.difference(today).inDays;
  }
}

class StudySession {
  final String id;
  final DateTime date;
  final String topic;
  final int durationMinutes;
  final bool completed;

  StudySession({
    required this.id,
    required this.date,
    required this.topic,
    required this.durationMinutes,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'topic': topic,
      'durationMinutes': durationMinutes,
      'completed': completed,
    };
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date']),
      topic: map['topic'] ?? '',
      durationMinutes: map['durationMinutes'] ?? 0,
      completed: map['completed'] ?? false,
    );
  }

  StudySession copyWith({bool? completed}) {
    return StudySession(
      id: id,
      date: date,
      topic: topic,
      durationMinutes: durationMinutes,
      completed: completed ?? this.completed,
    );
  }
}
