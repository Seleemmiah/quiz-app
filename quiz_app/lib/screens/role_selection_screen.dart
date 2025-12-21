import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:quiz_app/services/auth_service.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Colors.purple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                FadeInDown(
                  child: const Text(
                    'Who are you?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'Choose your role to get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
                const Spacer(),

                // Teacher Option
                FadeInLeft(
                  delay: const Duration(milliseconds: 400),
                  child: _buildRoleOption(
                    context,
                    title: 'I am a Teacher',
                    subtitle: 'Create classes, quizzes, and track progress',
                    icon: Icons.school,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/signup',
                        arguments: {'role': 'teacher'},
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Student Option
                FadeInRight(
                  delay: const Duration(milliseconds: 600),
                  child: _buildRoleOption(
                    context,
                    title: 'I am a Student',
                    subtitle: 'Join classes, take quizzes, and learn',
                    icon: Icons.person,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/signup',
                        arguments: {'role': 'student'},
                      );
                    },
                  ),
                ),

                const Spacer(),

                // Guest Option
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: TextButton.icon(
                    onPressed: () async {
                      try {
                        await AuthService().signInAnonymously();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (route) => false);
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
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
