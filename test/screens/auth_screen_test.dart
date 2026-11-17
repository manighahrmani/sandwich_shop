import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/auth_repository.dart';
import 'package:sandwich_shop/screens/auth_screen.dart';

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

  testWidgets('AuthScreen displays sign-in form and toggles mode', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: AuthScreen(key: UniqueKey())));
    await tester.pump();

    expect(find.text('Customer Sign In'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Sign In'), findsOneWidget);

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
