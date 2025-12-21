import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ModernOnboardingScreen extends StatefulWidget {
  const ModernOnboardingScreen({super.key});

  @override
  State<ModernOnboardingScreen> createState() => _ModernOnboardingScreenState();
}

class _ModernOnboardingScreenState extends State<ModernOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to Mindly',
      subtitle: 'Your AI-Powered Learning Companion',
      description:
          'Master any subject with interactive quizzes, real-time analytics, and gamified learning',
      icon: Icons.psychology_rounded,
      gradient: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      lottieAsset: null,
    ),
    OnboardingPage(
      title: 'Smart Quizzes',
      subtitle: 'Learn Faster, Remember Longer',
      description:
          'AI-generated questions adapt to your skill level. Track progress with detailed analytics',
      icon: Icons.quiz_rounded,
      gradient: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
      lottieAsset: null,
    ),
    OnboardingPage(
      title: 'Secure Exams',
      subtitle: 'Academic Integrity Built-In',
      description:
          'Anti-cheating features, screenshot prevention, and session monitoring ensure fair assessments',
      icon: Icons.verified_user_rounded,
      gradient: [Color(0xFF10B981), Color(0xFF059669)],
      lottieAsset: null,
    ),
    OnboardingPage(
      title: 'Achievements & Streaks',
      subtitle: 'Make Learning Addictive',
      description:
          'Unlock badges, climb leaderboards, and maintain daily streaks. Compete with friends!',
      icon: Icons.emoji_events_rounded,
      gradient: [Color(0xFFF59E0B), Color(0xFFEF4444)],
      lottieAsset: null,
    ),
    OnboardingPage(
      title: 'Offline Mode',
      subtitle: 'Learn Anywhere, Anytime',
      description:
          'Download quizzes and study offline. Your progress syncs automatically when you\'re back online',
      icon: Icons.cloud_download_rounded,
      gradient: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
      lottieAsset: null,
    ),
  ];

  Future<void> _onGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/role_selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _onGetStarted,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _pages[_currentPage].gradient[0],
                    ),
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], index);
                },
              ),
            ),

            // Page Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: _pages[_currentPage].gradient[0],
                  dotColor: Colors.grey.shade300,
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 4,
                ),
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  if (_currentPage > 0)
                    FadeIn(
                      child: OutlinedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          side: BorderSide(
                            color: _pages[_currentPage].gradient[0],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: _pages[_currentPage].gradient[0],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Back',
                              style: TextStyle(
                                color: _pages[_currentPage].gradient[0],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 100),

                  // Next/Get Started Button
                  FadeIn(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _pages.length - 1) {
                          _onGetStarted();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        backgroundColor: _pages[_currentPage].gradient[0],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        children: [
                          Text(
                            _currentPage == _pages.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with Gradient Background
          FadeInDown(
            delay: Duration(milliseconds: 200 * index),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: page.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: page.gradient[0].withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                page.icon,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Title
          FadeInUp(
            delay: Duration(milliseconds: 300 * index),
            child: Text(
              page.title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),

          // Subtitle
          FadeInUp(
            delay: Duration(milliseconds: 400 * index),
            child: Text(
              page.subtitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: page.gradient[0],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          // Description
          FadeInUp(
            delay: Duration(milliseconds: 500 * index),
            child: Text(
              page.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final String? lottieAsset;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradient,
    this.lottieAsset,
  });
}
