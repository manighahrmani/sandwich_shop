# Southsea Cinema Coursework Brief

<!--
TODO: The previously downloaded Union Shop coursework .docx could not be
located anywhere in this workspace, so its structure/content is not yet
merged into this brief. Once you provide that file, merge in any sections
(e.g. a formal cover page, learning outcomes wording, or rubric layout)
that should carry over, then convert this file to
"Flutter Coursework.docx" for the southsea_cinema-specific brief.
-->

**Modules**: Programming Applications and Programming Languages (M30235) and User Experience Design and Implementation (M32605)

**Item**: Item 1 (50% of the module mark)

## Overview

Your task is to recreate a mobile-friendly version of the Southsea Cinema website using Flutter. You must fork the [southsea_cinema starter repository](https://github.com/manighahrmani/southsea_cinema), then build your own version of the app step by step as you work through the weekly worksheets on the [Flutter Course homepage](https://manighahrmani.github.io/sandwich_shop/).

Reference website: [Southsea Cinema](https://southseacinema.savoysystems.co.uk/SouthseaCinema.dll/)

The starter app is deliberately minimal. It contains only a basic theme, an empty home page, a small drawer, and a default widget test. You are expected to add screens, widgets, data models, tests, persistence, and cloud services during the coursework.

## Assessment Structure

Item 1 is assessed entirely through 5 demo checkpoints of your Southsea Cinema coursework. There is no separate sign-off or coursework submission for Item 1: the demos are continuous assessment of the same coursework you build throughout the term.

### Schedule

| Week Commencing | Week Ending | Worksheet | Lecture | Demo |
| --------------- | ----------- | --------- | ------- | ---- |
| 14/09/2026 | 18/09/2026 | Worksheet 0 | Lecture 0 | Demo 1 |
| 21/09/2026 | 25/09/2026 | Worksheet 1 | Lecture 1 | |
| 28/09/2026 | 02/10/2026 | Worksheet 2 | Lecture 2 | |
| 05/10/2026 | 09/10/2026 | Worksheet 3 | Lecture 3 | Demo 2 |
| 12/10/2026 | 16/10/2026 | Worksheet 4 | Lecture 4 | |
| 19/10/2026 | 23/10/2026 | Worksheet 5 | Lecture 5 | Demo 3 (opens) |
| 26/10/2026 | 30/10/2026 | **Reading Week** | | |
| 02/11/2026 | 06/11/2026 | Worksheet 6 | Lecture 6 | Demo 3 (closes) |
| 09/11/2026 | 13/11/2026 | Worksheet 7 | Lecture 7 | Demo 4 |
| 16/11/2026 | 20/11/2026 | Worksheet 8 | Lecture 8 | |
| 23/11/2026 | 27/11/2026 | Worksheet 9 | Lecture 9 | Demo 5 |
| 30/11/2026 | 04/12/2026 | Worksheet 10 | Lecture 10 | |

Demo 3 is a single checkpoint with a two-week window either side of Reading Week.

### Demos (50%, 10% per demo)

At each demo, a member of staff checks your progress and asks you a few questions about your own code. Each demo is marked out of 10 (10% of the module):

* **Functionality (0-4)**: does the app implement the features expected by this point in the schedule? Extra marks are available if you have progressed further than expected.
* **Quality (0-2)**: code quality on inspection (naming and formatting early on, structure and separation of concerns later).
* **Understanding (0-4)**: your answers to a few questions about your own code and decisions.

The exact expectations for each demo are listed in the corresponding worksheet and in the demo issue on [the sandwich_shop repository's Issues tab](https://github.com/manighahrmani/sandwich_shop/issues).

If you use Firebase or another cloud service in your coursework, you must host the app live and provide the URL at the demo so it can be checked without needing your API keys.

## Getting Started

### Prerequisites

You need:

* A GitHub account
* A way to edit and run Flutter projects
* Git installed and connected to your GitHub account

You have three development options:

1. GitHub Codespaces (browser-based, no local install required)
2. University Windows computers
3. Your own computer

The worksheets on the [Flutter Course homepage](https://manighahrmani.github.io/sandwich_shop/) explain these options in more detail.

### Fork and Clone the Repository

1. Open [the southsea_cinema repository](https://github.com/manighahrmani/southsea_cinema) and click **Fork**. Leave the default options as they are (do not change the repository name) and click **Create fork**. Your fork should be called `southsea_cinema`.
2. Clone your forked repository:

    ```bash
    git clone https://github.com/YOUR-USERNAME/southsea_cinema.git
    cd southsea_cinema
    ```

    Replace `YOUR-USERNAME` with your GitHub username.

3. Install dependencies:

    ```bash
    flutter pub get
    ```

### Run the Application

This coursework targets Flutter Web. Use Chrome or Edge:

```bash
flutter run -d chrome
```

or:

```bash
flutter run -d edge
```

### Use Mobile View

The coursework should be designed mobile-first. In Chrome or Edge:

1. Right-click the page and choose **Inspect**.
2. Click the **Toggle device toolbar** button.
3. Choose a phone-sized device preset from the dropdown menu.

## Project Structure

The starter repository is intentionally small:

```text
southsea_cinema/
├── lib/
│   ├── constants.dart          # Shared colours, text styles, and app title
│   ├── main.dart               # Main app and route setup
│   ├── views/
│   │   └── home_view.dart      # Starter home page
│   └── widgets/
│       └── nav_drawer.dart     # Minimal starter drawer
├── test/
│   └── widget_test.dart        # Basic widget test
├── pubspec.yaml                # Project dependencies
└── README.md                   # This file
```

You will add more files and folders as the coursework develops.

## Submission

You will submit the link to your public forked repository on Moodle when instructed. You are not submitting a zip file or a copy of the source code.

Make sure your repository is public. Test this by opening your repository link in a private/incognito browser window.

## Demonstration

During each demo, you must be able to run your app and answer questions about your code. Before attending a demo, check that the app runs from a clean clone:

```bash
flutter pub get
flutter run -d chrome
```

## Referral/Deferral Assessment

More information about what referral/deferral are will be provided later in Moodle. Referral/deferral dates are on [the University Key Dates page](https://www.port.ac.uk/about-us/key-dates).

The referral/deferral assessment for this Flutter Course is a coursework that you need to complete during the referral/deferral period. This coursework is **not** the same as the coursework brief above. It will be added to Moodle nearer the time.

## Extenuating Circumstances

If there are external reasons stopping you from engaging with the module, submit an [Extenuating Circumstances Form (ECF)](https://myport.port.ac.uk/my-course/exams/extenuating-circumstances) as soon as you can and notify a member of staff when your ECF is approved.

Note that ECFs apply to the whole Item 1 (the entire Flutter Course, 50% of the module). You cannot use an ECF just for individual demos.

Also note that if your ECF is approved, any demo marks you already have will not be counted. Instead, you will be expected to take the deferral assessment in July and your Item 1 mark will come from that deferral coursework alone (not from the demos above).

If you do not have an ECF or it is not approved, you will receive all the demo marks you have completed.

## Getting Help

Use the worksheets on the [Flutter Course homepage](https://manighahrmani.github.io/sandwich_shop/) as your main guide.

To get support with this coursework, follow [discord_flutter.pptx](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and ask your question in the **Flutter** channel. Otherwise, attend your timetabled practical session and ask a member of staff for help.

If you get stuck:

* Ask for help in your practical session
* Post in the Flutter channel on Discord
* Check that your app still runs before making more changes
* Commit your work regularly with clear commit messages

Use AI tools carefully. You are allowed to use them, but you must understand, review, and adapt any generated code before adding it to your coursework.
