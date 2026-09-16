# Repository Guidance

This file is the single, centralised source of agent instructions for this
this file rather than duplicate rules.

## Chat replies must be minimal

- Reply in chat with the fewest words possible. State only what the user must
  know or must act on. Nothing else.
- Do not explain reasoning, background, alternatives, next-step suggestions,
  or instructions the user did not ask for.
- When a task is done, say it is done and give only essential results (e.g. a
  pushed commit range, a URL). No summaries, no recaps.
- Do not ask the user questions when the task is clear. Make reasonable
  decisions and act. Only ask if truly blocked by missing information that
  cannot be inferred.

## Reference-only directories — do not read or modify unless the user asks

These directories are gitignored and are separate/nested repositories. Do not
load them into context, read their contents, or modify them unless the user
explicitly names them in the request:

- moodle/, moodle_private/            (stale reference — never update)
- union_shop/                          (stale reference — never update)
- southsea_cinema/, southsea_cinema_private/
- sign-off-app/                        (contains student PII)
- flutter_vscode_package/ (and _private)

Never `git add -A` / `git add .` from the workspace root; stage files by name.
