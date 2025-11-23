import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/models/class_model.dart';
import 'package:quiz_app/models/class_member.dart';

class ClassService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate a unique 6-character class code
  String _generateClassCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  // Create a new class
  Future<ClassModel> createClass({
    required String className,
    required String teacherId,
    required String teacherName,
    String? subject,
    String? description,
  }) async {
    try {
      // Generate unique class code
      String classCode;
      bool isUnique = false;

      do {
        classCode = _generateClassCode();
        final existing = await _firestore
            .collection('classes')
            .where('classCode', isEqualTo: classCode)
            .get();
        isUnique = existing.docs.isEmpty;
      } while (!isUnique);

      final classId = _firestore.collection('classes').doc().id;

      final newClass = ClassModel(
        classId: classId,
        className: className,
        classCode: classCode,
        teacherId: teacherId,
        teacherName: teacherName,
        createdAt: DateTime.now(),
        subject: subject,
        description: description,
        memberCount: 1,
      );

      // Save class to Firestore
      await _firestore
          .collection('classes')
          .doc(classId)
          .set(newClass.toJson());

      // Add teacher as first member
      final teacherMember = ClassMember(
        classId: classId,
        userId: teacherId,
        userName: teacherName,
        userAvatar: '👨‍🏫',
        joinedAt: DateTime.now(),
        role: 'teacher',
      );

      await _firestore
          .collection('class_members')
          .doc('${classId}_$teacherId')
          .set(teacherMember.toJson());

      return newClass;
    } catch (e) {
      throw Exception('Failed to create class: $e');
    }
  }

  // Join a class using class code
  Future<ClassModel> joinClass({
    required String classCode,
    required String userId,
    required String userName,
    String userAvatar = '👨‍🎓',
  }) async {
    try {
      // Find class by code
      final classQuery = await _firestore
          .collection('classes')
          .where('classCode', isEqualTo: classCode.toUpperCase())
          .get();

      if (classQuery.docs.isEmpty) {
        throw Exception('Class not found. Please check the code.');
      }

      final classDoc = classQuery.docs.first;
      final classData = ClassModel.fromJson(classDoc.data());

      // Check if already a member
      final memberDoc = await _firestore
          .collection('class_members')
          .doc('${classData.classId}_$userId')
          .get();

      if (memberDoc.exists) {
        throw Exception('You are already a member of this class.');
      }

      // Add as member
      final newMember = ClassMember(
        classId: classData.classId,
        userId: userId,
        userName: userName,
        userAvatar: userAvatar,
        joinedAt: DateTime.now(),
        role: 'student',
      );

      await _firestore
          .collection('class_members')
          .doc('${classData.classId}_$userId')
          .set(newMember.toJson());

      // Update member count
      await _firestore
          .collection('classes')
          .doc(classData.classId)
          .update({'memberCount': FieldValue.increment(1)});

      return classData.copyWith(
        memberCount: classData.memberCount + 1,
      );
    } catch (e) {
      throw Exception('Failed to join class: $e');
    }
  }

  // Get user's classes (both as teacher and student)
  Future<List<ClassModel>> getUserClasses(String userId) async {
    try {
      // Get all class memberships for this user
      final memberQuery = await _firestore
          .collection('class_members')
          .where('userId', isEqualTo: userId)
          .get();

      if (memberQuery.docs.isEmpty) {
        return [];
      }

      // Get class IDs
      final classIds = memberQuery.docs
          .map((doc) => ClassMember.fromJson(doc.data()).classId)
          .toList();

      // Fetch all classes
      final classes = <ClassModel>[];
      for (final classId in classIds) {
        final classDoc =
            await _firestore.collection('classes').doc(classId).get();
        if (classDoc.exists) {
          classes.add(ClassModel.fromJson(classDoc.data()!));
        }
      }

      return classes;
    } catch (e) {
      throw Exception('Failed to fetch classes: $e');
    }
  }

  // Get class members
  Future<List<ClassMember>> getClassMembers(String classId) async {
    try {
      final memberQuery = await _firestore
          .collection('class_members')
          .where('classId', isEqualTo: classId)
          .get();

      return memberQuery.docs
          .map((doc) => ClassMember.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch class members: $e');
    }
  }

  // Submit score to class leaderboard
  Future<void> submitScoreToClasses({
    required String userId,
    required String userName,
    required int score,
    required int totalQuestions,
    required String category,
    required String difficulty,
  }) async {
    try {
      // Get all user's classes
      final memberQuery = await _firestore
          .collection('class_members')
          .where('userId', isEqualTo: userId)
          .get();

      final percentage = (score / totalQuestions) * 100;

      // Submit score to each class
      for (final memberDoc in memberQuery.docs) {
        final member = ClassMember.fromJson(memberDoc.data());

        final scoreData = {
          'classId': member.classId,
          'userId': userId,
          'userName': userName,
          'score': score,
          'totalQuestions': totalQuestions,
          'percentage': percentage,
          'category': category,
          'difficulty': difficulty,
          'completedAt': DateTime.now().millisecondsSinceEpoch,
        };

        await _firestore.collection('class_scores').add(scoreData);
      }
    } catch (e) {
      throw Exception('Failed to submit score: $e');
    }
  }

  // Get class leaderboard
  Future<List<Map<String, dynamic>>> getClassLeaderboard({
    required String classId,
    String? category,
    String? difficulty,
    int limit = 50,
  }) async {
    try {
      Query query = _firestore
          .collection('class_scores')
          .where('classId', isEqualTo: classId);

      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      if (difficulty != null) {
        query = query.where('difficulty', isEqualTo: difficulty);
      }

      final scoresQuery = await query
          .orderBy('percentage', descending: true)
          .orderBy('completedAt', descending: false)
          .limit(limit)
          .get();

      return scoresQuery.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch leaderboard: $e');
    }
  }

  // Leave a class
  Future<void> leaveClass({
    required String classId,
    required String userId,
  }) async {
    try {
      // Remove member
      await _firestore
          .collection('class_members')
          .doc('${classId}_$userId')
          .delete();

      // Update member count
      await _firestore
          .collection('classes')
          .doc(classId)
          .update({'memberCount': FieldValue.increment(-1)});
    } catch (e) {
      throw Exception('Failed to leave class: $e');
    }
  }

  // Get class by ID
  Future<ClassModel?> getClass(String classId) async {
    try {
      final classDoc =
          await _firestore.collection('classes').doc(classId).get();

      if (!classDoc.exists) {
        return null;
      }

      return ClassModel.fromJson(classDoc.data()!);
    } catch (e) {
      throw Exception('Failed to fetch class: $e');
    }
  }

  // Check if user is teacher of a class
  Future<bool> isTeacher(String classId, String userId) async {
    try {
      final memberDoc = await _firestore
          .collection('class_members')
          .doc('${classId}_$userId')
          .get();

      if (!memberDoc.exists) {
        return false;
      }

      final member = ClassMember.fromJson(memberDoc.data()!);
      return member.isTeacher;
    } catch (e) {
      return false;
    }
  }
}
