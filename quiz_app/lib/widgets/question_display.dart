import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:quiz_app/services/tts_service.dart';

class QuestionDisplay extends StatelessWidget {
  final String questionText;
  final String? imageUrl;
  final TextStyle? style;

  const QuestionDisplay({
    super.key,
    required this.questionText,
    this.imageUrl,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imageUrl != null && imageUrl!.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl!.startsWith('http')
                ? Image.network(
                    imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.broken_image)),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: Colors.grey[100],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  )
                : Image.asset(
                    imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.image_not_supported,
                                color: Colors.grey, size: 50),
                            const SizedBox(height: 8),
                            Text(
                              'Missing Image:\n$imageUrl',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
        ],
        _buildContent(context),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    // If text contains LaTeX delimiters ($$), use TeXView
    // Parse and render Math equations
    if (questionText.contains(r'$$')) {
      return _buildMathContent(context);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            questionText,
            style: style ??
                const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.volume_up, color: Colors.blue),
          onPressed: () {
            TtsService().speak(questionText);
          },
          tooltip: 'Read Aloud',
        ),
      ],
    );
  }

  Widget _buildMathContent(BuildContext context) {
    List<InlineSpan> richSpans = [];
    final pattern = RegExp(r'\$\$(.*?)\$\$');
    final matches = pattern.allMatches(questionText);
    int lastIndex = 0;

    final baseStyle = style ??
        Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18) ??
        const TextStyle(fontSize: 18);

    for (var match in matches) {
      // Add text before the equation
      if (match.start > lastIndex) {
        richSpans.add(TextSpan(
          text: questionText.substring(lastIndex, match.start),
          style: baseStyle,
        ));
      }

      // Add the equation
      final mathContent = match.group(1) ?? '';
      richSpans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Math.tex(
          mathContent,
          textStyle: baseStyle,
          mathStyle: MathStyle.display,
          onErrorFallback: (err) => Text('\$\$$mathContent\$\$',
              style: baseStyle.copyWith(color: Colors.red)),
        ),
      ));

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < questionText.length) {
      richSpans.add(TextSpan(
        text: questionText.substring(lastIndex),
        style: baseStyle,
      ));
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText.rich(
            TextSpan(children: richSpans),
          ),
          const SizedBox(height: 8),
          // TTS Button
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.volume_up, size: 20),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                TtsService().speak(questionText.replaceAll(r'$$', ''));
              },
              tooltip: 'Read Aloud',
            ),
          ),
        ],
      ),
    );
  }
}
