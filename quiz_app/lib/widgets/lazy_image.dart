import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Advanced lazy loading image widget with progressive loading and preloading
class LazyImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final bool enablePreload;
  final String? preloadUrl; // For preloading next image
  final VoidCallback? onLoadComplete;
  final VoidCallback? onLoadError;

  const LazyImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.enablePreload = false,
    this.preloadUrl,
    this.onLoadComplete,
    this.onLoadError,
  });

  @override
  State<LazyImage> createState() => _LazyImageState();
}

class _LazyImageState extends State<LazyImage>
    with AutomaticKeepAliveClientMixin {
  bool _isInView = false;
  bool _hasLoaded = false;
  bool _hasError = false;
  ImageStreamListener? _imageStreamListener;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _imageStreamListener = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return VisibilityDetector(
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedOpacity(
        opacity: _hasLoaded ? 1.0 : 0.0,
        duration: widget.fadeInDuration,
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (!_isInView && !_hasLoaded) {
      return _buildPlaceholder();
    }

    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        placeholder: (context, url) => _buildProgressivePlaceholder(),
        errorWidget: (context, url, error) {
          _hasError = true;
          widget.onLoadError?.call();
          return widget.errorWidget ?? _buildErrorWidget();
        },
        imageBuilder: (context, imageProvider) {
          _hasLoaded = true;
          widget.onLoadComplete?.call();

          // Preload next image if enabled
          if (widget.enablePreload && widget.preloadUrl != null) {
            _preloadImage(widget.preloadUrl!);
          }

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: widget.fit,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: widget.borderRadius,
      ),
      child: widget.placeholder ?? const Icon(Icons.image, color: Colors.grey),
    );
  }

  Widget _buildProgressivePlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: widget.borderRadius,
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: widget.borderRadius,
      ),
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  void _onVisibilityChanged(bool isVisible) {
    if (isVisible && !_isInView) {
      setState(() {
        _isInView = true;
      });
    }
  }

  void _preloadImage(String url) {
    final image = Image.network(url);
    final completer = Completer<void>();
    final listener = ImageStreamListener(
      (info, synchronousCall) => completer.complete(),
      onError: (error, stackTrace) => completer.completeError(error),
    );

    image.image.resolve(const ImageConfiguration()).addListener(listener);
    _imageStreamListener = listener;
  }
}

/// Visibility detector for lazy loading
class VisibilityDetector extends StatefulWidget {
  final Widget child;
  final Function(bool isVisible) onVisibilityChanged;
  final double threshold;

  const VisibilityDetector({
    super.key,
    required this.child,
    required this.onVisibilityChanged,
    this.threshold = 0.1,
  });

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: SizedBox(
        key: _key,
        child: widget.child,
      ),
    );
  }

  void _checkVisibility() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    // Check if widget is visible in viewport
    final isVisible =
        position.dy < screenHeight && position.dy + size.height > 0;

    // The following is a more precise check that was causing issues.
    // Reverting to a simpler, more reliable check.
    widget.onVisibilityChanged(isVisible);
  }
}

/// Image preloader for batch preloading
class ImagePreloader {
  static final Map<String, Completer<void>> _preloadCache = {};

  static Future<void> preloadImages(List<String> urls) async {
    final futures = <Future<void>>[];

    for (final url in urls) {
      if (!_preloadCache.containsKey(url)) {
        final completer = Completer<void>();
        _preloadCache[url] = completer;

        final image = Image.network(url);
        final listener = ImageStreamListener(
          (info, synchronousCall) => completer.complete(),
          onError: (error, stackTrace) => completer.completeError(error),
        );

        image.image.resolve(const ImageConfiguration()).addListener(listener);
        futures.add(completer.future);
      } else {
        futures.add(_preloadCache[url]!.future);
      }
    }

    await Future.wait(futures);
  }

  static void clearCache() {
    _preloadCache.clear();
  }
}
