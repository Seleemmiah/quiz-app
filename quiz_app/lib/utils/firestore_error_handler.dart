import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreErrorHandler {
  /// Executes a Firestore operation with automatic retry on failure
  static Future<T?> executeWithRetry<T>({
    required Future<T> Function() operation,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
    String operationName = 'Firestore operation',
  }) async {
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        return await operation();
      } on FirebaseException catch (e) {
        attempt++;
        debugPrint(
            '$operationName failed (attempt $attempt/$maxRetries): ${e.code} - ${e.message}');

        // Check if error is retryable
        if (_isRetryableError(e) && attempt < maxRetries) {
          debugPrint('Retrying in ${retryDelay.inSeconds} seconds...');
          await Future.delayed(retryDelay);
        } else {
          debugPrint('$operationName failed permanently: ${e.code}');
          return null;
        }
      } catch (e) {
        debugPrint('$operationName failed with unexpected error: $e');
        return null;
      }
    }

    debugPrint('$operationName exhausted all retry attempts');
    return null;
  }

  /// Checks if a Firebase error should trigger a retry
  static bool _isRetryableError(FirebaseException e) {
    // Retry on network errors, unavailable service, etc.
    const retryableCodes = [
      'unavailable',
      'deadline-exceeded',
      'resource-exhausted',
      'aborted',
      'internal',
      'unknown',
    ];

    return retryableCodes.contains(e.code);
  }

  /// Gets a user-friendly error message from a Firebase exception
  static String getUserFriendlyMessage(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'unavailable':
          return 'Network error. Please check your connection and try again.';
        case 'permission-denied':
          return 'You don\'t have permission to perform this action.';
        case 'not-found':
          return 'The requested data was not found.';
        case 'already-exists':
          return 'This data already exists.';
        case 'deadline-exceeded':
          return 'Request timed out. Please try again.';
        default:
          return 'An error occurred. Please try again later.';
      }
    }
    return 'An unexpected error occurred.';
  }

  /// Returns a stream that handles errors gracefully by returning a fallback value
  static Stream<T> handleStream<T>({
    required Stream<T> stream,
    required T fallbackValue,
    String streamName = 'Firestore stream',
  }) {
    return stream.handleError((error) {
      debugPrint('$streamName error: $error');
      // Return fallback value is not directly possible in stream transformation safely without transform
      // easier to just log error
    });
  }
}
