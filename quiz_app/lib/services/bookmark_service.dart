import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/models/question_model.dart';

class BookmarkService {
  static const String _bookmarksKey = 'bookmarked_questions';

  // Generate a unique ID for a question based on its content
  String _generateQuestionId(Question question) {
    return '${question.question}_${question.correctAnswer}'.hashCode.toString();
  }

  Future<bool> toggleBookmark(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = prefs.getString(_bookmarksKey) ?? '{}';
    final bookmarks = Map<String, dynamic>.from(jsonDecode(bookmarksJson));

    final questionId = _generateQuestionId(question);

    if (bookmarks.containsKey(questionId)) {
      // Remove bookmark
      bookmarks.remove(questionId);
      await prefs.setString(_bookmarksKey, jsonEncode(bookmarks));
      return false;
    } else {
      // Add bookmark
      bookmarks[questionId] = {
        'question': question.question,
        'correctAnswer': question.correctAnswer,
        'incorrectAnswers': question.incorrectAnswers,
        'category': question.category,
        'difficulty': question.difficulty,
        'explanation': question.explanation,
      };
      await prefs.setString(_bookmarksKey, jsonEncode(bookmarks));
      return true;
    }
  }

  Future<bool> isBookmarked(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = prefs.getString(_bookmarksKey) ?? '{}';
    final bookmarks = Map<String, dynamic>.from(jsonDecode(bookmarksJson));

    final questionId = _generateQuestionId(question);
    return bookmarks.containsKey(questionId);
  }

  Future<List<Question>> getBookmarkedQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = prefs.getString(_bookmarksKey) ?? '{}';
    final bookmarks = Map<String, dynamic>.from(jsonDecode(bookmarksJson));

    final questions = <Question>[];
    for (final entry in bookmarks.values) {
      try {
        questions.add(Question.fromLocalJson(entry));
      } catch (e) {
        // Skip invalid entries
        continue;
      }
    }

    return questions;
  }

  Future<int> getBookmarkCount() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = prefs.getString(_bookmarksKey) ?? '{}';
    final bookmarks = Map<String, dynamic>.from(jsonDecode(bookmarksJson));
    return bookmarks.length;
  }

  Future<void> clearAllBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookmarksKey);
  }
}
