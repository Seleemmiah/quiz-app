import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineIndicator extends StatefulWidget {
  const OfflineIndicator({super.key});

  @override
  State<OfflineIndicator> createState() => _OfflineIndicatorState();
}

class _OfflineIndicatorState extends State<OfflineIndicator> {
  bool _showIndicator = false;
  Timer? _hideTimer;
  ConnectivityResult? _lastResult;
  StreamSubscription<ConnectivityResult>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.map((event) {
      if (event is List<ConnectivityResult>) {
        return event.first;
      }
      return event as ConnectivityResult;
    }).listen(_handleConnectivityChange);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    // Only show indicator when connectivity changes
    if (_lastResult != null && _lastResult != result) {
      if (mounted) {
        setState(() {
          _showIndicator = true;
        });

        // Hide after 5 seconds
        _hideTimer?.cancel();
        _hideTimer = Timer(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              _showIndicator = false;
            });
          }
        });
      }
    }
    _lastResult = result;
  }

  @override
  Widget build(BuildContext context) {
    if (!_showIndicator) return const SizedBox.shrink();

    final isOffline = _lastResult == ConnectivityResult.none;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: AnimatedOpacity(
          opacity: _showIndicator ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isOffline
                      ? [
                          Colors.red.shade600,
                          Colors.red.shade700,
                        ]
                      : [
                          Colors.green.shade600,
                          Colors.green.shade700,
                        ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: (isOffline ? Colors.red : Colors.green)
                        .withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isOffline ? Icons.wifi_off_rounded : Icons.wifi_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isOffline ? 'Offline Mode' : 'Back Online',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
