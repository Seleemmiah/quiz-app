import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/services/firestore_service.dart';

class ProfileValidator {
  static final FirestoreService _firestoreService = FirestoreService();

  /// Checks if the current user has completed their profile
  /// Returns null if profile is complete, or an error message if incomplete
  static Future<String?> validateProfileForExam() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return 'Please login first';
    }

    try {
      final userData = await _firestoreService.getUser(user.uid);
      final username = userData?['username'] as String?;
      final matricNumber = userData?['matricNumber'] as String?;

      if (username == null || username.isEmpty) {
        return 'Please set your name in Settings before taking exams';
      }

      if (matricNumber == null || matricNumber.isEmpty) {
        return 'Please set your matric number in Settings before taking exams';
      }

      return null; // Profile is complete
    } catch (e) {
      return 'Error checking profile: $e';
    }
  }
}
