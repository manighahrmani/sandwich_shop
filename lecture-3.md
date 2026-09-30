# Lecture 3 — Repositories and Assets

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
- Widget of the Week — ListView: [Flutter YouTube channel](https://youtube.com/watch?v=KJpkjHGiI5A)

---

## Data models and separation of concerns — feedback

Some feedback to address:

| Feedback | Response |
| --- | --- |
| "Giving us more time to complete worksheets and prepare for demos, taking into consideration our timetables and how some of us have a lot less time to complete them than others." | There is a retrieval of failure week in February in addition to ref/def (ref/def is in the summer). You can also do Demo 1 next week (and Demo 2 in the next demo window and so on). Drop-in session available. |
| "Please start caring about students' emotions." | See above. |
| "Explain all the terms we need to learn and all the concepts for the coursework following everything we've learned from the worksheets." | Have you read the worksheet? Should the worksheets be more verbose? Should I do anything in the lecture? |
| "Keep more educated teacher." | What? |

---

## Data models and separation of concerns

- Dart files are code. If data (for example names of movies or ticket prices) are stored in Dart files, the data is hardcoded.
- Hardcoded data lives inside widget build methods. It makes code hard to maintain.
- For example, if inflation increases all prices by 20%, we need to update every file that lists the price of tickets.
- In companies we have different kinds of employees; some know how to edit code, others are only familiar with data (for example SQL).

---

## Data models and separation of concerns — models

- We need models. Models are plain Dart classes defining the shape and properties of real-world entities.
- Models roughly translate to SQL tables; they are essentially Python classes.
- Models can introduce immutability with `final` fields (it prevents accidental modification across the app).
- `const` constructors enable compile-time constants and efficient widget rebuilds.

---

## Separation of concerns — layers in Flutter

- Model: defines data structures.
- Repository: sits between the UI and data.
- Views and widgets: present data, capture user input.
- Having this separation, putting these boundaries, means that switching from mock data to a database or cloud services does not break the UI.
- See the diagrams here: [docs.flutter.dev/app-architecture/guide](https://docs.flutter.dev/app-architecture/guide)

---

## Repositories and asset management

- The term "repository" here is different from a GitHub repository.
- In Flutter, a repository abstracts data retrieval behind simple, testable methods.
- The repositories of your app act as the single source of truth for application data.
- They usually start with static mock lists; they can later swap to SQL databases or remote REST APIs to external services.

---

## Assets and efficient lists

- Static assets (images, videos, icons, fonts) are declared in `pubspec.yaml` under `assets:`.
- They must be registered before they can be used.
- `Image.asset` loads bundled assets with `BoxFit.cover` preventing distortion.
- `ListView.builder` renders rows lazily on demand as they scroll into view.
- More information on this is found on the worksheet.

---

## In-page navigation

- Navigation means moving between pages. You can navigate using the index (for example URL to apps), or you can implement in-page navigation.
- This method of navigation in Flutter is stack-based. Stack like a stack of books or plates.
- Navigation is managed by the `Navigator` class.
- `Navigator.push()` places a new route on top of the stack.
- `Navigator.pop()` removes the top route, revealing the previous screen underneath.
- `MaterialPageRoute` provides platform-appropriate transitions and automatic app bar back buttons.

---

## Demo 2 (footnote)

- Union of Worksheet 3 and Worksheet 4 exercises: home view with movie cards and navigation to dynamic listing. Also unit tests and widget tests covering almost all of your codebase.
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

Run this live during the lecture to teach Git branching and merging. These are transferable skills that students need for collaborative development, placement interviews, and any future software project. Do not mention the coursework or Southsea Cinema here; that is a footnote at the end.

### Setup

1. Create a fresh throwaway repository for the demo (or use any small repository that is not the coursework). This avoids confusion between teaching material and student work.

    ```bash
    mkdir git-demo && cd git-demo
    git init
    ```

2. Create a simple file and make an initial commit:

    ```bash
    echo "# Git branching demo" > README.md
    git add README.md
    git commit -m "docs: add README"
    ```

### Part 1 — Creating and switching branches

1. Explain that `main` is the default branch. Show it:

    ```bash
    git branch
    ```

2. Create a new branch called `feature` and switch to it:

    ```bash
    git checkout -b feature
    ```

3. Show that `git branch` now lists both branches with `feature` highlighted.

4. Add a new file on the `feature` branch:

    ```bash
    echo "This is a new feature." > feature.txt
    git add feature.txt
    git commit -m "feat: add feature file"
    ```

5. Switch back to `main` and show that `feature.txt` does not exist there:

    ```bash
    git checkout main
    ls
    ```

6. Key point: branches let you work on something without affecting `main`. Each branch is an independent line of development.

### Part 2 — Merging a branch

1. While on `main`, merge the `feature` branch:

    ```bash
    git merge feature
    ```

2. Show that `feature.txt` now exists on `main`. The merge brought the changes in.

3. Show the log to visualise the history:

    ```bash
    git log --oneline --graph --all
    ```

4. Key point: merging combines the work from one branch into another. In a team, each person works on their own branch and merges when the feature is ready.

5. Optionally show [learngitbranching.js.org](https://learngitbranching.js.org) on the projector for a visual explanation of what just happened.

### Wrap-up

- Branches isolate work. Merging brings it together.
- Conflict resolution (what happens when two branches edit the same line) will be covered in the next lecture.
- Encourage students to practise by creating branches in their own coursework repositories.
