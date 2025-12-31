import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Advanced caching service for API responses and data
class CacheService {
  static const String _cachePrefix = 'cache_';
  static const Duration _defaultCacheDuration = Duration(hours: 1);

  /// Cache an API response with optional custom duration and tags
  static Future<void> set(String key, dynamic data,
      {Duration? expiration, List<String>? tags}) async {
    final prefs = await SharedPreferences.getInstance();

    // Sanitize data recursively to handle Timestamps and other non-JSON types
    final sanitizedData = _sanitizeData(data);

    final cacheData = {
      'data': sanitizedData,
      'timestamp': DateTime.now().toIso8601String(),
      'duration': (expiration ?? _defaultCacheDuration).inMilliseconds,
      'tags': tags ?? [],
    };

    await prefs.setString(_cachePrefix + key, jsonEncode(cacheData));
  }

  /// Recursively sanitize data for JSON encoding
  static dynamic _sanitizeData(dynamic data) {
    if (data is Timestamp) {
      return data.toDate().toIso8601String();
    } else if (data is DateTime) {
      return data.toIso8601String();
    } else if (data is Map) {
      return data
          .map((key, value) => MapEntry(key.toString(), _sanitizeData(value)));
    } else if (data is List) {
      return data.map((item) => _sanitizeData(item)).toList();
    }
    return data;
  }

  /// Get cached data if not expired
  static Future<T?> get<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheJson = prefs.getString(_cachePrefix + key);
    if (cacheJson == null) return null;

    try {
      final cacheData = jsonDecode(cacheJson) as Map<String, dynamic>;
      final timestamp = DateTime.parse(cacheData['timestamp']);
      final duration = Duration(milliseconds: cacheData['duration']);
      final expiryTime = timestamp.add(duration);

      if (DateTime.now().isAfter(expiryTime)) {
        // Cache expired, remove it
        await prefs.remove(_cachePrefix + key);
        return null;
      }

      return cacheData['data'] as T;
    } catch (e) {
      // Invalid cache data, remove it
      await prefs.remove(_cachePrefix + key);
      return null;
    }
  }

  /// Check if cache exists and is valid
  static Future<bool> isValid(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheJson = prefs.getString(_cachePrefix + key);
    if (cacheJson == null) return false;

    try {
      final cacheData = jsonDecode(cacheJson) as Map<String, dynamic>;
      final timestamp = DateTime.parse(cacheData['timestamp']);
      final duration = Duration(milliseconds: cacheData['duration']);
      final expiryTime = timestamp.add(duration);

      return DateTime.now().isBefore(expiryTime);
    } catch (e) {
      return false;
    }
  }

  /// Remove specific cache entry
  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachePrefix + key);
  }

  /// Clear all cache entries
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    for (final key in allKeys) {
      if (key.startsWith(_cachePrefix)) {
        await prefs.remove(key);
      }
    }
  }

  /// Clear cache entries by tags
  static Future<void> clearByTags(List<String> tags) async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys =
        prefs.getKeys().where((key) => key.startsWith(_cachePrefix));

    for (final key in allKeys) {
      final cacheJson = prefs.getString(key);
      if (cacheJson != null) {
        try {
          final cacheData = jsonDecode(cacheJson) as Map<String, dynamic>;
          final entryTags = List<String>.from(cacheData['tags'] ?? []);
          if (tags.any((tag) => entryTags.contains(tag))) {
            await prefs.remove(key);
          }
        } catch (e) {
          // Invalid cache data, remove it
          await prefs.remove(key);
        }
      }
    }
  }

  /// Get cache size in bytes
  static Future<int> getCacheSize() async {
    final prefs = await SharedPreferences.getInstance();
    int size = 0;
    final keys = prefs.getKeys().where((key) => key.startsWith(_cachePrefix));
    for (final key in keys) {
      final value = prefs.getString(key);
      if (value != null) {
        size += value.length * 2; // Rough estimate: 2 bytes per character
      }
    }
    return size;
  }

  /// Clean expired cache entries
  static Future<void> cleanExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final keys =
        prefs.getKeys().where((key) => key.startsWith(_cachePrefix)).toList();

    for (final key in keys) {
      final cacheKey = key.substring(_cachePrefix.length);
      if (!(await isValid(cacheKey))) {
        await prefs.remove(key);
      }
    }
  }

  // Enhanced methods for specific data types

  /// Cache questions data
  static Future<void> cacheQuestions(
      String category, List<Map<String, dynamic>> questions) async {
    await set('questions_$category', questions,
        expiration: const Duration(hours: 24), tags: ['questions']);
  }

  /// Get cached questions
  static Future<List<Map<String, dynamic>>?> getCachedQuestions(
      String category) async {
    return await get<List<Map<String, dynamic>>>('questions_$category');
  }

  /// Cache user statistics
  static Future<void> cacheUserStats(Map<String, dynamic> stats) async {
    await set('user_stats', stats,
        expiration: const Duration(minutes: 30), tags: ['stats']);
  }

  /// Get cached user statistics
  static Future<Map<String, dynamic>?> getCachedUserStats() async {
    return await get<Map<String, dynamic>>('user_stats');
  }

  /// Cache leaderboard data
  static Future<void> cacheLeaderboard(
      List<Map<String, dynamic>> leaderboard) async {
    await set('leaderboard', leaderboard,
        expiration: const Duration(hours: 6), tags: ['leaderboard']);
  }

  /// Get cached leaderboard
  static Future<List<Map<String, dynamic>>?> getCachedLeaderboard() async {
    return await get<List<Map<String, dynamic>>>('leaderboard');
  }

  /// Cache API response with ETag support
  static Future<void> setWithETag(String key, dynamic data, String etag,
      {Duration? expiration}) async {
    final cacheData = {
      'data': data,
      'etag': etag,
      'timestamp': DateTime.now().toIso8601String(),
      'duration': (expiration ?? _defaultCacheDuration).inMilliseconds,
    };

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachePrefix + key, jsonEncode(cacheData));
  }

  /// Get cached data with ETag
  static Future<Map<String, dynamic>?> getWithETag(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheJson = prefs.getString(_cachePrefix + key);
    if (cacheJson == null) return null;

    try {
      final cacheData = jsonDecode(cacheJson) as Map<String, dynamic>;
      final timestamp = DateTime.parse(cacheData['timestamp']);
      final duration = Duration(milliseconds: cacheData['duration']);
      final expiryTime = timestamp.add(duration);

      if (DateTime.now().isAfter(expiryTime)) {
        await prefs.remove(_cachePrefix + key);
        return null;
      }

      return {
        'data': cacheData['data'],
        'etag': cacheData['etag'],
      };
    } catch (e) {
      await prefs.remove(_cachePrefix + key);
      return null;
    }
  }
}
