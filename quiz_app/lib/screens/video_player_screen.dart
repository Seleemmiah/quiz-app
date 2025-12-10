import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:quiz_app/models/video_explanation.dart';
import 'package:quiz_app/widgets/glass_card.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final VideoExplanation? videoExplanation;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    this.videoExplanation,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  final TextEditingController _notesController = TextEditingController();
  bool _isBookmarked = false;
  bool _showNotes = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Video Explanation'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Theme.of(context).primaryColor.withOpacity(0.7),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showNotes ? Icons.notes : Icons.notes_outlined,
              color: _showNotes ? Colors.amber : Colors.white,
            ),
            onPressed: () {
              setState(() => _showNotes = !_showNotes);
            },
            tooltip: 'Toggle Notes',
          ),
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? Colors.amber : Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      _isBookmarked ? 'Video bookmarked!' : 'Bookmark removed'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            },
            tooltip: 'Bookmark Video',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Video Player
              Hero(
                tag: widget.videoExplanation != null
                    ? 'video_thumbnail_${widget.videoExplanation!.id}'
                    : 'video_player',
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Theme.of(context).primaryColor,
                  progressColors: ProgressBarColors(
                    playedColor: Theme.of(context).primaryColor,
                    handleColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),

              // Content Area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video Info
                      if (widget.videoExplanation != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GlassCard(
                            borderRadius: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.videoExplanation!.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.2),
                                      child: Icon(Icons.person,
                                          size: 14,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.videoExplanation!.uploader,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Notes Section
                      if (_showNotes)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GlassCard(
                            borderRadius: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.edit_note,
                                        color: Theme.of(context).primaryColor),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'My Notes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _notesController,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    hintText: 'Type your notes here...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Related Videos
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.video_library,
                                    color: Theme.of(context).primaryColor),
                                const SizedBox(width: 8),
                                const Text(
                                  'Related Videos',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 110,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: GlassCard(
                                      padding: EdgeInsets.zero,
                                      borderRadius: 12,
                                      child: SizedBox(
                                        width: 140,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.1),
                                                borderRadius: const BorderRadius
                                                    .vertical(
                                                    top: Radius.circular(12)),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.play_circle_outline,
                                                  size: 32,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Related Topic ${index + 1}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
