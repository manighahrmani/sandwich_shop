import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart_item.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/auth_repository.dart';
import 'package:sandwich_shop/repositories/cart_repository.dart';

class _EmailLinkFirebaseAuth extends MockFirebaseAuth {
  @override
  bool isSignInWithEmailLink(String emailLink) {
    return emailLink.contains('oobCode=');
  }

  @override
  Future<UserCredential> signInWithEmailLink({
    required String email,
    required String emailLink,
  }) {
    return signInWithEmailAndPassword(email: email, password: 'link-user');
  }
}

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

    test('signOut signs out the current user and clears the basket', () async {
      final MockUser existingUser = MockUser(
        uid: 'user-2',
        email: 'claire@example.com',
      );
      final MockFirebaseAuth signedInAuth = MockFirebaseAuth(
        mockUser: existingUser,
        signedIn: true,
      );
      AuthRepository.instance.setAuth(signedInAuth);
      CartRepository.instance.addItem(
        const CartItem(
          sandwich: Sandwich(
            id: 'footlong',
            name: 'Footlong Sub',
            description: 'Fresh sub',
            price: 7.5,
            imagePath: 'assets/images/footlong.jpeg',
          ),
          quantity: 1,
        ),
      );
      expect(AuthRepository.instance.getCurrentUser(), isNotNull);
      expect(CartRepository.instance.getItems(), isNotEmpty);

      await AuthRepository.instance.signOut();

      expect(AuthRepository.instance.getCurrentUser(), isNull);
      expect(CartRepository.instance.getItems(), isEmpty);
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
          FirebaseAuthException(code: 'expired-action-code'),
        ),
        'This sign-in link has expired or is invalid.',
      );
      expect(
        AuthRepository.instance.getErrorMessage(
          FirebaseAuthException(code: 'invalid-action-code'),
        ),
        'This sign-in link has expired or is invalid.',
      );
      expect(
        AuthRepository.instance.getErrorMessage(
          FirebaseAuthException(code: 'popup-closed-by-user'),
        ),
        'Google sign-in was cancelled.',
      );
      expect(
        AuthRepository.instance.getErrorMessage(
          FirebaseAuthException(code: 'network-request-failed'),
        ),
        'Authentication failed. Please try again.',
      );
    });

    test('sendSignInLink completes without error', () async {
      await AuthRepository.instance.sendSignInLink(
        'alice@example.com',
        'https://example.com',
      );
    });

    test('isSignInWithEmailLink and signInWithEmailLink handle links',
        () async {
      expect(
        AuthRepository.instance.isSignInWithEmailLink('https://example.com'),
        isFalse,
      );

      final _EmailLinkFirebaseAuth linkAuth = _EmailLinkFirebaseAuth();
      AuthRepository.instance.setAuth(linkAuth);

      const String validLink = 'https://example.com/?oobCode=test123';
      expect(AuthRepository.instance.isSignInWithEmailLink(validLink), isTrue);

      final User? user = await AuthRepository.instance.signInWithEmailLink(
        'alice@example.com',
        validLink,
      );
      expect(user, isNotNull);
    });

    test('signInWithGoogle signs in on both web and mobile', () async {
      final User? webUser = await AuthRepository.instance.signInWithGoogle(
        isWeb: true,
      );
      expect(webUser, isNotNull);

      await AuthRepository.instance.signOut();

      final User? mobileUser = await AuthRepository.instance.signInWithGoogle(
        isWeb: false,
      );
      expect(mobileUser, isNotNull);
    });

    test('updateDisplayName updates signed-in profile and skips signed out',
        () async {
      await AuthRepository.instance.updateDisplayName('Ignored Name');
      expect(AuthRepository.instance.getCurrentUser(), isNull);

      final MockFirebaseAuth signedInAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'user-3', email: 'sam@example.com'),
      );
      AuthRepository.instance.setAuth(signedInAuth);

      await AuthRepository.instance.updateDisplayName('Sam Taylor');
      expect(
          AuthRepository.instance.getCurrentUser()?.displayName, 'Sam Taylor');
    });
  });
}
