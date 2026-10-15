# Lecture 5 — Navigation, State and Forms

> This mirrors `lecture-5.pptx`. Slides are minimal; detail lives in the worksheets and in what I say when each slide is shown. Update this file whenever the deck changes.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 5:

- Navigation
- Shared state
- Forms

---

## Navigation — tech news

I need tech news from you! I will provide some of my own.

Cloud courses:

- AWS Educate: [aws.amazon.com/education/awseducate](https://aws.amazon.com/education/awseducate/)
- Azure for Students: [azure.microsoft.com/en-us/free/students](https://azure.microsoft.com/en-us/free/students)

---

## Navigation — moving between screens

- Flutter's `Navigator` manages a stack of routes. A route represents a screen.
- The last route added is the visible one.
- `Navigator.push` adds a route; `Navigator.pop` returns to the previous one.
- This works well for a screen that should have a back button.
- Flutter's navigation and routing guide explains the wider options: [docs.flutter.dev/ui/navigation](https://docs.flutter.dev/ui/navigation)

---

## Navigation — push and pop

Suppose we have `HomeScreen`, `DetailsScreen` and `SettingsScreen`. A button on Home pushes Details:

```dart
Navigator.push(
  context,
  MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return const DetailsScreen();
    },
  ),
);
```

A button on Details removes it again:

```dart
Navigator.pop(context);
```

- `MaterialPageRoute` wraps the screen and supplies its transition.
- The stack changes from Home to Details and back to Home.
- `pop` reveals the existing Home; it does not create a new one.

---

## Navigation — named routes

Register each name in `MaterialApp`; registering a route does not open it:

```dart
routes: <String, WidgetBuilder>{
  '/settings': (BuildContext context) {
    return const SettingsScreen();
  },
},
```

A button can then push the route by its name:

```dart
Navigator.pushNamed(context, '/settings');
```

- The name chooses the screen; the stack works the same way.
- Repeated pushes can create repeated copies of a screen (the worksheet shows how to stop this).
- Flutter now recommends other approaches for complex apps: [docs.flutter.dev/ui/navigation#using-named-routes](https://docs.flutter.dev/ui/navigation#using-named-routes)

---

## Navigation — replacing a route

```dart
Navigator.pushReplacementNamed(context, '/settings');
```

- Called on Details, this swaps Details for Settings.
- The stack changes from Home and Details to Home and Settings, so Back returns to Home.
- Use it when the user should not return to the current screen, for example after a completed checkout.
- A `Drawer` is a side menu on a `Scaffold`; its items usually call `pushNamed` or `pushReplacementNamed`.

---

## Shared state — local state and app state

- Lecture 2: ephemeral state now; app-wide state later. This is later.
- Ephemeral (local) state belongs to one widget, for example the selected tab on one screen.
- App (shared) state is needed by many screens, for example a shopping cart, login details or user preferences.
- There is no clear-cut rule: data often starts local and becomes shared as the app grows.
- Ephemeral vs app state: [docs.flutter.dev/data-and-backend/state-mgmt/ephemeral-vs-app](https://docs.flutter.dev/data-and-backend/state-mgmt/ephemeral-vs-app)

---

## Shared state — one shared instance

- Local state is a field in a screen's `State` class, changed inside `setState`.
- App state lives outside the screens, in an object they can all reach.
- A private constructor and a `static final` instance make exactly one shared object (a singleton):

```dart
class Favourites {
  Favourites._internal();
  static final Favourites instance = Favourites._internal();

  final List<String> items = <String>[];
}
```

- Every screen uses `Favourites.instance`, so they all see the same list.
- Return an unmodifiable list if screens should not change the data directly.

---

## Shared state — data changes and rebuilds

- A singleton shares data; it does not automatically rebuild every screen.
- After changing the data, the visible screen calls `setState` so Flutter builds it again.
- Other screens read the latest data when they are next built.
- The data lives in memory only; it is lost when the app closes.
- The state management overview compares broader approaches: [docs.flutter.dev/data-and-backend/state-mgmt/intro](https://docs.flutter.dev/data-and-backend/state-mgmt/intro)

---

## Forms — collecting input

- A `TextField` collects text; a `TextEditingController` lets the screen read its current value.
- Create controllers in `initState` and release them in `dispose`.
- A `Switch` reports its new value to `onChanged`; store it in a field inside `setState`.

```dart
TextField(
  controller: _nameController,
  decoration: const InputDecoration(labelText: 'Name'),
);
```

- Other widgets for user input: [docs.flutter.dev/learn/pathway/tutorial/user-input](https://docs.flutter.dev/learn/pathway/tutorial/user-input)

---

## Forms — saving input

A save button's handler reads the current values:

```dart
void _save() {
  final String name = _nameController.text.trim();
  setState(() {
    _savedName = name;
  });
}
```

- `_nameController.text` holds what the user typed; the switch value is already in a field.
- Saving here keeps the values in memory; storing them between app launches comes later.
- To reject empty or invalid input, use `Form` and `TextFormField`: [docs.flutter.dev/cookbook/forms/validation](https://docs.flutter.dev/cookbook/forms/validation)

---

## Demo 3 (footnote)

- Union of Worksheet 5 and Worksheet 6 exercises: navigation, a basket, a profile form and saved bookings.
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

Run this live during the lecture to teach pull requests on GitHub. This continues from the branching demo in Lecture 3 and the merge conflict demo in Lecture 4. Pull requests are how teams review work before it is merged, in placements and in open-source projects. Do not mention the coursework or Southsea Cinema here; that is a footnote at the end.

### Setup

1. A pull request asks for one branch to be merged into another. Teammates review the changes before they are merged.
2. On GitHub, create an empty public repository called `pr-demo` (no README).
3. Create a fresh throwaway local repository and push it:

    ```bash
    mkdir pr-demo && cd pr-demo
    git init -b main
    echo "Hello" > greeting.txt
    git add greeting.txt
    git commit -m "docs: add greeting"
    git remote add origin https://github.com/YOUR-USERNAME/pr-demo.git
    git push -u origin main
    ```

### Part 1 — Opening a pull request

1. Create a branch and change the file on it:

    ```bash
    git checkout -b improve-greeting
    echo "Hello, everyone" > greeting.txt
    git add greeting.txt
    git commit -m "docs: improve greeting"
    git push -u origin improve-greeting
    ```

2. On GitHub, select **Compare & pull request**. Show that the base is `main` and the compare branch is `improve-greeting`.
3. Add a short title and description, then select **Create pull request**.
4. Key point: opening a pull request does not change `main`. Show `greeting.txt` on `main` still says "Hello".

### Part 2 — Reviewing and merging

1. Open the **Files changed** tab and leave a comment on the changed line, for example "Add a full stop".
2. Fix it on the same branch and push again:

    ```bash
    echo "Hello, everyone." > greeting.txt
    git add greeting.txt
    git commit -m "docs: add full stop to greeting"
    git push
    ```

3. Show that the new commit appears in the same pull request; there is no need to open another one.
4. Select **Merge pull request**, then **Confirm merge**.
5. Update the local copy and show the history:

    ```bash
    git checkout main
    git pull
    git log --oneline --graph --all
    ```

6. Key point: merging on GitHub does not change your local copy until you pull.

### Wrap-up

- A pull request proposes merging one branch into another and lets others review the changes first.
- Pushing more commits to the same branch updates the same pull request.
- Merge on GitHub, then pull to update your local copy.
- Encourage students to open a pull request in a throwaway repository to practise.
