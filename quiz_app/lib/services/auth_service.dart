import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_app/services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Add client ID for iOS
    clientId:
        '362153618720-qod5e15ubgq7v3urkqnc7r2aou7ovb25.apps.googleusercontent.com',
  );
  final FirestoreService _firestoreService = FirestoreService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      print('🔐 Starting signup for: $email');

      // Create user in Auth with timeout
      final credential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception(
              'Authentication timed out. Please check your internet connection.');
        },
      );

      print('✅ Auth user created: ${credential.user?.uid}');

      // Create user document in Firestore with timeout
      if (credential.user != null) {
        print('📝 Saving user to Firestore...');
        await _firestoreService
            .saveUser(credential.user!, username: username)
            .timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw Exception(
                'Failed to save user data. Please check Firestore permissions.');
          },
        );
        print('✅ User saved to Firestore');

        // Update display name
        print('👤 Updating display name...');
        await credential.user!.updateDisplayName(username);
        print('✅ Display name updated');
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      print('❌ Auth error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Unknown error: $e');
      throw Exception('An unknown error occurred: $e');
    }
  }

  // Sign in with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Create/update user document in Firestore
      if (userCredential.user != null) {
        await _firestoreService.saveUser(
          userCredential.user!,
          username: userCredential.user!.displayName ?? 'User',
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to send reset email: $e');
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw Exception('Failed to send verification email: $e');
    }
  }

  // Check if email is verified
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // Reload user to check verification status
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  // Helper to handle Firebase Auth exceptions
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return Exception('The password provided is too weak.');
      case 'email-already-in-use':
        return Exception('The account already exists for that email.');
      case 'user-not-found':
        return Exception('No user found for that email.');
      case 'wrong-password':
        return Exception('Wrong password provided for that user.');
      case 'invalid-email':
        return Exception('The email address is badly formatted.');
      default:
        return Exception(e.message ?? 'Authentication failed.');
    }
  }
}
