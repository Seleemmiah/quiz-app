import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _iconController;
  late AnimationController _textController;

  @override
  void initState() {
    super.initState();

    // Background Animation (Continuous)
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Icon Pulse Animation
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Text Staggered Animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Delay text slightly
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _textController.forward();
    });

    _navigateToHome();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _iconController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/role_selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Dynamic Gradient based on Theme
    final gradientColors = isDark
        ? [Colors.black, primaryColor.withOpacity(0.3)]
        : [
            primaryColor,
            primaryColor
                .withRed(primaryColor.red - 30)
                .withGreen(primaryColor.green - 30)
          ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Stack(
          children: [
            // Layer 1: Dynamic Particles Background
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _backgroundController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ParticleNetworkPainter(
                      animationValue: _backgroundController.value,
                      color: Colors.white.withOpacity(0.15),
                    ),
                  );
                },
              ),
            ),

            // Layer 2: Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Replaced Big 'M' with Glowing Brain/School Icon
                  AnimatedBuilder(
                    animation: _iconController,
                    builder: (context, child) {
                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white
                                  .withOpacity(0.2 * _iconController.value),
                              blurRadius: 20 + (10 * _iconController.value),
                              spreadRadius: 5 + (5 * _iconController.value),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.psychology, // Brain icon for "Mindly"
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Staggered Text Animation "Mindly" (Title Case)
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildStaggeredText('Mindly'),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Tagline with Slide Up
                  FadeInUp(
                    delay: const Duration(milliseconds: 1500),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Text(
                        'Learn. Play. Win.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Layer 3: Bottom Loading Indicator
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: FadeIn(
                  delay: const Duration(milliseconds: 2000),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStaggeredText(String text) {
    List<Widget> letters = [];
    for (int i = 0; i < text.length; i++) {
      final double start = i * 0.1;
      final double end = start + 0.4;

      final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _textController,
          curve:
              Interval(start, end > 1.0 ? 1.0 : end, curve: Curves.easeOutBack),
        ),
      );

      letters.add(
        Transform.translate(
          offset: Offset(0, 20 * (1 - animation.value)),
          child: Opacity(
            // Fix: Clamp opacity to ensure it's always valid
            opacity: animation.value.clamp(0.0, 1.0),
            child: Text(
              text[i],
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1, // Reduced spacing for title case
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
        ),
      );
    }
    return letters;
  }
}

// Custom Painter for Background Particles
class ParticleNetworkPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final math.Random random = math.Random(42); // Fixed seed

  ParticleNetworkPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 1.0;

    List<Offset> particles = [];

    // Generate moving particles
    for (int i = 0; i < 15; i++) {
      // Use sine waves for smooth movement
      double x = (size.width * (0.1 + 0.8 * random.nextDouble())) +
          math.sin(animationValue * 2 * math.pi + i) * 20;
      double y = (size.height * (0.1 + 0.8 * random.nextDouble())) +
          math.cos(animationValue * 2 * math.pi + i * 2) * 20;

      particles.add(Offset(x, y));
      canvas.drawCircle(Offset(x, y), 3, paint);
    }

    // Connect nearby particles
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        double dist = (particles[i] - particles[j]).distance;
        if (dist < 150) {
          // Fade line based on distance
          linePaint.color = color.withOpacity(0.3 * (1 - dist / 150));
          canvas.drawLine(particles[i], particles[j], linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticleNetworkPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
