import 'dart:async';
import 'package:animate_do/animate_do.dart';
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
    if (mounted) Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animate the icon dropping in
            FadeInDown(
              duration: const Duration(milliseconds: 1000),
              child: Icon(
                Icons.school,
                size: 120,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            // Animate the app title fading up
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              duration: const Duration(milliseconds: 1000),
              child: Text(
                'Quiz App',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
