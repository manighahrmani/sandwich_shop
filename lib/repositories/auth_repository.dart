import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';

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

  Future<void> sendSignInLink(String email, String continueUrl) async {
    final FirebaseAuth authInstance = auth;
    final ActionCodeSettings settings = ActionCodeSettings(
      url: continueUrl,
      handleCodeInApp: true,
      androidPackageName: 'com.example.sandwich_shop',
    );
    await authInstance.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: settings,
    );
  }

  bool isSignInWithEmailLink(String link) {
    if (!link.contains('oobCode=')) {
      return false;
    }
    final FirebaseAuth authInstance = auth;
    return authInstance.isSignInWithEmailLink(link);
  }

  Future<User?> signInWithEmailLink(String email, String link) async {
    final FirebaseAuth authInstance = auth;
    final UserCredential credential = await authInstance.signInWithEmailLink(
      email: email,
      emailLink: link,
    );
    return credential.user;
  }

  Future<User?> signInWithGoogle({bool isWeb = kIsWeb}) async {
    final FirebaseAuth authInstance = auth;
    final GoogleAuthProvider provider = GoogleAuthProvider();
    final UserCredential credential;
    if (isWeb) {
      credential = await authInstance.signInWithPopup(provider);
    } else {
      credential = await authInstance.signInWithProvider(provider);
    }
    return credential.user;
  }

  Future<void> signOut() async {
    final FirebaseAuth authInstance = auth;
    await authInstance.signOut();
    CartRepository.instance.clear();
  }

  Future<void> updateDisplayName(String displayName) async {
    final User? currentUser = getCurrentUser();
    if (currentUser != null) {
      await currentUser.updateDisplayName(displayName);
    }
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
    if (code == 'expired-action-code' || code == 'invalid-action-code') {
      return 'This sign-in link has expired or is invalid.';
    }
    if (code == 'popup-closed-by-user') {
      return 'Google sign-in was cancelled.';
    }
    return 'Authentication failed. Please try again.';
  }
}
