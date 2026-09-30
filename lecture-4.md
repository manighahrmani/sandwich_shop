# Lecture 4 — Unit and Widget Testing

> This mirrors `lecture-4.pptx`. Slides are minimal; detail lives in the worksheets and in what I say when each slide is shown. Update this file whenever the deck changes.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 4:

- Why automated testing matters
- Unit testing
- Widget testing

---

## Why automated testing matters — tech news

I need tech news from you! I will provide some of my own.

- Flutter testing overview: [docs.flutter.dev/testing/overview](https://docs.flutter.dev/testing/overview)
- Dart testing library: [pub.dev/packages/test](https://pub.dev/packages/test)
- Widget of the Week — Golden tests: [youtube.com/playlist](https://youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)

---

## Why automated testing matters

- Manual testing is slow and error-prone. You click through the app, check the screen, and repeat after every change.
- Automated tests run in seconds and catch regressions before they reach users.
- Tests document expected behaviour: a new team member reads the tests to understand what the code should do.
- The testing pyramid: many fast unit tests at the base, fewer widget tests in the middle, very few integration tests at the top.

---

## Unit testing

- A unit test exercises a single function, method, or class in isolation.
- No Flutter widgets, no UI rendering, no device needed.
- Use the `test` package: `test()`, `expect()`, matchers like `equals`, `isTrue`, `throwsA`.
- Group related tests with `group()` for readability.
- Good tests are independent, repeatable, and fast.

---

## Unit testing — what to test

- Model property assignment and computed getters (for example a formatted price).
- Repository methods returning the expected data.
- Edge cases: empty lists, null-safe fields, boundary values.
- Do not test Flutter framework code or third-party packages; test your own logic.

---

## Widget testing

- A widget test renders a widget in a test environment and verifies its behaviour.
- Use `testWidgets()`, `WidgetTester`, and finders like `find.text()`, `find.byType()`.
- `pumpWidget()` builds the widget tree; `pump()` triggers a rebuild after state changes.
- `tester.tap()` simulates user interaction; follow it with `pump()` to see the result.

---

## Widget testing — what to test

- Does the widget display the correct text and icons for a given model?
- Does tapping a button update the UI as expected?
- Does navigation push the right screen when a list item is tapped?
- Keep widget tests focused on one behaviour per test.

---

## Demo 2 (footnote)

- Union of Worksheet 3 and Worksheet 4 exercises: home view with movie cards and navigation to dynamic listing. Also unit tests and widget tests covering almost all of your codebase.
- Demonstrate in your own timetabled practical session.
- You can only do one demo in each window.
- More information on the web page: [manighahrmani.github.io/sandwich_shop](https://manighahrmani.github.io/sandwich_shop/)

---

## Module feedback

Give us your feedback, comments, criticisms, or insults by filling out the following form.

- It is anonymous; you need to sign in with your student account, but your details are not recorded.
- Use this link or the QR code: [forms.cloud.microsoft/e/88jd4UGAui](https://forms.cloud.microsoft/e/88jd4UGAui)

---

## Live demo guide (for the lecturer)

Run this live during the lecture to teach Git merge conflict resolution. This continues from the branching and merging demo in Lecture 3 and is a skill students will use repeatedly in team projects and placements. Do not mention the coursework or Southsea Cinema here; that is a footnote at the end.

### Setup

1. Create a fresh throwaway repository (or reuse the one from the Lecture 3 demo):

    ```bash
    mkdir conflict-demo && cd conflict-demo
    git init
    echo "line 1: hello" > greeting.txt
    git add greeting.txt
    git commit -m "docs: add greeting"
    ```

### Part 1 — Creating a conflict

1. Create a branch called `experiment` and change the file on it:

    ```bash
    git checkout -b experiment
    echo "line 1: hello from experiment" > greeting.txt
    git add greeting.txt
    git commit -m "feat: update greeting on experiment"
    ```

2. Switch back to `main` and make a different change to the same line:

    ```bash
    git checkout main
    echo "line 1: hello from main" > greeting.txt
    git add greeting.txt
    git commit -m "feat: update greeting on main"
    ```

3. Attempt to merge:

    ```bash
    git merge experiment
    ```

4. Git reports a merge conflict. Show `git status` to highlight the conflicted file.

### Part 2 — Resolving the conflict in VS Code

1. Open the conflicted file in VS Code. Show the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).

2. VS Code shows inline buttons: **Accept Current Change**, **Accept Incoming Change**, **Accept Both Changes**. Walk through what each option does.

3. Choose a resolution (for example accept both and edit the result), save the file, then:

    ```bash
    git add greeting.txt
    git commit -m "fix: resolve greeting conflict"
    ```

4. Show the clean log:

    ```bash
    git log --oneline --graph --all
    ```

### Part 3 — Avoiding conflicts in practice

1. Pull before you push. Fetch and merge (or rebase) regularly.
2. Keep branches short-lived. Merge back to `main` often.
3. Communicate with your team about who is working on which files.
4. Use meaningful commit messages so the merge history is readable.

### Wrap-up

- Conflicts are normal and not something to fear. They happen when two people (or two branches) edit the same line.
- The tooling in VS Code makes resolution straightforward.
- Encourage students to deliberately create a conflict in a throwaway repository to practise before it happens in their coursework.
