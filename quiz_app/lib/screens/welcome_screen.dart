import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:quiz_app/services/auth_service.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),

                // App Icon with Animation
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: const Hero(
                    tag: 'app_icon',
                    child: Icon(
                      Icons.school,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // App Name
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: const Text(
                    'Mindly',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tagline
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    'Test your knowledge.\nTrack your progress.\nAchieve greatness.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                ),

                const Spacer(),

                // Features List
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildFeature(Icons.quiz, 'AI-Powered Quizzes'),
                        const SizedBox(height: 12),
                        _buildFeature(Icons.cloud, 'Cloud Sync'),
                        const SizedBox(height: 12),
                        _buildFeature(Icons.groups, 'Share & Collaborate'),
                        const SizedBox(height: 12),
                        _buildFeature(Icons.analytics, 'Track Progress'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Get Started Button
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Login Button
                FadeInUp(
                  delay: const Duration(milliseconds: 1000),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Already have an account? Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Guest Button
                FadeInUp(
                  delay: const Duration(milliseconds: 1200),
                  child: TextButton.icon(
                    onPressed: () async {
                      try {
                        await AuthService().signInAnonymously();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Guest login failed: $e')),
                          );
                        }
                      }
                    },
                    icon:
                        const Icon(Icons.person_outline, color: Colors.white70),
                    label: const Text(
                      'Continue as Guest',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
