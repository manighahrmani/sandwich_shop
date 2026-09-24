# Lecture 3 — Data Models, Repositories, and Navigation

> This mirrors `lecture-3.pptx`. Slides are minimal; detail lives in the worksheets and in what I say when each slide is shown. Update this file whenever the deck changes.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 3:

- Data models and separation of concerns
- Repositories and asset management
- In-page navigation

---

## Data models and separation of concerns — tech news

I need tech news from you! I will provide some of my own.

- Dart constructors and class syntax: [dart.dev/language/constructors](https://dart.dev/language/constructors)
- Flutter app architecture guide: [docs.flutter.dev/app-architecture/guide](https://docs.flutter.dev/app-architecture/guide)
- Widget of the Week: ListView: [Flutter YouTube channel](https://youtube.com/watch?v=KJpkjHGiI5A)

---

## Data models and separation of concerns

- Hardcoding data inside widget build methods makes code brittle and hard to maintain.
- Models: plain Dart classes defining the shape and properties of real-world entities.
- Immutability with `final` fields prevents accidental modification across the app.
- `const` constructors enable compile-time constants and efficient widget rebuilds.

---

## Separation of concerns — layers in Flutter

- Model: defines data structures.
- Repository: mediates between the UI and data sources.
- Views and widgets: present data and capture user gestures.
- Clean boundaries mean switching from mock data to a database or cloud API does not break your UI.

---

## Repositories and asset management

- The repository pattern abstracts data retrieval behind simple, testable methods.
- Serves as the single source of truth for application domain data.
- Starts with static mock lists; can later swap to SQLite or remote REST APIs.

---

## Assets and efficient lists

- Static assets (images, icons, fonts) are declared in `pubspec.yaml` under `assets:`.
- `Image.asset` loads bundled assets, with `BoxFit.cover` preventing distortion.
- `ListView.builder` renders rows lazily on demand as they scroll into view.
- Recycles items that move out of view, avoiding memory bloat compared to eager columns.

---

## In-page navigation

- Navigation in Flutter is stack-based and managed by the `Navigator`.
- `Navigator.push()` places a new route on top of the stack.
- `Navigator.pop()` removes the top route, revealing the previous screen underneath.
- `MaterialPageRoute` provides platform-appropriate transitions and automatic app bar back buttons.

---

## Demo 2 (footnote)

- Union of Worksheet 3 and Worksheet 4 exercises: home view with movie cards and navigation to dynamic listing.
- Demonstrate in your own timetabled practical session.
- Marked on functionality, code quality, and understanding through two random questions.
- Commit regularly: frequent, descriptive commits are evaluated as part of your demo quality mark.

---

## Module feedback

Give us your feedback, comments, criticisms, or insults by filling out the following form.

- It is anonymous; you need to sign in with your student account, but your details are not recorded.
- Use this link or the QR code: [forms.cloud.microsoft/e/88jd4UGAui](https://forms.cloud.microsoft/e/88jd4UGAui)

---

## Live demo guide (for the lecturer)

Run this live during the lecture to make the three topics concrete. Start from the sandwich shop app at branch 2 (the counter app in `main.dart`). Do not mention the coursework or Southsea Cinema here; that is a footnote at the end.

Open the project and run it:

```bash
flutter run -d chrome
```

### Part 1 — Data models and separation of concerns

1. Open `lib/main.dart`. Show that the item name `'Footlong'` is hardcoded directly into the widgets.
2. In `lib/models/sandwich.dart`, create a small immutable model class:

    ```dart
    class Sandwich {
      final String id;
      final String name;
      final double price;

      const Sandwich({
        required this.id,
        required this.name,
        required this.price,
      });
    }
    ```

3. Emphasise that `final` guarantees immutability, and `const` enables Flutter optimisations.

### Part 2 — Repositories and ListView

1. In `lib/repositories/sandwich_repository.dart`, create a simple mock repository:

    ```dart
    import 'package:sandwich_shop/models/sandwich.dart';

    class SandwichRepository {
      List<Sandwich> getSandwiches() {
        return const [
          Sandwich(id: 'footlong', name: 'Footlong Sub', price: 7.50),
          Sandwich(id: 'six-inch', name: 'Six-Inch Sub', price: 4.50),
        ];
      }
    }
    ```

2. Point out that the repository isolates where data comes from. Today it is a static list; tomorrow it could be a local SQLite database or cloud backend.
3. In `lib/main.dart`, show how `ListView.builder` takes `itemCount: sandwiches.length` and lazily renders items on demand via `itemBuilder`.

### Part 3 — Stack-based navigation

1. Show navigation using `Navigator.push()` with `MaterialPageRoute`:

    ```dart
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderScreen(sandwich: sandwich),
      ),
    );
    ```

2. Click an item in the running browser app: the screen transitions to the order screen.
3. Click the back arrow in the app bar: Flutter pops the top route off the navigation stack, returning to the menu.
4. Conclude: data flows down into screens via models; navigation flows up and down via the stack.
