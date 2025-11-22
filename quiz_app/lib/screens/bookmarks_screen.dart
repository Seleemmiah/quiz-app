import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/bookmark_service.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final BookmarkService _bookmarkService = BookmarkService();
  List<Question> _allBookmarks = [];
  List<Question> _filteredBookmarks = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _searchController.addListener(_filterBookmarks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarks() async {
    setState(() => _isLoading = true);
    try {
      final bookmarks = await _bookmarkService.getBookmarkedQuestions();
      if (mounted) {
        setState(() {
          _allBookmarks = bookmarks;
          _filteredBookmarks = bookmarks;
          _isLoading = false;
        });
        _filterBookmarks(); // Re-filter in case there was a query
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterBookmarks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredBookmarks = List.from(_allBookmarks);
      } else {
        _filteredBookmarks = _allBookmarks.where((q) {
          return q.question.toLowerCase().contains(query) ||
              q.category.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _removeBookmark(Question question) async {
    await _bookmarkService.toggleBookmark(question);
    _loadBookmarks();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark removed')),
      );
    }
  }

  Future<void> _clearAllBookmarks() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Bookmarks?'),
        content: const Text(
            'Are you sure you want to remove all bookmarked questions?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _bookmarkService.clearAllBookmarks();
      _loadBookmarks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All bookmarks cleared')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Questions'),
        actions: [
          if (_allBookmarks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAllBookmarks,
              tooltip: 'Clear all bookmarks',
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          if (_allBookmarks.isNotEmpty || _searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search bookmarks...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
              ),
            ),

          // List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _allBookmarks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bookmark_border,
                                size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 20),
                            Text(
                              'No bookmarked questions',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Bookmark questions during review to save them here!',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : _filteredBookmarks.isEmpty
                        ? Center(
                            child: Text(
                              'No bookmarks match your search.',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: _filteredBookmarks.length,
                            itemBuilder: (context, index) {
                              final question = _filteredBookmarks[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ExpansionTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.1),
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    question.question,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            question.category,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getDifficultyColor(
                                                    question.difficulty)
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            question.difficulty.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: _getDifficultyColor(
                                                  question.difficulty),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.bookmark,
                                        color: Colors.amber),
                                    onPressed: () => _removeBookmark(question),
                                    tooltip: 'Remove bookmark',
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Correct Answer:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.green
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 2),
                                            ),
                                            child: Text(
                                              question.correctAnswer,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          if (question.explanation != null) ...[
                                            const SizedBox(height: 16),
                                            Text(
                                              'Explanation:',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              question.explanation!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
