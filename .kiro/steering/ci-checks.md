# CI/CD and Pre-commit Checks

This repository has pre-commit hooks and CI/CD checks that must pass before pushing.

## Checks

1. **Spell check** (British English) — `cspell "**/*.md" "**/*.dart" --locale en-GB --config cspell.json`
2. **Markdown lint** — `markdownlint "**/*.md" --config .markdownlint.json`
3. **Dart format** — `dart format --set-exit-if-changed .`
4. **Dart analyse** — `flutter analyze`
5. **Tests** — `flutter test`

## Rules

- All text must use British English spelling (e.g. "colour" not "color", "organise" not "organize").
- If you add new technical terms or proper nouns, add them to `cspell.json` in the `words` array.
- Run `pre-commit run --all-files` before committing to catch issues early.
- The GitHub Actions workflow in `.github/workflows/ci.yml` runs the same checks on push and PR.
