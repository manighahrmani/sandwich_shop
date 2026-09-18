# Lecture 2 — Declarative UI and Widgets

> This mirrors `lecture-2.pptx`. Slides are minimal; detail lives in the worksheets and in what I say when each slide is shown. Update this file whenever the deck changes.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 2:

- Everything is a widget
- Declarative UI
- Stateless vs stateful
- Demo 1 reminder

---

## Recap

- Worksheet 1: Dart, Git, GitHub, Flutter, coursework fork.
- This week: [Worksheet 2 — Stateless and Stateful Widgets](./worksheet-2.md).

---

## Everything is a widget

- The UI is a tree of widgets.
- Text, buttons, padding, layout, the whole screen: all widgets.
- You build screens by composing small widgets, not by editing one big file.

- Widget of the Week: [youtube.com/playlist](https://youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)

---

## Declarative UI

- You describe what the UI should look like for the current data.
- You do not manually mutate the screen; you change the data and rebuild.
- Contrast with the imperative style you may know from other frameworks.

- Reading: [docs.flutter.dev/get-started/fundamentals/widgets](https://docs.flutter.dev/get-started/fundamentals/widgets)

---

## Stateless vs stateful

- Stateless: fixed once built (a snapshot).
- Stateful: holds data that changes over time and rebuilds itself.
- Ephemeral state now; app-wide state later.

- [StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)
- [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)

---

## setState in one line

- Change the data inside `setState`, and Flutter rebuilds.
- Change it without `setState`, and the screen does not update.

- [Add interactivity](https://docs.flutter.dev/ui/interactivity)

---

## Composition and layout

- Small widgets combine into bigger ones (`Column`, `Row`, `Container`).
- Reuse: your own widgets take parameters, like a function.

- [Layout](https://docs.flutter.dev/get-started/fundamentals/layout)
- [Widget fundamentals tutorial](https://docs.flutter.dev/learn/pathway/tutorial/widget-fundamentals)

---

## Demo 1

- Union of Worksheet 1 and Worksheet 2 exercises: a movie listing page.
- Complete by Friday 2 October 2026, but demo in your own timetabled practical (check your timetable; not all sessions are on a Friday).
- Marked on functionality, quality, and understanding of your own code.
- I will ask two questions about your code, chosen at random, during the demo.

---

## Module feedback

Give us your feedback, comments, criticisms, or insults by filling out the following form.

- It's anonymous; you need to sign in via your student account, but your details aren't recorded.
- Use this link or the QR code: [forms.cloud.microsoft/e/88jd4UGAui](https://forms.cloud.microsoft/e/88jd4UGAui)
