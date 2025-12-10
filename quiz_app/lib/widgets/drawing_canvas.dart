import 'dart:ui';
import 'package:flutter/material.dart';

class DrawingCanvas extends StatefulWidget {
  final Function(List<List<Offset>>) onStrokesChanged;

  const DrawingCanvas({super.key, required this.onStrokesChanged});

  @override
  State<DrawingCanvas> createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];

  void clear() {
    setState(() {
      _strokes.clear();
      _currentStroke.clear();
    });
    widget.onStrokesChanged(_strokes);
  }

  void undo() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.removeLast();
      });
      widget.onStrokesChanged(_strokes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _currentStroke = [details.localPosition];
          _strokes.add(_currentStroke);
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _currentStroke.add(details.localPosition);
        });
      },
      onPanEnd: (details) {
        widget.onStrokesChanged(_strokes);
      },
      child: CustomPaint(
        painter: _DrawingPainter(_strokes),
        size: Size.infinite,
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;

  _DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length > 1) {
        Path path = Path();
        path.moveTo(stroke.first.dx, stroke.first.dy);
        for (int i = 1; i < stroke.length; i++) {
          path.lineTo(stroke[i].dx, stroke[i].dy);
        }
        canvas.drawPath(path, paint);
      } else if (stroke.isNotEmpty) {
        canvas.drawPoints(PointMode.points, stroke, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
