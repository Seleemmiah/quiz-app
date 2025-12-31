import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class QuotaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Limits based on user roles or simple constants for now
  static const int DAILY_AI_LIMIT = 5;

  Future<bool> hasRemainingQuota(String feature) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final usageRef =
          _db.collection('users').doc(user.uid).collection('usage').doc(today);

      final doc = await usageRef.get();
      if (!doc.exists) return true;

      final data = doc.data()!;
      final featureUsage = data[feature] ?? 0;

      return featureUsage < DAILY_AI_LIMIT;
    } catch (e) {
      debugPrint('Error checking quota: $e');
      return true; // Default to true on error to avoid blocking users
    }
  }

  Future<void> incrementUsage(String feature) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final usageRef =
          _db.collection('users').doc(user.uid).collection('usage').doc(today);

      await _db.runTransaction((transaction) async {
        final doc = await transaction.get(usageRef);
        if (!doc.exists) {
          transaction.set(usageRef, {feature: 1});
        } else {
          final currentUsage = doc.data()![feature] ?? 0;
          transaction.update(usageRef, {feature: currentUsage + 1});
        }
      });
    } catch (e) {
      debugPrint('Error incrementing usage: $e');
    }
  }

  Future<int> getRemainingQuota(String feature) async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final usageRef =
          _db.collection('users').doc(user.uid).collection('usage').doc(today);

      final doc = await usageRef.get();
      if (!doc.exists) return DAILY_AI_LIMIT;

      final data = doc.data()!;
      final int featureUsage = (data[feature] ?? 0) as int;

      return (DAILY_AI_LIMIT - featureUsage).clamp(0, DAILY_AI_LIMIT);
    } catch (e) {
      return 0;
    }
  }
}
