import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/models/video_explanation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // YouTube Data API v3 Key
  static const String _apiKey = 'AIzaSyAEZSpjuaT3AaLNA_avGVvaczFR08QdSRU';
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  // Search YouTube for topic using real API
  Future<List<VideoExplanation>> searchVideos(String topic) async {
    try {
      // Build search query
      final query = Uri.encodeComponent('$topic explanation tutorial');
      final url = Uri.parse(
        '$_baseUrl/search?part=snippet&q=$query&type=video&maxResults=5&key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;

        // Convert YouTube search results to VideoExplanation objects
        final videos = <VideoExplanation>[];
        for (final item in items) {
          final snippet = item['snippet'];
          final videoId = item['id']['videoId'];

          videos.add(VideoExplanation(
            id: videoId,
            questionId: '',
            videoUrl: 'https://www.youtube.com/watch?v=$videoId',
            title: snippet['title'] ?? 'Video Explanation',
            duration: 0, // Would need additional API call to get duration
            uploader: snippet['channelTitle'] ?? 'Unknown',
            thumbnailUrl: snippet['thumbnails']?['medium']?['url'] ??
                'https://img.youtube.com/vi/$videoId/mqdefault.jpg',
          ));
        }

        return videos;
      } else {
        print('YouTube API error: ${response.statusCode}');
        return _getMockVideos(topic);
      }
    } catch (e) {
      print('Error searching YouTube: $e');
      // Fallback to mock data if API fails
      return _getMockVideos(topic);
    }
  }

  // Fallback mock data if API fails or quota exceeded
  List<VideoExplanation> _getMockVideos(String topic) {
    return [
      VideoExplanation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        questionId: '',
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        title: 'Explanation for $topic',
        duration: 180,
        uploader: 'Mindly Education',
        thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg',
      ),
      VideoExplanation(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        questionId: '',
        videoUrl: 'https://www.youtube.com/watch?v=jNQXAC9IVRw',
        title: 'Advanced $topic Concepts',
        duration: 300,
        uploader: 'Science Channel',
        thumbnailUrl: 'https://img.youtube.com/vi/jNQXAC9IVRw/0.jpg',
      ),
    ];
  }

  // Get video for question
  Future<VideoExplanation?> getVideoForQuestion(String questionId) async {
    try {
      final snapshot = await _db
          .collection('video_explanations')
          .where('questionId', isEqualTo: questionId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return VideoExplanation.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print('Error getting video for question: $e');
      return null;
    }
  }

  // Save custom video link
  Future<void> linkVideo(VideoExplanation video) async {
    await _db
        .collection('video_explanations')
        .doc(video.id)
        .set(video.toJson());
  }

  // Get video details (duration, etc.) - optional enhancement
  Future<Map<String, dynamic>?> getVideoDetails(String videoId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/videos?part=contentDetails,statistics&id=$videoId&key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;
        if (items.isNotEmpty) {
          return items.first;
        }
      }
      return null;
    } catch (e) {
      print('Error getting video details: $e');
      return null;
    }
  }
}
