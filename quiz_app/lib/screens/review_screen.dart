import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/bookmark_service.dart';
import 'package:quiz_app/services/ai_service.dart';
import 'package:quiz_app/screens/video_player_screen.dart';
import 'package:quiz_app/services/video_service.dart';
import 'package:quiz_app/models/video_explanation.dart';
import 'package:quiz_app/services/quota_service.dart';
import 'package:quiz_app/widgets/glass_dialog.dart';

class ReviewScreen extends StatefulWidget {
  final List<Question> questions;
  final List<String?> selectedAnswers;

  const ReviewScreen({
    super.key,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _reviewIndex = 0;
  bool _showIncorrectOnly = false;
  List<int> _filteredIndices = [];
  final BookmarkService _bookmarkService = BookmarkService();
  final Map<int, bool> _bookmarkStates = {};

  @override
  void initState() {
    super.initState();
    _updateFilteredIndices();
    _loadBookmarkStates();
  }

  Future<void> _loadBookmarkStates() async {
    for (int i = 0; i < widget.questions.length; i++) {
      final isBookmarked =
          await _bookmarkService.isBookmarkedQuestion(widget.questions[i]);
      if (mounted) {
        setState(() {
          _bookmarkStates[i] = isBookmarked;
        });
      }
    }
  }

  Future<void> _toggleBookmark(int index) async {
    final question = widget.questions[index];
    final isBookmarked = await _bookmarkService.toggleBookmark(question);
    if (mounted) {
      setState(() {
        _bookmarkStates[index] = isBookmarked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(isBookmarked ? 'Question bookmarked' : 'Bookmark removed'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _updateFilteredIndices() {
    if (_showIncorrectOnly) {
      _filteredIndices = [];
      for (int i = 0; i < widget.questions.length; i++) {
        if (widget.selectedAnswers[i] != widget.questions[i].correctAnswer) {
          _filteredIndices.add(i);
        }
      }
    } else {
      _filteredIndices = List.generate(widget.questions.length, (i) => i);
    }
    _reviewIndex = 0;
  }

  void _goToQuestion(int index) {
    setState(() {
      _reviewIndex = index;
    });
  }

  Future<void> _askAiTutor(
      String question, String correctAnswer, String userAnswer) async {
    final quotaService = QuotaService();

    // Check quota
    final hasQuota = await quotaService.hasRemainingQuota('ai_explanation');
    if (!hasQuota) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Daily Limit Reached 🛑'),
            content: const Text(
              'You have used up your daily AI Tutor explanations. Please try again tomorrow or upgrade for more!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Use a local context that is passed to showDialog
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final explanation = await AIService().getExplanation(
        question: question,
        correctAnswer: correctAnswer,
        userAnswer: userAnswer,
      );

      if (mounted) {
        Navigator.pop(context); // Dismiss loading
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.purple),
                SizedBox(width: 8),
                Text('AI Tutor'),
              ],
            ),
            content: Text(explanation),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Thanks!'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _watchExplanation(Question question) async {
    if (question.videoUrl != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            videoUrl: question.videoUrl!,
            videoExplanation: VideoExplanation(
              id: 'embedded',
              questionId: '',
              videoUrl: question.videoUrl!,
              title: 'Explanation',
              duration: 0,
              uploader: 'Mindly',
            ),
          ),
        ),
      );
    } else {
      // Search for video
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Search using category and a snippet of the question to be more relevant
        final query =
            '${question.category} ${question.question.length > 50 ? question.question.substring(0, 50) : question.question} explanation';
        final videos = await VideoService().searchVideos(query);

        if (mounted) {
          Navigator.pop(context); // Dismiss loading
          if (videos.isNotEmpty) {
            _showVideoSelectionDialog(videos);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No video explanation found.')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error searching videos: $e')),
          );
        }
      }
    }
  }

