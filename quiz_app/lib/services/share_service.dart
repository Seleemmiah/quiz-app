import 'package:share_plus/share_plus.dart';
import 'dart:ui';

class ShareService {
  static Future<void> shareQuizResult({
    required String quizTitle,
    required int score,
    required int totalQuestions,
    required String category,
    Rect? sharePositionOrigin,
  }) async {
    final percentage = ((score / totalQuestions) * 100).round();
    final message =
        'I just scored $score/$totalQuestions ($percentage%) on "$quizTitle" in $category category! 🧠\n\nTry Mindly for gamified learning!';

    await Share.share(message,
        subject: 'My Quiz Result', sharePositionOrigin: sharePositionOrigin);
  }

  static Future<void> shareAchievement({
    required String achievementTitle,
    required String description,
    Rect? sharePositionOrigin,
  }) async {
    final message =
        '🏆 Achievement Unlocked: $achievementTitle\n\n$description\n\nJoin me on Mindly!';

    await Share.share(message,
        subject: 'Achievement Unlocked',
        sharePositionOrigin: sharePositionOrigin);
  }

  static Future<void> shareApp({
    Rect? sharePositionOrigin,
  }) async {
    const message =
        'Check out Mindly - The Ultimate Gamified Learning Experience! 📚✨\n\nDownload now and start your learning journey with interactive quizzes, achievements, and more!\n\nhttps://play.google.com/store/apps/details?id=com.mindly.app';

    await Share.share(message,
        subject: 'Discover Mindly', sharePositionOrigin: sharePositionOrigin);
  }
}
