# Sandwich Shop

This branch contains the Sandwich Shop app as it is after completing [Worksheet 7 — SQLite and order history](https://github.com/manighahrmani/sandwich_shop/blob/main/worksheet-7.md). It saves orders in an SQLite database, so it must run on an Android emulator. SQLite does not work in a web browser or on Windows desktop.

## Prerequisites

On a university computer, follow the setup steps of the [Android emulator bundle](https://github.com/manighahrmani/flutter_vscode_package#android-emulator-setup-worksheet-7-onwards). It installs Flutter, Git, VS Code, the Android tools and an emulator called `flutter_emulator`, and leaves the emulator running. It takes about 10 minutes. When it asks for a repository URL, press **Enter** to continue with the starter app; VS Code then opens.

On your own computer, install the following:

- [Git](https://git-scm.com/downloads)
- [Flutter and VS Code](https://docs.flutter.dev/install/quick), which also sets up the Flutter extension
- [Android Studio and an Android emulator](https://docs.flutter.dev/platform-integration/android/setup), following the guide up to creating a virtual device in **Device Manager**

Run `flutter doctor` afterwards and check that the **Android toolchain** line has a tick.

## Get the code

In VS Code, open the Command Palette with **Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS, run **Terminal: Create New Terminal**, then enter the following commands. They clone branch `7` into your `Downloads` folder, which is not synchronised to cloud storage, and open it in a new VS Code window:

```bash
cd ~/Downloads
git clone --branch 7 https://github.com/manighahrmani/sandwich_shop
code sandwich_shop
```

If you already have a clone, commit your own work first, then switch to this branch from inside the `sandwich_shop` folder:

```bash
git fetch origin
git checkout 7
```

## Run the app

In the new VS Code window, open a terminal and install the dependencies:

```bash
flutter pub get
```

Make sure the emulator is running and shows the Android home screen. If it is not running, start it with the command below. On your own computer, start it from **Device Manager** in Android Studio instead, or use the name listed by `flutter emulators`. The first start can take a few minutes, and a black screen is normal while it boots.

```bash
flutter emulators --launch flutter_emulator
```

Click the device name in the bottom-right corner of the status bar and choose the Android emulator, for example **sdk gphone64 x86 64**. Do not choose **Edge**, **Chrome** or **Windows**. Then press **F5** to build and run the app. Alternatively, run it from the terminal:

```bash
flutter run -d emulator-5554
```

The first build downloads Android build files and can take several minutes. Replace `emulator-5554` with the id shown by `flutter devices` if yours is different.

## Run the tests

The tests use an in-memory SQLite database and in-memory preferences, so they do not need the emulator. Run them with coverage:

```bash
flutter test --coverage
```

This writes `coverage/lcov.info`. Use the [Flutter Coverage extension](https://marketplace.visualstudio.com/items?itemName=Flutterando.flutter-coverage) in VS Code to see which lines the tests run.

## Get support

Ask questions in the [dedicated Discord channel](https://discord.com/channels/760155974467059762/1370633732779933806). Include the error message you see and a screenshot.
