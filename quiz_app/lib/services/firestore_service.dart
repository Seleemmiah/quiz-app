import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/quiz_result.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/utils/firestore_error_handler.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Quiz Operations ---

  Future<void> createQuiz(Quiz quiz) async {
    await _db.collection('quizzes').doc(quiz.id).set(quiz.toJson());
  }

  Future<Quiz?> getQuiz(String quizId) async {
    return await FirestoreErrorHandler.executeWithRetry<Quiz?>(
      operationName: 'Fetch Quiz',
      operation: () async {
        final doc = await _db.collection('quizzes').doc(quizId).get();
        if (doc.exists) {
          return Quiz.fromJson(doc.data()!);
        }
        return null;
      },
    );
  }

  Future<List<Quiz>> getQuizzes() async {
    final snapshot = await FirestoreErrorHandler.executeWithRetry(
      operationName: 'Fetch All Quizzes',
      operation: () => _db.collection('quizzes').get(),
    );
    if (snapshot == null) return [];
    return snapshot.docs.map((doc) => Quiz.fromJson(doc.data())).toList();
  }

  Future<List<Quiz>> getUserQuizzes(String userId) async {
    final snapshot = await _db
        .collection('quizzes')
        .where('creatorId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => Quiz.fromJson(doc.data())).toList();
  }

  Future<Quiz?> getQuizByAccessCode(String code) async {
    final snapshot = await _db
        .collection('quizzes')
        .where('accessCode', isEqualTo: code)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return Quiz.fromJson(snapshot.docs.first.data());
    }

    // Try exams collection
    final examDoc = await _db.collection('exams').doc(code).get();
    if (examDoc.exists) {
      final examData = examDoc.data()!;
      // Map exam data to Quiz model if possible
      return Quiz(
        id: examData['code'] ?? code,
        title: examData['subject'] ?? 'Exam',
        description: 'Scheduled Exam',
        creatorId: examData['creatorId'] ?? '',
        creatorName: 'Teacher',
        createdAt: DateTime.now(),
        questions: (examData['quizId'] != null)
            ? [] // We'd need to fetch the actual quiz questions here if linked
            : [], // Or use questions from the map if they were stored there
        difficulty: examData['difficulty'] ?? 'Medium',
        category: 'Exam',
        accessCode: code,
        isBlindMode: true, // Exams are blind by default
        resultsReleased: examData['resultsReleased'] ?? false,
      );
    }
    return null;
  }

  // --- Result Operations ---

  Future<void> saveQuizResult(QuizResult result) async {
    await _db
        .collection('user_results')
        .doc(result.userId)
        .collection('results')
        .doc(result.id)
        .set(result.toJson());

    // Also save to global registry for teacher dashboard analytics
    await _db.collection('quiz_results').doc(result.id).set(result.toJson());
  }

  Future<List<QuizResult>> getUserResults(String userId, {int? limit}) async {
    Query query = _db
        .collection('user_results')
        .doc(userId)
        .collection('results')
        .orderBy('date', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => QuizResult.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<QuizResult>> getAllQuizResults() async {
    try {
      final snapshot = await FirestoreErrorHandler.executeWithRetry(
        operationName: 'Fetch All Results',
        operation: () => _db
            .collection('quiz_results')
            .orderBy('date', descending: true)
            .limit(100)
            .get(),
      );

      if (snapshot == null) return [];

      return snapshot.docs
          .map((doc) => QuizResult.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching all results: $e');
      return [];
    }
  }

  Future<List<QuizResult>> getResultsForStudents(
      List<String> studentIds) async {
    if (studentIds.isEmpty) return [];

    try {
      List<QuizResult> results = [];
      // Firestore whereIn is limited to 30 items
      for (var i = 0; i < studentIds.length; i += 30) {
        final end = (i + 30 < studentIds.length) ? i + 30 : studentIds.length;
        final chunk = studentIds.sublist(i, end);

        final snapshot = await FirestoreErrorHandler.executeWithRetry(
          operationName: 'Fetch Results for Student Chunk',
          operation: () => _db
              .collection('quiz_results')
              .where('userId', whereIn: chunk)
              .orderBy('date', descending: true)
              .limit(100)
              .get(),
        );

        if (snapshot != null) {
          results.addAll(
            snapshot.docs.map((doc) => QuizResult.fromJson(doc.data())),
          );
        }
      }

      // Sort by date globally after fetching chunks
      results.sort((a, b) => b.date.compareTo(a.date));
      return results;
    } catch (e) {
      print('Error fetching student results: $e');
      return [];
    }
  }

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

  // --- User Profile Operations ---

  Future<void> saveUser(User user,
      {required String username,
      String role = 'student',
      String? matricNumber}) async {
    await _db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'username': username,
      'role': role,
      'matricNumber': matricNumber,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    return await FirestoreErrorHandler.executeWithRetry<Map<String, dynamic>?>(
      operationName: 'Fetch User',
      operation: () async {
        final doc = await _db.collection('users').doc(userId).get();
        return doc.exists ? doc.data() : null;
      },
    );
  }

  Future<String?> getUserRole(String userId) async {
    return await FirestoreErrorHandler.executeWithRetry<String?>(
      operationName: 'Fetch User Role',
      operation: () async {
        final doc = await _db.collection('users').doc(userId).get();
        if (doc.exists) {
          return doc.data()?['role'] as String?;
        }
        return null;
      },
    );
  }

  // --- Teacher & Student Linking ---

  Future<void> addStudentsToTeacher(
      String teacherId, List<String> studentIds) async {
    final batch = _db.batch();
    for (var id in studentIds) {
      final docRef = _db
          .collection('teachers')
          .doc(teacherId)
          .collection('students')
          .doc(id);
      batch.set(docRef, {'addedAt': FieldValue.serverTimestamp()},
          SetOptions(merge: true));
    }
    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> getTeacherStudents(
      String teacherId) async {
    try {
      final snapshot = await FirestoreErrorHandler.executeWithRetry(
        operationName: 'Fetch Teacher Students List',
        operation: () => _db
            .collection('teachers')
            .doc(teacherId)
            .collection('students')
            .get(),
      );

      if (snapshot == null || snapshot.docs.isEmpty) return [];

      final studentIds = snapshot.docs.map((d) => d.id).toList();
      List<Map<String, dynamic>> students = [];

      for (var i = 0; i < studentIds.length; i += 10) {
        final end = (i + 10 < studentIds.length) ? i + 10 : studentIds.length;
        final chunk = studentIds.sublist(i, end);

        final userSnap = await FirestoreErrorHandler.executeWithRetry(
          operationName: 'Fetch Student Profiles Chunk',
          operation: () => _db
              .collection('users')
              .where(FieldPath.documentId, whereIn: chunk)
              .get(),
        );

        if (userSnap != null) {
          students.addAll(userSnap.docs.map((d) => d.data()).toList());
        }
      }
      return students;
    } catch (e) {
      print('Error fetching teacher students: $e');
      return [];
    }
  }

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

  // --- Exam Operations ---

  Future<void> createExam(Map<String, dynamic> examData) async {
    await _db.collection('exams').doc(examData['code']).set(examData);
  }

  Future<Map<String, dynamic>?> getExamByCode(String code) async {
    final doc = await _db.collection('exams').doc(code).get();
    return doc.exists ? doc.data() : null;
  }

  Future<void> releaseExamResults(String code) async {
    final docRef = _db.collection('exams').doc(code);
    final doc = await docRef.get();

    if (!doc.exists) {
      throw 'Exam with code "$code" not found. Please verify the code.';
    }

    await docRef.update({'resultsReleased': true});

    // Also update in quizzes if it exists there
    final quizQuery = await _db
        .collection('quizzes')
        .where('accessCode', isEqualTo: code)
        .limit(1)
        .get();
    if (quizQuery.docs.isNotEmpty) {
      await quizQuery.docs.first.reference.update({'resultsReleased': true});
    }
  }

  Future<List<Map<String, dynamic>>> getExamsByTeacher(String userId) async {
    final snapshot = await _db
        .collection('exams')
        .where('creatorId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // --- Leaderboard Operations ---

  Future<List<Map<String, dynamic>>> getLeaderboard({int? limit}) async {
    Query query =
        _db.collection('users').orderBy('multiplayerPoints', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<int> getUserRank(String userId) async {
    final snapshot = await _db
        .collection('users')
        .orderBy('multiplayerPoints', descending: true)
        .get();

    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id == userId) {
        return i + 1;
      }
    }
    return -1;
  }

  Future<void> updateMultiplayerStats(String userId,
      {required bool isWin, required int points}) async {
    final Map<String, dynamic> updates = {
      'multiplayerPoints': FieldValue.increment(points),
    };
    if (isWin) {
      updates['multiplayerWins'] = FieldValue.increment(1);
    }
    await _db.collection('users').doc(userId).update(updates);
  }
}
