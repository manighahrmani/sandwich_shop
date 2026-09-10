# Repository Guidance

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
