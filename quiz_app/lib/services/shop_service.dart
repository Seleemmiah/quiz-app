import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ShopService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection references
  CollectionReference get _users => _firestore.collection('users');

  // Get current user balance
  Future<int> getBalance() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    try {
      final doc = await _users.doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return data['coins'] ?? 0;
      }
      return 0;
    } catch (e) {
      debugPrint('Error fetching balance: $e');
      return 0;
    }
  }

  // Add coins to user balance
  Future<void> addCoins(int amount) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _users.doc(user.uid).set({
        'coins': FieldValue.increment(amount),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error adding coins: $e');
    }
  }

  // Get list of owned theme IDs
  Future<List<String>> getOwnedThemes() async {
    final user = _auth.currentUser;
    if (user == null) return ['default']; // Default theme is always owned

    try {
      final doc = await _users.doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        final List<dynamic> owned = data['owned_themes'] ?? [];
        final List<String> result = owned.map((e) => e.toString()).toList();
        if (!result.contains('default')) result.add('default');
        return result;
      }
      return ['default'];
    } catch (e) {
      debugPrint('Error fetching owned themes: $e');
      return ['default'];
    }
  }

  // Buy a theme
  Future<bool> buyTheme(String themeId, int price) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      // Run as a transaction to ensure atomic update
      return await _firestore.runTransaction((transaction) async {
        final userRef = _users.doc(user.uid);
        final snapshot = await transaction.get(userRef);

        if (!snapshot.exists) return false;

        final data = snapshot.data() as Map<String, dynamic>;
        final int currentCoins = data['coins'] ?? 0;
        final List<dynamic> owned = data['owned_themes'] ?? [];

        if (owned.contains(themeId)) return true; // Already owned
        if (currentCoins < price) return false; // Insufficient funds

        // Deduct coins and add theme
        transaction.update(userRef, {
          'coins': currentCoins - price,
          'owned_themes': FieldValue.arrayUnion([themeId]),
        });

        return true;
      });
    } catch (e) {
      debugPrint('Error buying theme: $e');
      return false;
    }
  }
}
