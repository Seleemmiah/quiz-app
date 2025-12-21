import 'package:flutter/material.dart';
import 'dart:ui';

class GlassDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final EdgeInsets? contentPadding;
  final bool barrierDismissible;

  const GlassDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.contentPadding,
    this.barrierDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.15)
                      : Colors.white.withOpacity(0.7),
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                    child: Text(
                      title!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
                  ),
                  Divider(
                    color: Colors.white.withOpacity(0.2),
                    height: 1,
                  ),
                ],
                Flexible(
                  child: SingleChildScrollView(
                    padding: contentPadding ??
                        const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: content,
                  ),
                ),
                if (actions != null && actions!.isNotEmpty) ...[
                  Divider(
                    color: Colors.white.withOpacity(0.2),
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions!
                          .map((action) => Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: action,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<Widget>? actions,
    EdgeInsets? contentPadding,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => GlassDialog(
        title: title,
        content: content,
        actions: actions,
        contentPadding: contentPadding,
        barrierDismissible: barrierDismissible,
      ),
    );
  }
}
