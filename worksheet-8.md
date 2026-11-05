# Worksheet 8 — Review-Driven Development with AI

## Table of contents

- [Getting started](#getting-started)
  - [Continue from Worksheet 7](#continue-from-worksheet-7)
  - [Clone the Sandwich Shop repository](#clone-the-sandwich-shop-repository)
  - [Switch to branch 7](#switch-to-branch-7)
- [Working with an AI assistant](#working-with-an-ai-assistant)
  - [What employers expect](#what-employers-expect)
  - [Give the assistant context](#give-the-assistant-context)
  - [Explore and plan before changing code](#explore-and-plan-before-changing-code)
  - [Work in small steps](#work-in-small-steps)
  - [Give the assistant a check to run](#give-the-assistant-a-check-to-run)
  - [Review and understand every change](#review-and-understand-every-change)
  - [Keep learning while you use AI](#keep-learning-while-you-use-ai)
  - [Use AI responsibly and sustainably](#use-ai-responsibly-and-sustainably)
- [Introducing GitHub Copilot and workspace context](#introducing-github-copilot-and-workspace-context)
  - [Understanding workspace context and chat participants](#understanding-workspace-context-and-chat-participants)
  - [Crafting bounded and specific prompts](#crafting-bounded-and-specific-prompts)
- [Connecting external tools with Model Context Protocol](#connecting-external-tools-with-model-context-protocol)
  - [What is Model Context Protocol](#what-is-model-context-protocol)
  - [Configuring Dart and GitHub MCP servers in VS Code](#configuring-dart-and-github-mcp-servers-in-vs-code)
  - [Using MCP tools for repository queries and diagnostics](#using-mcp-tools-for-repository-queries-and-diagnostics)
- [Generating project documentation with AI](#generating-project-documentation-with-ai)
  - [Supplying context files for a repository README](#supplying-context-files-for-a-repository-readme)
  - [Reviewing and auditing AI-generated text](#reviewing-and-auditing-ai-generated-text)
- [Implementing dark mode with saved preferences](#implementing-dark-mode-with-saved-preferences)
  - [Prompting Copilot for theme mode persistence](#prompting-copilot-for-theme-mode-persistence)
  - [Reviewing inline diffs and code suggestions](#reviewing-inline-diffs-and-code-suggestions)
  - [Verifying runtime behaviour and test suites](#verifying-runtime-behaviour-and-test-suites)
- [Adding a feature test first](#adding-a-feature-test-first)
  - [Writing a failing test](#writing-a-failing-test)
  - [Asking Copilot to make the test pass](#asking-copilot-to-make-the-test-pass)
- [Storing order items in a related table](#storing-order-items-in-a-related-table)
  - [Why one summary string is not enough](#why-one-summary-string-is-not-enough)
  - [Designing the order items table](#designing-the-order-items-table)
  - [Upgrading an existing database](#upgrading-an-existing-database)
  - [Letting Copilot carry out the change](#letting-copilot-carry-out-the-change)
- [Auditing tests and checking coverage](#auditing-tests-and-checking-coverage)
  - [Auditing tests against false positives and weak assertions](#auditing-tests-against-false-positives-and-weak-assertions)
  - [Inspecting test coverage](#inspecting-test-coverage)
- [End-to-end integration testing with AI](#end-to-end-integration-testing-with-ai)
  - [Setting up the Flutter integration test package](#setting-up-the-flutter-integration-test-package)
  - [Prompting Copilot for complete user flow integration tests](#prompting-copilot-for-complete-user-flow-integration-tests)
  - [Running integration tests on the Android emulator](#running-integration-tests-on-the-android-emulator)
- [Exercises](#exercises)

## Getting started

### Continue from Worksheet 7

<!-- TODO: Instruct students to continue from their branch after Worksheet 7 (SQLite orders persistence and mirrored test structure). -->

### Clone the Sandwich Shop repository

<!-- TODO: Standard fallback cloning instructions for students starting fresh. -->

### Switch to branch 7

<!-- TODO: Command to check out branch 7 (`git checkout 7`). -->

## Working with an AI assistant

<!-- TODO: Introduce one workflow that the official guidance from GitHub, Anthropic, OpenAI and Google agrees on, rather than a list of named "styles". Each later section of this worksheet practises one or more of the steps below and should link back to it. Sources to cite and link:
- GitHub Docs, Best practices for using GitHub Copilot: https://docs.github.com/copilot/get-started/best-practices-for-using-github-copilot
- GitHub Docs, Prompt engineering for GitHub Copilot Chat: https://docs.github.com/en/copilot/concepts/prompting-and-context/prompt-engineering
- Claude Code Docs, Best practices: https://code.claude.com/docs/en/best-practices
- OpenAI Cookbook, Iterating development workflows with Codex: https://developers.openai.com/cookbook/examples/codex/iterating-development-workflows-with-codex
- Google DORA, State of AI-assisted Software Development 2025 and the DORA AI Capabilities Model: https://dora.dev/research/2025/dora-report/
- Anthropic, How AI assistance impacts the formation of coding skills (2026): https://www.anthropic.com/research/AI-assistance-coding-skills
- Google Cloud, Measuring the environmental impact of AI inference (2025): https://cloud.google.com/blog/products/infrastructure/measuring-the-environmental-impact-of-ai-inference -->

### What employers expect

<!-- TODO: DORA 2025 (nearly 5,000 professionals): about 90% use AI at work, yet about 30% report little or no trust in AI-generated code. Its key finding is that "AI is an amplifier": it magnifies good engineering practice and bad practice alike. Two of its seven AI capabilities are strong version control and working in small batches, which students already practise. Employers want graduates who can direct an assistant and judge its output, not graduates who can only prompt. -->

### Give the assistant context

<!-- TODO: The assistant only knows what it can see. Name the files, the goal and the constraints (GitHub: "be specific about your requirements", "provide examples"). Keep durable project rules in a repository instructions file such as `.github/copilot-instructions.md` or `AGENTS.md` (for example: verbose Dart, no arrow syntax, squared buttons, test folders mirror lib). Practised in "Introducing GitHub Copilot and workspace context" and "Connecting external tools with Model Context Protocol". -->

### Explore and plan before changing code

<!-- TODO: Claude Code, Codex and Copilot all recommend a read-only exploration and an agreed plan before edits for anything larger than a one-line fix (Copilot's Plan agent, Claude's plan mode, Codex's read-only preflight). Ask the assistant to explain the relevant code and propose a plan, then correct the plan before any file changes. Practised in "Storing order items in a related table". -->

### Work in small steps

<!-- TODO: Break a large task into small, separately verifiable steps (GitHub: "break down complex tasks"; DORA: working in small batches). Commit after each reviewed step so `git diff` shows only the next change and any step can be undone. This is also what makes large, repetitive changes (renaming a field everywhere, adding a table and updating every test) safe to hand to an assistant. -->

### Give the assistant a check to run

<!-- TODO: Claude Code's docs: "give Claude a check to run". The strongest check is a test written first: write or ask for a test of the wanted behaviour, run it and watch it fail, commit it, then ask the assistant to make it pass without editing the test (test-driven development). `dart analyze`, `dart format` and `flutter test` are checks the assistant can run after every change. Practised in "Adding a feature test first". -->

### Review and understand every change

<!-- TODO: GitHub: "Understand suggested code before you implement it" and "Review Copilot's suggestions carefully", considering functionality, security, readability and maintainability. Read every line of the diff as you would a colleague's pull request, reject edits you did not ask for, run the checks, and try the feature in the running app. You are responsible for any code you commit, whoever wrote it. Practised in "Reviewing inline diffs and code suggestions" and "Auditing tests and checking coverage". -->

### Keep learning while you use AI

<!-- TODO: Anthropic's 2026 randomised trial found that developers who handed a new task fully to AI understood the code less well and were worse at reading and debugging it, with no significant time saving on average. Those who asked for explanations and conceptual help kept their learning. For students: use AI to explain and to check your thinking, write the first attempt yourself when learning something new, and make sure you can explain every line in your demo. -->

### Use AI responsibly and sustainably

<!-- TODO: Short guidance:
- Never paste secrets, personal data or other people's private code into an assistant; check what your tool sends and stores.
- Follow the university's academic integrity rules and say where you used AI.
- Each prompt has a small energy and water cost (Google estimates about 0.24 Wh for a median Gemini text prompt in 2025), and long agent runs use many prompts. Prefer focused prompts, a smaller model for simple tasks, and your own knowledge for things you already know. -->

## Introducing GitHub Copilot and workspace context

### Understanding workspace context and chat participants

<!-- TODO: Introduce GitHub Copilot Chat in VS Code.
- Explain `@workspace` participant and `#file` / `#folder` context references.
- Explain why AI without repository context produces generic or hallucinated code.
- Contrast naive copy-paste prompting with context-aware pair programming. -->

### Crafting bounded and specific prompts

<!-- TODO: Teach the anatomy of an effective coding prompt:
- State the goal, the exact files involved, and architectural constraints (e.g. stateful vs stateless, existing theme constants).
- Remind students to prompt for small, incremental steps rather than asking the AI to write entire screens at once. -->

## Connecting external tools with Model Context Protocol

### What is Model Context Protocol

<!-- TODO: Introduce Model Context Protocol (MCP):
- Explain MCP as an open standard enabling AI assistants to securely connect to external tools, databases, and development environments.
- Contrast static LLM training data with real-time, tool-assisted grounding. -->

### Configuring Dart and GitHub MCP servers in VS Code

<!-- TODO: Setup guide for MCP in VS Code:
- Introduce `.vscode/mcp.json` configuration for MCP servers.
- Dart / Flutter MCP: exposes analyzer diagnostics, symbol outlines, and documentation lookup.
- GitHub MCP: enables querying issues, PRs, commit logs, and repository metadata directly from Copilot Chat.
- Optional SQLite MCP: querying local tables and schemas directly from the chat interface. -->

### Using MCP tools for repository queries and diagnostics

<!-- TODO: Hands-on examples using MCP tools in Copilot:
- Asking Copilot to fetch current analyser warnings using Dart MCP.
- Asking Copilot to check recent commit messages and diffs via GitHub MCP. -->

## Generating project documentation with AI

### Supplying context files for a repository README

<!-- TODO: Initial exercise on documentation:
- Prompt Copilot to draft a comprehensive README.md for the Sandwich Shop project.
- Reference pubspec.yaml, main.dart, and feature folders to give the model full context. -->

### Reviewing and auditing AI-generated text

<!-- TODO: Reviewing documentation output:
- Identify inaccuracies, missing setup steps, or hallucinated commands.
- Edit and refine the generated markdown to adhere to project realities. -->

## Implementing dark mode with saved preferences

### Prompting Copilot for theme mode persistence

<!-- TODO: Real feature development:
- Add a theme mode toggle (light/dark) to the settings screen.
- Persist the chosen mode in `shared_preferences` alongside existing user settings.
- Guide students on prompting Copilot with existing `settings_screen.dart` and `constants.dart` context. -->

### Reviewing inline diffs and code suggestions

<!-- TODO: Review-Driven Development (RDD) core discipline:
- Using VS Code inline diff viewer to inspect every suggested modification line by line.
- Checking for regressions, unwanted styling changes, or anti-patterns (e.g. unhandled nulls, arrow functions where blocks are preferred). -->

### Verifying runtime behaviour and test suites

<!-- TODO: Physical verification:
- Running `dart format lib test` and `dart analyze`.
- Running `flutter test` to ensure existing regression tests pass.
- Verifying the toggle in the running emulator and testing persistence across app restarts. -->

## Adding a feature test first

This section practises [giving the assistant a check to run](#give-the-assistant-a-check-to-run).

### Writing a failing test

<!-- TODO: Sandwich Shop checkout already handles a failed save (Worksheet 7, "Test that a failed save keeps the basket"), so use a new small feature here, for example showing the total spent across all saved orders on the orders page.
- Write the widget test first in `test/screens/orders_screen_test.dart` with two saved orders and an expected "Total spent: £..." text.
- Run `flutter test` and watch the new test fail for the right reason (the text is missing), not because of a typo or a missing import.
- Commit the failing test so the next diff shows only the change to `lib/`. -->

### Asking Copilot to make the test pass

<!-- TODO: Prompt Copilot with the test file and `orders_screen.dart`: make this test pass without changing the test.
- Review the diff: reject any edit to the test itself, any new package and any unrelated styling change.
- Run the whole suite, then check the orders page on the emulator. -->

## Storing order items in a related table

This section practises [planning first](#explore-and-plan-before-changing-code) and [working in small steps](#work-in-small-steps) on a large change, with review at every stage.

### Why one summary string is not enough

<!-- TODO: Worksheet 7 flattens each order into a summary string such as "2 x Veggie Delight, 1 x Chicken Teriyaki". Show what cannot be done easily with that string: count how many of one sandwich were sold, change a sandwich name, or rebuild the basket from an old order. Each value would have to be cut out of text. -->

### Designing the order items table

<!-- TODO: Introduce a second table, `order_items`, with one row per basket line: `id`, `order_id`, `sandwich_name`, `size`, `bread`, `quantity` and `line_total`.
- Explain the one-to-many relationship: one order has many items.
- Explain the foreign key `order_id REFERENCES orders(id)` and turning foreign keys on with `PRAGMA foreign_keys = ON` in `onConfigure`.
- Show a short JOIN or a second query that reads the items of one order. Keep the `summary` column so the orders page still works while the change is in progress. -->

### Upgrading an existing database

<!-- TODO: Explain why `onCreate` does not run again on a phone that already has version 1 of the database, so the new table would never appear.
- Raise `version` to 2 and add `onUpgrade`, which creates `order_items` when `oldVersion` is less than 2. New installs create both tables in `onCreate`.
- Check both paths: a fresh install and an upgrade from the Worksheet 7 app with saved orders that must survive.
- Mention that uninstalling the app also works during development but deletes the user's orders, so it is not a fix for real users. -->

### Letting Copilot carry out the change

<!-- TODO: Plan, then ask for the change in stages with a commit after each:
1. Model: add an `OrderItem` class with `toMap` and `fromMap` and its unit tests.
2. Database: create the table, `onUpgrade`, insert an order and its items together in one transaction, and read them back; in-memory tests for each.
3. Screens and widget tests: save the items at checkout and show them on the orders page.
- Review each diff before moving on; run `dart analyze` and `flutter test` at every stage. -->

## Auditing tests and checking coverage

### Auditing tests against false positives and weak assertions

<!-- TODO: Critical test audit of AI-written tests:
- Watch out for tautological assertions (tests that always pass regardless of implementation).
- Verify assertions check real UI state, not just `findsOneWidget` on generic containers.
- Break the code on purpose and confirm that the test fails. -->

### Inspecting test coverage

<!-- Note: The lecturer will demonstrate how to use AI pair-programming to achieve near-complete test coverage across the application, visualised with test coverage tools. -->

<!-- Technical guidance notes for drafting this section:
- Scope: Coverage is introduced here in Worksheet 8, NOT in Worksheet 7.
- Explain that coverage shows which lines ran during the tests, not whether the assertions are strong. 100% coverage with weak tests can still miss bugs.
- CLI generation: Run `flutter test --coverage` in the terminal to produce the LCOV trace file at `coverage/lcov.info`.
- Extension and UI realities (do not instruct false UI actions):
  * No gutter decorations: `Flutterando.flutter-coverage` does NOT render green or red gutter decorations in the editor margin (gutter line decorations require the Coverage Gutters extension).
  * No watch command or status bar: There is no `Flutter Coverage: Watch` command in the Command Palette and no coverage percentage item in the status bar.
  * Side bar panel behaviour: The "Flutter Coverage" section in the Testing side bar often does not automatically parse or display the tree on Windows after running tests in the terminal, and clicking the standard "play" button runs tests through the Dart test runner without passing `--coverage`.
  * Before drafting student instructions, verify the exact visualisation method (such as inspecting `coverage/lcov.info` directly or testing the extension configuration).
- Review: Review uncovered branches and use AI pair-programming to generate targeted tests across models, repositories, database helpers and screens. -->

## End-to-end integration testing with AI

### Setting up the Flutter integration test package

<!-- TODO: Introduce integration_test:
- Contrast widget tests (isolated, simulated clock) with integration tests (running on actual Android emulator or device).
- Add `integration_test` to `dev_dependencies` in `pubspec.yaml`.
- Create `integration_test/app_test.dart` entry point with `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`. -->

### Prompting Copilot for complete user flow integration tests

<!-- TODO: Prompting Copilot for end-to-end flows:
- End-to-end journey: launch app -> select sandwich -> add to basket -> checkout -> verify order appears in SQLite history -> toggle dark mode in settings.
- Guide Copilot to use real UI taps (`tester.tap`), scrolling (`tester.scrollUntilVisible`), and waiting for animations (`tester.pumpAndSettle`). -->

### Running integration tests on the Android emulator

<!-- TODO: Running integration tests:
- Command: `flutter test integration_test/app_test.dart -d <emulator-id>`.
- Observing the automated execution live on the Android emulator screen.
- Debugging timing issues and test timeouts. -->

## Exercises

The exercises below apply these ways of working to your Southsea Cinema coursework. Together with the exercises in Worksheet 7, they prepare you for Demo 4. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw).

<!-- TODO: Draft exercises. They match the Demo 4 Worksheet 8 items in the sign-off app (func_ai_readme, func_dark_mode, func_failed_checkout_tdd, func_relational_bookings, func_integration_test and the coverage quality item). Shorten and link the sections once they are written, as in Worksheet 7. -->

1. Use Copilot to write a `README.md` for your cinema app, as in [Generating project documentation with AI](#generating-project-documentation-with-ai). Check every setup step and command against your project before you commit it.

2. Add a dark mode switch to your settings page that is saved with `SharedPreferencesAsync` and applied when the app starts, as in [Implementing dark mode with saved preferences](#implementing-dark-mode-with-saved-preferences). Keep your squared buttons and theme constants, and check that the choice survives a full restart.

3. Your cinema checkout does not yet handle a failed save. Write a widget test first that makes saving fail, as in [Test that a failed save keeps the basket](worksheet-7.md#test-that-a-failed-save-keeps-the-basket) from Worksheet 7, and check that it fails. Then ask Copilot to make it pass without changing the test, as in [Adding a feature test first](#adding-a-feature-test-first).

4. Store the films of each booking in a `booking_items` table linked to `bookings`, as in [Storing order items in a related table](#storing-order-items-in-a-related-table). Existing bookings must survive the upgrade, and your models, database helper, basket page and tests must all be updated.

5. Run your tests with coverage, as in [Inspecting test coverage](#inspecting-test-coverage). Show the coverage of your project in the Flutter Coverage extension and add tests for any important code that is not covered.

6. (Advanced) Add an integration test that books a film and checks that the booking appears in the past bookings list, and run it on your emulator, as in [End-to-end integration testing with AI](#end-to-end-integration-testing-with-ai).
