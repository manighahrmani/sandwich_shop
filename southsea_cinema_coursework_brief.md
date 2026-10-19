# Southsea Cinema — Flutter Coursework

School of Computing, Mathematics and Physics 2026/27

| | |
| --- | --- |
| Module Title and Code | **PROGRAMMING APPLICATIONS AND PROGRAMMING LANGUAGES - M30235 - FHEQ 5** <br> **USER EXPERIENCE DESIGN AND IMPLEMENTATION - M32605 - FHEQ 5** |
| Module Coordinator | [mani.ghahremani@port.ac.uk](mailto:mani.ghahremani@port.ac.uk) |
| Assessment Item number | Item 1 |
| Assessment Title | Southsea Cinema — Flutter Coursework |
| Date Issued | 2026-09-21 |

## Schedule and Deliverables

| Deliverable | Format | Weight | Date of demos |
| --- | --- | --- | --- |
| GitHub Repository | Link to your repository submitted to Moodle | 100% | Demo 1 by 02/10/2026 <br> Demo 2 by 16/10/2026 <br> Demo 3 by 06/11/2026 <br> Demo 4 by 20/11/2026 <br> Demo 5 by 04/12/2026 |

Demo: 10 minutes demo in your timetabled practical. All marks awarded in the demo.

## Notes and Advice

