import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class MultiplayerService {
  static final MultiplayerService _instance = MultiplayerService._internal();
  factory MultiplayerService() => _instance;
  MultiplayerService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new lobby
  Future<String?> createLobby(String category, String difficulty) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      // Generate a 6-digit code
      final code = (100000 + Random().nextInt(900000)).toString();

      await _firestore.collection('lobbies').doc(code).set({
        'hostId': user.uid,
        'category': category,
        'difficulty': difficulty,
        'status': 'waiting', // waiting, playing, finished
        'createdAt': FieldValue.serverTimestamp(),
        'currentQuestionIndex': 0,
        'startTime': null,
      });

      // Add host as player
      await joinLobby(code);

      return code;
    } catch (e) {
      debugPrint('Error creating lobby: $e');
      return null;
    }
  }

  // Join an existing lobby
  Future<bool> joinLobby(String code) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final lobbyRef = _firestore.collection('lobbies').doc(code);
      final lobbyDoc = await lobbyRef.get();

      if (!lobbyDoc.exists) return false;
      if (lobbyDoc.data()?['status'] != 'waiting') return false;

      // Add player to subcollection
      await lobbyRef.collection('players').doc(user.uid).set({
        'userId': user.uid,
        'name': user.displayName ?? 'Player',
        'score': 0,
        'joinedAt': FieldValue.serverTimestamp(),
        'isReady': false,
      });

      return true;
    } catch (e) {
      debugPrint('Error joining lobby: $e');
      return false;
    }
  }

  // Stream of players in a lobby
  Stream<List<Map<String, dynamic>>> getPlayersStream(String code) {
    return _firestore
        .collection('lobbies')
        .doc(code)
        .collection('players')
        .orderBy('joinedAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Stream of lobby status
  Stream<DocumentSnapshot> getLobbyStream(String code) {
    return _firestore.collection('lobbies').doc(code).snapshots();
  }

  // Start the game
  Future<void> startGame(String code) async {
    await _firestore.collection('lobbies').doc(code).update({
      'status': 'playing',
      'startTime': FieldValue.serverTimestamp(),
    });
  }

  // Submit an answer
  Future<void> submitScore(String code, int score) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('lobbies')
        .doc(code)
        .collection('players')
        .doc(user.uid)
        .update({
      'score': FieldValue.increment(score),
    });
  }

  // Leave lobby
  Future<void> leaveLobby(String code) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('lobbies')
        .doc(code)
        .collection('players')
        .doc(user.uid)
        .delete();

    // If host leaves, maybe delete lobby? (Simplified for now)
  }
}
