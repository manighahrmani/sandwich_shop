import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/widgets/account_button.dart';

void main() {
  testWidgets('AccountButton navigates to /auth when on another route', (
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

    expect(find.byTooltip('Account'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.account_circle_outlined));
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

    await tester.tap(find.byIcon(Icons.account_circle_outlined));
    await tester.pumpAndSettle();

    expect(authBuildCount, 1);
  });

  testWidgets('AccountButton navigates from an unnamed route', (
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

    await tester.tap(find.byIcon(Icons.account_circle_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Auth Page'), findsOneWidget);
  });
}
