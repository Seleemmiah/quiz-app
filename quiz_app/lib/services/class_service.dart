import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/models/class_model.dart';
import 'package:quiz_app/models/class_member.dart';
import 'package:quiz_app/services/notification_service.dart';
import 'package:quiz_app/models/notification_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

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

      // Send notification to teacher
      await NotificationService().sendNotification(
        userId: teacherId,
        title: 'Class Created!',
        body:
            'You have successfully created class "$className". Code: $classCode',
        type: NotificationType.general,
        data: {'route': '/class_detail', 'arguments': newClass.toJson()},
      );

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

      // Fetch all scores for the class (without ordering to avoid index issues)
      final scoresQuery = await query.get();

      final scores = scoresQuery.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Sort client-side
      scores.sort((a, b) {
        // Sort by percentage descending
        final percentageA = (a['percentage'] as num?)?.toDouble() ?? 0.0;
        final percentageB = (b['percentage'] as num?)?.toDouble() ?? 0.0;
        final percentageCompare = percentageB.compareTo(percentageA);

        if (percentageCompare != 0) {
          return percentageCompare;
        }

        // Secondary sort by completedAt ascending (earlier is better)
        final completedAtA = (a['completedAt'] as num?)?.toInt() ?? 0;
        final completedAtB = (b['completedAt'] as num?)?.toInt() ?? 0;
        return completedAtA.compareTo(completedAtB);
      });

      // Apply limit
      if (scores.length > limit) {
        return scores.sublist(0, limit);
      }

      return scores;
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

  // Schedule an event for a class
  Future<void> scheduleEvent({
    required String classId,
    required String title,
    String? description,
    required DateTime scheduledAt,
    int? reminderBeforeMinutes,
  }) async {
    try {
      final eventData = {
        'classId': classId,
        'title': title,
        'description': description,
        'scheduledAt': scheduledAt.millisecondsSinceEpoch,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        if (reminderBeforeMinutes != null)
          'reminderBeforeMinutes': reminderBeforeMinutes,
      };

      await _firestore.collection('class_events').add(eventData);

      // Schedule reminder notification with custom time
      final eventId =
          '${eventData['classId']}_${scheduledAt.millisecondsSinceEpoch}';
      final reminderBefore = eventData['reminderBeforeMinutes'] != null
          ? Duration(minutes: eventData['reminderBeforeMinutes'] as int)
          : const Duration(hours: 1); // Default 1 hour

      await NotificationService().scheduleEventReminder(
        eventId: eventId,
        title: 'Upcoming Event: $title',
        body: 'Event starts in ${_formatDuration(reminderBefore)}',
        scheduledAt: scheduledAt,
        reminderBefore: reminderBefore,
      );

      // Notify all class members
      final members = await getClassMembers(classId);
      for (final member in members) {
        // Don't notify the teacher who created it
        if (member.role == 'teacher') continue;

        await NotificationService().sendNotification(
          userId: member.userId,
          title: 'New Event Scheduled: $title',
          body:
              'A new event has been scheduled for ${DateFormat.yMMMd().add_jm().format(scheduledAt)}.',
          type: NotificationType.scheduleUpdate,
          data: {
            'route': '/class_detail',
            'arguments': (await getClass(classId))?.toJson()
          },
        );
      }
    } catch (e) {
      throw Exception('Failed to schedule event: $e');
    }
  }

  // Get upcoming events for a class
  Future<List<Map<String, dynamic>>> getClassEvents(String classId) async {
    try {
      debugPrint('Fetching events for classId: $classId');
      final query = await _firestore
          .collection('class_events')
          .where('classId', isEqualTo: classId)
          .get();

      debugPrint('Found ${query.docs.length} events in Firestore');

      // Sort client-side to avoid index requirement
      final events = query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID for edit/delete
        return data;
      }).toList();

      events.sort((a, b) {
        final aTime = (a['scheduledAt'] as num?)?.toInt() ?? 0;
        final bTime = (b['scheduledAt'] as num?)?.toInt() ?? 0;
        return aTime.compareTo(bTime);
      });

      return events;
    } catch (e) {
      debugPrint('Error fetching class events: $e');
      throw Exception('Failed to load events: $e');
    }
  }

  // Update an existing event
  Future<void> updateEvent({
    required String eventId,
    required String classId,
    required String title,
    String? description,
    required DateTime scheduledAt,
  }) async {
    try {
      final eventData = {
        'title': title,
        'description': description,
        'scheduledAt': scheduledAt.millisecondsSinceEpoch,
      };

      await _firestore
          .collection('class_events')
          .doc(eventId)
          .update(eventData);

      // Notify all class members about the update
      final members = await getClassMembers(classId);
      for (final member in members) {
        if (member.role == 'teacher') continue;

        await NotificationService().sendNotification(
          userId: member.userId,
          title: 'Event Updated: $title',
          body:
              'An event has been updated to ${DateFormat.yMMMd().add_jm().format(scheduledAt)}.',
          type: NotificationType.scheduleUpdate,
          data: {
            'route': '/class_detail',
            'arguments': (await getClass(classId))?.toJson()
          },
        );
      }
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  // Delete an event
  Future<void> deleteEvent({
    required String eventId,
    required String classId,
    required String eventTitle,
  }) async {
    try {
      // Cancel reminder notification
      await NotificationService().cancelEventReminder(eventId);

      await _firestore.collection('class_events').doc(eventId).delete();

      // Notify all class members about the deletion
      final members = await getClassMembers(classId);
      for (final member in members) {
        if (member.role == 'teacher') continue;

        await NotificationService().sendNotification(
          userId: member.userId,
          title: 'Event Cancelled: $eventTitle',
          body: 'The event "$eventTitle" has been cancelled.',
          type: NotificationType.scheduleUpdate,
          data: {
            'route': '/class_detail',
            'arguments': (await getClass(classId))?.toJson()
          },
        );
      }
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} minutes';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    } else {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
    }
  }
}
