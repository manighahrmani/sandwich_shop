# Lecture 6 — JSON and Saved Preferences

> This mirrors `finalised_lectures/lecture-6.pptx`. Slides are minimal; detail lives in the worksheets and in what I say when each slide is shown. Update this file whenever the deck changes.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 6:

- JSON assets
- Async load
- Saved preferences

---

## JSON assets — tech news

- Got tech news? Share it on Discord.
- JetBrains Student Pack:
  - Free professional licences for IntelliJ IDEA Ultimate, WebStorm, PyCharm, …
  - Renews annually with university email: [jetbrains.com/academy/student-pack](https://www.jetbrains.com/academy/student-pack/)
- GitHub Student Developer Pack:
  - Free developer tools, cloud credits, and domain names: [education.github.com/pack](https://education.github.com/pack)
- Resolving conflicts on GitHub:
  - Guide to resolving PR merge conflicts in the web editor: [docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/resolving-a-merge-conflict-on-github](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/resolving-a-merge-conflict-on-github)

---

## JSON assets — kinds of data

Technically, JSON is semi-structured data:

- Structured data has a rigid rule that enforces the same types in every instance (e.g. rows in a normalised SQL database).
- Semi-structured data allows exceptions and is less rigid compared to structured data (e.g. XML and JSON).
- Unstructured data has no order; no schema is enforced (e.g. plain text files, images, and generally files that require special software to be read or used).

---

## JSON assets — structured data with JSON

- JSON (JavaScript Object Notation) is a plain-text format for data interchange.
- Data is organised into key-value objects (`{}`) and ordered arrays (`[]`).

A JSON object with different value types:

```json
{
  "id": "1",
  "name": "Item A",
  "count": 10,
  "active": true
}
```

A JSON array of objects:

```json
[
  { "id": "1", "name": "Item A" },
  { "id": "2", "name": "Item B" }
]
```

- Hardcoded data mixes presentation with data; changing content requires recompiling Dart code.
- Moving data to JSON separates content from code so non-developers can update data independently.
- Dart maps JSON objects to `Map<String, dynamic>` and arrays to `List<dynamic>`.
- Learn more in the [MDN JSON guide](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting/JSON).

---

## JSON assets — bundled assets

JSON assets must be registered in `pubspec.yaml` under the `flutter` section:

```yaml
flutter:
  assets:
    - assets/data/
```

- Flutter bundles registered assets into the compiled app binary at build time.
- Read asset text with `rootBundle` from `package:flutter/services.dart`:

```dart
final String jsonString =
    await rootBundle.loadString(
      'assets/data/items.json',
    );
```

- More information at [Adding assets and images](https://docs.flutter.dev/ui/assets/assets-and-images)

---

## JSON assets — from JSON to a Dart object

A class for the object, with a `factory` constructor that reads a map:

```dart
class Item {
  final String id;
  final String name;

  Item({required this.id, required this.name});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
```

- Each value comes out as `dynamic`, so cast it explicitly with `as`.
- A `toJson` method does the reverse:

```dart
Map<String, dynamic> toJson() {
  return <String, dynamic>{
    'id': id,
    'name': name,
  };
}
```

- More detail: [JSON and serialization](https://docs.flutter.dev/data-and-backend/serialization/json)

---

## Async load — futures, async and await

- Reading a file takes time; the app must not freeze while waiting.
- A `Future<T>` is a value of type `T` that arrives later.
- Inside an `async` function, `await` pauses until the `Future` completes:

```dart
Future<List<Item>> loadItems() async {
  final String text =
      await rootBundle.loadString('assets/data/items.json');
  final List<dynamic> list =
      jsonDecode(text) as List<dynamic>;

  final List<Item> items = <Item>[];
  for (final dynamic item in list) {
    items.add(Item.fromJson(item as Map<String, dynamic>));
  }
  return items;
}
```

- `jsonDecode` (from `dart:convert`) turns the text into Dart lists and maps.
- More detail: [Asynchronous programming: futures, async, await](https://dart.dev/libraries/async/async-await)

---

## Async load — starting the load

- `initState` runs once when the screen's `State` is created; start the load there, not in `build`:

```dart
@override
void initState() {
  super.initState();
  _load();
}
```

- Always call `super.initState()` first.
- After an `await`, check `mounted` before calling `setState`; the user may have navigated away:

```dart
final List<Item> items = await loadItems();
if (!mounted) {
  return;
}
setState(() {
  _items = items;
});
```

- More detail: [initState](https://api.flutter.dev/flutter/widgets/State/initState.html)

---

## Async load — loading and error states

The screen tracks state using simple fields:

```dart
bool _loading = true;
String _error = '';
List<Item> _items = <Item>[];
```

`build` picks what to show based on state:

```dart
if (_loading) {
  return const CircularProgressIndicator();
}
if (_error != '') {
  return Text(_error);
}
return Text('${_items.length} items loaded');
```

- More detail: [CircularProgressIndicator](https://api.flutter.dev/flutter/material/CircularProgressIndicator-class.html)

---

## Saved preferences — key-value storage

- Variables in memory are lost when the app closes.
- `shared_preferences` saves lightweight values (`bool`, `int`, `double`, `String`, `List<String>`) under string keys across app restarts.
- Not intended for large datasets or sensitive credentials.

```bash
flutter pub add shared_preferences
```

- We use `SharedPreferencesAsync`, the package's current API; every read and write is awaited.
- More detail: [Store key-value data on disk](https://docs.flutter.dev/cookbook/persistence/key-value) and [shared_preferences](https://pub.dev/packages/shared_preferences)

---

## Saved preferences — reading, writing and testing

Access the store asynchronously to save and read values:

```dart
final SharedPreferencesAsync prefs =
    SharedPreferencesAsync();
await prefs.setString('username', 'Alex');
final String? name = await prefs.getString('username');
```

- `getString` returns `null` if nothing has been stored under that key yet; provide a default fallback value.
- In unit tests, use an in-memory store from `shared_preferences_platform_interface` to isolate tests:

```dart
SharedPreferencesAsyncPlatform.instance =
    InMemorySharedPreferencesAsync.withData(
      <String, Object>{'username': 'Alex'},
    );
```

---

## Live coding

- Simulating teamwork: resolving pull request conflicts on GitHub (see the live demo guide below).
- Handling concurrent changes across multiple files and multiple locations.
- Reviewing, combining, and merging changes in a PR.

---

## Demo 3 (footnote)

- Union of Worksheet 5 and Worksheet 6 exercises: navigation, a basket, a profile form, and saved preferences.
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

Resolving pull request conflicts across multiple files on GitHub. In previous lectures we resolved conflicts locally in VS Code and introduced pull requests; this demonstrates how student teams encounter, understand, and resolve conflicts in a shared GitHub pull request without losing each other's work.

- GitHub's guide: [Resolving a merge conflict on GitHub](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/resolving-a-merge-conflict-on-github)
- Real teamwork scenario: teammate Alex and teammate Sam both work on separate features branching from `main`. Alex merges their feature into `main` first. When Sam opens a pull request, GitHub detects conflicting changes in multiple files (`README.md` and `config.json`).
- Rather than blindly accepting one person's branch over another, the lecturer shows how to combine changes from both teammates in the GitHub web editor.

### Setup — initialise the team repository

Create an empty public repository called `team-conflict-demo` on GitHub (without a README or `.gitignore`), then run:

```bash
mkdir team-conflict-demo && cd team-conflict-demo
git init -b main

cat << 'EOF' > README.md
# Team Project

A shared application for community events.

## Prerequisites
- Flutter SDK (stable channel)
- VS Code or Android Studio
- Chrome or an Android emulator

## Getting started
Clone the repository and run pub get.
EOF

cat << 'EOF' > config.json
{
  "version": "1.0.0",
  "theme": "light"
}
EOF

git add README.md config.json
git commit -m "feat: initial project setup"
git remote add origin https://github.com/YOUR-USERNAME/team-conflict-demo.git
git push -u origin main
```

### Part 1 — Sam branches and makes changes

Simulate teammate Sam creating `feature-sam` to add the team roster, test command, and a version bump:

```bash
git checkout -b feature-sam

cat << 'EOF' > README.md
# Team Project

A shared application for community events.
Team members: Alex, Sam, Taylor.

## Prerequisites
- Flutter SDK (stable channel)
- VS Code or Android Studio
- Chrome or an Android emulator

## Getting started
Clone the repository and run pub get.
Run flutter test to execute the automated test suite.
EOF

cat << 'EOF' > config.json
{
  "version": "1.1.0",
  "theme": "light"
}
EOF

git add README.md config.json
git commit -m "feat: add team roster, test instructions, and bump version"
git push -u origin feature-sam
```

### Part 2 — Alex branches, makes changes, and merges first

Simulate teammate Alex working concurrently from `main`. Alex updates the project description, adds the web run command, and switches to dark theme:

```bash
git checkout main
git checkout -b feature-alex

cat << 'EOF' > README.md
# Team Project

A modular Flutter application for local community events.

## Prerequisites
- Flutter SDK (stable channel)
- VS Code or Android Studio
- Chrome or an Android emulator

## Getting started
Clone the repository and run pub get.
Run flutter run -d chrome to start the development server.
EOF

cat << 'EOF' > config.json
{
  "version": "1.0.0",
  "theme": "dark"
}
EOF

git add README.md config.json
git commit -m "feat: update description, web run command, and dark theme"
git push -u origin feature-alex
```

Alex merges their branch into `main` first:

```bash
git checkout main
git merge feature-alex
git push origin main
```

Now `main` on GitHub contains Alex's commits.

### Part 3 — Sam opens a pull request

1. On GitHub, navigate to the repository and select **Compare & pull request** (or open a new pull request with base `main` and compare `feature-sam`).
2. GitHub displays: `Can't automatically merge. Don't worry, you can still create the pull request.`
3. Select **Create pull request**.
4. The pull request page shows: `This branch has conflicts that must be resolved`, and the green **Merge pull request** button is disabled.

### Part 4 — Resolve conflicts in the GitHub web editor

Select **Resolve conflicts**. Point out to students that GitHub lists two conflicting files on the left sidebar: `README.md` and `config.json`.

#### 1. Resolve README.md (multiple conflict locations)

Point out the conflict markers (`<<<<<<< feature-sam`, `=======`, and `>>>>>>> main`):

- **Location 1 (top):** Sam added team members while Alex updated the project description:

```markdown
<<<<<<< feature-sam
A shared application for community events.
Team members: Alex, Sam, Taylor.
=======
A modular Flutter application for local community events.
>>>>>>> main
```

Combine both changes so neither teammate's contribution is lost:

```markdown
A modular Flutter application for local community events.
Team members: Alex, Sam, Taylor.
```

- **Location 2 (bottom):** Sam added test instructions while Alex added web run instructions:

```markdown
<<<<<<< feature-sam
Run flutter test to execute the automated test suite.
=======
Run flutter run -d chrome to start the development server.
>>>>>>> main
```

Keep both instructions in logical order:

```markdown
Run flutter test to execute the automated test suite.
Run flutter run -d chrome to start the development server.
```

Delete all conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) from `README.md` and select **Mark as resolved**.

#### 2. Resolve config.json (combining properties)

Switch to `config.json` on the left sidebar:

```json
<<<<<<< feature-sam
  "version": "1.1.0",
  "theme": "light"
=======
  "version": "1.0.0",
  "theme": "dark"
>>>>>>> main
```

Explain that Sam bumped the version to `1.1.0` while Alex updated the theme to `dark`. Keep both:

```json
{
  "version": "1.1.0",
  "theme": "dark"
}
```

Delete the markers and select **Mark as resolved**.

#### 3. Complete the merge

1. Select **Commit merge**. GitHub creates a merge commit into `feature-sam`.
2. Back on the pull request, select **Merge pull request**, then **Confirm merge**.

### Part 5 — Update the local repository

Switch back to the local terminal to demonstrate that GitHub merges do not automatically appear locally until pulled:

```bash
git checkout main
git pull
git log --oneline --graph --all
```

Open `README.md` and `config.json` in VS Code to verify that both teammates' changes are present and intact.

### Wrap-up notes for the lecturer

- Merge conflicts are normal in team software development; they occur when teammates edit the same lines before syncing.
- Resolving a conflict usually means integrating both people's changes rather than picking one and discarding the other.
- The web editor is ideal for text conflicts; complex conflicts involving renamed or deleted files are best resolved locally in VS Code.
- Always run `git pull` on your local workstation after merging pull requests on GitHub.
