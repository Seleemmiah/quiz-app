import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum ReportReason {
  incorrectAnswer,
  unclearQuestion,
  typo,
  offensive,
  other,
}

class QuestionReport {
  final String questionText;
  final String category;
  final ReportReason reason;
  final String? comment;
  final DateTime timestamp;

  QuestionReport({
    required this.questionText,
    required this.category,
    required this.reason,
    this.comment,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'category': category,
      'reason': reason.name,
      'comment': comment,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory QuestionReport.fromJson(Map<String, dynamic> json) {
    return QuestionReport(
      questionText: json['questionText'] as String,
      category: json['category'] as String,
      reason: ReportReason.values.firstWhere(
        (r) => r.name == json['reason'],
        orElse: () => ReportReason.other,
      ),
      comment: json['comment'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class QuestionReportService {
  static const String _reportsKey = 'question_reports';

  Future<void> reportQuestion(QuestionReport report) async {
    final prefs = await SharedPreferences.getInstance();
    final reports = await getReports();
    reports.add(report);

    final reportsJson = reports.map((r) => r.toJson()).toList();
    await prefs.setString(_reportsKey, jsonEncode(reportsJson));
  }

  Future<List<QuestionReport>> getReports() async {
    final prefs = await SharedPreferences.getInstance();
    final reportsJson = prefs.getString(_reportsKey);

    if (reportsJson == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(reportsJson);
      return decoded
          .map((json) => QuestionReport.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearReports() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_reportsKey);
  }
}
