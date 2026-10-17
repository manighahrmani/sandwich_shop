# Sandwich Shop

This is a simple Flutter app that allows users to order sandwiches.
The app is built using Flutter and Dart. Branch `6` loads the menu from a JSON
asset, saves settings with shared preferences and runs on an Android emulator
rather than a web browser.

## Install the essential tools

1. **Terminal**:

    - **macOS** – use the built-in Terminal app by pressing **⌘ + Space**, typing **Terminal**, and pressing **Return**.
    - **Windows** – open the start menu using the **Windows** key. Then enter **cmd** to open the **Command Prompt**. Alternatively, you can use **Windows PowerShell** or **Windows Terminal**.

2. **Git** – verify that you have `git` installed by entering `git --version`, in the terminal.
    If this is missing, download the installer from [Git's official site](https://git-scm.com/downloads?utm_source=chatgpt.com).

3. **Package managers**:

    - **Homebrew** (macOS) – verify that you have `brew` installed with `brew --version`; if missing, follow the instructions on the [Homebrew installation page](https://brew.sh/).
    - **Chocolatey** (Windows) – verify that you have `choco` installed with `choco --version`; if missing, follow the instructions on the [Chocolatey installation page](https://chocolatey.org/install).

4. **Flutter SDK** – verify that you have `flutter` installed and it is working with `flutter doctor`; if missing, install it using your package manager:

    - **macOS**: `brew install --cask flutter`
    - **Windows**: `choco install flutter`

5. **Visual Studio Code** – verify that you have `code` installed with `code --version`; if missing, use your package manager to install it:

    - **macOS**: `brew install --cask visual-studio-code`
    - **Windows**: `choco install vscode`

## Get the code

### If this is your first time working on this project

Enter the following commands in your terminal to clone the repository and
open it in Visual Studio Code.
You may want to change directory (`cd`) to the directory where you want to clone the
repository first.

```bash
git clone --branch 6 https://github.com/manighahrmani/sandwich_shop
cd sandwich_shop
code .
```

### If you have already cloned the repository

Enter the following commands in your terminal to switch to the correct branch.
Remember to `cd` to the directory where you cloned the repository first.

```bash
git fetch origin
git checkout 6
```

## Run the app

Open the integrated terminal in Visual Studio Code by first opening the Command
Palette with **⌘ + Shift + P** (macOS) or **Ctrl + Shift + P** (Windows) and
typing **Terminal: Create New Terminal** then pressing **Enter**.

In the terminal, run the following commands to install the dependencies and run
the app on your selected Android emulator:

```bash
flutter pub get
flutter run
```

On university computers, use the [Android emulator bundle](https://github.com/manighahrmani/flutter_vscode_package#android-emulator-setup-worksheet-6-onwards)
and launch `flutter_emulator`. On your own computer, follow the
[Flutter Android setup guide](https://docs.flutter.dev/platform-integration/android/setup).
Select the booted emulator in VS Code before running.

Tests use mock shared preferences and do not need an emulator:

```bash
flutter test
```

## Get support

Use [the dedicated Discord channel](https://discord.com/channels/760155974467059762/1370633732779933806)
to ask your questions and get help from the community.
Please provide as much context as possible, including the error messages you are seeing and
screenshots (you can open Discord in your web browser).
