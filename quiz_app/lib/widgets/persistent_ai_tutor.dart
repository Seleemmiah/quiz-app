import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:quiz_app/services/ai_service.dart';
import 'package:quiz_app/services/quota_service.dart';
import 'package:quiz_app/widgets/glass_card.dart';

class PersistentAITutor extends StatefulWidget {
  const PersistentAITutor({super.key});

  @override
  State<PersistentAITutor> createState() => _PersistentAITutorState();
}

class _PersistentAITutorState extends State<PersistentAITutor> {
  final AIService _aiService = AIService();
  final QuotaService _quotaService = QuotaService();
  final TextEditingController _controller = TextEditingController();
  bool _isExpanded = false;
  bool _isLoading = false;
  String? _lastResponse;

  Future<void> _askAI() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    final remaining = await _quotaService.getRemainingQuota('ai_explanation');
    if (remaining <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Daily AI limit reached!')),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _lastResponse = null;
    });

    try {
      final response = await _aiService.getExplanation(
        question: "General inquiry from student: $query",
        userAnswer: "",
        correctAnswer: "",
      );

      if (mounted) {
        setState(() {
          _lastResponse = response;
          _isLoading = false;
          _controller.clear();
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isExpanded)
            FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: 250,
                margin: const EdgeInsets.only(bottom: 16),
                child: GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Ask AI Tutor 🧙‍♂️',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_lastResponse != null)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _lastResponse!,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _controller,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Ask me anything...',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.all(8),
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _askAI,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 32),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Text('Ask',
                                    style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          FloatingActionButton(
            mini: true,
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            backgroundColor: Theme.of(context).primaryColor,
            child: _isExpanded
                ? const Icon(Icons.close, color: Colors.white)
                : const Icon(Icons.psychology, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
