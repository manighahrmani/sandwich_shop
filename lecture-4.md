# Lecture 4 — Unit and Widget Testing

> This mirrors `lecture-4.pptx`. Slides are minimal; detail lives in the worksheets and in what I say when each slide is shown. Update this file whenever the deck changes.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 4:

- Automated testing
- Unit testing
- Widget testing

---

## Automated testing — tech news

I need tech news from you! I will provide some of my own.

- Become a Course Representative:
  - Represent your cohort's voice in school meetings to shape teaching and assessment.
  - Gain CV-ready experience in leadership, advocacy, and public speaking through Students' Union training.
  - Open across undergraduate and postgraduate cohorts; contact your course leader via the [staff directory](https://soc.port.ac.uk/staff/) (Computer Science students can contact their course leader directly), or register on the [Portsmouth Students' Union Course Rep Portal](https://upsu.net/course-reps/become-a-course-rep).
- Santander Brighter Futures Grants:
  - Ten University of Portsmouth students will each receive a £1,000 cash grant to spend freely on rent, bills, or study materials.
  - Open to all current undergraduate and postgraduate students (aged 18+, no Santander account required); 5-minute application.
  - Applications close 3 December 2026; apply on the [Santander Open Academy](https://app.santanderopenacademy.com/en/program/santander-brighter-futures-grants-2026), or read more on [MyPort](https://myport.port.ac.uk/my-course/careers-support/santander-universities-partnership).

---

## Automated testing

- Manual testing, testing an application by hand, is slow and error-prone.
- You click through the app, check the screen, and repeat after every change.
- Automated tests run in seconds and, if they are designed well, can catch bugs early on.
- Tests also document expected behaviour: a new team member reads the tests to understand what the code should do.
- (That is in addition to documentation which we will learn about later.)

---

## Testing strategies

- The testing pyramid: many fast unit tests at the base, fewer widget tests in the middle, very few integration tests at the top.
- Release and application tests correspond to integration tests on builds (more on this later).
- Feature and component testing correspond to widget testing in Flutter.
- We will learn about unit and widget testing now.
- Image source: "Testing strategies", Android Developers, Google. Available at: [developer.android.com/training/testing/fundamentals/strategies](https://developer.android.com/training/testing/fundamentals/strategies)

---

## Integration testing

- Integration tests verify how multiple units work together or test the full application on a real device or browser.
- Simulates complete user journeys end-to-end, such as navigating screens, submitting forms, and saving data.
- Slower than unit and widget tests, but provides the highest confidence before releasing.
- We will cover it later, but for more info on integration testing, check the documentation: [docs.flutter.dev/testing/integration-tests](https://docs.flutter.dev/testing/integration-tests)

---

## Test coverage

- Test coverage measures the proportion of your codebase executed while running automated tests.
- Helps identify untested branches, missing edge cases, and dead code.
- Run `flutter test --coverage` to generate coverage data in `coverage/lcov.info`.
- Visualise coverage directly in your editor using coverage extensions.

---

## Unit testing

- A unit test exercises a single function, method, or class in isolation.
- No Flutter widgets, no UI rendering, no device needed.
- Use the `test` package: `test()`, `expect()`, matchers like `equals`, `isTrue`, `throwsA`.
- See examples here: [pub.dev/packages/test](https://pub.dev/packages/test)
- Group related tests with `group()` for readability.
- Also group related tests into a file (ideally a test file corresponding to a unit).
- Good tests are independent, repeatable, and fast.

---

## Widget testing

- A widget test renders a widget in a test environment and verifies its behaviour.
- Use `testWidgets()`, `WidgetTester`, and finders like `find.text()`, `find.byType()`.
- `pumpWidget()` builds the widget tree; `pump()` triggers a rebuild after state changes.
- `tester.tap()` simulates user interaction; follow it with `pump()` to see the result.
- Check the documentation page to learn the basics: [An introduction to widget testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)

---

## Widget testing — behaviours to test

- Does the widget display the correct text and icons for a given model?
- Does tapping a button update the UI as expected?
- Does navigation push the right screen when a list item is tapped?
- Keep widget tests focused on one behaviour per test (they can be grouped into files or groups just like unit tests).

---

## Demo 2 (footnote)

- Union of Worksheet 3 and Worksheet 4 exercises: home view with movie cards and navigation to dynamic listing.
- Also unit tests and widget tests covering almost all of your codebase.
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

1. Conflicts are normal and not something to fear. They happen when two people (or two branches) edit the same line.
2. The tooling in VS Code makes resolution straightforward.
3. Avoiding conflicts in practice:
    - Pull before you push. Fetch and merge (or rebase) regularly.
    - Keep branches short-lived. Merge back to `main` often.
    - Communicate with your team about who is working on which files.
    - Use meaningful commit messages so the merge history is readable.

4. Create a fresh throwaway repository (or reuse the one from the Lecture 3 demo):

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

### Wrap-up

- Conflicts are normal and not something to fear. They happen when two people (or two branches) edit the same line.
- The tooling in VS Code makes resolution straightforward.
- Encourage students to deliberately create a conflict in a throwaway repository to practise before it happens in their coursework.
