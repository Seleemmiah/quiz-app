import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/bookmarked_question.dart';
import 'package:quiz_app/models/question_model.dart';

class BookmarkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a bookmark
  Future<void> bookmarkQuestion({
    required String userId,
    required String questionText,
    required List<String> options,
    required int correctAnswerIndex,
    String? explanation,
    required String category,
    required String difficulty,
    String? userNote,
  }) async {
    final bookmark = BookmarkedQuestion(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      questionText: questionText,
      options: options,
      correctAnswerIndex: correctAnswerIndex,
      explanation: explanation,
      category: category,
      difficulty: difficulty,
      bookmarkedAt: DateTime.now(),
      userNote: userNote,
    );

    await _firestore
        .collection('bookmarked_questions')
        .doc(userId)
        .collection('questions')
        .doc(bookmark.id)
        .set(bookmark.toJson());
  }

  // Get all bookmarks for a user
  Future<List<BookmarkedQuestion>> getUserBookmarks(String userId) async {
    final snapshot = await _firestore
        .collection('bookmarked_questions')
        .doc(userId)
        .collection('questions')
        .orderBy('bookmarkedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BookmarkedQuestion.fromJson(doc.data()))
        .toList();
  }

  // Remove a bookmark
  Future<void> removeBookmark(String userId, String bookmarkId) async {
    await _firestore
        .collection('bookmarked_questions')
        .doc(userId)
        .collection('questions')
        .doc(bookmarkId)
        .delete();
  }

  // Check if question is bookmarked
  Future<bool> isBookmarked(String userId, String questionText) async {
    final snapshot = await _firestore
        .collection('bookmarked_questions')
        .doc(userId)
        .collection('questions')
        .where('questionText', isEqualTo: questionText)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // Update bookmark note
  Future<void> updateBookmarkNote(
    String userId,
    String bookmarkId,
    String note,
  ) async {
    await _firestore
        .collection('bookmarked_questions')
        .doc(userId)
        .collection('questions')
        .doc(bookmarkId)
        .update({'userNote': note});
  }

  // Get bookmarks by category
  Future<List<BookmarkedQuestion>> getBookmarksByCategory(
    String userId,
    String category,
  ) async {
    final snapshot = await _firestore
        .collection('bookmarked_questions')
        .doc(userId)
        .collection('questions')
        .where('category', isEqualTo: category)
        .orderBy('bookmarkedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BookmarkedQuestion.fromJson(doc.data()))
        .toList();
  }

  // --- Compatibility Methods for Existing Code ---

  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  // Get all bookmarked questions as Question objects (for PracticeService)
  Future<List<Question>> getBookmarkedQuestions() async {
    if (_currentUserId.isEmpty) return [];

    final bookmarks = await getUserBookmarks(_currentUserId);
    return bookmarks
        .map((b) => Question.fromLocalJson({
              'category': b.category,
              'difficulty': b.difficulty,
              'question': b.questionText,
              'correct_answer': b.options[b.correctAnswerIndex],
              'incorrect_answers': b.options
                  .where((o) => o != b.options[b.correctAnswerIndex])
                  .toList(),
              'type': 'multiple',
              'explanation': b.explanation,
            }))
        .toList();
  }

  // Toggle bookmark for a question (for ReviewScreen)
  Future<bool> toggleBookmark(Question question) async {
    if (_currentUserId.isEmpty) return false;

    final isAlreadyBookmarked =
        await isBookmarked(_currentUserId, question.question);

    if (isAlreadyBookmarked) {
      // Find and remove
      final snapshot = await _firestore
          .collection('bookmarked_questions')
          .doc(_currentUserId)
          .collection('questions')
          .where('questionText', isEqualTo: question.question)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
      }
      return false;
    } else {
      // Add
      await bookmarkQuestion(
        userId: _currentUserId,
        questionText: question.question,
        options: question.shuffledAnswers,
        correctAnswerIndex:
            question.shuffledAnswers.indexOf(question.correctAnswer),
        explanation: question.explanation,
        category: question.category,
        difficulty: question.difficulty,
      );
      return true;
    }
  }

  // Check if question is bookmarked (Overload for Question object)
  Future<bool> isBookmarkedQuestion(Question question) async {
    if (_currentUserId.isEmpty) return false;
    return isBookmarked(_currentUserId, question.question);
  }

  // Clear all bookmarks (for SettingsScreen)
  Future<void> clearAllBookmarks() async {
    if (_currentUserId.isEmpty) return;

    final snapshot = await _firestore
        .collection('bookmarked_questions')
        .doc(_currentUserId)
        .collection('questions')
        .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
