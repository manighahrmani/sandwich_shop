# Lecture 2 — Declarative UI

> This mirrors `lecture-2.pptx`. Slides are minimal; detail lives in the worksheets and in what I say when each slide is shown. Update this file whenever the deck changes.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 2:

- Everything is a widget
- Declarative UI
- Stateless vs stateful

---

## Everything is a widget — tech news

I need tech news from you! I will provide some of my own.

- Git branches, visually and interactively: [learngitbranching.js.org](https://learngitbranching.js.org)
- Resolving merge conflicts in VS Code: [code.visualstudio.com/docs/sourcecontrol/merge-conflicts](https://code.visualstudio.com/docs/sourcecontrol/merge-conflicts)
- How Flutter hot reload works: [docs.flutter.dev/tools/hot-reload](https://docs.flutter.dev/tools/hot-reload)
- Widget of the Week: [youtube.com/playlist](https://youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)

---

## Everything is a widget

- Text, buttons, padding, layout, the whole screen: all widgets.
- You build screens by composing small widgets, not by editing one big file.
- The UI is a tree of widgets.

- Widget fundamentals tutorial: [Create widgets](https://docs.flutter.dev/learn/pathway/tutorial/widget-fundamentals)

---

## Everything is a widget — composition and layout

- Small widgets combine into bigger ones (`Column`, `Row`, `Container`).
- Reuse your own widgets; they take parameters too, like a function.

- Layout: [Flutter learning pathway](https://docs.flutter.dev/learn/pathway/tutorial/layout)
- Widget of the Week: [youtube.com/playlist](https://youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)

---

## Declarative UI

- You describe what the UI should look like for the current data.
- You do not manually mutate the screen; you change the data and rebuild.

- All of this sounds very abstract. You learn it more easily by doing the worksheets, or by trying my new favourite website: [docs.flutter.dev/learn/pathway](https://docs.flutter.dev/learn/pathway)

---

## Stateless vs stateful

- Stateless: fixed once built (a snapshot).
- Stateful: holds data that changes over time and rebuilds itself.
- Ephemeral state now; app-wide state later.

- Ephemeral vs app state: [docs.flutter.dev/data-and-backend/state-mgmt/ephemeral-vs-app](https://docs.flutter.dev/data-and-backend/state-mgmt/ephemeral-vs-app)

---

## Stateless vs stateful — setState

- Change the data inside `setState`, and Flutter rebuilds.
- Change it without `setState`, and the screen does not update.

- [StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)
- [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
- Adding interactivity: [docs.flutter.dev/ui/interactivity](https://docs.flutter.dev/ui/interactivity)

---

## Demo 1 (footnote)

- Union of Worksheet 1 and Worksheet 2 exercises: a movie listing page.
- Complete by the week ending Friday 2 October 2026.
- Demo in your own timetabled practical (you will not get marks if you attend a different session).
- Marked on functionality, quality, and understanding of your own code.
- I will ask two questions about your code, chosen at random, during the demo. You will find these easy if you have done the coding yourself.

---

## Module feedback

Give us your feedback, comments, criticisms, or insults by filling out the following form.

- It's anonymous; you need to sign in via your student account, but your details aren't recorded.
- Use this link or the QR code: [forms.cloud.microsoft/e/88jd4UGAui](https://forms.cloud.microsoft/e/88jd4UGAui)

---

## Live demo guide (for the lecturer)

Run this live during the lecture to make the three topics concrete. Start from the sandwich shop app as it stands at the end of Worksheet 1 (the default counter app). Do not mention the coursework or Southsea Cinema here; that is a footnote at the end.

Open the project and run it:

```bash
flutter run -d chrome
```

### Part 1 — Everything is a widget

1. Open the Widget Inspector (Command Palette, `Flutter: Open DevTools`, then the Widget Inspector tab).
2. Turn on Select Widget Mode and click the counter number in the running app. Walk the tree up: `Text` inside `Center` inside `Scaffold` inside `MaterialApp`.
3. Point out that even the whole screen is just a widget made of smaller widgets.

### Part 2 — Declarative UI

1. In `main.dart`, change the `AppBar` title text, save, and hot reload. The UI updates because you changed the description, not the screen directly.
2. Change `colorScheme` seed colour (for example `Colors.deepPurple` to `Colors.orange`), save, hot reload. Same idea: new data in, Flutter rebuilds.
3. Say the line: you never reach in and repaint pixels; you describe the UI for the current data and Flutter redraws.

### Part 3 — Stateless vs stateful

1. Show `_MyHomePageState` and the `_counter` field. Press the button; the number goes up because `_incrementCounter` calls `setState`.
2. Temporarily remove the `setState` wrapper (just do `_counter++;`), save, hot reload. Press the button: the value changes in memory but the screen does not update. Put `setState` back.
3. To show composition and reuse, add a tiny stateless widget above `main` and drop it into the `Column`:

    ```dart
    class Greeting extends StatelessWidget {
      final String name;

      const Greeting(this.name, {super.key});

      @override
      Widget build(BuildContext context) {
        return Text('Hello, $name!');
      }
    }
    ```

    Use it with `const Greeting('everyone'),` and hot reload. Point out it takes a parameter, like a function, and can be reused.

4. Wrap up: stateless widgets are a snapshot; stateful widgets hold changing data and rebuild with `setState`.