  void _showVideoSelectionDialog(List<VideoExplanation> videos) {
    GlassDialog.show(
      context: context,
      title: 'Select Video Explanation',
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return ListTile(
              leading: Image.network(video.thumbnailUrl ?? '',
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => const Icon(Icons.video_library)),
              title: Text(video.title,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text(video.uploader),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      videoUrl: video.videoUrl,
                      videoExplanation: video,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_filteredIndices.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Review Answers'),
          actions: [
            FilterChip(
              label: const Text('Incorrect Only'),
              selected: _showIncorrectOnly,
              onSelected: (bool value) {
                setState(() {
                  _showIncorrectOnly = value;
                  _updateFilteredIndices();
                });
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 80, color: Colors.green),
              const SizedBox(height: 20),
              Text(
                _showIncorrectOnly
                    ? 'Great job! No incorrect answers.'
                    : 'No questions to review.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (_showIncorrectOnly)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showIncorrectOnly = false;
                      _updateFilteredIndices();
                    });
                  },
                  child: const Text('Show All Questions'),
                ),
            ],
          ),
        ),
      );
    }

    final realIndex = _filteredIndices[_reviewIndex];
    final currentQuestion = widget.questions[realIndex];
    final selectedAnswer = widget.selectedAnswers[realIndex];
    final isCorrect = selectedAnswer == currentQuestion.correctAnswer;

    return Scaffold(
      appBar: AppBar(
        title: Text('Review (${_reviewIndex + 1}/${_filteredIndices.length})'),
        actions: [
          IconButton(
            icon: Icon(
              _bookmarkStates[realIndex] == true
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: _bookmarkStates[realIndex] == true ? Colors.amber : null,
            ),
            onPressed: () => _toggleBookmark(realIndex),
            tooltip: 'Bookmark question',
          ),
          FilterChip(
            label: const Text('Incorrect Only'),
            selected: _showIncorrectOnly,
            onSelected: (bool value) {
              setState(() {
                _showIncorrectOnly = value;
                _updateFilteredIndices();
              });
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (_reviewIndex + 1) / _filteredIndices.length,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${realIndex + 1} of ${widget.questions.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text(
                currentQuestion.question,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ...currentQuestion.shuffledAnswers.map((answer) {
                final isCorrectAnswer = answer == currentQuestion.correctAnswer;
                final isSelectedAnswer = answer == selectedAnswer;

                Color borderColor = Colors.transparent;
                Icon? trailingIcon;
                String? subtitle;

                // Case 1: The user's answer was correct.
                if (isSelectedAnswer && isCorrect) {
                  borderColor = Colors.green;
                  trailingIcon =
                      const Icon(Icons.check_circle, color: Colors.green);
                  subtitle = 'Your Answer (Correct)';
                }
                // Case 2: The user's answer was incorrect.
                else if (isSelectedAnswer && !isCorrect) {
                  borderColor = Colors.red;
                  trailingIcon = const Icon(Icons.cancel, color: Colors.red);
                  subtitle = 'Your Answer (Incorrect)';
                }
                // Case 3: This is the correct answer, which the user did NOT pick.
                else if (isCorrectAnswer) {
                  borderColor = Colors.green;
                  trailingIcon = const Icon(Icons.check_circle_outline,
                      color: Colors.green);
                  subtitle = 'Correct Answer';
                }

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: borderColor, width: 2),
                  ),
                  child: ListTile(
                    title: Text(answer),
                    subtitle: subtitle != null
                        ? Text(subtitle,
                            style: TextStyle(
                                color: borderColor,
                                fontWeight: FontWeight.bold))
                        : null,
                    trailing: trailingIcon,
                  ),
                );
              }),
              const SizedBox(height: 30),
              // Explanation Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Explanation:',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  _watchExplanation(currentQuestion),
                              icon: const Icon(Icons.play_circle_filled,
                                  color: Colors.red),
                              tooltip: 'Watch Video Explanation',
                            ),
                            TextButton.icon(
                              onPressed: () => _askAiTutor(
                                currentQuestion.question,
                                currentQuestion.correctAnswer,
                                selectedAnswer ?? 'No Answer',
                              ),
                              icon: const Icon(Icons.psychology,
                                  color: Colors.purple),
                              label: const Text('Ask AI Tutor'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentQuestion.explanation ??
                          'No explanation available for this question.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Button
            TextButton.icon(
              icon: const Icon(Icons.arrow_back_ios),
              label: const Text('Previous'),
              onPressed: _reviewIndex > 0
                  ? () => _goToQuestion(_reviewIndex - 1)
                  : null,
            ),
            // Next Button
            TextButton.icon(
              icon: const Icon(Icons.arrow_forward_ios),
              label: const Text('Next'),
              onPressed: _reviewIndex < _filteredIndices.length - 1
                  ? () => _goToQuestion(_reviewIndex + 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
