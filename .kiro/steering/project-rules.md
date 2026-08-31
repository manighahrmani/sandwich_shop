# Project Rules (mirror of root AGENTS.md)

Canonical version: `AGENTS.md` at the repository root. If the two differ, the root file wins.

## Southsea Cinema Sync Rule

Any change to `southsea_cinema/` (public template) must be immediately mirrored to `southsea_cinema_private/` (model solution). Applies to code, config, tests, and documentation.

The nested folders `southsea_cinema/`, `southsea_cinema_private/`, `flutter_vscode_package/`, `flutter_vscode_package_private/` and `sign-off-app/` are separate git repositories. Never commit or push them to this public `sandwich_shop` repository.

## Web-Only Platform Target

- Only Flutter Web (`flutter run -d edge` or `-d chrome`) is supported. Lab machines lack C++ Build Tools and Xcode.
- Never build or configure desktop or mobile native binaries for module work.
- SQLite runs in WebAssembly via `sqflite_common_ffi_web` with `databaseFactoryFfiWebNoWebWorker`. CRUD is live in-memory per web session; cloud persistence (e.g. Firebase) is used for cross-device storage.

## Response Style

- Keep replies to the absolute minimum. State findings and actions directly.

## No Emojis

- Never use emojis anywhere: responses, READMEs, code, commit messages, comments, UI text, logs, or documentation. Plain text and Markdown only.
