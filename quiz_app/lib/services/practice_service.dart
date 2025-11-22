import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/bookmark_service.dart';

enum PracticeMode {
  bookmarks,
  incorrectAnswers,
  category,
}

class PracticeService {
  final BookmarkService _bookmarkService = BookmarkService();

  /// Get questions for practice based on mode
  Future<List<Question>> getPracticeQuestions(PracticeMode mode,
      {String? category}) async {
    switch (mode) {
      case PracticeMode.bookmarks:
        return await _bookmarkService.getBookmarkedQuestions();

      case PracticeMode.incorrectAnswers:
        // For now, return bookmarked questions
        // In a full implementation, we'd track incorrect answers separately
        return await _bookmarkService.getBookmarkedQuestions();

      case PracticeMode.category:
        // For now, filter bookmarks by category
        final bookmarks = await _bookmarkService.getBookmarkedQuestions();
        if (category != null) {
          return bookmarks.where((q) => q.category == category).toList();
        }
        return bookmarks;
    }
  }

  /// Check if practice mode is available (has questions)
  Future<bool> isPracticeModeAvailable(PracticeMode mode) async {
    final questions = await getPracticeQuestions(mode);
    return questions.isNotEmpty;
  }

  /// Get count of available practice questions
  Future<int> getPracticeQuestionCount(PracticeMode mode) async {
    final questions = await getPracticeQuestions(mode);
    return questions.length;
  }
}
