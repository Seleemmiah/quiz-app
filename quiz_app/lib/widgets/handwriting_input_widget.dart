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
  final DigitalInkRecognizerModelManager _modelManager =
      DigitalInkRecognizerModelManager();
  final String _languageCode = 'en-US';
  final ValueNotifier<Ink> _inkNotifier = ValueNotifier<Ink>(Ink());
  List<StrokePoint> _points = [];
  String _recognizedText = '';
  bool _isInitialized = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _initializeRecognizer();
  }

  Future<void> _initializeRecognizer() async {
    try {
      final isDownloaded = await _modelManager.isModelDownloaded(_languageCode);
      if (!isDownloaded) {
        setState(() => _isDownloading = true);
        await _modelManager.downloadModel(_languageCode);
        setState(() => _isDownloading = false);
      }
      _digitalInkRecognizer = DigitalInkRecognizer(languageCode: _languageCode);
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint('ML Kit initialization failed (simulator?): $e');
      if (mounted) {
        setState(() {
          _isInitialized = false;
          _isDownloading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _digitalInkRecognizer?.close();
    _inkNotifier.dispose();
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
      final candidates =
          await _digitalInkRecognizer!.recognize(_inkNotifier.value);
      if (candidates.isNotEmpty) {
        setState(() {
          _recognizedText = candidates.first.text;
        });
        widget.onRecognized(_recognizedText);
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
      _inkNotifier.value = Ink();
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
          child: Stack(
            children: [
              GestureDetector(
                onPanStart: (details) {
                  _points = [];
                  _inkNotifier.value.strokes.add(Stroke());
                },
                onPanUpdate: (details) {
                  final point = StrokePoint(
                    x: details.localPosition.dx,
                    y: details.localPosition.dy,
                    t: DateTime.now().millisecondsSinceEpoch,
                  );
                  _points.add(point);
                  if (_inkNotifier.value.strokes.isNotEmpty) {
                    _inkNotifier.value.strokes.last.points.add(point);
                    // Trigger rebuild of listener only
                    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                    _inkNotifier.notifyListeners();
                  }
                },
                onPanEnd: (details) {
                  _points = [];
                  _recognize();
                },
                child: RepaintBoundary(
                  child: ValueListenableBuilder<Ink>(
                    valueListenable: _inkNotifier,
                    builder: (context, ink, child) {
                      return CustomPaint(
                        painter: InkPainter(ink: ink),
                        size: Size.infinite,
                      );
                    },
                  ),
                ),
              ),
              if (_isDownloading)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text(
                          'Downloading recognition model...',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
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
