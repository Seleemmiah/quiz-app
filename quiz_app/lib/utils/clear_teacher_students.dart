import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// One-time script to clear all teacher-student links
/// Run this ONCE to reset your teacher dashboard to show 0 students
/// Then only students who use your codes after this will appear
class ClearTeacherStudents {
  static Future<void> clearAllStudentLinks() async {
    try {
      final teacherId = FirebaseAuth.instance.currentUser?.uid;
      if (teacherId == null) {
        print('❌ No teacher logged in');
        return;
      }

      print('🔄 Clearing all student links for teacher: $teacherId');

      final FirebaseFirestore db = FirebaseFirestore.instance;

      // Get all students currently linked to this teacher
      final studentsSnapshot = await db
          .collection('teachers')
          .doc(teacherId)
          .collection('students')
          .get();

      print('📊 Found ${studentsSnapshot.docs.length} linked students');

      // Delete all of them
      final batch = db.batch();
      for (var doc in studentsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      print('✅ Successfully cleared all student links!');
      print('💡 Now only students who use your codes will appear');
    } catch (e) {
      print('❌ Error clearing student links: $e');
    }
  }
}
