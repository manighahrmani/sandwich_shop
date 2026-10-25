# Sandwich Shop

This branch contains the Sandwich Shop app as it is after completing [Worksheet 2 — Stateless and Stateful Widgets](https://github.com/manighahrmani/sandwich_shop/blob/main/worksheet-2.md). It runs in a web browser such as Edge or Chrome.

## Prerequisites

On a university computer, follow the setup steps of the [Flutter and VS Code bundle](https://github.com/manighahrmani/flutter_vscode_package#setup). It installs Flutter, Git and VS Code for you. When it asks for a repository URL, press **Enter** to continue with the starter app; VS Code then opens.

On your own computer, install the following:

- [Git](https://git-scm.com/downloads)
- [Flutter and VS Code](https://docs.flutter.dev/install/quick), which also sets up the Flutter extension
- [Microsoft Edge](https://www.microsoft.com/edge/download) or [Google Chrome](https://www.google.com/chrome/)

## Get the code

In VS Code, open the Command Palette with **Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS, run **Terminal: Create New Terminal**, then enter the following commands. They clone branch `2` into your `Downloads` folder, which is not synchronised to cloud storage, and open it in a new VS Code window:

```bash
cd ~/Downloads
git clone --branch 2 https://github.com/manighahrmani/sandwich_shop
code sandwich_shop
```

If you already have a clone, commit your own work first, then switch to this branch from inside the `sandwich_shop` folder:

```bash
git fetch origin
git checkout 2
```

## Run the app

In the new VS Code window, open a terminal and install the dependencies:

```bash
flutter pub get
```

Click the device name in the bottom-right corner of the status bar and choose **Edge** or **Chrome**. Then press **F5** to run the app. Alternatively, run it from the terminal:

```bash
flutter run -d edge
```

## Format and analyse

Run these commands in the terminal to format the code and check it for problems:

```bash
dart format lib
dart analyze
```

## Get support

Ask questions in the [dedicated Discord channel](https://discord.com/channels/760155974467059762/1370633732779933806). Include the error message you see and a screenshot.
