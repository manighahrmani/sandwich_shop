# Worksheet 0 — Prerequisites

If you're new to the Dart programming language or haven't used Git and GitHub before, completing these materials is essential for you. If you're already comfortable with these topics, feel free to skip to the [Exercises](#exercises) section.

## Introduction to Git and GitHub

**Git** is the version control system we'll use to track changes in our code, while **GitHub** is the platform where we'll host our code repositories online. Since your coursework must be submitted via GitHub, a solid understanding of both is fundamental for this module.

The following free courses from GitHub will get you up to speed:

  * **Introduction to GitHub**: This course covers the basics of creating repositories, committing changes, working with branches, and collaborating using pull requests.
      * [https://github.com/skills/introduction-to-github](https://github.com/skills/introduction-to-github)
  * **Getting Started with GitHub Copilot**: Learn how to use GitHub's AI pair programmer to write code faster. As a student, you're likely eligible for a free Copilot subscription through the **GitHub Student Developer Pack**.
      * [https://github.com/skills/getting-started-with-github-copilot](https://github.com/skills/getting-started-with-github-copilot)

-----

## Introduction to the Dart Language 🎯

**Dart** is the programming language developed by Google that powers the Flutter framework. Its syntax is clear, concise, and will feel familiar if you have experience with languages like Java, C\#, or JavaScript. The following resources provide a comprehensive introduction.

### Getting started with Dart

  * **Worksheet**: [Link to SharePoint Document](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/ESkq3xBzVgpPh8U0zkb3WXQB49yLKZjjC9QxM-f3V-PTiQ?e=p5ckav)
  * **Lecture**: [Link to SharePoint Presentation](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/EQZicReK_3ZLkNAOj--M3psBntl0cZRT7piu6W3j4OFPcg)
  * **Code Repository**: [https://github.com/Programming-M30299/week-15-dart-code](https://github.com/Programming-M30299/week-15-dart-code)

### Functions and Control Flow in Dart

  * **Worksheet**: [Link to SharePoint Document](https://portdotacdotuk-my.sharepoint.com/:w:/r/personal/mani_ghahremani_port_ac_uk/Documents/Programming%202/worksheets/worksheets_public/week-16/Dart%20Worksheet%2016%20-%20Functions%20and%20Control%20Flow.docx?d=w88b2c555813f4b2f94015b51350c5e3e&csf=1&web=1&e=ZPvrbN)
  * **Lecture**: [Link to SharePoint Presentation](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/EbUO-PZOSWNPoA9TL1AqiSkBgURErCT0WE7I81dSu2OEQA?e=ZvHyB0)
  * **Code Repository**: [https://github.com/Programming-M30299/week-16-dart-code](https://github.com/Programming-M30299/week-16-dart-code)

### Strings and Collections in Dart

  * **Worksheet**: [Link to SharePoint Document](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/EV6lZOGcgydPuoR65cCrVfcBXW1SaRNSRgjqv3hzjd-EOA?e=o6d2EM)
  * **Lecture**: [Link to SharePoint Presentation](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/EbUO-PZOSWNPoA9TL1AqiSkBgURErCT0WE7I81dSu2OEQA?e=N2Xhcy)
  * **Code Repository**: [https://github.com/Programming-M30299/week-17-dart-code](https://github.com/Programming-M30299/week-17-dart-code)

### Object-Oriented Programming in Dart

  * **Worksheet**: [Link to SharePoint Document](https://portdotacdotuk-my.sharepoint.com/:w:/r/personal/mani_ghahremani_port_ac_uk/Documents/Programming%202/worksheets/worksheets_public/week-18/Dart%20Worksheet%2018%20-%20Object-Oriented%20Programming.docx?d=w0255bb1109b344d5b17d2673eb3e9d3e&csf=1&web=1&e=0jFuVj)
  * **Lecture**: [Link to SharePoint Presentation](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/EcpaP0-SOaJBqpDuSlcl4xwBTSzN9HgPhCOMnL74Zw54Zw)
  * **Code Repository**: [https://github.com/Programming-M30299/week-18-dart-code](https://github.com/Programming-M30299/week-18-dart-code)

-----

## Exercises

To ensure you're ready for the upcoming work, please complete the following setup tasks. These will help verify that you have engaged with the material above.

1.  **Set Up Your GitHub Profile**

    Your GitHub profile is your developer portfolio. If you don't already have an account, **sign up at [github.com](https://github.com)**. As a small but important step, personalise your profile:

      - Add a profile picture.
      - Write a short, one-line bio.

2.  **Create a "Hello Dart" Repository**

    This task will confirm that you can create a project locally and publish it to GitHub using VS Code.

      - On your computer, create a new folder named `hello_dart`.
      - Open this `hello_dart` folder in **Visual Studio Code**.
      - Create a new file inside it named `main.dart`.
      - In `main.dart`, write a simple Dart program that prints a welcome message to the console.
        ```dart
        void main() {
          print('Hello, Dart! My GitHub username is [YOUR_USERNAME]');
        }
        ```
      - Using the **Source Control** panel in VS Code, initialise a Git repository, make your first commit, and publish the repository to your GitHub account. Make the repository **public** so it can be reviewed.

3.  **Activate and Use GitHub Copilot**

    Let's put your AI pair programmer to work. First, ensure you have access.

      - Install the **GitHub Copilot** extension in VS Code.
      - Sign in and authorise the extension. If you don't have access, apply for the **[GitHub Student Developer Pack](https://education.github.com/pack)**.
      - In your `hello_dart` project, use a comment to ask Copilot to write a new function for you. For example:
        ```dart
        // a function that returns the sum of two integers
        ```
      - Commit this new, AI-generated code to your repository with the commit message: `feat: Add function with GitHub Copilot`.