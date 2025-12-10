import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/models/quiz_result.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Operations ---

  // Create or Update User
  Future<void> saveUser(User user,
      {String username = 'User',
      String role = 'student',
      String? matricNumber}) async {
    try {
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'username': username,
        'role': role,
        'createdAt': DateTime.now(),
        'lastLogin': DateTime.now(),
      };

      if (matricNumber != null) {
        userData['matricNumber'] = matricNumber;
      }

      await _db
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
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

  // Get User Role
  Future<String?> getUserRole(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['role'] as String?;
      }
      return null;
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

  // --- Teacher Operations ---

  // Get All Students
  Future<List<Map<String, dynamic>>> getStudents() async {
    try {
      final snapshot = await _db
          .collection('users')
          .where('role', isEqualTo: 'student')
          .orderBy('username')
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching students: $e');
      return [];
    }
  }

  // Get All Quiz Results (Teacher View)
  Future<List<QuizResult>> getAllQuizResults() async {
    try {
      final snapshot = await _db
          .collection('quiz_results')
          .orderBy('completedAt', descending: true)
          .limit(100) // Limit to last 100 for performance
          .get();

      return snapshot.docs
          .map((doc) => QuizResult.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching all results: $e');
      return [];
    }
  }

  // Create Exam
  Future<void> createExam(Map<String, dynamic> examData) async {
    await _db.collection('exams').doc(examData['code']).set(examData);
  }

  // Get Exam by Code
  Future<Map<String, dynamic>?> getExamByCode(String code) async {
    try {
      final doc = await _db.collection('exams').doc(code).get();
      return doc.data();
    } catch (e) {
      print('Error fetching exam: $e');
      return null;
    }
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

  // --- Analytics Operations ---

  // Save Quiz Result
  Future<void> saveQuizResult(QuizResult result) async {
    await _db
        .collection('user_results')
        .doc(result.userId)
        .collection('results')
        .doc(result.id)
        .set(result.toJson());
  }

  // Get User Results
  Future<List<QuizResult>> getUserResults(String userId,
      {int limit = 20}) async {
    final snapshot = await _db
        .collection('user_results')
        .doc(userId)
        .collection('results')
        .orderBy('date', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => QuizResult.fromJson(doc.data())).toList();
  }

  // Check if user has taken a specific quiz
  Future<bool> hasUserTakenQuiz(String userId, String quizId) async {
    final snapshot = await _db
        .collection('user_results')
        .doc(userId)
        .collection('results')
        .where('quizId', isEqualTo: quizId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // --- Group Operations (Placeholder) ---

  // --- Multiplayer Leaderboard Operations ---

  // Update Multiplayer Stats
  Future<void> updateMultiplayerStats(String uid,
      {bool isWin = false, int points = 0}) async {
    try {
      final userRef = _db.collection('users').doc(uid);
      await _db.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        if (!snapshot.exists) {
          throw Exception('User does not exist!');
        }

        final currentWins = snapshot.data()?['multiplayerWins'] ?? 0;
        final currentPoints = snapshot.data()?['multiplayerPoints'] ?? 0;

        transaction.update(userRef, {
          'multiplayerWins': isWin ? currentWins + 1 : currentWins,
          'multiplayerPoints': currentPoints + points,
        });
      });
    } catch (e) {
      print('Error updating multiplayer stats: $e');
      throw Exception('Failed to update multiplayer stats: $e');
    }
  }

  // Get Leaderboard
  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    try {
      final snapshot = await _db
          .collection('users')
          .orderBy('multiplayerPoints', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'uid': doc.id,
          'username': data['username'] ?? 'Anonymous',
          'multiplayerWins': data['multiplayerWins'] ?? 0,
          'multiplayerPoints': data['multiplayerPoints'] ?? 0,
        };
      }).toList();
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }

  // Get User Rank
  Future<int> getUserRank(String uid) async {
    try {
      final userDoc = await _db.collection('users').doc(uid).get();
      if (!userDoc.exists) return -1;

      final userPoints = userDoc.data()?['multiplayerPoints'] ?? 0;

      final snapshot = await _db
          .collection('users')
          .where('multiplayerPoints', isGreaterThan: userPoints)
          .get();

      return snapshot.docs.length + 1;
    } catch (e) {
      print('Error fetching user rank: $e');
      return -1;
    }
  }
}
