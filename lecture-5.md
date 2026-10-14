# Lecture 5 — Navigation, State and Forms

> This mirrors `finalised/lecture-5.pptx`. Slides are minimal; detail lives in the worksheets and in what I say when each slide is shown. Update this file whenever the deck changes.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 5:

- Navigation
- Shared state
- Forms

---

## Navigation — tech news

I need tech news from you! I will provide some of my own.

- [Flutter 3.44](https://flutter.dev/blog/whats-new-in-flutter-3-44) includes experimental Widget Previews and improvements to DevTools.
- [Dart 3.12](https://dart.dev/blog/announcing-dart-3-12) brings new language and tooling updates.
- Which new tools or updates would make building and checking interfaces easier?

---

## Navigation

---

## Navigation — moving between screens

- Flutter's `Navigator` manages a stack of routes.
- `Navigator.push` adds a route; `Navigator.pop` returns to the previous one.
- This works well for a detail screen that should have a back button.
- [Flutter's navigation and routing guide](https://docs.flutter.dev/ui/navigation) explains the wider navigation options.

---

## Navigation — top-level sections

- A drawer gives the app consistent links to its main sections.
- Add a `Drawer` to a `Scaffold`; Flutter supplies the menu button.
- Register named routes in `MaterialApp` to connect route names to screens.
- `Navigator.pushReplacementNamed` changes the current top-level screen without stacking another copy.

---

## Shared state

---

## Shared state — local state and shared data

- A quantity on the order screen is local state; `setState` rebuilds that screen when it changes.
- Basket items must remain available when you leave the order screen.
- Keep shared basket data outside an individual screen so each screen can read the same source.
- The [Flutter app architecture guide](https://docs.flutter.dev/app-architecture/guide) explains how repositories separate data work from the interface.

---

## Shared state — one repository instance

- `CartRepository` owns the basket operations and data.
- A private constructor and `static final` instance make one shared `CartRepository`.
- Order and basket screens use `CartRepository.instance` to add, read or remove items.
- Return an unmodifiable list so screens cannot change the repository's data directly.

---

## Shared state — data changes and rebuilds

- A singleton shares data; it does not automatically rebuild every screen.
- After changing the basket, the visible screen calls `setState` so Flutter builds it again from the repository.
- The [state management overview](https://docs.flutter.dev/data-and-backend/state-mgmt/intro) compares broader approaches; this worksheet uses a plain Dart singleton.

---

## Forms

---

## Forms — collecting input

- A `TextField` collects text; a `TextEditingController` lets the screen read its current value.
- Create controllers in `initState` and release them in `dispose`.
- A `Switch` reports its new boolean value to `onChanged`; use `setState` to update the screen.
- The [Flutter user input pathway](https://docs.flutter.dev/learn/pathway/tutorial/user-input) covers these ideas.

---

## Forms — saving settings

- The save handler reads the controllers and switch, then creates a `UserSettings` object.
- Keep settings immutable with `final` fields; use `copyWith` to create an updated object.
- Saving the object is separate from storing it between app launches, which comes later.
- Wrap a long form in `SingleChildScrollView` so its fields remain reachable when the keyboard is open.

---

## Demo 3 (footnote)

- Demo 3 assesses the Worksheet 5 and Worksheet 6 exercises.

---

## Module feedback

Give us your feedback, comments, criticisms, or insults by filling out the following form.

- It is anonymous; you need to sign in with your student account, but your details are not recorded.
- Use this link or the QR code: [forms.cloud.microsoft/e/88jd4UGAui](https://forms.cloud.microsoft/e/88jd4UGAui)

---

## Live demo

- Follow one order from the order screen into the basket.
- Identify the shared repository and the `setState` calls that refresh each screen.

---

## Live demo guide (for the lecturer)

Use the Sandwich Shop app at the end of Worksheet 5. Trace one order through the app to show how local state and shared repository data work together.

### Setup

1. Open the project at its Worksheet 5 end state and run it in Chrome.
2. Make sure the basket is empty before the demo.

### Follow an order

1. Open a sandwich order screen and increase its quantity. Point out that this quantity belongs to that screen and changes inside `setState`.
2. Add the sandwich to the basket. In `lib/screens/order_screen.dart`, show that `_addToBasket` writes through `CartRepository.instance.addItem`.
3. Open the basket screen and show the same item and its total. In `lib/repositories/cart_repository.dart`, show the private constructor, shared `instance` and basket list.
4. Remove the item or check out. In `lib/screens/basket_screen.dart`, show that `setState` runs after the repository changes so the screen rebuilds with the updated data.

### Wrap-up

- The order screen owns its quantity; the repository owns basket data shared by screens.
- `setState` rebuilds the current screen, while the singleton provides the common data source.
