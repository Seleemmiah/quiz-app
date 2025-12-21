import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Memory-efficient list with object pooling and lazy building
class MemoryEfficientList<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final double itemExtent;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final bool reverse;
  final int poolSize; // Number of reusable widgets to keep in memory

  const MemoryEfficientList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.itemExtent,
    this.scrollController,
    this.padding,
    this.reverse = false,
    this.poolSize = 10,
  });

  @override
  State<MemoryEfficientList<T>> createState() => _MemoryEfficientListState<T>();
}

class _MemoryEfficientListState<T> extends State<MemoryEfficientList<T>> {
  final Map<int, _ListItem<T>> _activeItems = {};
  final List<_ListItem<T>> _itemPool = [];
  double _scrollOffset = 0.0;
  double _viewportHeight = 0.0;

  ScrollController? _internalController;

  ScrollController get _controller =>
      widget.scrollController ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController == null) {
      _internalController = ScrollController();
    }
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (_internalController != null) {
      _internalController!.dispose();
    } else {
      _controller.removeListener(_onScroll);
    }
    _activeItems.clear();
    _itemPool.clear();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _controller.offset;
      _updateVisibleItems();
    });
  }

  void _updateVisibleItems() {
    if (_viewportHeight == 0.0) return;

    final firstVisibleIndex = (_scrollOffset / widget.itemExtent).floor();
    final lastVisibleIndex =
        ((_scrollOffset + _viewportHeight) / widget.itemExtent).ceil();

    final visibleIndices = <int>{};
    for (int i = firstVisibleIndex; i <= lastVisibleIndex; i++) {
      if (i >= 0 && i < widget.items.length) {
        visibleIndices.add(i);
      }
    }

    // Remove items that are no longer visible
    _activeItems.removeWhere((index, item) {
      if (!visibleIndices.contains(index)) {
        // Return to pool
        if (_itemPool.length < widget.poolSize) {
          _itemPool.add(item);
        }
        return true;
      }
      return false;
    });

    // Add new visible items
    for (final index in visibleIndices) {
      if (!_activeItems.containsKey(index)) {
        _activeItems[index] = _getOrCreateItem(index);
      }
    }
  }

  _ListItem<T> _getOrCreateItem(int index) {
    if (_itemPool.isNotEmpty) {
      final item = _itemPool.removeLast();
      item.updateData(widget.items[index], index);
      return item;
    }

    return _ListItem<T>(
      data: widget.items[index],
      index: index,
      builder: widget.itemBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _viewportHeight = constraints.maxHeight;
        _updateVisibleItems();

        return ListView.builder(
          controller: _controller,
          reverse: widget.reverse,
          padding: widget.padding,
          itemCount: widget.items.length,
          itemExtent: widget.itemExtent,
          itemBuilder: (context, index) {
            final item = _activeItems[index];
            return item?.widget ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class _ListItem<T> {
  T _data;
  int _index;
  Widget Function(BuildContext context, T item, int index) _builder;
  Widget? _cachedWidget;

  _ListItem({
    required T data,
    required int index,
    required Widget Function(BuildContext context, T item, int index) builder,
  })  : _data = data,
        _index = index,
        _builder = builder;

  void updateData(T newData, int newIndex) {
    if (_data != newData || _index != newIndex) {
      _data = newData;
      _index = newIndex;
      _cachedWidget = null; // Invalidate cache
    }
  }

  Widget get widget {
    _cachedWidget ??= _builder(_getContext(), _data, _index);
    return _cachedWidget!;
  }

  BuildContext _getContext() {
    // This is a simplified approach. In a real implementation,
    // you'd need to pass the context from the builder.
    // For now, we'll use a placeholder.
    return _contextHolder!;
  }

  static BuildContext? _contextHolder;
}

/// Question pool for reusing question objects
class QuestionPool {
  static final Map<String, List<dynamic>> _pools = {};
  static const int _maxPoolSize = 100;

  static T? getFromPool<T>(String poolKey) {
    final pool = _pools[poolKey];
    if (pool != null && pool.isNotEmpty) {
      return pool.removeLast() as T?;
    }
    return null;
  }

  static void returnToPool(String poolKey, dynamic item) {
    final pool = _pools.putIfAbsent(poolKey, () => []);
    if (pool.length < _maxPoolSize) {
      pool.add(item);
    }
  }

  static void clearPool(String poolKey) {
    _pools[poolKey]?.clear();
  }

  static void clearAllPools() {
    _pools.clear();
  }

  static Map<String, int> getPoolStats() {
    return _pools.map((key, value) => MapEntry(key, value.length));
  }
}

/// Garbage collection hints for Flutter
class MemoryManager {
  static const Duration _gcInterval = Duration(seconds: 30);
  static Timer? _gcTimer;

  static void startPeriodicGC() {
    _gcTimer?.cancel();
    _gcTimer = Timer.periodic(_gcInterval, (_) {
      // Force garbage collection hint
      // Note: This is a hint, not a guarantee
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Clear any cached images that are no longer visible
        PaintingBinding.instance.imageCache.clear();
      });
    });
  }

  static void stopPeriodicGC() {
    _gcTimer?.cancel();
    _gcTimer = null;
  }

  static void forceGC() {
    // Clear image cache
    PaintingBinding.instance.imageCache.clear();

    // Clear text layout cache
    // Note: This is internal Flutter API, use with caution
    // TextPainter.clearCache();

    // Force a garbage collection (if available)
    // This is platform dependent and may not work on all platforms
  }
}

/// Memoized widget builder to prevent unnecessary rebuilds
class MemoizedBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final List<Object?> dependencies;

  const MemoizedBuilder({
    super.key,
    required this.builder,
    required this.dependencies,
  });

  @override
  State<MemoizedBuilder> createState() => _MemoizedBuilderState();
}

class _MemoizedBuilderState extends State<MemoizedBuilder> {
  Widget? _cachedWidget;
  List<Object?>? _lastDependencies;

  @override
  Widget build(BuildContext context) {
    if (_cachedWidget == null ||
        !_listEquals(_lastDependencies, widget.dependencies)) {
      _cachedWidget = widget.builder(context);
      _lastDependencies = List.from(widget.dependencies);
    }

    return _cachedWidget!;
  }

  bool _listEquals(List<Object?>? a, List<Object?>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;

    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }
}

/// Optimized question display widget with memoization
class OptimizedQuestionDisplay extends StatelessWidget {
  final String question;
  final List<String> options;
  final int? selectedIndex;
  final Function(int)? onOptionSelected;
  final bool showExplanation;
  final String? explanation;

  const OptimizedQuestionDisplay({
    super.key,
    required this.question,
    required this.options,
    this.selectedIndex,
    this.onOptionSelected,
    this.showExplanation = false,
    this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    return MemoizedBuilder(
      dependencies: [
        question,
        options,
        selectedIndex,
        showExplanation,
        explanation
      ],
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              question,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          // Options
          ...options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = selectedIndex == index;

            return MemoizedBuilder(
              dependencies: [option, isSelected],
              builder: (context) => ListTile(
                title: Text(option),
                leading: Radio<int>(
                  value: index,
                  groupValue: selectedIndex,
                  onChanged: onOptionSelected != null
                      ? (value) => onOptionSelected!(value!)
                      : null,
                ),
                tileColor: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : null,
              ),
            );
          }),

          // Explanation
          if (showExplanation && explanation != null) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Explanation: $explanation',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
