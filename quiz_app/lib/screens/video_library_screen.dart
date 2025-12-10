import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/video_explanation.dart';
import 'package:quiz_app/services/video_service.dart';
import 'package:quiz_app/screens/video_player_screen.dart';
import 'package:quiz_app/widgets/glass_card.dart';
import 'package:quiz_app/screens/start_screen.dart';

class VideoLibraryScreen extends StatefulWidget {
  const VideoLibraryScreen({super.key});

  @override
  State<VideoLibraryScreen> createState() => _VideoLibraryScreenState();
}

class _VideoLibraryScreenState extends State<VideoLibraryScreen> {
  final VideoService _videoService = VideoService();
  final TextEditingController _searchController = TextEditingController();
  List<VideoExplanation> _videos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDefaultVideos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultVideos() async {
    setState(() => _isLoading = true);
    final videos = await _videoService.searchVideos('Math Science');
    if (mounted) {
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    }
  }

  Future<void> _searchVideos(String query) async {
    if (query.isEmpty) {
      _loadDefaultVideos();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final videos = await _videoService.searchVideos(query);
    if (mounted) {
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Video Library'),
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
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    16, 12, 16, 8), // Reduced top padding
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4), // Reduced vertical padding
                  borderRadius: 30,
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14), // Smaller text
                    decoration: InputDecoration(
                      hintText: 'Search for topics...',
                      hintStyle:
                          TextStyle(color: Colors.grey[600], fontSize: 14),
                      prefixIcon: Icon(Icons.search,
                          color: Theme.of(context).primaryColor,
                          size: 20), // Smaller icon
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                _loadDefaultVideos();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10), // Reduced content padding
                      isDense: true,
                    ),
                    onSubmitted: _searchVideos,
                    onChanged: (value) => setState(() {}),
                  ),
                ),
              ),

              // Topic Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4), // Reduced vertical padding
                child: Row(
                  children: [
                    _buildTopicChip('Math'),
                    _buildTopicChip('Physics'),
                    _buildTopicChip('Chemistry'),
                    _buildTopicChip('Biology'),
                    _buildTopicChip('History'),
                    _buildTopicChip('Computer Science'),
                  ],
                ),
              ),

              // Quiz Me Button (Visible when searching)
              if (_searchController.text.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Capitalize search term to match category format
                        String category =
                            _capitalizeCategory(_searchController.text.trim());

                        // Navigate to StartScreen with the selected topic
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StartScreen(
                              initialCategory: category,
                            ),
                          ),
                          (route) => false, // Remove all previous routes
                        );
                      },
                      icon: const Icon(Icons.timer_outlined, size: 20),
                      label: Text('Take Quiz on "${_searchController.text}"'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10), // Reduced padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                ),

              // Videos List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _videos.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.video_library_outlined,
                                    size: 64,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5)),
                                const SizedBox(height: 16),
                                Text(
                                  'No videos found',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try searching for a different topic',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _videos.length,
                            itemBuilder: (context, index) {
                              final video = _videos[index];
                              return _buildGlassVideoCard(video);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassVideoCard(VideoExplanation video) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8), // Reduced bottom padding
      child: GestureDetector(
        onTap: () {
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
        child: GlassCard(
          padding: const EdgeInsets.all(8), // Reduced padding
          borderRadius: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail with Hero Animation
              Hero(
                tag: 'video_thumbnail_${video.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      video.thumbnailUrl != null
                          ? Image.network(
                              video.thumbnailUrl!,
                              width: 80, // Reduced width
                              height: 60, // Reduced height
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildThumbnailPlaceholder(),
                            )
                          : _buildThumbnailPlaceholder(),
                      Container(
                        width: 80, // Reduced width
                        height: 60, // Reduced height
                        color: Colors.black26,
                        child: const Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: 24, // Smaller icon
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10), // Reduced spacing

              // Video Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13, // Smaller font
                      ),
                    ),
                    const SizedBox(height: 2), // Reduced spacing
                    Text(
                      video.uploader,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 11, // Smaller font
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (video.duration > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time,
                                size: 10,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              '${(video.duration / 60).toStringAsFixed(0)} min',
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailPlaceholder() {
    return Container(
      width: 80, // Reduced width
      height: 60, // Reduced height
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.video_library,
        size: 24, // Smaller icon
        color: Theme.of(context).primaryColor.withOpacity(0.5),
      ),
    );
  }

  Widget _buildTopicChip(String label) {
    final isSelected =
        _searchController.text.toLowerCase().contains(label.toLowerCase());
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label:
            Text(label, style: const TextStyle(fontSize: 12)), // Smaller text
        padding: const EdgeInsets.symmetric(
            horizontal: 4, vertical: 0), // Reduced padding
        backgroundColor: isSelected
            ? Theme.of(context).primaryColor
            : Theme.of(context).cardColor.withOpacity(0.8),
        labelStyle: TextStyle(
          color: isSelected
              ? Colors.white
              : Theme.of(context).textTheme.bodyMedium?.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        onPressed: () {
          _searchController.text = label;
          _searchVideos(label);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  // Capitalize each word in the search term to match category format
  // "organic chemistry" -> "Organic Chemistry"
  String _capitalizeCategory(String text) {
    if (text.isEmpty) return text;

    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
