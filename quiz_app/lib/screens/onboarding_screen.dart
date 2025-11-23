import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _onGetStarted(BuildContext context) async {
    // When the user taps "Get Started", we'll save a preference
    // to remember that they've seen this screen.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    // Then, navigate to the main screen of the app and remove this
    // onboarding screen from the navigation stack.
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.quiz_rounded,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to the Quiz App!',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Test your knowledge with our fun quizzes or create your own to challenge your friends.',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              const _FeatureTile(
                icon: Icons.play_circle_outline,
                title: 'Play Standard Quizzes',
                subtitle: 'Choose from various categories and start playing.',
              ),
              const SizedBox(height: 16),
              const _FeatureTile(
                icon: Icons.add_circle_outline,
                title: 'Create Your Own',
                subtitle: 'Build custom questions and play your own quizzes.',
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _onGetStarted(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Get Started'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// A small helper widget for displaying features.
class _FeatureTile extends StatelessWidget {
  const _FeatureTile(
      {required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 32, color: Theme.of(context).primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
