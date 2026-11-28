# Lecture 10 — Integration testing and CI/CD

> Draft for `finalised_lectures/lecture-10.pptx`. Slides are minimal; detail lives in Worksheet 10 and in the classroom walkthrough notes at the end.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 10:

- Integration testing
- Continuous integration
- Deployment and releases

---

## Integration testing — beyond unit and widget tests

- In Lecture 4 we saw the testing pyramid: many fast unit tests, focused widget tests, fewer integration tests.
- Integration tests run the full app on a phone, emulator or browser to check that screens, navigation and shared state work together.
- Documentation: [Integration testing](https://docs.flutter.dev/testing/integration-tests)

---

## Integration testing — mocks and fakes

- Testing against live servers or cloud databases is slow, unreliable when the network drops, and can clutter real data.
- Instead, swap them out in tests for in-memory mocks and fakes such as `MockFirebaseAuth` and `FakeFirebaseFirestore` so tests stay fast, offline and repeatable.
- Documentation: [Mock dependencies](https://docs.flutter.dev/cookbook/testing/unit/mocking)

---

## Integration testing — resetting state with UniqueKey

- When two tests run back to back, Flutter may reuse the previous root widget and keep old state from the first test.
- Passing `UniqueKey()` to the root widget inside each test tells Flutter it is a brand-new widget, forcing a fresh widget tree.
- Your app in `lib/` only needs the standard `super.key` parameter; `UniqueKey()` lives in the test file.
- Documentation: [UniqueKey](https://api.flutter.dev/flutter/foundation/UniqueKey-class.html)

```dart
// lib/main.dart — accept a key on the root widget
class CounterApp extends StatefulWidget {
  const CounterApp({super.key});
  // ...
}
```

```dart
// integration_test/app_test.dart — fresh key per test
testWidgets('first test', (WidgetTester tester) async {
  await tester.pumpWidget(CounterApp(key: UniqueKey()));
});

testWidgets('second test', (WidgetTester tester) async {
  await tester.pumpWidget(CounterApp(key: UniqueKey()));
});
```

---

## Integration testing — how Flutter runs them

- Add `integration_test` to `dev_dependencies` and place your tests in an `integration_test/` folder so normal `flutter test` runs stay fast.
- Initialise the integration test binding at the top of the file, find widgets by `Key`, and check the screen just like a widget test.

```dart
IntegrationTestWidgetsFlutterBinding.ensureInitialized();

testWidgets('tapping add increments the counter', (
  WidgetTester tester,
) async {
  await tester.pumpWidget(CounterApp(key: UniqueKey()));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('addButton')));
  await tester.pumpAndSettle();
  expect(find.text('1'), findsOneWidget);
});
```

---

## Integration testing — where tests can run

- On a phone or emulator, run your integration test with `flutter test` and pass the device with `-d`.
- In a web browser, Flutter uses `flutter drive` with ChromeDriver to click through the app automatically.
- You can also run tests on real remote phones in the cloud using [Firebase Test Lab](https://docs.flutter.dev/testing/integration-tests#test-in-firebase-test-lab-android).
- Integration tests do not measure code coverage, so keep tracking coverage with your unit and widget tests.

---

## Continuous integration — automating checks

- It is easy to forget to format, analyse and test your code before pushing.
- Continuous integration (CI) runs those checks automatically on a clean cloud machine whenever you push or open a pull request.
- Continuous deployment (CD) goes one step further and publishes every passing build automatically.
- [GitHub Actions](https://docs.github.com/en/actions) runs these checks for free on public repositories and includes a free monthly allowance for private ones.

---

## Continuous integration — workflows, jobs and steps

- Workflows are YAML files saved in `.github/workflows/` that tell GitHub what to run.
- Triggers (`on`) decide when a workflow starts, such as on a `push`, a `pull_request` or a manual button click.
- Jobs (`jobs`) are groups of tasks that run on a fresh cloud machine, one after another or in parallel.
- Steps (`steps`) are the individual commands or reusable actions inside each job.

---

## Continuous integration — pipelines and branch rules

- Chain jobs into stages: check and test the code first, then build for web and Android in parallel, then deploy.
- Save build outputs (such as test coverage or a web bundle) as workflow artifacts so later jobs or teammates can download them.
- Use GitHub branch rulesets to block pull requests from merging until all required checks pass.

---

## Deployment and releases — automated hosting and secrets

- Never commit API keys or passwords to Git; store them in GitHub repository secrets so workflows can read them safely.
- Firebase can connect directly to GitHub Actions to deploy your web app automatically whenever `main` is updated.
- Pull requests can also get temporary preview links so you can test changes live before merging.

---

## Deployment and releases — GitHub Releases and mobile stores

- Use GitHub **Releases** to tag milestones with version numbers such as `v1.0.0` and share release notes.
- You can attach a built Android APK to a release so testers can download and install it directly on a phone or emulator.
- Publishing to the Play Store or App Store needs signed release builds: see [Android deployment](https://docs.flutter.dev/deployment/android), [iOS deployment](https://docs.flutter.dev/deployment/ios) and [Firebase App Distribution](https://firebase.google.com/docs/app-distribution).

---

## Classroom walkthrough ideas (for the lecturer)

### Example 1 — Minimal GitHub Action with Python

1. Create a small public GitHub repository named `hello-ci` containing two files (`hello.py` and `test_hello.py`):

    ```python
    def greet(name: str) -> str:
        return f"Hello, {name}!"
    ```

    ```python
    import unittest
    from hello import greet


    class TestHello(unittest.TestCase):
        def test_greet(self) -> None:
            self.assertEqual(greet("World"), "Hello, World!")


    if __name__ == "__main__":
        unittest.main()
    ```

2. On GitHub in your browser, open **Actions > New workflow > set up a workflow yourself**, name the file `.github/workflows/ci.yml`, paste the workflow below, and select **Commit changes...**:

    ```yaml
    name: Python CI

    on:
      push:
      pull_request:
      workflow_dispatch:

    jobs:
      test:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v7
          - uses: actions/setup-python@v7
            with:
              python-version: "3.12"
          - name: Run unit tests
            run: python3 -m unittest discover -v
    ```

3. Open the **Actions** tab to watch the green run live, click into `Run unit tests` to inspect the `OK` log, then edit `hello.py` on GitHub to return `f"Hi, {name}!"` so students see the red failure log and how fixing it turns the workflow green again.

### Example 2 — Minimal Flutter integration test, CI/CD and release

1. Create a disposable Flutter counter app locally and run a minimal integration test on an emulator or phone:

    ```bash
    flutter create counter_demo
    cd counter_demo
    flutter pub add "dev:integration_test:{sdk: flutter}"
    ```

2. Add `key: const Key('increment')` to the `FloatingActionButton` in `lib/main.dart`, add `integration_test/app_test.dart` tapping `find.byKey(const Key('increment'))` and checking `'1'`, then run:

    ```bash
    flutter test integration_test/app_test.dart -d <device-id>
    ```

3. Push `counter_demo` to a new GitHub repository, connect a throwaway Spark Hosting site with `firebase init hosting:github` (answering **No** to the build script and **No** to automatic merge deploy), and save the [Flutter CI/CD workflow gist](https://gist.github.com/manighahrmani/0ae8219aca8315f1380b952683e878c4) as `.github/workflows/ci.yml` (replacing the Firebase secret name and project ID with yours).

4. Show the green three-stage pipeline graph in **Actions**, walk through **Settings > Rules > Rulesets** to require those checks on `main`, download `app-debug.apk` from **Artifacts**, publish a `v1.0.0` release under **Releases** with `app-debug.apk` attached, and drag the APK onto a running emulator (or install via `adb install app-debug.apk`).
