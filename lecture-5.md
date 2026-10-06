# Lecture 5 — Navigation, Data, and Forms

> This mirrors `lecture-5.pptx`. Slides are minimal; detail lives in the worksheets and in what I say when each slide is shown. Update this file whenever the deck changes.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 5:

- Multi-screen navigation
- Loading and sharing data
- User input and forms

---

## Multi-screen navigation — tech news

I need tech news from you! I will provide some of my own.

- Named routes and the Navigator: [docs.flutter.dev/ui/navigation](https://docs.flutter.dev/ui/navigation)
- Widget of the Week on the `Drawer`: [youtube.com/watch](https://www.youtube.com/watch?v=WRj86iHihgY)
- Parsing JSON in Flutter: [docs.flutter.dev/data-and-backend/serialization/json](https://docs.flutter.dev/data-and-backend/serialization/json)

---

## Multi-screen navigation

- Worksheet 3 used `Navigator.push` to stack a route on top and show a back arrow.
- That suits a detail screen you return from, but not top-level sections.
- A navigation drawer gives a consistent panel of links on every screen.
- A `Drawer` works directly with the `drawer` property of `Scaffold`.
- When a `Scaffold` has a `drawer`, Flutter adds the hamburger button automatically.

---

## Named routes

- Instead of writing `MaterialPageRoute` each time, register string paths in `MaterialApp`.
- Paths such as `'/'`, `'/cart'`, and `'/settings'` live in the `routes` map.
- `Navigator.pushReplacementNamed` swaps the current route rather than stacking it.
- Primary sections then never accumulate back arrows.
- Push stacks and returns; replace swaps and stays flat.

---

## Loading and sharing data — loading from JSON

- Hardcoding a menu in Dart means recompiling for every data change.
- Store the catalogue in a JSON asset and register the folder in `pubspec.yaml`.
- `rootBundle.loadString` reads the bundled file into a string at runtime.
- `jsonDecode` from `dart:convert` turns that string into Dart lists and maps.
- A `factory` constructor named `fromJson` builds a model from a decoded map.

---

## Loading and sharing data — sharing state

- Each screen builds its own widgets, so a basket added on one screen is invisible on another.
- We need one shared in-memory basket every screen reads from.
- The singleton pattern gives a class exactly one instance.
- A private `._internal()` constructor stops other code constructing it.
- A `static final instance` field exposes the one instance via `CartRepository.instance`.
- This is the plain-Dart pattern; we import no package for it.

---

## Loading and sharing data — the next step

- The singleton is enough for one small basket shared across screens.
- Larger apps often want widgets to rebuild automatically when the data changes.
- Flutter's own pathway introduces `ChangeNotifier` for exactly this.
- Set up a state project: [docs.flutter.dev/learn/pathway/tutorial/set-up-state-project](https://docs.flutter.dev/learn/pathway/tutorial/set-up-state-project)
- Use `ChangeNotifier`: [docs.flutter.dev/learn/pathway/tutorial/change-notifier](https://docs.flutter.dev/learn/pathway/tutorial/change-notifier)

---

## User input and forms

- A `TextField` captures typed text; a `TextEditingController` holds and reads its value.
- Create the controller in `initState`, the lifecycle method that runs once before the first `build`.
- Mark the field `late` so a non-nullable controller is assigned there rather than at declaration.
- Release it in `dispose`, the lifecycle method that runs when the `State` leaves the tree.
- A `Switch` is an on/off toggle whose `onChanged` callback reports the new boolean.
- Flutter's user-input pathway walks through the same pattern: [docs.flutter.dev/learn/pathway/tutorial/user-input](https://docs.flutter.dev/learn/pathway/tutorial/user-input)

---

## User input and forms — immutable settings

- Keep model fields `final` so a settings object cannot be changed in place.
- A `copyWith` method returns a new instance, reusing current values except the ones you pass.
- The `??` null-coalescing operator picks the right-hand value when the left is null.
- This keeps edits predictable: nothing mutates until you deliberately build a new object.

---

## Test yourself (for the lecturer)

- The pathway tutorials above include a "Test yourself" step at the end of each page.
- Run the set-up-state and `ChangeNotifier` steps as a live demo, or set them as a between-lectures exercise.
- Frame `ChangeNotifier` as the next step beyond the singleton students just built.
- The user-input page pairs with the settings form in Worksheet 5.

---

## Demo 3 (footnote)

- Union of the Worksheet 5 and Worksheet 6 exercises: a drawer-navigated app with a basket, a settings form, and persisted order history.
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

Run this live during the lecture to show how a drawer, named routes, and a shared basket fit together. Start from the Sandwich Shop app at the end of Worksheet 4. Do not mention the coursework or Southsea Cinema here; that is a footnote at the end.

### Setup

1. Open the Sandwich Shop project at its Worksheet 4 end state in VS Code.
2. Run the app so students see the single menu screen before any navigation exists.
3. Point out that there is no way yet to move between sections.

### Part 1 — Add a navigation drawer

1. Create `lib/widgets/nav_drawer.dart` and build a small `Drawer` with a header and one `ListTile`.
2. Attach it to the menu screen with `drawer: const NavDrawer()`.
3. Hot reload and show the hamburger button appearing automatically in the app bar.
4. Open the drawer to show the panel sliding in.

### Part 2 — Register named routes

1. In `lib/main.dart`, add a `routes` map to `MaterialApp` with `'/'` and one more path.
2. In a drawer `ListTile`, call `Navigator.pushReplacementNamed(context, '/cart')` from `onTap`.
3. Hot reload, tap the tile, and show the screen swapping with no back arrow.
4. Contrast this with `Navigator.push` from Worksheet 3, which would have stacked a back arrow.

### Part 3 — Share a basket with a singleton

1. Create `lib/repositories/cart_repository.dart` with a private `._internal()` constructor.
2. Add `static final CartRepository instance = CartRepository._internal();` and a private `_items` list.
3. Add an `addItem` method and a `getItems` method.
4. From the order screen, call `CartRepository.instance.addItem(...)`, then read the same list on the basket screen.
5. Add an item on one screen, navigate to the basket, and show it is there — one shared instance.

### Wrap-up

- A `Drawer` plus named routes gives flat, top-level navigation with no stacking.
- A singleton shares one in-memory basket across every screen.
- Loading the menu from JSON and capturing input with controllers are the worksheet's next steps.
- Encourage students to build the full drawer, basket, and settings form by following Worksheet 5.
