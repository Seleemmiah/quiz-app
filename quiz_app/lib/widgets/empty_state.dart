import 'package:flutter/material.dart';

/// Empty state widget for when there's no data to display
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  // Predefined empty states
  const EmptyState.noQuizzes({super.key})
      : icon = Icons.quiz_outlined,
        title = 'No Quizzes Yet',
        message = 'Start your first quiz to begin your learning journey!',
        actionLabel = 'Start Quiz',
        onAction = null;

  const EmptyState.noBookmarks({super.key})
      : icon = Icons.bookmark_border,
        title = 'No Bookmarks',
        message = 'Bookmark questions during quizzes to review them later.',
        actionLabel = null,
        onAction = null;

  const EmptyState.noAchievements({super.key})
      : icon = Icons.emoji_events_outlined,
        title = 'No Achievements Yet',
        message = 'Complete quizzes and challenges to unlock achievements!',
        actionLabel = 'Take a Quiz',
        onAction = null;

  const EmptyState.noResults({super.key})
      : icon = Icons.bar_chart_outlined,
        title = 'No Results Yet',
        message = 'Your quiz results and statistics will appear here.',
        actionLabel = 'Start Learning',
        onAction = null;

  const EmptyState.noClasses({super.key})
      : icon = Icons.school_outlined,
        title = 'No Classes',
        message =
            'Create or join a class to get started with collaborative learning.',
        actionLabel = 'Create Class',
        onAction = null;

  const EmptyState.noNotifications({super.key})
      : icon = Icons.notifications_none,
        title = 'No Notifications',
        message = 'You\'re all caught up! Check back later for updates.',
        actionLabel = null,
        onAction = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state for search results
class SearchEmptyState extends StatelessWidget {
  final String searchQuery;

  const SearchEmptyState({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'No Results Found',
      message:
          'We couldn\'t find anything matching "$searchQuery".\nTry different keywords.',
    );
  }
}

/// Empty state with illustration
class IllustratedEmptyState extends StatelessWidget {
  final String imagePath;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const IllustratedEmptyState({
    super.key,
    required this.imagePath,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 200,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.grey[400],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
