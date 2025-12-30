import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.code, e.message));
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> register(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.code, e.message));
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Logout failed');
    }
  }

  String _getAuthErrorMessage(String code, String? message) {
    switch (code) {
      case 'weak-password':
        return 'Password is weak. Use at least 6 characters.';
      case 'email-already-in-use':
        return 'This email is already registered. Please login instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'operation-not-allowed':
        return 'Email/Password authentication not enabled.\n\nPlease:\n1. Go to Firebase Console\n2. Enable Email/Password in Authentication\n3. Try again';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network connection failed.\n\nPlease check:\n1. Internet is working\n2. Firestore Database is created\n3. Firestore is in test mode (not production)';
      case 'internal-error':
        return 'Firebase internal error.\n\nPlease check:\n1. Email/Password authentication is enabled\n2. Firestore Database is created\n3. Go to Firebase Console and verify settings';
      default:
        return 'Error: $code - ${message ?? "Unknown error"}';
    }
  }
}
