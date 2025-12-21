import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;

class QuestionImage extends StatelessWidget {
  final String imageUrl;

  const QuestionImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Some servers require a User-Agent header.
    final Map<String, String> headers = {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36',
    };

    // Robust check for SVG by parsing the URL path's extension.
    // This correctly handles URLs like '.../image.svg.png' as PNG.
    bool isSvg = false;
    try {
      final uri = Uri.parse(imageUrl);
      isSvg = p.extension(uri.path).toLowerCase() == '.svg';
    } catch (e) {
      // If parsing fails, default to false.
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.3,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: isSvg
            ? SvgPicture.network(
                imageUrl,
                headers:
                    kIsWeb ? null : headers, // Headers are not supported on web
                fit: BoxFit.contain,
                placeholderBuilder: (BuildContext context) =>
                    const Center(child: CircularProgressIndicator()),
                // The errorBuilder for SvgPicture.network provides the error object.
                errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) =>
                    Container(
                  color: Colors.red.withOpacity(0.1),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 8),
                      Text(
                        'Failed to load SVG.\nIt might contain an unsupported element.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )
            : CachedNetworkImage(
                // Pass headers to the request.
                httpHeaders: headers,
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                // errorBuilder: (context, url, error) => const Icon(
                //     Icons.broken_image_outlined,
                //     color: Colors.red,
                //     size: 48),
              ),
      ),
    );
  }
}
