import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:quiz_app/utils/firestore_error_handler.dart';

class ShopService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection references
  CollectionReference get _users => _firestore.collection('users');

  // Get current user balance
  Future<int> getBalance() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    final result = await FirestoreErrorHandler.executeWithRetry<int>(
      operation: () async {
        final doc = await _users.doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          return data['coins'] ?? 0;
        }
        return 0;
      },
      operationName: 'Get coin balance',
    );
    return result ?? 0;
  }

  // Add coins to user balance
  Future<void> addCoins(int amount) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await FirestoreErrorHandler.executeWithRetry(
      operation: () async {
        await _users.doc(user.uid).set({
          'coins': FieldValue.increment(amount),
        }, SetOptions(merge: true));
      },
      operationName: 'Add coins',
    );
  }

  // Get list of owned theme IDs
  Future<List<String>> getOwnedThemes() async {
    final user = _auth.currentUser;
    if (user == null) return ['default']; // Default theme is always owned

    final result = await FirestoreErrorHandler.executeWithRetry<List<String>>(
      operation: () async {
        final doc = await _users.doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          final List<dynamic> owned = data['owned_themes'] ?? [];
          final List<String> result = owned.map((e) => e.toString()).toList();
          if (!result.contains('default')) result.add('default');
          return result;
        }
        return ['default'];
      },
      operationName: 'Get owned themes',
    );
    return result ?? ['default'];
  }

  // Buy a theme
  Future<bool> buyTheme(String themeId, int price) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final result = await FirestoreErrorHandler.executeWithRetry<bool>(
      operation: () async {
        return await _firestore.runTransaction((transaction) async {
          final userRef = _users.doc(user.uid);
          final snapshot = await transaction.get(userRef);

          if (!snapshot.exists) return false;

          final data = snapshot.data() as Map<String, dynamic>;
          final int currentCoins = data['coins'] ?? 0;
          final List<dynamic> owned = data['owned_themes'] ?? [];

          if (owned.contains(themeId)) return true;
          if (currentCoins < price) return false;

          transaction.update(userRef, {
            'coins': currentCoins - price,
            'owned_themes': FieldValue.arrayUnion([themeId]),
          });

          return true;
        });
      },
      operationName: 'Buy theme',
    );
    return result ?? false;
  }

  // Get list of owned avatar IDs
  Future<List<String>> getOwnedAvatars() async {
    final user = _auth.currentUser;
    if (user == null) return ['👨‍🎓', '👩‍🎓']; // Default avatars

    final result = await FirestoreErrorHandler.executeWithRetry<List<String>>(
      operation: () async {
        final doc = await _users.doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          final List<dynamic> owned = data['owned_avatars'] ?? [];
          final List<String> result = owned.map((e) => e.toString()).toList();

          // Ensure defaults are always there
          if (!result.contains('👨‍🎓')) result.add('👨‍🎓');
          if (!result.contains('👩‍🎓')) result.add('👩‍🎓');
          return result;
        }
        return ['👨‍🎓', '👩‍🎓'];
      },
      operationName: 'Get owned avatars',
    );
    return result ?? ['👨‍🎓', '👩‍🎓'];
  }

  // Buy an avatar
  Future<bool> buyAvatar(String avatarEmoji, int price) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final result = await FirestoreErrorHandler.executeWithRetry<bool>(
      operation: () async {
        return await _firestore.runTransaction((transaction) async {
          final userRef = _users.doc(user.uid);
          final snapshot = await transaction.get(userRef);

          // If user doc doesn't exists, create it with initial coins if needed, but here we expect it exists
          if (!snapshot.exists) {
            transaction.set(userRef, {
              'coins': 0,
              'owned_avatars': [avatarEmoji],
            });
            return price == 0;
          }

          final data = snapshot.data() as Map<String, dynamic>;
          final int currentCoins = data['coins'] ?? 0;
          final List<dynamic> owned = data['owned_avatars'] ?? [];

          if (owned.contains(avatarEmoji)) return true;
          if (currentCoins < price) return false;

          transaction.update(userRef, {
            'coins': currentCoins - price,
            'owned_avatars': FieldValue.arrayUnion([avatarEmoji]),
          });

          return true;
        });
      },
      operationName: 'Buy avatar',
    );
    return result ?? false;
  }

  // --- Power-Ups ---

  // Get owned power-ups counts
  Future<Map<String, int>> getOwnedPowerUps() async {
    final user = _auth.currentUser;
    if (user == null) return {};

    final result =
        await FirestoreErrorHandler.executeWithRetry<Map<String, int>>(
      operation: () async {
        final doc = await _users.doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          final Map<dynamic, dynamic> powerups = data['powerups'] ?? {};
          return powerups.map((k, v) => MapEntry(k.toString(), v as int));
        }
        return {};
      },
      operationName: 'Get owned power-ups',
    );
    return result ?? {};
  }

  // Buy a power-up
  Future<bool> buyPowerUp(String powerUpId, int price) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final result = await FirestoreErrorHandler.executeWithRetry<bool>(
      operation: () async {
        return await _firestore.runTransaction((transaction) async {
          final userRef = _users.doc(user.uid);
          final snapshot = await transaction.get(userRef);

          if (!snapshot.exists) return false;

          final data = snapshot.data() as Map<String, dynamic>;
          final int currentCoins = data['coins'] ?? 0;
          if (currentCoins < price) return false;

          final Map<String, dynamic> powerups =
              Map<String, dynamic>.from(data['powerups'] ?? {});
          powerups[powerUpId] = (powerups[powerUpId] ?? 0) + 1;

          transaction.update(userRef, {
            'coins': currentCoins - price,
            'powerups': powerups,
          });

          return true;
        });
      },
      operationName: 'Buy power-up',
    );
    return result ?? false;
  }

  // Use a power-up
  Future<bool> usePowerUp(String powerUpId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final result = await FirestoreErrorHandler.executeWithRetry<bool>(
      operation: () async {
        return await _firestore.runTransaction((transaction) async {
          final userRef = _users.doc(user.uid);
          final snapshot = await transaction.get(userRef);

          if (!snapshot.exists) return false;

          final data = snapshot.data() as Map<String, dynamic>;
          final Map<String, dynamic> powerups =
              Map<String, dynamic>.from(data['powerups'] ?? {});

          if ((powerups[powerUpId] ?? 0) <= 0) return false;

          powerups[powerUpId] = powerups[powerUpId] - 1;

          transaction.update(userRef, {
            'powerups': powerups,
          });

          return true;
        });
      },
      operationName: 'Use power-up',
    );
    return result ?? false;
  }
}
