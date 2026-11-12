# Lecture 8 — AI-Assisted Development, Debugging and Coverage

> This mirrors `finalised_lectures/lecture-8.pptx`. Slides are minimal; detail lives in Worksheet 8 and in what I say when each slide is shown. Update this file whenever the deck changes.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 8:

- AI-assisted development
- Debugging
- Test coverage

---

## AI-assisted development — tech news

Got tech news? Share it on Discord.

- Microsoft Imagine Cup:
  - Global student technology competition for software and AI projects: [imaginecup.microsoft.com](https://imaginecup.microsoft.com)
- Model Context Protocol:
  - Open standard connecting AI coding assistants directly to development tools and databases: [modelcontextprotocol.io](https://modelcontextprotocol.io)

---

## AI-assisted development — using Copilot effectively

- Copilot assists with repetitive code, boilerplate, syntax fixes, and test cases.
- It does not replace software architecture knowledge or code review.
- Inline suggestions predict the next few tokens or lines as you write code.
- Copilot Chat explains code, plans multi-step edits, and refactors logic.
- Learn more in GitHub's guide: [Best practices for using GitHub Copilot](https://docs.github.com/en/copilot/get-started/best-practices)

---

## AI-assisted development — prompt and context

- Output quality depends directly on the context provided.
- Keep relevant files open in the editor; close unrelated files to prevent context dilution.
- In Copilot Chat, reference exact files with `#file` or highlight specific code.
- State requirements explicitly: naming conventions, architecture patterns, and constraints.
- Treat generated code as untrusted input: verify logic, review diffs, and run automated tests.

---

## Debugging — automated tests vs debugging

- Automated tests verify expected behaviour; they do not always explain why a failure occurred.
- Interactive debugging lets you inspect running state step by step.
- Print statements are temporary and clutter source code.
- Breakpoints pause execution before a line runs, letting you inspect variables in memory.
- More detail: [Debugging Flutter apps programmatically](https://docs.flutter.dev/testing/debugging)

---

## Debugging — breakpoints and inspection

- Set a breakpoint by clicking in the gutter next to a line number in VS Code.
- Start debugging with **F5** (or **Debug: Start Debugging**).
- Stepping through paused code:
  - Step Over (**F10**): execute the current line and advance to the next line.
  - Step Into (**F11**): follow execution inside the called function.
  - Step Out (**Shift + F11**): finish the current function and return to the caller.
- Inspect variables in the **Variables** pane or evaluate expressions in the `Debug Console`.

---

## Debugging — Flutter DevTools and layout issues

- Open the Flutter DevTools suite from the VS Code status bar or Command Palette.
- The Flutter Inspector visualises the widget tree in real time.
- **Select Widget Mode** highlights a widget on the device when selected in the tree.
- **Layout Explorer** visualises flex containers (`Row`, `Column`) and constraint bounds.
- Yellow and black hazard stripes indicate a render flex overflow where content exceeds available space.

---

## Test coverage — measuring automated tests

- Test coverage measures the proportion of code executed while running automated tests.
- Run tests and export an LCOV trace file:

```bash
flutter test --coverage
```

- Line execution data is written to `coverage/lcov.info`.
- Automated pipelines and teams use coverage metrics to discover untested logic.
- Learn more in the Flutter guide: [Testing Flutter apps](https://docs.flutter.dev/testing/overview)

---

## Test coverage — visualising coverage in VS Code

- The Flutter Coverage extension parses `coverage/lcov.info` directly inside the editor.
- The status bar displays overall line coverage and opens the file coverage tree.
- Gutter indicators highlight covered lines in green and untested branches in red.
- Focus test effort on models, calculations, database queries and state logic.
- Extension details: [Flutter Coverage](https://open-vsx.org/vscode/item?itemName=Flutterando.flutter-coverage)

---

## Test coverage — limitations and verification

- High coverage means lines ran; it does not guarantee that tests assert correctness.
- A test without an `expect` still marks lines green in coverage reports.
- Verify tests catch bugs: deliberately break a calculation or database query.
- Running tests against broken code must produce an immediate test failure.
- Coverage highlights blind spots, but meaningful assertions protect against regressions.

---

## Demo 4 (footnote)

- Union of Worksheet 7 and Worksheet 8 exercises: SQLite bookings, past bookings, tests and working with AI.
- Test coverage and a `test` folder that mirrors `lib` carry a significant portion of the marks.
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

Run this live during the lecture using the Sandwich Shop repository on branch 7. The demo illustrates prompt crafting with Copilot, discovering and diagnosing a flex layout overflow, setting breakpoints in VS Code, and generating test coverage.

### Setup

1. Open the Sandwich Shop project in VS Code on branch 7:

    ```bash
    git checkout 7
    flutter pub get
    ```

2. Start the Android emulator and launch the app with **F5**.

### Part 1 — Generating a subtotal with Copilot Chat

1. Open `lib/screens/order_screen.dart`.
2. Open Copilot Chat (**Ctrl + Shift + I** on Windows or **⌘ + Shift + I** on macOS).
3. Ask Copilot to add an order subtotal row above the **Add to Basket** button.
4. Review the generated code with students. Demonstrate two common failure modes:
   - String interpolation arithmetic without expression evaluation: `'£$widget.sandwich.price * _quantity'`.
   - An unconstrained `Row` containing long label text that exceeds the device width.
5. Apply the suggestion into `_OrderScreenState.build` above the `ElevatedButton`:

    ```dart
    Row(
      children: <Widget>[
        Text(
          'Current order subtotal for ${widget.sandwich.name}:',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Text(
          '£$widget.sandwich.price * _quantity',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
    ```

6. Save the file. Trigger hot reload and open an item on the emulator.

### Part 2 — Diagnosing the layout overflow and evaluating state

1. Point out the yellow and black hazard stripes on the emulator showing that the row overflowed by 176 pixels.
2. Point out that the subtotal text literally prints `£10.0 * 2` instead of computing the total.
3. Open the `Debug Console` in VS Code to show the runtime flex overflow exception.
4. Open Flutter DevTools (**Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS and select **Flutter: Open DevTools**).
5. In the **Flutter Inspector**, select **Layout Explorer** to show students the unbounded horizontal constraints on the `Row`.
6. Set a gutter breakpoint inside `_incrementQuantity` in `lib/screens/order_screen.dart`.
7. Tap **Add** on the emulator. Execution pauses at the breakpoint.
8. Inspect `_quantity` and `widget.sandwich.price` in the **Variables** pane.

### Part 3 — Applying the fix and running test coverage

1. Stop or resume the debugger.
2. Refactor the subtotal row to use calculated arithmetic and flexible formatting:

    ```dart
    final double subtotal = widget.sandwich.price * _quantity;
    ```

    ```dart
    Text(
      'Subtotal: £${subtotal.toStringAsFixed(2)}',
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    ```

3. Save the file and trigger hot reload. Verify that the subtotal calculates accurately and no layout stripes remain.
4. Switch to the built-in terminal and run automated tests with coverage:

    ```bash
    flutter test --coverage
    ```

5. Point out `coverage/lcov.info` generated in the file explorer, and view coverage gutters using the Flutter Coverage extension.

### Wrap-up notes for the lecturer

- AI suggestions require active review; verify calculations and layout constraints before accepting them.
- Tests confirm expected outcomes, while breakpoints and DevTools pinpoint runtime causes.
- Generate coverage reports regularly to identify untested branches in models and screens.
