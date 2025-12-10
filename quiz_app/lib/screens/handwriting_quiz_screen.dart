import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/ocr_service.dart';
import 'package:quiz_app/widgets/drawing_canvas.dart';

class HandwritingQuizScreen extends StatefulWidget {
  final Question question;

  const HandwritingQuizScreen({super.key, required this.question});

  @override
  State<HandwritingQuizScreen> createState() => _HandwritingQuizScreenState();
}

class _HandwritingQuizScreenState extends State<HandwritingQuizScreen> {
  final OCRService _ocrService = OCRService();
  final GlobalKey<DrawingCanvasState> _canvasKey = GlobalKey();
  String _recognizedText = '';
  bool _isModelDownloaded = false;
  List<List<Offset>> _strokes = [];
  bool _isRecognizing = false;

  @override
  void initState() {
    super.initState();
    _checkModel();
  }

  Future<void> _checkModel() async {
    final isDownloaded = await _ocrService.isModelDownloaded();
    if (!isDownloaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Downloading handwriting model...')),
      );
      await _ocrService.downloadModel();
    }
    if (mounted) {
      setState(() {
        _isModelDownloaded = true;
      });
    }
  }

  Future<void> _recognize() async {
    if (_strokes.isEmpty) return;
    setState(() => _isRecognizing = true);

    final text = await _ocrService.recognize(_strokes);

    if (mounted) {
      setState(() {
        _recognizedText = text;
        _isRecognizing = false;
      });
    }
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Handwriting Quiz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () => _canvasKey.currentState?.undo(),
            tooltip: 'Undo last stroke',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _canvasKey.currentState?.clear();
              setState(() => _recognizedText = '');
            },
            tooltip: 'Clear canvas',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.question.question,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    DrawingCanvas(
                      key: _canvasKey,
                      onStrokesChanged: (strokes) {
                        _strokes = strokes;
                      },
                    ),
                    if (!_isModelDownloaded)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Recognized: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        _recognizedText.isEmpty
                            ? '(Draw to recognize)'
                            : _recognizedText,
                        style: TextStyle(
                            fontSize: 18,
                            color: _recognizedText.isEmpty
                                ? Colors.grey
                                : Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isRecognizing ? null : _recognize,
                      icon: _isRecognizing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.text_fields),
                      label: const Text('Recognize'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _recognizedText.isNotEmpty
                          ? () {
                              Navigator.pop(context, _recognizedText);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text('Submit Answer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
