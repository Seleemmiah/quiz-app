import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/bookmarked_question.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/bookmark_service.dart';
import 'package:quiz_app/screens/study_mode_screen.dart';
import 'package:quiz_app/widgets/loading_skeleton.dart';
import 'package:quiz_app/widgets/empty_state.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final BookmarkService _bookmarkService = BookmarkService();
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  List<BookmarkedQuestion> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    if (_userId.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final bookmarks = await _bookmarkService.getUserBookmarks(_userId);
      if (mounted) {
        setState(() {
          _bookmarks = bookmarks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading bookmarks: $e')),
        );
      }
    }
  }

  Future<void> _removeBookmark(String bookmarkId) async {
    try {
      await _bookmarkService.removeBookmark(_userId, bookmarkId);
      setState(() {
        _bookmarks.removeWhere((b) => b.id == bookmarkId);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookmark removed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing bookmark: $e')),
      );
    }
  }

  void _startStudySession() {
    if (_bookmarks.isEmpty) return;

    // Convert bookmarks to Questions
    final questions = _bookmarks
        .map((b) => Question.fromLocalJson({
              'category': b.category,
              'difficulty': b.difficulty,
              'question': b.questionText,
              'correct_answer': b.options[b
                  .correctAnswerIndex], // Assuming original correct answer is preserved or we can reconstruct
              // Wait, BookmarkedQuestion stores options and index. Question model needs correct answer string.
              // Let's assume options[correctAnswerIndex] is the correct answer.
              'incorrect_answers': b.options
                  .where((o) => o != b.options[b.correctAnswerIndex])
                  .toList(),
              'type': 'multiple', // Defaulting
              'explanation': b.explanation,
            }))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyModeScreen(
          questions: questions,
          category: 'Bookmarked Questions',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          if (_bookmarks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Study All Bookmarks',
              onPressed: _startStudySession,
            ),
        ],
      ),
      body: _isLoading
          ? ListSkeleton(
              itemCount: 5,
              itemBuilder: () => const QuizCardSkeleton(),
            )
          : _bookmarks.isEmpty
              ? const EmptyState.noBookmarks()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = _bookmarks[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.1),
                          child: Icon(Icons.question_mark,
                              color: Theme.of(context).primaryColor, size: 20),
                        ),
                        title: Text(
                          bookmark.questionText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${bookmark.category} • ${bookmark.difficulty}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Answer:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                                Text(bookmark
                                    .options[bookmark.correctAnswerIndex]),
                                if (bookmark.explanation != null) ...[
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Explanation:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                  Text(bookmark.explanation!),
                                ],
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      label: const Text('Remove',
                                          style: TextStyle(color: Colors.red)),
                                      onPressed: () =>
                                          _removeBookmark(bookmark.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
