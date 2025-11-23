import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/quiz_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Operations ---

  // Create or Update User
  Future<void> saveUser(User user, {String? username}) async {
    final userRef = _db.collection('users').doc(user.uid);

    final userData = {
      'email': user.email,
      'lastLogin': FieldValue.serverTimestamp(),
    };

    if (username != null) {
      userData['username'] = username;
      userData['createdAt'] = FieldValue.serverTimestamp();
      userData['avatar'] = '😎'; // Default avatar
      userData['xp'] = 0;
      userData['level'] = 1;
    }

    await userRef.set(userData, SetOptions(merge: true));
  }

  // Get User Data
  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  // Update User Fields
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // --- Quiz Operations ---

  // Create Quiz
  Future<void> createQuiz(Quiz quiz) async {
    await _db.collection('quizzes').doc(quiz.id).set(quiz.toJson());
  }

  // Get Public Quizzes
  Future<List<Quiz>> getPublicQuizzes() async {
    final snapshot = await _db
        .collection('quizzes')
        .where('isPublic', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Quiz.fromJson(doc.data())).toList();
  }

  // Get User Quizzes
  Future<List<Quiz>> getUserQuizzes(String userId) async {
    final snapshot = await _db
        .collection('quizzes')
        .where('creatorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Quiz.fromJson(doc.data())).toList();
  }

  // Get Single Quiz
  Future<Quiz?> getQuiz(String quizId) async {
    final doc = await _db.collection('quizzes').doc(quizId).get();
    if (doc.exists) {
      return Quiz.fromJson(doc.data()!);
    }
    return null;
  }

  // Get Quiz by Access Code
  Future<Quiz?> getQuizByAccessCode(String accessCode) async {
    final snapshot = await _db
        .collection('quizzes')
        .where('accessCode', isEqualTo: accessCode)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Quiz.fromJson(snapshot.docs.first.data());
    }
    return null;
  }

  // --- Group Operations (Placeholder) ---
}
