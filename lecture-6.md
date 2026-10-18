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

- JetBrains Student Pack:
  - Free professional licences for IntelliJ IDEA Ultimate, WebStorm, PyCharm, …
  - Renews annually with university email.
  - Get yourself some here: [jetbrains.com/academy/student-pack](https://www.jetbrains.com/academy/student-pack/)

---

## JSON assets — kinds of data

Technically, JSON is semi-structured data:

- Structured data has a rigid rule that enforces the same types in every instance (e.g., rows in a normalised SQL database).
- Semi-structured data allows exceptions and is less rigid compared to structured data (e.g., XML and JSON).
- Unstructured data has no order; no schema is enforced (e.g., plain text files, images, and generally files that require special software to be read/used).

---

## JSON assets — structured data with JSON

- JSON (JavaScript Object Notation) is a plain-text format for data.
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

- Hardcoded data lives inside widget code; changing values requires editing and recompiling.
- Moving data to JSON separates content from code so data updates independently.
- Dart maps JSON objects to `Map<String, dynamic>` and arrays to `List<dynamic>`.
- Learn more in the [MDN JSON guide](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting/JSON).

---

## JSON assets — bundled assets

JSON assets must also be registered in `pubspec.yaml` under the `flutter` section:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/data/
```

- Flutter bundles registered assets into the compiled app binary at build time.
- Read asset text with `rootBundle` from `package:flutter/services.dart`:

```dart
final String jsonString =
    await rootBundle.loadString(
        'assets/data/data.json'
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

- Each value comes out as `dynamic`, so cast it with `as`.
- A `toJson` method does the reverse:

```dart
Map<String, dynamic> toJson() {
  return <String, dynamic>{'id': id, 'name': name};
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
      await rootBundle.loadString('assets/data/data.json');
  final List<dynamic> list = jsonDecode(text) as List<dynamic>;

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
- After an `await`, check `mounted` before calling `setState`; the user may have navigated away.
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
- `shared_preferences` saves lightweight values (`bool`, `int`, `double`, `String`, `List<String>`) under string keys.
- Not intended for large datasets or sensitive credentials.

```bash
flutter pub add shared_preferences
```

- More detail: [Store key-value data on disk](https://docs.flutter.dev/cookbook/persistence/key-value) and [shared_preferences](https://pub.dev/packages/shared_preferences)

---

## Saved preferences — reading, writing and testing

Access the store asynchronously to save and read values:

```dart
final SharedPreferences prefs =
    await SharedPreferences.getInstance();
await prefs.setString('username', 'Alex');
final String? name = prefs.getString('username');
```

- `getString` returns `null` if nothing has been stored under that key yet.
- In tests, use an in-memory mock store:

```dart
SharedPreferences.setMockInitialValues(
  <String, Object>{'username': 'Alex'},
);
```

---

## Demo 3 (footnote)

- Union of Worksheet 5 and Worksheet 6 exercises: …
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

Resolving a pull request conflict on GitHub. Lecture 4 resolved conflicts locally in VS Code and Lecture 5 introduced pull requests; this combines the two in the browser.

- GitHub's guide: [Resolving a merge conflict on GitHub](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-on-github)
- The web editor only handles competing line changes. Anything more complex (for example a file deleted on one branch) must be resolved locally.

### Setup

Create an empty public repository called `pr-conflict-demo` on GitHub (no README), then:

```bash
mkdir pr-conflict-demo && cd pr-conflict-demo
git init -b main
echo "Open 9 to 5" > notice.txt
git add notice.txt
git commit -m "docs: add notice"
git remote add origin https://github.com/YOUR-USERNAME/pr-conflict-demo.git
git push -u origin main
```

### Part 1 — Open a pull request

```bash
git checkout -b weekend-hours
echo "Open 9 to 5, weekends 10 to 4" > notice.txt
git add notice.txt
git commit -m "docs: add weekend hours"
git push -u origin weekend-hours
```

On GitHub, open a pull request from `weekend-hours` into `main`. It reports no conflicts. Do not merge it.

### Part 2 — Change the same line on main

This simulates a teammate merging first:

```bash
git checkout main
echo "Open 8 to 6" > notice.txt
git add notice.txt
git commit -m "docs: extend opening hours"
git push
```

Refresh the pull request. GitHub now says "This branch has conflicts that must be resolved" and the merge button is disabled.

### Part 3 — Resolve on GitHub

1. Select **Resolve conflicts**.
2. Point out the markers: the `weekend-hours` version sits between `<<<<<<<` and `=======`, the `main` version between `=======` and `>>>>>>>`.
3. Replace everything, markers included, with `Open 8 to 6, weekends 10 to 4`.
4. Select **Mark as resolved**, then **Commit merge**. This merges `main` into `weekend-hours`.
5. Back on the pull request, select **Merge pull request**, then **Confirm merge**.

### Part 4 — Update the local copy

```bash
git pull
git log --oneline --graph --all
```

Merging on GitHub does not change the local copy until you pull.

### Wrap-up

- A pull request conflicts when its base branch changes the same lines after the branch was created.
- Simple conflicts can be resolved in the browser; complex ones need VS Code.
- Pull after merging on GitHub.
