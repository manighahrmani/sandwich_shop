import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/auth_repository.dart';
import 'package:sandwich_shop/widgets/account_button.dart';

void main() {
  setUp(() {
    AuthRepository.instance.setAuth(MockFirebaseAuth());
  });

  tearDown(() {
    AuthRepository.instance.setAuth(null);
  });

  testWidgets('AccountButton shows Log In when signed out and opens /auth', (
    WidgetTester tester,
  ) async {
    int authBuildCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) {
            return const Scaffold(body: AccountButton());
          },
          '/auth': (BuildContext context) {
            authBuildCount = authBuildCount + 1;
            return const Scaffold(body: Text('Auth Page'));
          },
        },
      ),
    );
    await tester.pump();

    expect(find.text('Log In'), findsOneWidget);

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.text('Auth Page'), findsOneWidget);
    expect(authBuildCount, 1);
  });

  testWidgets('AccountButton does not push /auth twice when already on /auth', (
    WidgetTester tester,
  ) async {
    int authBuildCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/auth',
        routes: <String, WidgetBuilder>{
          '/auth': (BuildContext context) {
            authBuildCount = authBuildCount + 1;
            return const Scaffold(body: AccountButton());
          },
        },
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(authBuildCount, 1);
  });

  testWidgets('AccountButton navigates from an unnamed route when signed out', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: <String, WidgetBuilder>{
          '/auth': (BuildContext context) {
            return const Scaffold(body: Text('Auth Page'));
          },
        },
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return const Scaffold(body: AccountButton());
                      },
                    ),
                  );
                },
                child: const Text('Open Unnamed'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Unnamed'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.text('Auth Page'), findsOneWidget);
  });

  testWidgets(
      'AccountButton shows Sign Out when signed in and signs out on tap', (
    WidgetTester tester,
  ) async {
    final MockFirebaseAuth signedInAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(email: 'alice@example.com'),
    );
    AuthRepository.instance.setAuth(signedInAuth);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AccountButton()),
      ),
    );
    await tester.pump();

    expect(find.text('Sign Out'), findsOneWidget);

    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();

    expect(find.text('Log In'), findsOneWidget);
    expect(AuthRepository.instance.getCurrentUser(), isNull);
  });
}
