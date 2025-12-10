import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';

class EnhancedOnboardingScreen extends StatefulWidget {
  const EnhancedOnboardingScreen({super.key});

  @override
  State<EnhancedOnboardingScreen> createState() =>
      _EnhancedOnboardingScreenState();
}

class _EnhancedOnboardingScreenState extends State<EnhancedOnboardingScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  Future<void> _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/role_selection');
    }
  }

  Widget _buildImage(String assetName, {double height = 200}) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Icon(
        _getIconForAsset(assetName),
        size: height,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  IconData _getIconForAsset(String name) {
    switch (name) {
      case 'quiz':
        return Icons.quiz_rounded;
      case 'exam':
        return Icons.assignment_turned_in_rounded;
      case 'class':
        return Icons.school_rounded;
      case 'achievement':
        return Icons.emoji_events_rounded;
      case 'ai':
        return Icons.psychology_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: _introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: null,
      infiniteAutoScroll: false,
      pages: [
        // Page 1: Welcome
        PageViewModel(
          title: "Welcome to Mindly! 🧠",
          body:
              "Your AI-powered learning companion for quizzes, exams, and collaborative learning.",
          image: _buildImage('ai', height: 250),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 3,
            bodyAlignment: Alignment.center,
            imageAlignment: Alignment.center,
          ),
        ),

        // Page 2: Quizzes
        PageViewModel(
          title: "Take Interactive Quizzes 📝",
          body:
              "Test your knowledge across multiple subjects with our extensive question bank. Track your progress and improve your skills!",
          image: _buildImage('quiz'),
          decoration: pageDecoration,
        ),

        // Page 3: Secure Exams
        PageViewModel(
          title: "Secure Exam Mode 🔐",
          body:
              "Take proctored exams with advanced anti-cheating features. Screenshot prevention, device fingerprinting, and session monitoring ensure academic integrity.",
          image: _buildImage('exam'),
          decoration: pageDecoration,
        ),

        // Page 4: Classes
        PageViewModel(
          title: "Join Classes 👥",
          body:
              "Collaborate with teachers and classmates. Join study groups, participate in class quizzes, and track your performance on leaderboards.",
          image: _buildImage('class'),
          decoration: pageDecoration,
        ),

        // Page 5: Achievements
        PageViewModel(
          title: "Earn Achievements 🏆",
          body:
              "Unlock badges, maintain streaks, and climb the leaderboard. Gamified learning makes studying fun and engaging!",
          image: _buildImage('achievement'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: const Icon(Icons.arrow_back),
      skip: Text('Skip',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor)),
      next: Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
      done: Text('Get Started',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.grey.shade300,
        activeColor: Theme.of(context).primaryColor,
        activeSize: const Size(22.0, 10.0),
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
