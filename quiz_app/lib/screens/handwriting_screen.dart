import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/glass_card.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HandwritingScreen extends StatefulWidget {
  const HandwritingScreen({super.key});

  @override
  State<HandwritingScreen> createState() => _HandwritingScreenState();
}

class _HandwritingScreenState extends State<HandwritingScreen> {
  final List<Offset?> _points = [];
  bool _isRecognizing = false;
  String _solution = '';

  // AI Model for solving
  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: 'AIzaSyDAqx8gzlIKNU0-WGwuo4XVG45T1GrTQLE',
    );
  }

  void _clearCanvas() {
    setState(() {
      _points.clear();
      _solution = '';
    });
  }

  Future<void> _solveProblem() async {
    if (_points.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something first!')),
      );
      return;
    }

    setState(() => _isRecognizing = true);

    try {
      // For now, we'll use a prompt that asks the AI to solve a general math problem
      // In the future, this would be replaced with actual OCR
      final prompt = '''
I've written a math problem. Please solve this common math problem step by step:

Solve: 2x + 5 = 15

Provide:
1. The problem restated clearly
2. Step-by-step solution
3. Final answer

Format your response clearly with line breaks.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      setState(() {
        _solution = response.text ?? 'Could not generate solution';
      });
    } catch (e) {
      setState(() {
        _solution = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() => _isRecognizing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Math Solver'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Theme.of(context).primaryColor.withOpacity(0.7),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearCanvas,
            tooltip: 'Clear Canvas',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Instruction
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  borderRadius: 12,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Write a math problem below and tap "Solve"',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Canvas Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GlassCard(
                    padding: EdgeInsets.zero,
                    borderRadius: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _points.add(details.localPosition);
                          });
                        },
                        onPanEnd: (details) {
                          _points.add(null);
                        },
                        child: Container(
                          color: Colors.white.withOpacity(0.05),
                          child: CustomPaint(
                            painter: HandwritingPainter(
                              points: _points,
                              color: Theme.of(context).primaryColor,
                            ),
                            size: Size.infinite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Controls & Result
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Solution
                    if (_solution.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.15),
                              Theme.of(context).primaryColor.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.auto_fix_high,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Solution:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _solution,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Solve Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _isRecognizing ? null : _solveProblem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          disabledBackgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                        icon: _isRecognizing
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.auto_fix_high, size: 24),
                        label: Text(
                          _isRecognizing ? 'Solving...' : 'Solve Math Problem',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HandwritingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;

  HandwritingPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(HandwritingPainter oldDelegate) => true;
}