- The [Extenuating Circumstances procedure](https://myport.port.ac.uk/my-course/exams/extenuating-circumstances#apply) is there to support you if you have had any circumstances that have been significant enough to prevent you from attending, completing or submitting an assessment on time. If you complete an Extenuating Circumstances Form (ECF) for this assessment, use the correct module code, item number and deadline (not the late deadline) given above.
- [ASDAC](http://www2.port.ac.uk/additional-support-and-disability-advice-centre/) are available to any students who disclose a disability or require additional support for their academic studies.
- The University takes any form of academic misconduct (such as plagiarism) seriously, so please make sure your work is your own. Please ensure you adhere to our [Student Conduct Policy](https://policies.docstore.port.ac.uk/policy-261.pdf) and watch the video on [Plagiarism.](https://www.youtube.com/watch?v=2a0QJnCmfEs)
- Any material included in your coursework should be fully cited and referenced in **APA 7** format. Detailed advice on referencing is available from the [library](https://library.port.ac.uk/w165.html), also see TECFAC 08 Plagiarism and [library.port.ac.uk/referencing](https://library.port.ac.uk/referencing).
- Any material submitted that does not meet format or submission guidelines or falls outside of the submission deadline could be subject to a cap on your overall result or disqualification entirely.
- If you need additional assistance, you can ask your personal tutor, student engagement officer [ana.baker@port.ac.uk](mailto:ana.baker@port.ac.uk) or your lecturers.
- If you are concerned about your well-being, contact our [Well-being service](https://myport.port.ac.uk/guidance-and-support/health-and-wellbeing)

## Overview

Your task is to recreate a mobile-friendly version of the Southsea Cinema website using Flutter. You must not start from scratch: begin by forking the [southsea_cinema starter repository](https://github.com/manighahrmani/southsea_cinema), then build your own version of the app step by step as you work through the weekly worksheets on the [Flutter Course homepage](https://manighahrmani.github.io/sandwich_shop/).

![Southsea Cinema website](images/5/southsea_cinema.png)

Reference website: [Southsea Cinema](https://southseacinema.savoysystems.co.uk/SouthseaCinema.dll/)

We have provided a starter app for this coursework which is deliberately minimal. It contains only a basic theme, an empty home page, a small drawer, and a default widget test. You are expected to add screens, widgets, data models, tests, persistence, and cloud services during the coursework.

## Getting Started

### Prerequisites

You must already have a GitHub account to be able to start this coursework, and you need to be able to edit and run a Flutter project in your environment of choice and to commit your changes to a GitHub repository. All of these are explained in [Worksheet 1](https://manighahrmani.github.io/sandwich_shop/worksheet-1.html); complete it before continuing if you have not done so already.

You need:

- A GitHub account
- A way to edit and run Flutter projects
- Git installed and connected to your GitHub account

Follow the [development environment instructions in Worksheet 1](https://manighahrmani.github.io/sandwich_shop/worksheet-1.html). You can use your own device or access the university machines remotely.

### Fork the Repository

Open the [southsea_cinema repository](https://github.com/manighahrmani/southsea_cinema) and click **Fork** (or use [this link](https://github.com/manighahrmani/southsea_cinema/fork)):

![Clicking the Fork button on GitHub](images/1/step1_fork_button.png)

On the "Create a new fork" page, leave the default options as they are (do not change the repository name) and click **Create fork**:

![Creating a new fork on GitHub](images/1/step1_create_fork.png)

Your fork must be named `southsea_cinema` (if you already have a repository with this name, rename it beforehand) and should have a URL like:

```text
https://github.com/YOUR-USERNAME/southsea_cinema
```

### Clone Your Forked Repository

On your forked repository page, click the green **Code** button and copy the HTTPS URL:

![Copying the clone URL from GitHub](images/1/step2_clone_repository.png)

If you are using VS Code, open the Source Control panel and click **Clone Repository** (or open the Command Palette with `Ctrl+Shift+P` / `Cmd+Shift+P` and choose "Git: Clone"), then paste the URL you copied:

![Cloning the repository from VS Code](images/1/step2_open_in_vscode.png)

Alternatively, if you are using a terminal, run:

```bash
git clone https://github.com/YOUR-USERNAME/southsea_cinema.git
cd southsea_cinema
```

Replace `YOUR-USERNAME` with your GitHub username.

### Install Dependencies

When you open the project, VS Code may show a popup asking if you want to fetch missing packages. If you see it, click **Run 'pub get'**:

![VS Code prompting to run pub get](images/1/step3_flutter_pub_get_better.png)

If you do not see this popup, open a terminal and run the command manually:

```bash
flutter pub get
```

![Running flutter pub get in the terminal](images/1/step3_flutter_pub_get.png)

### Run the Application

This coursework targets Flutter Web and should be viewed in mobile view using your browser's developer tools. We recommend Chrome or Edge.

```bash
flutter run -d chrome
```

or:

```bash
flutter run -d edge
```

The app should open in your browser and show the Southsea Cinema starter home page:

![Starter app running in Edge](images/1/step4_run_app.png)

To view it in mobile view, open developer tools (right-click the page and choose **Inspect**, or press F12), then click the **Toggle device toolbar** button:

![Toggle device toolbar button in Chrome DevTools](images/1/step5_open_devtools.png)

Finally, choose a phone-sized device preset from the dropdown menu:

![Selecting a mobile device preset](images/1/step5_mobile_view.png)

## Assessment structure

Your module (PAPL — M30235, or UXDI — M32605, depending on your cohort) has two assessments. This Southsea Cinema coursework is Item 1, worth 50% of the overall module mark. Item 1 is assessed as a portfolio, not as a single submission: you build the app in five stages and demonstrate each stage to a member of staff during a timetabled demo window in your practical session.

You develop your coursework by completing the exercises at the end of each weekly worksheet. Every two worksheets prepare you for one demo (for example, Worksheets 1 and 2 prepare you for Demo 1). You submit the link to your public GitHub repository on Moodle before the first demo, then attend your practical to demonstrate your work. Marks are awarded only at the demos.

There are five demos across the term, but only your best four demo marks count towards Item 1. Each counted demo is worth 25% of Item 1 (12.5% of the overall module mark). At each demo a member of staff assesses functionality (9% of Item 1) by watching you run your app, inspects code quality (8%), and asks two questions to test your understanding of your own code (8%). From Demo 4 onwards, the code quality component places significant weight on project structure and automated test coverage. Specifically, your `test/` directory must strictly mirror the organisation of folders in `lib/` (such as `test/models/`, `test/screens/`, `test/widgets/`, `test/repositories/`, `test/database/`), and you must generate test coverage with `flutter test --coverage` and demonstrate it live using the Flutter Coverage extension in VS Code. Leaving test files unorganised in the root of `test/` or having inadequate test coverage will result in a substantial mark penalty.

For Demos 1 to 3, if any required functionality item scores zero, the final demo mark is capped at 23 out of 25. A lower mark remains unchanged; the cap does not add a separate deduction for each missing feature. Demo 3 asks one understanding question from Worksheet 5 and one from Worksheet 6, excluding advanced, optional extensions.

Demo 3 covers Worksheets 5 and 6: themed navigation, the ticket basket, profile forms, a JSON film catalogue and saved profile preferences. SQLite booking history and database-backed checkout begin in Worksheet 7 for Demo 4. Provider and notifiers are not required.

Assessment takes place across five two-week demo windows (Weeks 1 and 2, Weeks 3 and 4, Weeks 5 and 6, Weeks 7 and 8, and Weeks 9 and 10). Three rules apply:

- You can perform at most one demo in any demo window.
- Demos must be completed in order. You cannot skip ahead to a later demo if you have missed an earlier one, because each stage builds on the previous codebase.
- Missing one demo window carries no mark penalty because only your best four demo marks count. Missing two or more windows reduces the number of demos you can complete.

⚠️ You will only receive marks if you attend your timetabled practical. You cannot get marks in practicals at a different time to what is shown on your timetable.

For the full details of how you are assessed — including the exact mark breakdown, the missed-demo rules, and how Extenuating Circumstances affect Item 1 — read the [Assessment Guide](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQC9nZoNwb2jT40MnFQPZWVvAVdTK2PGBmZ8jPff30RRyPc).

For the overall dates and worksheet schedule, visit the [Flutter Course homepage](https://manighahrmani.github.io/sandwich_shop/).

## Submission

You need to submit the link to your public forked repository on Moodle before the first demo. You are not submitting a zip file or a copy of the source code.

Make sure your repository is public. Test this by opening your repository link in a private/incognito browser window (you should not get a 404 error).

## Demonstration

During each demo, you must be able to run your app and answer questions about your code. Before attending a demo, check that the app runs from a clean clone:

```bash
flutter pub get
flutter run -d chrome
```

## Project structure

The starter repository is intentionally small:

```text
southsea_cinema/
├── lib/
│   ├── constants.dart          # Shared colours, text styles, and app title
│   ├── main.dart               # Main app and route setup
│   ├── views/
│   │   ├── home_view.dart      # Starter home page
│   │   └── movie_listing.dart  # Empty movie listing page
│   └── widgets/
│       └── nav_drawer.dart     # Minimal starter drawer
├── test/
│   └── widget_test.dart        # Basic widget test
├── pubspec.yaml                # Project dependencies
└── README.md                   # This file
You are expected to create additional files and directories as needed to complete the coursework. From Demo 4 onwards, your `test/` directory must be reorganised so that its subdirectories strictly mirror `lib/`:

```text
southsea_cinema/
├── lib/
│   ├── constants.dart
│   ├── database/
│   ├── models/
│   ├── repositories/
│   ├── screens/
│   └── widgets/
├── test/
│   ├── database/
│   ├── models/
│   ├── repositories/
│   ├── screens/
│   └── widgets/
├── pubspec.yaml
└── README.md
```

## Retrieval of failure

The retrieval of failure period for Term 1 takes place in the week beginning Monday 22 February 2027 (22/02/2027 to 26/02/2027). If your total mark across all demos before the Christmas break is under 40%, you have not passed Item 1 and must arrange a meeting with me during this period to complete your remaining demos (or all demos if none were completed). You do not need to start a new coursework; you continue and finish the same Southsea Cinema coursework.

## Referral/Deferral Assessment

Your assessment during the retrieval period in February depends on whether you have an approved Extenuating Circumstances Form (ECF):

- **Approved ECF (deferral):** Your mark in February is uncapped.
- **No approved ECF (referral):** Your overall mark for Item 1 is capped at 40%.

## Extenuating Circumstances

If external events affect your study for more than one to two weeks (such as physical or mental illness, family issues, problems with accommodation, or laptop breakdown), submit an [Extenuating Circumstances Form (ECF)](https://myport.port.ac.uk/my-course/exams/extenuating-circumstances#apply) with supporting evidence as soon as you can.

⚠️ Once your ECF is approved, you must email me ([mani.ghahremani@port.ac.uk](mailto:mani.ghahremani@port.ac.uk)).

Please still attend practical sessions and complete as many demos as possible during term time. ECFs apply to the whole of Item 1 (the entire Flutter Coursework, 50% of the module) rather than individual demos. For the full assessment rules, see the [Assessment Guide](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQC9nZoNwb2jT40MnFQPZWVvAVdTK2PGBmZ8jPff30RRyPc).

## Help with Coursework

If you have questions or encounter issues while working on this coursework, use the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) to find the dedicated Discord channel and ask for help. Before posting a new question, check the existing posts to see if your question has already been answered. You can also attend your timetabled practical sessions to get face-to-face support from teaching staff.
