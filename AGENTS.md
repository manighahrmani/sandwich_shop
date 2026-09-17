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

## Writing style for worksheets and teaching material

These rules define the house writing style for all Markdown teaching material
(worksheets, README, coursework briefs). Worksheet 1 and the sections of
Worksheet 2 above the exercises are the reference examples. Follow these rules
whenever you write or edit teaching material, and never "improve" prose by
adding emphasis, structure, or explanation the style forbids. Much of this is
enforced automatically by Vale, markdownlint and cspell (see the Style
enforcement section at the end).

### Document structure

- Start every worksheet with a single level-1 title in the form
  `# Worksheet N — Topic`, using an em dash (—), not a hyphen, and no bold.
- Follow the title with a `## Table of contents` built from bullet links to
  every `##` and `###` heading, in document order. Anchors are the heading
  text lowercased, spaces replaced by hyphens, with punctuation removed.
- Use `##` for main sections and `###` for subsections. Do not go deeper than
  `###`. Do not skip levels (no `####`).
- Headings are plain sentence case text. Do not wrap headings in bold or
  italics, and do not put backticks, trailing punctuation or emojis in them.
  The one allowed pattern with parentheses is a repeated step such as
  `### Commit your changes (3)`.

### Paragraphs and prose

- Write in prose. Prefer short paragraphs of one to four sentences that each
  carry the reader through one step or idea.
- Use full sentences with a full stop. Address the reader as "you", and use
  "we" for shared actions, matching the existing worksheets.
- Use a bullet list only for a genuine enumeration of parallel items (for
  example a list of widget categories). Do not use bullets to hold a sequence
  of instructions; write those as prose or as a numbered list when the order
  matters and there are three or more ordered steps.
- Do not restate the same instruction twice, and do not re-explain a concept,
  term or keyboard shortcut that an earlier section of the same worksheet, or
  an earlier worksheet, has already introduced. A brief one-clause reminder is
  fine; a second full explanation is not.

### Emphasis, code and terminology

- Use bold only for keyboard shortcuts and for literal user-interface labels
  the reader clicks or reads (for example a button caption). Do not use bold
  for emphasis in ordinary prose.
- Do not use italics for emphasis.
- Use inline code for identifiers, types, file names, properties, values and
  short commands (for example `main.dart`, `StatelessWidget`, `_quantity`).
- Use fenced code blocks with a language tag for multi-line code: use a
  `dart` fence for Dart, a `bash` fence for terminal commands and a `text`
  fence for plain output.
- Refer to widgets and classes by their exact name in inline code, and keep
  the same name for the same thing throughout (for example always "terminal",
  never switching to "console").

### Keyboard shortcuts and tooling references

- Write every shortcut as both platforms in bold, in the form
  `**Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS`, with single
  spaces around each `+`.
- Introduce tools such as the Command Palette, Source Control panel, hot
  reload and the terminal once, where they first appear. After that, refer to
  them by name without redefining them, including in later worksheets.

### Images

- Every image needs descriptive alt text that says what the screenshot shows,
  for example `![The widget tree with the app bar selected](...)`. Do not use
  the word "placeholder" in alt text or commit placeholder images.
- Place an image immediately after the sentence that introduces it, and lead
  into it with a phrase such as "as shown below" or "your code should look
  like this".
- Store worksheet images under `images/<worksheet-number>/` and name files
  descriptively in lower snake case.

### Emojis

- Do not add decorative emojis to prose, headings or lists.
- The only emoji allowed in prose is ⚠️, used for warning callouts (as in the
  README). Worksheets should generally avoid even this.
- Emojis that are part of the app's own code or output (for example the 🥪
  sandwich emoji) are content, not decoration, and must be preserved. Do not
  add emojis of your own to code or output that the author did not write.

### Spelling and language

- Use British English spelling (for example centre, colour, behaviour,
  analyse, initialise). Spelling is checked with cspell using the en-GB
  locale; add genuinely new technical terms to `cspell.json` rather than
  rewording around them.

### Logical consistency

- Do not use a class, method, property or widget in code before the worksheet
  has introduced it. Introduce each new identifier in prose before or at the
  point the reader first types it.
- Do not contradict earlier statements, and do not forward-reference content
  that appears later (for example do not say the reader "already met"
  something in the exercises when the exercises come after the current
  section).
- Keep counts and lists accurate: if the prose says there are three children,
  the code and the following list must contain three.

### Style enforcement

Style is enforced automatically and runs in pre-commit and CI:

- markdownlint (`.markdownlint.json`) checks Markdown structure.
- cspell (`cspell.json`, en-GB) checks spelling.
- Vale (`.vale.ini` with the `Worksheet` style under `.vale/styles`) checks the
  prose rules above that can be checked mechanically, such as banned decorative
  emojis, stray bold or italic emphasis, forbidden heading formatting and
  inconsistent terminology.

Run all three locally before committing teaching material:

```bash
pre-commit run --all-files
vale worksheet-2.md
```
