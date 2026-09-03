# Southsea Cinema — Flutter Coursework

School of Computing

| | |
| --- | --- |
| Module Title and Code | **USER EXPERIENCE DESIGN AND IMPLEMENTATION - M32605 - FHEQ 5** <br> **PROGRAMMING APPLICATIONS AND PROGRAMMING LANGUAGES - M30235 - FHEQ 5** |
| Module Coordinator | [mani.ghahremani@port.ac.uk](mailto:mani.ghahremani@port.ac.uk) |
| Assessment Item number | Item 1 |
| Assessment Title | Southsea Cinema — Flutter Coursework |
| Date Issued | TBC (2026-27 delivery) |

## Notes and Advice

* The [Extenuating Circumstances procedure](https://myport.port.ac.uk/my-course/extenuating-circumstances) is there to support you if you have had any circumstances that have been significant enough to prevent you from attending, completing or submitting an assessment on time. If you complete an Extenuating Circumstances Form (ECF) for this assessment, use the correct module code and item number given above.
* [ASDAC](http://www2.port.ac.uk/additional-support-and-disability-advice-centre/) are available to any students who disclose a disability or require additional support for their academic studies, with a good set of resources on the [ASDAC moodle site](https://moodle.port.ac.uk/course/view.php?id=3012).
* The University takes any form of academic misconduct (such as plagiarism) seriously, so please make sure your work is your own. Please ensure you adhere to our [Student Conduct Policy](https://policies.docstore.port.ac.uk/policy-261.pdf) and watch the video on [Plagiarism](https://www.youtube.com/watch?v=2a0QJnCmfEs).
* Any material included in your coursework should be fully cited and referenced in **APA 7** format. Detailed advice on referencing is available from the [library](https://library.port.ac.uk/w165.html) and [library.port.ac.uk/referencing](https://library.port.ac.uk/referencing).
* If you need additional assistance, you can ask your personal tutor or your lecturers.
* If you are concerned about your well-being, contact our [Well-being service](https://myport.port.ac.uk/guidance-and-support/health-and-wellbeing).

## Overview

Your task is to recreate a mobile-friendly version of the Southsea Cinema website using Flutter. You must not start from scratch: begin by forking the [southsea_cinema starter repository](https://github.com/manighahrmani/southsea_cinema), then build your own version of the app step by step as you work through the weekly worksheets on the [Flutter Course homepage](https://manighahrmani.github.io/sandwich_shop/).

Reference website: [Southsea Cinema](https://southseacinema.savoysystems.co.uk/SouthseaCinema.dll/)

The starter app is deliberately minimal. It contains only a basic theme, an empty home page, a small drawer, and a default widget test. You are expected to add screens, widgets, data models, tests, persistence, and cloud services during the coursework.

## Getting Started

### Prerequisites

You must already have a GitHub account to be able to start this coursework. If you have not done so, read and complete the exercises in [Worksheet 0](https://manighahrmani.github.io/sandwich_shop/worksheet-0.html) before continuing.

You also need to be able to edit and run a Flutter project in your environment of choice, and to commit your changes to a GitHub repository. Both of these are explained in [Worksheet 1](https://manighahrmani.github.io/sandwich_shop/worksheet-1.html); complete it before continuing if you have not done so already.

You have three development options:

1. GitHub Codespaces (browser-based, no local install required)
2. University Windows computers
3. Your own computer

Note that all the recommended development tools for this coursework, including AI assistants, are free. If you do not own a high-spec computer, you can use the university machines or a browser-based option. See [Worksheet 1](https://manighahrmani.github.io/sandwich_shop/worksheet-1.html) for details.

### Fork the Repository

Open the [southsea_cinema repository](https://github.com/manighahrmani/southsea_cinema) and click **Fork** (or use [this link](https://github.com/manighahrmani/southsea_cinema/fork)). Leave the default options as they are and click **Create fork**. Your fork must be named `southsea_cinema`; if you already have a repository with this name, rename it beforehand.

You should then have a public fork with a URL like:

```text
https://github.com/YOUR-USERNAME/southsea_cinema
```

### Clone Your Forked Repository

Open a terminal, change to your desired directory, and run:

```bash
git clone https://github.com/YOUR-USERNAME/southsea_cinema.git
cd southsea_cinema
```

Replace `YOUR-USERNAME` with your GitHub username.

### Install Dependencies

Your editor should automatically prompt you to install the required dependencies when you open the project. If not, open a terminal and run:

```bash
flutter pub get
```

### Run the Application

This coursework targets Flutter Web and should be viewed in mobile view using your browser's developer tools. We recommend Chrome or Edge.

```bash
flutter run -d chrome
```

or:

```bash
flutter run -d edge
```

Once the app is running, open developer tools (right-click the page and choose **Inspect**, or press F12), click the **Toggle device toolbar** button, and choose a phone-sized device preset from the dropdown menu.

## Assessment Structure

Item 1 is worth 50% of the overall module mark and is assessed entirely through 5 demo checkpoints of your Southsea Cinema coursework. There is no separate sign-off or coursework submission for Item 1: the demos are continuous assessment of the same coursework you build throughout the term.

⚠️ You will only receive marks if you attend your timetabled demo session and demonstrate your progress to a member of staff. Missing a demo without an approved ECF means a mark of 0 for that checkpoint.

For the overall assessment structure, dates, and worksheet schedule, visit the [Flutter Course homepage](https://manighahrmani.github.io/sandwich_shop/).

### Demos (50%, 10% per demo)

At each demo, a member of staff checks your progress and asks you a few questions about your own code. Each demo is marked out of 10 (10% of the module):

* **Functionality (0-4)**: does the app implement the features expected by this point in the schedule? Extra marks are available if you have progressed further than expected.
* **Quality (0-2)**: code quality on inspection (naming and formatting early on, structure and separation of concerns later).
* **Understanding (0-4)**: your answers to a few questions about your own code and decisions.

The exact expectations for each demo are listed in the corresponding worksheet and in the demo issue on [the sandwich_shop repository's Issues tab](https://github.com/manighahrmani/sandwich_shop/issues).

If you use Firebase or another cloud service in your coursework, you must host the app live and provide the URL at the demo so it can be checked without needing your API keys.

## Submission

You will submit the link to your public forked repository on Moodle when instructed. You are not submitting a zip file or a copy of the source code.

Make sure your repository is public. Test this by opening your repository link in a private/incognito browser window (you should not get a 404 error).

## Demonstration

During each demo, you must be able to run your app and answer questions about your code. Before attending a demo, check that the app runs from a clean clone:

```bash
flutter pub get
flutter run -d chrome
```

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

Note that this is the initial structure. You are expected to create additional files and directories as needed to complete the coursework, and you can reorganize the project structure as you see fit.

## Referral/Deferral Assessment

More information about what referral/deferral are will be provided later in Moodle. Referral/deferral dates are on [the University Key Dates page](https://www.port.ac.uk/about-us/key-dates).

The referral/deferral assessment for this Flutter Course is a coursework that you need to complete during the referral/deferral period. This coursework is **not** the same as the coursework brief above. It will be added to Moodle nearer the time.

## Extenuating Circumstances

If there are external reasons stopping you from engaging with the module, submit an [Extenuating Circumstances Form (ECF)](https://myport.port.ac.uk/my-course/exams/extenuating-circumstances) as soon as you can and notify a member of staff when your ECF is approved.

Note that ECFs apply to the whole Item 1 (the entire Flutter Course, 50% of the module). You cannot use an ECF just for individual demos.

Also note that if your ECF is approved, any demo marks you already have will not be counted. Instead, you will be expected to take the deferral assessment in July and your Item 1 mark will come from that deferral coursework alone (not from the demos above).

If you do not have an ECF or it is not approved, you will receive all the demo marks you have completed.

## Help with Coursework

### Support

If you have questions or encounter issues while working on this coursework, use [discord_flutter.pptx](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) to find the dedicated Discord channel and ask for help. Before posting a new question, check the existing posts to see if your question has already been answered. You can also attend your timetabled practical sessions to get face-to-face support from teaching staff.

If you are facing external extenuating circumstances that are affecting your ability to complete this coursework, submit an [Extenuating Circumstances Form](https://myport.port.ac.uk/my-course/exams/extenuating-circumstances) as soon as possible.

### Resources

The worksheets listed on the [Flutter Course homepage](https://manighahrmani.github.io/sandwich_shop/) are your primary learning resource for Flutter development. Work through these worksheets systematically, as they provide the foundation you need to complete the coursework successfully.

### Tips

Starting early is crucial for success in this coursework. The earlier you begin, the more time you have to learn, experiment, and seek help when needed. Work on the coursework alongside the worksheets rather than leaving everything until the end: as you complete each worksheet, implement the corresponding features in your coursework application.

Version control is an essential part of this coursework. Commit your changes regularly to Git with clear, descriptive commit messages. Each commit should represent a small, meaningful unit of work rather than large batches of changes. To commit and push your changes, use:

```bash
git add .
git commit -m "Brief description of what you changed"
git push
```

If you make a mistake and need to revert to a previous commit, view your commit history with `git log --oneline`, find the commit hash where things were working (for example, `abc1234`), and revert to that commit with `git reset --hard abc1234`. If necessary, you can force push with `git push --force`.

In extreme cases where your repository is completely broken and unrecoverable, you can start fresh by deleting your forked repository on GitHub (Settings → Danger Zone → Delete this repository), forking the [southsea_cinema repository](https://github.com/manighahrmani/southsea_cinema) again, and cloning your fresh fork.

AI tools are valuable during development, and you are encouraged to use them. However, you must apply the best practices taught in the worksheets, particularly [Worksheet 6](https://manighahrmani.github.io/sandwich_shop/worksheet-6.html). AI-generated code should be reviewed, understood, and adapted to fit your application properly. Use AI as a learning aid and coding partner rather than a replacement for your own understanding and decision-making.
