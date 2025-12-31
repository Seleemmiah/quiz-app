import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/widgets/lazy_image.dart';
import 'package:uuid/uuid.dart';

class OfflineCacheService {
  static const String _boxName = 'offline_quizzes_box';
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
    _isInitialized = true;
  }

  static Box get _box => Hive.box(_boxName);

  /// Save a quiz for offline use
  static Future<String> saveQuiz({
    required String title,
    required String category,
    required List<Question> questions,
    bool isGenerated = false,
  }) async {
    final id = const Uuid().v4();
    final quizData = {
      'id': id,
      'title': title,
      'category': category,
      'questions': questions.map((q) => q.toJson()).toList(),
      'downloadedAt': DateTime.now().toIso8601String(),
      'isGenerated': isGenerated,
    };

    await _box.put(id, quizData);

    // Preload images for these questions
    final List<String> imageUrls = questions
        .map((q) => q.imageUrl)
        .where((url) => url != null && url.isNotEmpty)
        .cast<String>()
        .toList();

    if (imageUrls.isNotEmpty) {
      ImagePreloader.preloadImages(imageUrls).catchError((e) {
        debugPrint('Image preloading failed: $e');
      });
    }

    return id;
  }

  /// Get all saved offline quizzes
  static List<Map<String, dynamic>> getAllSavedQuizzes() {
    return _box.values
        .cast<Map>()
        .map((m) => Map<String, dynamic>.from(m))
        .toList();
  }

  /// Delete a saved quiz
  static Future<void> deleteQuiz(String id) async {
    await _box.delete(id);
  }

  /// Check if a category has a downloaded version
  static bool hasOfflineCategory(String category) {
    return _box.values
        .any((q) => q['category'] == category && q['isGenerated'] == false);
  }

  /// Get questions for a specific offline quiz
  static List<Question> getQuizQuestions(String id) {
    final data = _box.get(id);
    if (data == null) return [];

    final List<dynamic> questionsJson = data['questions'];
    return questionsJson
        .map((q) => Question.fromLocalJson(Map<String, dynamic>.from(q)))
        .toList();
  }
}
