# Worksheet 8 — Review-Driven Development with AI

## Table of contents

- [Getting started](#getting-started)
  - [Continue from Worksheet 7](#continue-from-worksheet-7)
  - [Clone the Sandwich Shop repository](#clone-the-sandwich-shop-repository)
  - [Switch to branch 7](#switch-to-branch-7)
- [Introducing GitHub Copilot and workspace context](#introducing-github-copilot-and-workspace-context)
  - [Understanding workspace context and chat participants](#understanding-workspace-context-and-chat-participants)
  - [Crafting bounded and specific prompts](#crafting-bounded-and-specific-prompts)
- [Generating project documentation with AI](#generating-project-documentation-with-ai)
  - [Supplying context files for a repository README](#supplying-context-files-for-a-repository-readme)
  - [Reviewing and auditing AI-generated text](#reviewing-and-auditing-ai-generated-text)
- [Implementing dark mode with saved preferences](#implementing-dark-mode-with-saved-preferences)
  - [Prompting Copilot for theme mode persistence](#prompting-copilot-for-theme-mode-persistence)
  - [Reviewing inline diffs and code suggestions](#reviewing-inline-diffs-and-code-suggestions)
  - [Verifying runtime behaviour and test suites](#verifying-runtime-behaviour-and-test-suites)
- [Expanding automated tests with AI assistance](#expanding-automated-tests-with-ai-assistance)
  - [Generating edge-case unit and widget tests](#generating-edge-case-unit-and-widget-tests)
  - [Auditing tests against false positives and weak assertions](#auditing-tests-against-false-positives-and-weak-assertions)
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

## Expanding automated tests with AI assistance

### Generating edge-case unit and widget tests

<!-- TODO: Testing with AI:
- Ask Copilot to identify untested boundary conditions (e.g. theme preference defaults, corrupted preferences, extreme screen sizes).
- Generate targeted unit tests in `test/models/` and widget tests in `test/screens/`. -->

### Auditing tests against false positives and weak assertions

<!-- TODO: Critical test audit:
- Watch out for tautological assertions (tests that always pass regardless of implementation).
- Verify assertions check real UI state, not just `findsOneWidget` on generic containers.
- Check test coverage using `flutter test --coverage` and the Flutter Coverage extension. -->

## Exercises

The exercises below apply Review-Driven Development to your Southsea Cinema coursework.

<!-- TODO: Map exercises directly to Southsea Cinema Private:
1. Use Copilot with `@workspace` to generate a professional, accurate `README.md` for Southsea Cinema, and audit it before committing.
2. Prompt Copilot to implement a dark mode theme switch on the cinema settings page, persisting the choice in `shared_preferences`.
3. Review the AI-generated code diff line by line, ensuring squared buttons (`BorderRadius.zero`) and existing theme constants are preserved.
4. Prompt Copilot to generate boundary-condition unit and widget tests for the new theme setting and booking models.
5. Audit generated test assertions, confirm zero warnings in `dart analyze`, and verify all tests pass with `flutter test`. -->
