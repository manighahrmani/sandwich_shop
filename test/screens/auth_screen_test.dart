import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/auth_repository.dart';
import 'package:sandwich_shop/screens/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

class _FailingFirebaseAuth extends MockFirebaseAuth {
  _FailingFirebaseAuth({required this.errorToThrow});

  final Object errorToThrow;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return Future<UserCredential>.error(errorToThrow);
  }

  @override
  Future<void> sendSignInLinkToEmail({
    required String email,
    required ActionCodeSettings actionCodeSettings,
  }) {
    return Future<void>.error(errorToThrow);
  }

  @override
  Future<UserCredential> signInWithPopup(AuthProvider provider) {
    return Future<UserCredential>.error(errorToThrow);
  }

  @override
  Future<UserCredential> signInWithProvider(AuthProvider provider) {
    return Future<UserCredential>.error(errorToThrow);
  }
}

void main() {
  late MockFirebaseAuth mockAuth;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    mockAuth = MockFirebaseAuth();
    AuthRepository.instance.setAuth(mockAuth);
  });

  tearDown(() {
    AuthRepository.instance.setAuth(null);
  });

  testWidgets('AuthScreen displays sign-in form and toggles mode', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: AuthScreen(key: UniqueKey())));
    await tester.pump();

    expect(find.text('Customer Sign In'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Email me a sign-in link'), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);

    await tester.tap(find.text('Need an account? Register'));
    await tester.pump();

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);

    await tester.tap(find.text('Already have an account? Sign In'));
    await tester.pump();

    expect(find.text('Customer Sign In'), findsOneWidget);
  });

  testWidgets('AuthScreen shows validation error when fields are empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
    await tester.pump();

    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(
      find.text('Please enter both an email and a password.'),
      findsOneWidget,
    );
  });

  testWidgets('AuthScreen registers a customer and returns to previous screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
                },
                child: const Text('Open Auth'),
              ),
            );
          },
          '/auth': (BuildContext context) {
            return const AuthScreen();
          },
        },
      ),
    );

    await tester.tap(find.text('Open Auth'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Need an account? Register'));
    await tester.pump();

    await tester.enterText(find.byType(TextField).at(0), 'alice@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret123');
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Open Auth'), findsOneWidget);
    expect(
        AuthRepository.instance.getCurrentUser()?.email, 'alice@example.com');
  });

  testWidgets('AuthScreen signs in an existing customer and returns', (
    WidgetTester tester,
  ) async {
    await mockAuth.createUserWithEmailAndPassword(
      email: 'alice@example.com',
      password: 'secret123',
    );
    await mockAuth.signOut();

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
                },
                child: const Text('Open Auth'),
              ),
            );
          },
          '/auth': (BuildContext context) {
            return const AuthScreen();
          },
        },
      ),
    );

    await tester.tap(find.text('Open Auth'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'alice@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret123');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Open Auth'), findsOneWidget);
    expect(
        AuthRepository.instance.getCurrentUser()?.email, 'alice@example.com');
  });

  testWidgets('AuthScreen validates email and sends sign-in link', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
    await tester.pump();

    await tester.tap(find.text('Email me a sign-in link'));
    await tester.pump();

    expect(find.text('Please enter your email address.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'alice@example.com');
    await tester.tap(find.text('Email me a sign-in link'));
    await tester.pumpAndSettle();

    expect(
      find.text('Sign-in link sent to alice@example.com. Check your inbox.'),
      findsOneWidget,
    );
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    expect(await prefs.getString(prefPendingEmail), 'alice@example.com');
  });

  testWidgets('AuthScreen shows errors when sending email link fails', (
    WidgetTester tester,
  ) async {
    AuthRepository.instance.setAuth(
      _FailingFirebaseAuth(
        errorToThrow: FirebaseAuthException(code: 'invalid-email'),
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
    await tester.pump();

    await tester.enterText(find.byType(TextField).at(0), 'bad-email');
    await tester.tap(find.text('Email me a sign-in link'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email address.'), findsOneWidget);

    AuthRepository.instance.setAuth(
      _FailingFirebaseAuth(errorToThrow: Exception('offline')),
    );

    await tester.tap(find.text('Email me a sign-in link'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Could not send sign-in link:'), findsOneWidget);
  });

  testWidgets('AuthScreen signs in with Google and returns to previous screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
                },
                child: const Text('Open Auth'),
              ),
            );
          },
          '/auth': (BuildContext context) {
            return const AuthScreen();
          },
        },
      ),
    );

    await tester.tap(find.text('Open Auth'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign in with Google'));
    await tester.pumpAndSettle();

    expect(find.text('Open Auth'), findsOneWidget);
    expect(AuthRepository.instance.getCurrentUser(), isNotNull);
  });

  testWidgets('AuthScreen shows errors when Google sign-in fails', (
    WidgetTester tester,
  ) async {
    AuthRepository.instance.setAuth(
      _FailingFirebaseAuth(
        errorToThrow: FirebaseAuthException(code: 'popup-closed-by-user'),
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
    await tester.pump();

    await tester.tap(find.text('Sign in with Google'));
    await tester.pumpAndSettle();

    expect(find.text('Google sign-in was cancelled.'), findsOneWidget);

    AuthRepository.instance.setAuth(
      _FailingFirebaseAuth(errorToThrow: Exception('popup blocked')),
    );

    await tester.tap(find.text('Sign in with Google'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Could not complete Google sign-in:'),
      findsOneWidget,
    );
  });

  testWidgets('AuthScreen displays mapped FirebaseAuthException message', (
    WidgetTester tester,
  ) async {
    AuthRepository.instance.setAuth(
      _FailingFirebaseAuth(
        errorToThrow: FirebaseAuthException(code: 'wrong-password'),
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
    await tester.pump();

    await tester.enterText(find.byType(TextField).at(0), 'alice@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'wrongpass');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Incorrect email or password.'), findsOneWidget);
  });

  testWidgets('AuthScreen displays fallback message on unexpected error', (
    WidgetTester tester,
  ) async {
    AuthRepository.instance.setAuth(
      _FailingFirebaseAuth(errorToThrow: Exception('network down')),
    );

    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
    await tester.pump();

    await tester.enterText(find.byType(TextField).at(0), 'alice@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret123');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Could not complete sign-in:'), findsOneWidget);
  });
}
