import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository._internal();

  static final AuthRepository instance = AuthRepository._internal();

  FirebaseAuth? _auth;

  void setAuth(FirebaseAuth? auth) {
    _auth = auth;
  }

  FirebaseAuth get auth {
    final FirebaseAuth? existingAuth = _auth;
    if (existingAuth != null) {
      return existingAuth;
    }
    return FirebaseAuth.instance;
  }

  User? getCurrentUser() {
    final FirebaseAuth authInstance = auth;
    return authInstance.currentUser;
  }

  Stream<User?> watchAuthState() {
    final FirebaseAuth authInstance = auth;
    return authInstance.authStateChanges();
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    final FirebaseAuth authInstance = auth;
    final UserCredential credential =
        await authInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    final FirebaseAuth authInstance = auth;
    final UserCredential credential =
        await authInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<void> signOut() async {
    final FirebaseAuth authInstance = auth;
    await authInstance.signOut();
  }

  String getErrorMessage(FirebaseAuthException error) {
    final String code = error.code;
    if (code == 'invalid-email') {
      return 'Please enter a valid email address.';
    }
    if (code == 'user-not-found') {
      return 'No account was found with that email address.';
    }
    if (code == 'wrong-password' || code == 'invalid-credential') {
      return 'Incorrect email or password.';
    }
    if (code == 'email-already-in-use') {
      return 'An account already exists for that email address.';
    }
    if (code == 'weak-password') {
      return 'Password must be at least 6 characters long.';
    }
    return 'Authentication failed. Please try again.';
  }
}
