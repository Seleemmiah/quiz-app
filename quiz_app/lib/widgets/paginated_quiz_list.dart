import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/widgets/lazy_image.dart';
import 'package:quiz_app/services/cache_service.dart';

/// Paginated quiz list with lazy loading and caching
class PaginatedQuizList extends StatefulWidget {
  final List<Question> questions;
  final int questionsPerPage;
  final Function(Question question, int index)? onQuestionTap;
  final ScrollController? scrollController;

  const PaginatedQuizList({
    super.key,
    required this.questions,
    this.questionsPerPage = 10,
    this.onQuestionTap,
    this.scrollController,
  });

  @override
  State<PaginatedQuizList> createState() => _PaginatedQuizListState();
}

class _PaginatedQuizListState extends State<PaginatedQuizList> {
  final List<Question> _visibleQuestions = [];
  int _currentPage = 0;
  bool _isLoading = false;
  final ScrollController _internalController = ScrollController();

  ScrollController get _controller =>
      widget.scrollController ?? _internalController;

  @override
  void initState() {
    super.initState();
    _loadInitialPage();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _loadInitialPage() {
    _loadPage(0);
  }

  Future<void> _loadPage(int page) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final startIndex = page * widget.questionsPerPage;
    final endIndex = (startIndex + widget.questionsPerPage)
        .clamp(0, widget.questions.length);

    if (startIndex >= widget.questions.length) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Try to load from cache first
    final cacheKey = 'questions_page_${page}_${widget.questions.hashCode}';
    List<Question>? cachedQuestions =
        await CacheService.get<List<Question>>(cacheKey);

    if (cachedQuestions != null) {
      setState(() {
        _visibleQuestions.addAll(cachedQuestions);
        _currentPage = page;
        _isLoading = false;
      });
      return;
    }

    // Load from original list
    final newQuestions = widget.questions.sublist(startIndex, endIndex);

    // Cache the page
    await CacheService.set(
      cacheKey,
      newQuestions,
      expiration: const Duration(minutes: 30),
      tags: ['questions', 'pagination'],
    );

    setState(() {
      _visibleQuestions.addAll(newQuestions);
      _currentPage = page;
      _isLoading = false;
    });
  }

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      _loadPage(_currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      itemCount: _visibleQuestions.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _visibleQuestions.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final question = _visibleQuestions[index];
        final globalIndex = _currentPage * widget.questionsPerPage + index;

        return QuestionListItem(
          question: question,
          index: globalIndex,
          onTap: widget.onQuestionTap != null
              ? () => widget.onQuestionTap!(question, globalIndex)
              : null,
        );
      },
    );
  }
}

/// Optimized question list item
class QuestionListItem extends StatelessWidget {
  final Question question;
  final int index;
  final VoidCallback? onTap;

  const QuestionListItem({
    super.key,
    required this.question,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question number and category
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Q${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      question.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Question text
              Text(
                question.question,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // Image if available
              if (question.imageUrl != null) ...[
                const SizedBox(height: 8),
                LazyImage(
                  imageUrl: question.imageUrl!,
                  height: 120,
                  borderRadius: BorderRadius.circular(8),
                  fit: BoxFit.cover,
                ),
              ],

              const SizedBox(height: 8),

              // Options preview
              Row(
                children: [
                  Icon(
                    question.isTrueFalse
                        ? Icons.radio_button_checked
                        : Icons.check_box,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    question.isTrueFalse
                        ? 'True/False'
                        : '${question.shuffledAnswers.length} options',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Virtualized leaderboard list for better performance
class VirtualizedLeaderboard extends StatefulWidget {
  final List<LeaderboardEntry> entries;
  final double itemHeight;
  final Widget Function(BuildContext context, LeaderboardEntry entry, int index)
      itemBuilder;

  const VirtualizedLeaderboard({
    super.key,
    required this.entries,
    required this.itemHeight,
    required this.itemBuilder,
  });

  @override
  State<VirtualizedLeaderboard> createState() => _VirtualizedLeaderboardState();
}

class _VirtualizedLeaderboardState extends State<VirtualizedLeaderboard> {
  final ScrollController _controller = ScrollController();
  double _scrollOffset = 0.0;
  double _viewportHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _scrollOffset = _controller.offset;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _viewportHeight = constraints.maxHeight;

        final firstVisibleIndex = (_scrollOffset / widget.itemHeight).floor();
        final lastVisibleIndex =
            ((_scrollOffset + _viewportHeight) / widget.itemHeight).ceil() + 1;

        final visibleEntries = <Widget>[];

        for (int i = firstVisibleIndex; i <= lastVisibleIndex; i++) {
          if (i >= 0 && i < widget.entries.length) {
            visibleEntries.add(
              Positioned(
                top: i * widget.itemHeight,
                left: 0,
                right: 0,
                height: widget.itemHeight,
                child: widget.itemBuilder(context, widget.entries[i], i),
              ),
            );
          }
        }

        return SingleChildScrollView(
          controller: _controller,
          child: SizedBox(
            height: widget.entries.length * widget.itemHeight,
            child: Stack(
              children: visibleEntries,
            ),
          ),
        );
      },
    );
  }
}

/// Leaderboard entry model (placeholder - adjust based on your actual model)
class LeaderboardEntry {
  final String name;
  final int score;
  final int rank;

  const LeaderboardEntry({
    required this.name,
    required this.score,
    required this.rank,
  });
}
