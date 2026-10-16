# Lecture 5 — Navigation, State and Forms

> This mirrors `past_lectures/lecture-5.pptx`. Slides are minimal; detail lives in the worksheets and in what I say when each slide is shown. Update this file whenever the deck changes.

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
- Azure for students: [azure.microsoft.com/en-us/free/students](https://azure.microsoft.com/en-us/free/students)

---

## Navigation — moving between screens

- Flutter's `Navigator` manages a stack of routes.
- A route represents a screen.
- The last route added is the visible one.
- `Navigator.push` adds a route. `Navigator.pop` returns to the previous one.
- This works well for a screen that should have a back button.
- Flutter's navigation and routing guide explains the wider navigation options: [docs.flutter.dev/ui/navigation](https://docs.flutter.dev/ui/navigation)

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
- Repeated pushes create repeated copies of a screen (the worksheet shows how to stop this).
- Flutter recommends other approaches too: [Navigation and routing](https://docs.flutter.dev/ui/navigation#using-named-routes)

---

## Navigation — replacing a route

Sometimes Back should not return to the current screen. E.g., after logging in, Back should not reopen the login form.

Here's a button on `LoginScreen`:

```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushReplacementNamed(
      context, '/home'
    );
  },
  child: const Text('Log in'),
);
```

Suppose the stack is Welcome, Login:

- `pushNamed(context, '/home')` keeps Login underneath: the stack becomes Welcome, Login, Home, so Back is Login.
- `pushReplacementNamed(context, '/home')` swaps Login for Home. Stack would be Welcome, Home, so Back is Welcome.

---

## Shared state — local state and shared data

- In lecture 2 we covered ephemeral state
- Now we have app-wide state.
- Ephemeral (local) state belongs to one widget
- For example, the selected tab on one screen or a text showing a number of sandwich emojis.
- App (shared) state is needed by many screens.
- For example, a shopping cart, login details, or user preferences.
- There is no clear-cut rule: data often starts local and becomes shared as the app grows.
- More detail: [Differentiate between ephemeral state and app state](https://docs.flutter.dev/data-and-backend/state-mgmt/ephemeral-vs-app)

---

## Shared state — one shared instance

- Local state is a field in a screen's `State` class, changed inside `setState`.
- App state lives outside the screens, in an object they can all reach.
- A private constructor and a `static final` instance make exactly one shared object (a singleton):

```dart
class Favourites {
  Favourites._internal();
  static final Favourites instance =
    Favourites._internal();
  final List<String> items = <String>[];
}
```

- `Favourites._internal()` is a named constructor, blocking other files to instantiate.
- Every screen uses `Favourites.instance`, so they all see the same list.
- Return an unmodifiable list if screens should not change the data directly.

---

## Shared state — one shared instance (continued)

- A singleton shares data; it does not automatically rebuild every screen.
- After changing the data, the visible screen calls `setState` so Flutter builds it again.
- Other screens read the latest data when they are next built.
- The data lives in memory only; it is lost when the app closes. (We'll talk about persistence in the next lecture)
- The state management page below compares other approaches: [State management](https://docs.flutter.dev/data-and-backend/state-mgmt/intro)

---

## Forms — collecting input

- Text: `TextField`, read through a `TextEditingController`. See examples here: [pub.dev/documentation/material_ui/latest/material_ui/TextField-class](https://pub.dev/documentation/material_ui/latest/material_ui/TextField-class.html)
- On or off: `Switch` or `Checkbox`.

```dart
Switch(
  value: _notifications,
  onChanged: (bool newValue) {
    setState(() {
      _notifications = newValue;
    });
  },
)
```

- A number in a range: `Slider`.
- One option from a list: `DropdownMenu` or `SegmentedButton`.
- A date: `showDatePicker` opens a calendar.
- Flutter's selection widgets: [Material component widgets](https://docs.flutter.dev/ui/widgets/material)

---

## Forms — saving input

A save button's handler like the one below can read the current values:

```dart
void _save() {
  final String name = _nameController.text;
  setState(() {
    _savedName = name;
  });
}
```

- `_nameController.text` holds what the user typed; the switch value is already in a field.
- Saving here keeps the values in memory; in Worksheet 6 we'll see storing values between app launches (persistence).
- To reject empty or invalid input, use `Form` and `TextFormField`: [Build a form with validation](https://docs.flutter.dev/cookbook/forms/validation)

---

## Demo 3 (footnote)

- Union of Worksheet 5 and Worksheet 6 exercises: navigation, a basket, a profile form and saved bookings.
- More on SQL databases and emulators next week too.
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

Run this live during the lecture to teach pull requests on GitHub. We continue from the branching demo in Lecture 3 and the merge conflict demo in Lecture 4. Pull requests are how teams review work before it is merged. Do not mention the coursework or Southsea Cinema here; that is a footnote at the end.

- For a video tutorial on PRs in VS Code: [Pull Requests in VS Code](https://www.youtube.com/watch?v=LdSwWxVzUpo)
- Or for an interactive tutorial on GitHub: [skills/review-pull-requests: Collaborate and work together on GitHub.](https://github.com/skills/review-pull-requests)

### Setup

1. On GitHub, create an empty public repository called `pr-demo` (no README).
2. Create a fresh throwaway local repository and push it:

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

2. On GitHub, select **Compare & pull request**. See that the base is `main` and the compare branch is `improve-greeting`.
3. Add a short title and description, then select **Create pull request**.
4. Note that opening a pull request does not change `main`. See that `greeting.txt` on `main` still says "Hello".

### Part 2 — Reviewing and merging

1. Open the **Files changed** tab and leave a comment on the changed line, for example "Add a full stop".
2. Fix the issue mentioned in this comment on the same branch and push again:

    ```bash
    echo "Hello, everyone." > greeting.txt
    git add greeting.txt
    git commit -m "docs: add full stop to greeting"
    git push
    ```

3. See that the new commit appears in the same pull request; there is no need to open another one.
4. Select **Merge pull request**, then **Confirm merge**.
5. Update the local copy and show the history:

    ```bash
    git checkout main
    git pull
    git log --oneline --graph --all
    ```

6. In summary, merging on GitHub does not change your local copy until you pull.

### Wrap-up

- A pull request proposes merging one branch into another and lets others review the changes first.
- Pushing more commits to the same branch updates the same pull request.
- Merge on GitHub, then pull to update your local copy.
- Encourage students to open a pull request in a throwaway repository to practise.
