# Worksheet 10 — Integration testing and CI/CD

<!-- DRAFT: outline only. The integration testing section was moved here from Worksheet 8. Replace the TODO comments with prose, code and screenshots, then check them against branch 10. -->

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 9](#continue-from-worksheet-9)
- [Integration testing](#integration-testing)
  - [Set up the package](#set-up-the-package)
  - [Plan a journey](#plan-a-journey)
  - [Run on the emulator](#run-on-the-emulator)
- [Continuous integration](#continuous-integration)
  - [What CI and CD mean](#what-ci-and-cd-mean)
  - [Create a workflow](#create-a-workflow)
  - [Read the results](#read-the-results)
  - [Add integration tests](#add-integration-tests)
- [Deployment](#deployment)
- [Exercises](#exercises)

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

### Continue from Worksheet 9

Continue with your Sandwich Shop app from [Worksheet 9](worksheet-9.md). Run `flutter test` once before making changes, so that you can tell existing failures apart from problems you introduce.

<!-- TODO: add the clone and switch commands for branch 9, as in Worksheet 8. -->

## Integration testing

An integration test runs a complete journey in the real app on a device. Unlike the in-memory unit and widget tests you wrote in [Worksheet 8](worksheet-8.md#test-coverage), it can exercise Android plugins and the emulator's SQLite file. The [Flutter integration testing guide](https://docs.flutter.dev/testing/integration-tests) explains the setup.

### Set up the package

Add `integration_test` from the Flutter SDK under the existing `dev_dependencies` in `pubspec.yaml`. Keep the other dependencies:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
```

Run `flutter pub get` after this dependency change. Put device tests in `integration_test`, separate from `test`. An ordinary `flutter test` run does not run that directory.

`IntegrationTestWidgetsFlutterBinding.ensureInitialized()` prepares the device test runner. You can start with this small check in `integration_test/app_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('the menu opens', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Footlong Sub'), findsOneWidget);
  });
}
```

The import's `as app` gives the application code a name so we can call its `main` separately from the test's `main`. `app.main()` starts the real application.

`pumpAndSettle` lets pending frames finish; it does not guarantee that every database or preference operation has completed. Check that the expected screen is ready. It can time out if the app has an animation that never stops; investigate that condition instead of blindly increasing waits.

<!-- TODO: check this snippet against branch 10, because the app now loads the menu from a web service. -->

### Plan a journey

Our task is to check a purchase from selection to saved history. Perform the journey manually first and decide which observations would prove it worked. Then write your own prompt with the relevant screens, test setup and device id, and ask Copilot to plan the test before writing it, just as [Plan first](worksheet-8.md#plan-first) recommended.

Read its finders and assertions. The order quantity starts at 0, so the test must increase it before adding to the basket. A generic **Order** finder can match several buttons; use a stable key or a finder scoped to the intended card.

Check that the test proves a new order was saved with the chosen item and correct total, and that the basket is empty afterwards. Seeded orders must not satisfy its assertions. The emulator retains data between runs, so do not assume that a fixed order number will always be new. Reading the next order number before checkout and then looking for that exact order is one useful check, but combine it with the expected content and basket state.

Use real taps and scrolling where needed, not direct calls that bypass the UI. When the test fails, distinguish a wrong finder or timing problem from a real application bug. Do not remove assertions or alter the app's behaviour just to get a green result.

### Run on the emulator

Start your emulator and get its id with `flutter devices`. Run the selected file, replacing `emulator-5554` if your device has a different id:

```bash
flutter test integration_test/app_test.dart -d emulator-5554
```

Let Copilot run this command after you approve it and watch the journey on the emulator. If it fails, supply the error and the screen where it stopped, then review the proposed correction.

Use a test installation with invented data. Do not let an agent erase the database to make its assumptions pass. Verify persistence separately with a full close and reopen; a navigation test alone does not prove restart persistence.

Keep a few integration tests for important journeys. They are slower than unit and widget tests and are not included in the coverage report from `flutter test --coverage`.

<!-- Capture: the emulator showing the saved purchase after the integration test completes checkout. -->
![The emulator displaying the saved purchase after the integration test completes checkout](images/10/integration_test_checkout.png)

## Continuous integration

### What CI and CD mean

<!-- TODO: explain continuous integration (every push builds and tests the code automatically) and continuous delivery or deployment (every passing change can be released). Use the idea that the checks students run by hand, dart format, dart analyze and flutter test, become an automatic gate. -->

### Create a workflow

<!-- TODO: add .github/workflows/tests.yml for the Sandwich Shop. Starting point:

name: Tests
on:
  push:
    branches: [main]
  pull_request:
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true
      - run: flutter pub get
      - run: dart format --output=none --set-exit-if-changed lib test
      - run: dart analyze
      - run: flutter test --coverage

Pin the action versions as the module repository does, and explain every line.
-->

### Read the results

<!-- TODO: show the Actions tab, a passing run, a failing run and how to read the log. Add a coverage summary step and upload lcov.info as an artifact. -->

### Add integration tests

<!-- TODO: decide whether to run integration_test in CI with an Android emulator action, or keep it as a local check because it is slow. -->

## Deployment

<!-- TODO: build a release APK with flutter build apk, explain signing at a high level, and decide whether deployment to a store or hosting service is in scope. -->

## Exercises

The exercises below are optional extension tasks and are not assessed in Demo 5. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw).

<!-- TODO: write numbered exercises. Suggested outline:
1. (Advanced) Add the integration_test package to the cinema app and ask Copilot to develop an end-to-end test for booking a cinema ticket. Run it on the emulator and verify that the booking reaches history and the basket is cleared.
2. Add a GitHub Actions workflow to the cinema repository that formats, analyses and tests the app with coverage.
3. Build a release APK.
-->
