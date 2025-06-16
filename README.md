# Sandwich Shop

This is a simple Flutter app that allows users to order sandwiches. The app is
built using Flutter and Dart, and it is designed primarily to be run in a web
browser.

## Prerequisites

1. **Terminal**:

   - **macOS** – use the built-in Terminal app by pressing **⌘ + Space**,
     typing **Terminal**, and pressing **Return**.
   - **Windows** – open the start menu using the **Windows** key. Then enter
     **cmd** to open the **Command Prompt**. Alternatively, you can use
     **Windows PowerShell** or **Windows Terminal**.

2. **Git** – verify that you have `git` installed by entering `git --version`;
   in the terminal; if missing, download the installer from
   [Git's official site](https://git-scm.com/downloads?utm_source=chatgpt.com).
3. **Package managers**:

   - **Homebrew** (macOS) – verify that you have `brew` installed with
     `brew --version`; if missing, follow the instructions on the
     [Homebrew installation page](https://brew.sh/).
   - **Chocolatey** (Windows) – verify that you have `choco` installed with
     `choco --version`; if missing, follow the instructions on the
     [Chocolatey installation page](https://chocolatey.org/install).

4. **Flutter SDK** – verify that you have `flutter` installed and it is
   working with `flutter doctor`; if missing, install it using your package
   manager:

   - **macOS**: `brew install --cask flutter`
   - **Windows**: `choco install flutter`

5. **Visual Studio Code** – verify that you have `code` installed with
   `code --version`; if missing, use your package manager to install it:

   - **macOS**: `brew install --cask visual-studio-code`
   - **Windows**: `choco install vscode`

## Get the code

Enter the following commands in your terminal to clone the repository and
open it in Visual Studio Code:

```bash
git clone --branch 2 https://github.com/manighahrmani/sandwich_shop
cd sandwich_shop
code .
```

## Run the app

Open the integrated terminal in Visual Studio Code by first opening the Command
Palette with **⌘ + Shift + P** (macOS) or **Ctrl + Shift + P** (Windows) and
typing **Terminal: Create New Terminal** then pressing **Enter**.

In the terminal, run the following commands to install the dependencies and run
the app in your web browser:

```bash
flutter pub get
flutter run
```

## Need help?

Use [the dedicated Discord channel](https://discord.com/channels/760155974467059762/1370633732779933806)
to ask your questions and get help from the community. Please provide as much
context as possible, including the error messages you are seeing and
screenshots (you can open Discord in your web browser).
