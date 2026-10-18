# Lecture 6 — JSON Assets and Saved Preferences

> This mirrors `finalised_lectures/lecture-6.pptx`. Slides are minimal; detail lives in the worksheets and in what I say when each slide is shown. Update this file whenever the deck changes.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 6:

- JSON assets
- Asynchronous loading
- Saved preferences

---

## JSON assets — tech news

I need tech news from you! I will provide some of my own.

Student opportunities and developer events:

- Google Solution Challenge:
  - Annual global university competition to build solutions for UN Sustainable Development Goals using Flutter and Google technologies.
  - Mentorship, hands-on workshops, and global showcase: [developers.google.com/community/solutions-challenge](https://developers.google.com/community/solutions-challenge)
- JetBrains Student Pack:
  - Free professional licences for IntelliJ IDEA Ultimate, WebStorm, PyCharm, and DataGrip.
  - Renewable annually with your university email: [jetbrains.com/community/education](https://www.jetbrains.com/community/education/)

Tech news from you:

- [Leave space for student news, placements, and module tech updates]

---

## JSON assets — structured data with JSON

- JSON (JavaScript Object Notation) is a plain-text format for structured data.
- Data is organised into key-value maps (`{}`) and ordered lists (`[]`).
- In Lecture 3, our menu items were hardcoded directly in Dart code.
- Hardcoded data mixes presentation with data; changing a price or sandwich requires recompiling and redeploying.
- Moving data to JSON separates content from code so non-developers can update catalogues independently.
- Dart maps JSON objects to `Map<String, dynamic>` and arrays to `List<dynamic>`.
- Learn more in the [MDN JSON guide](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting/JSON).

---

## JSON assets — bundled assets

- Assets live in an `assets/` directory (for example `assets/sandwiches.json`).
- Register the file in `pubspec.yaml` under the `flutter` section:

```yaml
flutter:
  assets:
    - assets/sandwiches.json
```

- YAML indentation is strict: exactly two spaces per level, never tabs.
- Flutter bundles registered assets into the compiled app binary at build time.
- Read asset text with `rootBundle` from `package:flutter/services.dart`:

```dart
final String data = await rootBundle.loadString('assets/sandwiches.json');
```

---

## JSON assets — parsing and converting collections

- `dart:convert` provides `jsonDecode` to convert raw JSON strings into Dart collections:

```dart
import 'dart:convert';

final dynamic decoded = jsonDecode(data);
final List<dynamic> jsonList = decoded as List<dynamic>;
```

- `jsonDecode` returns `dynamic`; always cast collections explicitly.
- A procedural `for-in` loop converts each dynamic item into a strongly typed model:

```dart
final List<Sandwich> menu = <Sandwich>[];
for (final dynamic item in jsonList) {
  menu.add(Sandwich.fromJson(item as Map<String, dynamic>));
}
```

- Avoid dense functional chains or arrow shorthands; explicit loops make data transformations transparent and easy to debug.

---

## JSON assets — model serialisation

- A factory constructor creates a model instance from a `Map<String, dynamic>`:

```dart
factory Sandwich.fromJson(Map<String, dynamic> json) {
  return Sandwich(
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
  );
}
```

- Numbers in JSON decode as either `int` or `double`; cast to `num` first before calling `toDouble()`.
- A `toJson` method converts model instances back into a map for saving:

```dart
Map<String, dynamic> toJson() {
  return <String, dynamic>{
    'name': name,
    'price': price,
  };
}
```

- Read the official [JSON serialisation guide](https://docs.flutter.dev/data-and-backend/serialization/json) for further patterns.

---

## Asynchronous loading — futures and async/await

- Reading assets from disk is I/O: it takes time and must not block the UI thread.
- A `Future<T>` represents a value that will become available in the future.
- Mark functions `async` to pause at `await` without freezing the screen:

```dart
Future<List<Sandwich>> loadMenu() async {
  final String text = await rootBundle.loadString('assets/sandwiches.json');
  return parseSandwiches(text);
}
```

- While awaiting, Flutter continues to render animations smoothly at 60 fps.
- Practise asynchronous programming with the [Dart async codelab](https://dart.dev/codelabs/async-await).

---

## Asynchronous loading — lifecycle and initState

- `StatefulWidget` provides lifecycle methods that execute as widgets mount and unmount.
- `initState` runs exactly once when the `State` object is inserted into the tree:

```dart
@override
void initState() {
  super.initState();
  _loadMenu();
}
```

- Always call `super.initState()` on the first line.
- Never trigger asynchronous loading directly inside `build()`; `build` runs repeatedly on every frame and `setState` call.
- Check the [State.initState documentation](https://api.flutter.dev/flutter/widgets/State/initState.html) for details.

---

## Asynchronous loading — loading and error states

- Asynchronous screens have three distinct states: loading, loaded, and failed.
- Track these with simple state fields in your `State` class:

```dart
bool _isLoading = true;
String? _errorMessage;
List<Sandwich> _menu = <Sandwich>[];
```

- In `build`, return the appropriate widget based on the current state:

```dart
if (_isLoading) {
  return const Center(child: CircularProgressIndicator());
}
if (_errorMessage != null) {
  return Center(child: Text(_errorMessage!));
}
return ListView.builder(...);
```

- See the [CircularProgressIndicator documentation](https://api.flutter.dev/flutter/material/CircularProgressIndicator-class.html).

---

## Saved preferences — key-value persistence

- In-memory variables and singletons reset when the application process terminates.
- For user preferences, theme modes, and customer profiles, we need persistence across app launches.
- `shared_preferences` wraps platform-native storage (`NSUserDefaults` on iOS, `SharedPreferences` on Android).
- Add the package from your terminal:

```bash
flutter pub add shared_preferences
```

- Values are stored against string keys (such as `'customer_name'` or `'is_vegetarian'`).
- Supported types: `String`, `bool`, `int`, `double`, and `List<String>`.
- Read the [shared_preferences documentation](https://pub.dev/packages/shared_preferences).

---

## Saved preferences — reading, writing and testing

- Access the preferences instance asynchronously, then save or retrieve:

```dart
final SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setString('customer_name', _nameController.text);
final String savedName = prefs.getString('customer_name') ?? '';
```

- The `??` operator provides a fallback default when no value has been stored yet.
- Unit and widget tests run in headless environments; mock initial values before testing:

```dart
SharedPreferences.setMockInitialValues(<String, Object>{
  'customer_name': 'Alex',
  'is_vegetarian': true,
});
```

- Mocked tests run in milliseconds without launching an emulator or physical device.

---

## Demo 3 (footnote)

- Union of Worksheet 5 and Worksheet 6 exercises: navigation, a basket, customer profile form, JSON catalogue and saved profile preferences.
- SQLite bookings and Android emulators follow in Worksheet 7 for Demo 4.
- Also unit tests and widget tests covering almost all of your codebase.
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

Run this live during the lecture to teach resolving pull request conflicts on GitHub. We continue from the pull request demo in Lecture 5. In Lecture 4 we resolved merge conflicts locally in VS Code; this demo shows what happens when a pull request conflicts with `main` on GitHub, and how to resolve it directly in the GitHub web interface. Do not mention the coursework or Southsea Cinema here; that is a footnote at the end.

### Setup

1. Pull requests are how teams review code before merging into `main`.
2. When two developers change the same lines on different branches, GitHub cannot merge automatically.
3. GitHub disables the merge button and warns: "This branch has conflicts that must be resolved".
4. GitHub provides a built-in web conflict editor to resolve conflicts directly in the browser without having to switch branches locally.
5. Create a fresh throwaway repository on GitHub called `pr-conflict-demo` (or reuse the repository from Lecture 5). Push an initial commit with a base file:

    ```bash
    mkdir pr-conflict-demo && cd pr-conflict-demo
    git init -b main
    echo "Welcome to the Sandwich Shop" > announcement.txt
    git add announcement.txt
    git commit -m "docs: add initial announcement"
    git remote add origin https://github.com/YOUR-USERNAME/pr-conflict-demo.git
    git push -u origin main
    ```

### Part 1 — Creating a conflicting feature branch

1. Create a feature branch called `summer-special` and change the announcement:

    ```bash
    git checkout -b summer-special
    echo "Welcome to the Sandwich Shop - 20% off summer subs!" > announcement.txt
    git add announcement.txt
    git commit -m "feat: add summer discount"
    git push -u origin summer-special
    ```

2. On GitHub, open a pull request from `summer-special` into `main`. Show students that GitHub reports: "Able to merge. These branches can be automatically merged."
3. Do not merge the pull request yet.

### Part 2 — Simulating a concurrent change on main

1. Switch back to `main` locally to simulate another developer merging work before you:

    ```bash
    git checkout main
    echo "Welcome to the Sandwich Shop - open 7 days a week!" > announcement.txt
    git add announcement.txt
    git commit -m "docs: update opening hours on main"
    git push origin main
    ```

2. Return to the open pull request on GitHub and refresh the page.
3. Show students the change in state:
    - The green merge button is gone.
    - GitHub displays a grey box: "This branch has conflicts that must be resolved".
    - A **Resolve conflicts** button appears next to the warning.

### Part 3 — Resolving the conflict on GitHub

1. Select **Resolve conflicts**. GitHub opens its online conflict editor.
2. Highlight the conflict markers to the students:
    - `<<<<<<< summer-special` marks the incoming change.
    - `=======` separates the conflicting versions.
    - `>>>>>>> main` marks the existing version on `main`.
3. Combine the changes into one final version:

    ```text
    Welcome to the Sandwich Shop - 20% off summer subs! Open 7 days a week.
    ```

4. Delete the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).
5. Select **Mark as resolved** in the top right.
6. Select **Commit merge**. GitHub automatically creates a merge commit on `summer-special`.
7. Return to the pull request: the merge button is now green and ready. Select **Merge pull request**, then **Confirm merge**.

### Part 4 — Synchronising your local environment

1. Show students that merging on GitHub does not automatically update your local terminal:

    ```bash
    git checkout main
    git pull
    git log --oneline --graph --all
    ```

2. Point out the merge commit in the git graph showing the resolution.

### Wrap-up

- Pull request conflicts occur when `main` moves ahead while a feature branch is being developed.
- Simple conflicts can be resolved directly in GitHub's web editor without switching branches locally.
- Always pull `main` after merging on GitHub to keep your local machine up to date.
- Encourage students to practise creating and resolving a conflict in a throwaway repository.
