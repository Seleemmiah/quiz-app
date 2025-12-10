import 'package:flutter/material.dart' hide Ink;
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';

class HandwritingInputWidget extends StatefulWidget {
  final Function(String) onRecognized;

  const HandwritingInputWidget({super.key, required this.onRecognized});

  @override
  State<HandwritingInputWidget> createState() => _HandwritingInputWidgetState();
}

class _HandwritingInputWidgetState extends State<HandwritingInputWidget> {
  DigitalInkRecognizer? _digitalInkRecognizer;
  final Ink _ink = Ink();
  List<StrokePoint> _points = [];
  String _recognizedText = '';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeRecognizer();
  }

  Future<void> _initializeRecognizer() async {
    try {
      _digitalInkRecognizer = DigitalInkRecognizer(languageCode: 'en-US');
      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('ML Kit initialization failed (simulator?): $e');
      setState(() => _isInitialized = false);
    }
  }

  @override
  void dispose() {
    _digitalInkRecognizer?.close();
    super.dispose();
  }

  Future<void> _recognize() async {
    if (!_isInitialized || _digitalInkRecognizer == null) {
      // Fallback: Just show a message that recognition is unavailable
      setState(() {
        _recognizedText = 'Recognition unavailable on simulator';
      });
      return;
    }

    try {
      final candidates = await _digitalInkRecognizer!.recognize(_ink);
      if (candidates.isNotEmpty) {
        _recognizedText = candidates.first.text;
        widget.onRecognized(_recognizedText);
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error recognizing ink: $e');
      setState(() {
        _recognizedText =
            'Recognition error: ${e.toString().substring(0, 30)}...';
      });
    }
  }

  void _clear() {
    setState(() {
      _ink.strokes.clear();
      _points.clear();
      _recognizedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onPanStart: (details) {
              _points = [];
              _ink.strokes.add(Stroke());
            },
            onPanUpdate: (details) {
              setState(() {
                final point = StrokePoint(
                  x: details.localPosition.dx,
                  y: details.localPosition.dy,
                  t: DateTime.now().millisecondsSinceEpoch,
                );
                _points.add(point);
                // Also update the last stroke in _ink
                if (_ink.strokes.isNotEmpty) {
                  _ink.strokes.last.points.add(point);
                }
              });
            },
            onPanEnd: (details) {
              _points = [];
              _recognize();
            },
            child: CustomPaint(
              painter: InkPainter(ink: _ink),
              size: Size.infinite,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Recognized: $_recognizedText',
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(onPressed: _clear, child: const Text('Clear')),
          ],
        ),
      ],
    );
  }
}

class InkPainter extends CustomPainter {
  final Ink ink;

  InkPainter({required this.ink});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (final stroke in ink.strokes) {
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = stroke.points[i];
        final p2 = stroke.points[i + 1];
        canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
