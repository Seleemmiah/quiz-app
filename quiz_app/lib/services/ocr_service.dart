import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:flutter/material.dart' hide Ink;

class OCRService {
  final DigitalInkRecognizerModelManager _modelManager =
      DigitalInkRecognizerModelManager();
  final String _language = 'en-US';
  late DigitalInkRecognizer _recognizer;

  OCRService() {
    _recognizer = DigitalInkRecognizer(languageCode: _language);
  }

  Future<bool> isModelDownloaded() async {
    return await _modelManager.isModelDownloaded(_language);
  }

  Future<String> downloadModel() async {
    try {
      final result = await _modelManager.downloadModel(_language);
      return result ? 'Model downloaded' : 'Failed to download model';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> recognize(List<List<Offset>> strokes) async {
    if (strokes.isEmpty) return '';

    final ink = Ink();
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    for (final strokePoints in strokes) {
      if (strokePoints.isEmpty) continue;

      final stroke = Stroke();
      for (int i = 0; i < strokePoints.length; i++) {
        final point = strokePoints[i];
        // Add points with incrementing timestamps for better recognition
        stroke.points.add(
          StrokePoint(
            x: point.dx,
            y: point.dy,
            t: timestamp + i,
          ),
        );
      }
      ink.strokes.add(stroke);
      timestamp += strokePoints.length;
    }

    try {
      final candidates = await _recognizer.recognize(ink);
      if (candidates.isNotEmpty) {
        return candidates.first.text;
      }
    } catch (e) {
      debugPrint('Recognition error: $e');
    }
    return '';
  }

  void dispose() {
    _recognizer.close();
  }
}
