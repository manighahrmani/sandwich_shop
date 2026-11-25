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
- Integration tests run the full app on an emulator, physical phone or browser to check screens, routes and shared state together.
- Keep automated tests fast, repeatable and offline with test doubles such as `MockFirebaseAuth` and `FakeFirebaseFirestore`.
- Pass `UniqueKey()` to your root widget so each test starts cleanly without leftover state.
- Documentation: [Integration testing](https://docs.flutter.dev/testing/integration-tests)

---

## Integration testing — how Flutter runs them

- Add `integration_test` under `dev_dependencies` and put test files inside a top-level `integration_test/` folder so `flutter test` stays fast.
- Initialise `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`, label shared widgets with `Key` and reset dependencies in `setUp()` and `tearDown()`.

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

## Integration testing — devices, browsers and test labs

- Emulators and physical Android or iOS devices: run `flutter test integration_test/app_test.dart -d <device-id>`.
- Web browsers: `flutter drive` pairs with `test_driver/integration_test.dart` (`integrationDriver()`) and ChromeDriver on port `4444`.
- Hosted device clouds: [Firebase Test Lab](https://docs.flutter.dev/testing/integration-tests#test-in-firebase-test-lab-android) runs Android or iOS tests on remote devices.
- Keep line coverage (`flutter test --coverage`) measured from `test/`, because integration tests do not record coverage.

---

## Continuous integration — automating checks

- Running `dart format`, `dart analyze` and `flutter test` manually is easy to forget before pushing commits.
- Continuous integration (CI) runs those checks automatically on a clean cloud machine whenever you push code or open a pull request.
- Continuous deployment (CD) takes the next step and publishes every passing build automatically.
- [GitHub Actions](https://docs.github.com/en/actions) gives public repositories free runners and private repositories a free monthly allowance.

---

## Continuous integration — workflows, jobs and steps

- Workflows live as `.yml` files inside `.github/workflows/` using two-space YAML indentation (no tabs), just like `pubspec.yaml`.
- Triggers (`on:`): events that start the workflow, such as `push`, `pull_request`, `workflow_dispatch` (manual **Run workflow** button) or `schedule`.
- Jobs (`jobs:`): tasks executed on clean virtual machines (`runs-on: ubuntu-latest`), ordered with `needs:` when one job depends on another.
- Steps (`steps:`): actions called via `uses:` (such as `actions/checkout@v7` or `subosito/flutter-action@v2`) or shell commands run via `run:`.

---

## Continuous integration — pipelines, matrices and rulesets

- Chain jobs into a clear pipeline: run checks first (`test`), build targets in parallel with a `matrix` (`Build web` and `Build android` with `needs: test`), then deploy.
- Write test metrics to `$GITHUB_STEP_SUMMARY`, attach outputs (`coverage-report`, `app-web`, `app-android`) with `actions/upload-artifact@v7`, and run slow emulator tests locally or on a nightly schedule.
- Protect default branches under **Settings > Rules > Rulesets** by requiring a pull request and passing status checks before merging.

---

## Deployment and releases — automated hosting and secrets

- Never commit API keys or service accounts to Git; store encrypted keys under **Settings > Secrets and variables > Actions** and read them with `${{ secrets.NAME }}`.
- Connect Firebase Hosting with `firebase init hosting:github` to create a service account secret and pull-request preview workflow.
- Add a `deploy` job (`needs: build`) gated to pushes on `main` that downloads `app-web` (`actions/download-artifact@v8`) and deploys live.
- Pull requests receive temporary seven-day preview URLs before anything reaches users on `main`.

---

## Deployment and releases — GitHub Releases and mobile stores

- Tag milestones under **Releases** with semantic versions such as `v1.0.0` (major release, new features, small fixes) and generated release notes.
- Download `app-debug.apk` from CI **Artifacts**, attach it to the release and install it on Android phones or emulators (`adb install app-debug.apk`) for testing.
- Store publishing requires release builds and signing keys: see [Android deployment](https://docs.flutter.dev/deployment/android), [iOS deployment](https://docs.flutter.dev/deployment/ios) and [Firebase App Distribution](https://firebase.google.com/docs/app-distribution).

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

3. Push `counter_demo` to a new GitHub repository, connect a throwaway Spark Hosting site with `firebase init hosting:github` (answering **No** to the build script and **No** to automatic merge deploy), and add `.github/workflows/ci.yml` with three chained jobs:
   - `test`: `actions/checkout@v7`, `subosito/flutter-action@v2`, `flutter pub get`, `dart format --output=none --set-exit-if-changed lib test integration_test`, `dart analyze`, `flutter test --coverage`, and `actions/upload-artifact@v7` (`coverage/lcov.info`).
   - `build` (`needs: test`, `matrix` for `web` and `android` debug APK using `actions/setup-java@v6` and `actions/upload-artifact@v7`).
   - `deploy` (`needs: build`, gated with `if: github.event_name == 'push' && github.ref == 'refs/heads/main'`, using `actions/download-artifact@v8` for `app-web` and `FirebaseExtended/action-hosting-deploy@v0`).
4. Show the green three-stage pipeline graph in **Actions**, walk through **Settings > Rules > Rulesets** to require those checks on `main`, download `app-debug.apk` from **Artifacts**, publish a `v1.0.0` release under **Releases** with `app-debug.apk` attached, and drag the APK onto a running emulator (or install via `adb install app-debug.apk`).
