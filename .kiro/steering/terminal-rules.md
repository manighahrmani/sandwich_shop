# Terminal Rules

## Banned commands

Never run interactive or long-running commands in the terminal. These block
execution and freeze the agent session. Examples of banned patterns:

- `flutter run` (use the user's own terminal or provide the command to run)
- `npm run dev`, `yarn start`, `webpack --watch`
- Any command with `--watch` or `--interactive` flags
- `vim`, `nano`, `less`, `more`, or any interactive editor
- `python -m http.server` or similar persistent servers

If a dev server or long-running process is needed, **tell the user the exact
command to run in their own terminal**. Do not start it yourself.

## Safe alternatives

- To check if something compiles: `flutter build web` (terminates)
- To run tests: `flutter test` (terminates)
- To check lint: `flutter analyze` (terminates)
- To install deps: `flutter pub get` (terminates)

## Applies to

All agents and sessions working in this repository, without exception.
