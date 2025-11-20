import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    // Wait for a moment to show the animation, then navigate.
    await Future.delayed(const Duration(seconds: 3));
    // Use pushReplacementNamed to ensure the splash screen is removed from the stack.
    // The '/' route correctly points to the StartScreen.
    if (mounted) Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animate the icon dropping in
            Icon(
              Icons.school,
              size: 120,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 20),
            // Animate the app title fading up
            Text(
              'Quiz App',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
