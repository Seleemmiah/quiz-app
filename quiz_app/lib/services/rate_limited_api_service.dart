import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/services/cache_service.dart';

/// Rate-limited API service with request deduplication and caching
class RateLimitedApiService {
  static const int _maxRequestsPerMinute = 60;
  static const Duration _rateLimitWindow = Duration(minutes: 1);
  static const int _maxRetries = 3;
  static const Duration _baseRetryDelay = Duration(seconds: 1);

  final List<DateTime> _requestTimestamps = [];
  final Map<String, Future<http.Response>> _pendingRequests = {};

  /// Make a rate-limited HTTP GET request with caching
  Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    bool useCache = true,
    Duration? cacheExpiration,
  }) async {
    // Check cache first
    if (useCache) {
      final cachedResponse =
          await CacheService.get<String>('api_response_$url');
      if (cachedResponse != null) {
        return http.Response(cachedResponse, 200);
      }
    }

    // Rate limiting
    await _enforceRateLimit();

    // Request deduplication
    final requestKey = 'GET_$url';
    if (_pendingRequests.containsKey(requestKey)) {
      return await _pendingRequests[requestKey]!;
    }

    final completer = Completer<http.Response>();
    _pendingRequests[requestKey] = completer.future;

    try {
      final response = await _makeRequestWithRetry(
        () => http.get(Uri.parse(url), headers: headers),
      );

      // Cache successful responses
      if (useCache && response.statusCode == 200) {
        await CacheService.set(
          'api_response_$url',
          response.body,
          expiration: cacheExpiration ?? const Duration(minutes: 5),
          tags: ['api', 'responses'],
        );
      }

      completer.complete(response);
      return response;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _pendingRequests.remove(requestKey);
    }
  }

  /// Make a rate-limited HTTP POST request
  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    await _enforceRateLimit();

    return await _makeRequestWithRetry(
      () => http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
        encoding: encoding,
      ),
    );
  }

  /// Make a rate-limited HTTP PUT request
  Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    await _enforceRateLimit();

    return await _makeRequestWithRetry(
      () => http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
        encoding: encoding,
      ),
    );
  }

  /// Make a rate-limited HTTP DELETE request
  Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    await _enforceRateLimit();

    return await _makeRequestWithRetry(
      () => http.delete(Uri.parse(url), headers: headers),
    );
  }

  /// Enforce rate limiting
  Future<void> _enforceRateLimit() async {
    final now = DateTime.now();

    // Remove timestamps outside the rate limit window
    _requestTimestamps.removeWhere(
      (timestamp) => now.difference(timestamp) > _rateLimitWindow,
    );

    // If we've exceeded the rate limit, wait
    if (_requestTimestamps.length >= _maxRequestsPerMinute) {
      final oldestTimestamp = _requestTimestamps.first;
      final waitTime = _rateLimitWindow - now.difference(oldestTimestamp);

      if (waitTime > Duration.zero) {
        await Future.delayed(waitTime);
      }
    }

    _requestTimestamps.add(now);
  }

  /// Make request with exponential backoff retry
  Future<http.Response> _makeRequestWithRetry(
    Future<http.Response> Function() request,
  ) async {
    int attempt = 0;

    while (attempt < _maxRetries) {
      try {
        final response = await request();

        // Don't retry on client errors (4xx) except 429 (Too Many Requests)
        if (response.statusCode >= 400 && response.statusCode < 500) {
          if (response.statusCode == 429) {
            // Rate limited, wait longer
            final waitTime = _baseRetryDelay * (attempt + 1) * 2;
            await Future.delayed(waitTime);
            attempt++;
            continue;
          }
          return response; // Don't retry other 4xx errors
        }

        // Retry on server errors (5xx) and network errors
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }

        // Server error, retry
        if (attempt < _maxRetries - 1) {
          final waitTime =
              _baseRetryDelay * (1 << attempt); // Exponential backoff
          await Future.delayed(waitTime);
        }
      } catch (e) {
        // Network error, retry
        if (attempt < _maxRetries - 1) {
          final waitTime = _baseRetryDelay * (1 << attempt);
          await Future.delayed(waitTime);
        } else {
          rethrow;
        }
      }

      attempt++;
    }

    // If we get here, all retries failed
    throw Exception('Request failed after $_maxRetries attempts');
  }

  /// Clear all pending requests (useful for cleanup)
  void clearPendingRequests() {
    _pendingRequests.clear();
  }

  /// Get current rate limit status
  Map<String, dynamic> getRateLimitStatus() {
    final now = DateTime.now();

    // Clean up old timestamps
    _requestTimestamps.removeWhere(
      (timestamp) => now.difference(timestamp) > _rateLimitWindow,
    );

    return {
      'requestsInWindow': _requestTimestamps.length,
      'maxRequestsPerMinute': _maxRequestsPerMinute,
      'pendingRequests': _pendingRequests.length,
    };
  }
}

/// API response cache with TTL
class ApiResponseCache {
  static final Map<String, _CachedApiResponse> _cache = {};
  static const Duration _defaultTTL = Duration(minutes: 5);

  static Future<http.Response?> getCachedResponse(String url) async {
    final cached = _cache[url];
    if (cached != null && !cached.isExpired) {
      return cached.response;
    }

    // Try disk cache as fallback
    final diskCached = await CacheService.get<String>('api_response_$url');
    if (diskCached != null) {
      final response = http.Response(diskCached, 200);
      _cache[url] = _CachedApiResponse(response, _defaultTTL);
      return response;
    }

    return null;
  }

  static void cacheResponse(String url, http.Response response,
      {Duration? ttl}) {
    _cache[url] = _CachedApiResponse(response, ttl ?? _defaultTTL);

    // Also cache to disk
    CacheService.set(
      'api_response_$url',
      response.body,
      expiration: ttl ?? _defaultTTL,
      tags: ['api', 'responses'],
    );
  }

  static void clearCache() {
    _cache.clear();
    CacheService.clearByTags(['api']);
  }
}

class _CachedApiResponse {
  final http.Response response;
  final DateTime expiration;

  _CachedApiResponse(this.response, Duration ttl)
      : expiration = DateTime.now().add(ttl);

  bool get isExpired => DateTime.now().isAfter(expiration);
}
