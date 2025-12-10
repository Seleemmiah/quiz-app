class VideoExplanation {
  final String id;
  final String questionId;
  final String videoUrl; // YouTube URL
  final String title;
  final int duration; // in seconds
  final String uploader;
  final String? thumbnailUrl;

  VideoExplanation({
    required this.id,
    required this.questionId,
    required this.videoUrl,
    required this.title,
    required this.duration,
    required this.uploader,
    this.thumbnailUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'videoUrl': videoUrl,
      'title': title,
      'duration': duration,
      'uploader': uploader,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory VideoExplanation.fromJson(Map<String, dynamic> json) {
    return VideoExplanation(
      id: json['id'] ?? '',
      questionId: json['questionId'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? 0,
      uploader: json['uploader'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}
