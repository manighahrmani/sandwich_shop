# Worksheet 8 — Review-Driven Development with AI

## Table of contents

- [Getting started](#getting-started)
  - [Continue from Worksheet 7](#continue-from-worksheet-7)
  - [Clone the Sandwich Shop repository](#clone-the-sandwich-shop-repository)
  - [Switch to branch 7](#switch-to-branch-7)
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
- [Expanding unit and widget tests with AI assistance](#expanding-unit-and-widget-tests-with-ai-assistance)
  - [Generating edge-case unit and widget tests](#generating-edge-case-unit-and-widget-tests)
  - [Auditing tests against false positives and weak assertions](#auditing-tests-against-false-positives-and-weak-assertions)
- [End-to-end integration testing with AI](#end-to-end-integration-testing-with-ai)
  - [Setting up the Flutter integration test package](#setting-up-the-flutter-integration-test-package)
  - [Prompting Copilot for complete user flow integration tests](#prompting-copilot-for-complete-user-flow-integration-tests)
  - [Running integration tests on the Android emulator](#running-integration-tests-on-the-android-emulator)
  - [Inspecting final test coverage](#inspecting-final-test-coverage)
- [Exercises](#exercises)

## Getting started

### Continue from Worksheet 7

<!-- TODO: Instruct students to continue from their branch after Worksheet 7 (SQLite orders persistence and mirrored test structure). -->

### Clone the Sandwich Shop repository

<!-- TODO: Standard fallback cloning instructions for students starting fresh. -->

### Switch to branch 7

<!-- TODO: Command to check out branch 7 (`git checkout 7`). -->

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

## Expanding unit and widget tests with AI assistance

### Generating edge-case unit and widget tests

<!-- TODO: Testing with AI:
- Ask Copilot to identify untested boundary conditions (e.g. theme preference defaults, corrupted preferences, extreme screen sizes).
- Generate targeted unit tests in `test/models/` and widget tests in `test/screens/`. -->

### Auditing tests against false positives and weak assertions

<!-- TODO: Critical test audit:
- Watch out for tautological assertions (tests that always pass regardless of implementation).
- Verify assertions check real UI state, not just `findsOneWidget` on generic containers.
- Check test coverage using `flutter test --coverage` and the Flutter Coverage extension. -->

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

### Inspecting final test coverage

<!-- Note: The lecturer will demonstrate how to use AI pair-programming to achieve near-complete test coverage across the application, visualised with the Flutter Coverage extension. -->

<!-- TODO: Reviewing overall coverage:
- Run `flutter test --coverage`.
- Inspect combined coverage across models, repositories, database, screens, and integration flows in Flutter Coverage extension.
- Achieve near-complete test coverage across the application. -->

## Exercises

The exercises below apply Review-Driven Development to your Southsea Cinema coursework.

<!-- TODO: Map exercises directly to Southsea Cinema Private:
1. Configure MCP tools in your VS Code environment for Dart and GitHub.
2. Use Copilot with `@workspace` to generate a professional, accurate `README.md` for Southsea Cinema, and audit it before committing.
3. Prompt Copilot to implement a dark mode theme switch on the cinema settings page, persisting the choice in `shared_preferences`.
4. Review the AI-generated code diff line by line, ensuring squared buttons (`BorderRadius.zero`) and existing theme constants are preserved.
5. Prompt Copilot to generate boundary-condition unit and widget tests for the new theme setting and booking models.
6. Set up `integration_test` in Southsea Cinema and prompt Copilot to write an end-to-end user journey test (`integration_test/booking_flow_test.dart`) that selects a movie, adds tickets, completes checkout, and confirms the booking in SQLite.
7. Run the integration test on your Android emulator, confirm zero warnings in `dart analyze`, and verify high coverage in the Flutter Coverage extension. -->
