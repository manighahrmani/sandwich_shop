import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/auth_repository.dart';

void main() {
  late MockFirebaseAuth mockAuth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    AuthRepository.instance.setAuth(mockAuth);
  });

  tearDown(() {
    AuthRepository.instance.setAuth(null);
  });

  group('AuthRepository unit tests', () {
    test('getCurrentUser returns null when signed out', () {
      final User? currentUser = AuthRepository.instance.getCurrentUser();
      expect(currentUser, isNull);
    });

    test('signUpWithEmail creates and signs in a new user', () async {
      final User? user = await AuthRepository.instance.signUpWithEmail(
        'alice@example.com',
        'secret123',
      );

      expect(user, isNotNull);
      expect(user!.email, 'alice@example.com');
      final User? currentUser = AuthRepository.instance.getCurrentUser();
      expect(currentUser, isNotNull);
      expect(currentUser!.email, 'alice@example.com');
    });

    test('signInWithEmail signs in an existing user', () async {
      final MockUser existingUser = MockUser(
        uid: 'user-1',
        email: 'bob@example.com',
      );
      final MockFirebaseAuth signedOutAuth = MockFirebaseAuth(
        mockUser: existingUser,
        signedIn: false,
      );
      AuthRepository.instance.setAuth(signedOutAuth);

      final User? user = await AuthRepository.instance.signInWithEmail(
        'bob@example.com',
        'password123',
      );

      expect(user, isNotNull);
      expect(user!.uid, 'user-1');
      expect(user.email, 'bob@example.com');
    });

    test('signOut signs out the current user', () async {
      final MockUser existingUser = MockUser(
        uid: 'user-2',
        email: 'claire@example.com',
      );
      final MockFirebaseAuth signedInAuth = MockFirebaseAuth(
        mockUser: existingUser,
        signedIn: true,
      );
      AuthRepository.instance.setAuth(signedInAuth);
      expect(AuthRepository.instance.getCurrentUser(), isNotNull);

      await AuthRepository.instance.signOut();

      expect(AuthRepository.instance.getCurrentUser(), isNull);
    });

    test('watchAuthState emits sign-in and sign-out updates', () async {
      final List<User?> emittedUsers = <User?>[];
      final StreamSubscription<User?> subscription =
          AuthRepository.instance.watchAuthState().listen((User? user) {
        emittedUsers.add(user);
      });

      await AuthRepository.instance.signUpWithEmail(
        'dana@example.com',
        'secret123',
      );
      await AuthRepository.instance.signOut();
      await Future<void>.delayed(Duration.zero);
      await subscription.cancel();

      expect(emittedUsers.length, greaterThanOrEqualTo(2));
      expect(emittedUsers.last, isNull);
    });

    test('auth falls back to FirebaseAuth.instance when no mock is set', () {
      AuthRepository.instance.setAuth(null);

      FirebaseAuth readAuth() {
        return AuthRepository.instance.auth;
      }

      expect(readAuth, throwsA(isA<FirebaseException>()));
    });

    test('getErrorMessage maps each supported FirebaseAuthException code', () {
      expect(
        AuthRepository.instance.getErrorMessage(
          FirebaseAuthException(code: 'invalid-email'),
        ),
        'Please enter a valid email address.',
      );
      expect(
        AuthRepository.instance.getErrorMessage(
          FirebaseAuthException(code: 'user-not-found'),
        ),
        'No account was found with that email address.',
      );
      expect(
        AuthRepository.instance.getErrorMessage(
          FirebaseAuthException(code: 'wrong-password'),
        ),
        'Incorrect email or password.',
      );
      expect(
        AuthRepository.instance.getErrorMessage(
          FirebaseAuthException(code: 'invalid-credential'),
        ),
        'Incorrect email or password.',
      );
      expect(
        AuthRepository.instance.getErrorMessage(
          FirebaseAuthException(code: 'email-already-in-use'),
        ),
        'An account already exists for that email address.',
      );
      expect(
        AuthRepository.instance.getErrorMessage(
          FirebaseAuthException(code: 'weak-password'),
        ),
        'Password must be at least 6 characters long.',
      );
      expect(
        AuthRepository.instance.getErrorMessage(
          FirebaseAuthException(code: 'network-request-failed'),
        ),
        'Authentication failed. Please try again.',
      );
    });
  });
}
