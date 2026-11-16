# Worksheet 9 — Cloud services

<!-- DRAFT: setup instructions written for walkthrough and screenshot capture; code implementation, Firestore data flow and testing sections remain outlined as TODO comments pending branch 9 completion. -->

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 8](#continue-from-worksheet-8)
  - [Enable Android and web support](#enable-android-and-web-support)
- [Why apps use the cloud](#why-apps-use-the-cloud)
- [Choosing cloud services](#choosing-cloud-services)
  - [Billing](#billing)
- [Setting up Firebase](#setting-up-firebase)
  - [Create a Firebase project](#create-a-firebase-project)
  - [Set up user authentication](#set-up-user-authentication)
  - [Create a Cloud Firestore database](#create-a-cloud-firestore-database)
  - [Install the Firebase and FlutterFire tools](#install-the-firebase-and-flutterfire-tools)
  - [Connect the Flutter app](#connect-the-flutter-app)
  - [Support more platforms](#support-more-platforms)
- [Firebase Authentication](#firebase-authentication)
  - [Sign up, sign in and sign out](#sign-up-sign-in-and-sign-out)
- [Cloud Firestore](#cloud-firestore)
  - [Read the menu from Firestore](#read-the-menu-from-firestore)
  - [Save user settings in the cloud](#save-user-settings-in-the-cloud)
  - [Store and read orders](#store-and-read-orders)
  - [Test with multiple users](#test-with-multiple-users)
  - [Protect user data with security rules](#protect-user-data-with-security-rules)
- [Testing cloud code](#testing-cloud-code)
  - [Fake Firebase in unit tests](#fake-firebase-in-unit-tests)
  - [Keep coverage high](#keep-coverage-high)
- [Exercises](#exercises)

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

### Continue from Worksheet 8

Continue with your Sandwich Shop app from [Worksheet 8](worksheet-8.md). Your tests should pass, and your coverage should sit close to 100% after the work in [Test coverage](worksheet-8.md#test-coverage). If you need the starting code, clone the [Sandwich Shop repository](https://github.com/manighahrmani/sandwich_shop) and switch to branch `8`:

```bash
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
git switch 8
```

Run `flutter pub get` to install the existing dependencies, then run `flutter test` to confirm all tests from Worksheet 8 pass before you start making changes.

Do not switch branches over unfinished work. Branch `9` contains the completed Sandwich Shop application for this worksheet; use it to compare your finished work, not as your starting point.

### Enable Android and web support

Up to [Worksheet 7](worksheet-7.md), the app stored orders in a local SQLite database that could not run in a browser, so we removed the `web` folder and blocked web builds in `lib/main.dart`. Replacing local SQLite with Cloud Firestore means customers will be able to use the shop in Chrome or Edge as well as on Android.

Check that your Flutter installation lists Chrome or Edge alongside your Android emulator by opening the terminal and running:

```bash
flutter devices
```

If your project does not already contain a `web` folder, generate the web runner files in the root of your repository:

```bash
flutter create --platforms=web .
```

The `.` targets the current project folder without touching your `lib`, `assets` or existing test files. If `flutter create` adds a starter `test/widget_test.dart` template, delete that template file and keep your existing mirrored `test/` files.

Even with the `web` folder restored, running the app in Chrome right now still shows the fallback screen from Worksheet 7 because `isSupportedPlatform()` in `lib/main.dart` returns `false` whenever `kIsWeb` is `true`. In this worksheet, we enable both Android and web for Firebase as a minimum, while keeping `isSupportedPlatform()` so accidentally launching a platform you have not configured, such as Windows, macOS or Linux, shows a helpful message rather than crashing. If you also want to add iOS or desktop platforms later, follow the optional [Support more platforms](#support-more-platforms) section.

Open `lib/main.dart` and update `isSupportedPlatform()` so it allows web builds alongside Android. Passing an optional `isWeb` parameter that defaults to `kIsWeb` keeps the real app's behaviour while letting unit tests simulate running on the web without a browser:

```dart
bool isSupportedPlatform({bool isWeb = kIsWeb}) {
  if (isWeb) {
    return true;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return true;
  }
  return false;
}
```

In the same file, update the message inside `UnsupportedPlatformApp` so it describes the supported platforms accurately:

```dart
            child: Text(
              'This app is configured for Android and web only. Stop the app '
              'and run it on Chrome or an Android emulator instead.',
              textAlign: TextAlign.center,
            ),
```

Now open `test/main_test.dart`, add a unit test confirming `isSupportedPlatform(isWeb: true)` returns `true`, and update the fallback screen test so it checks for the updated text:

```dart
  test('Web is supported', () {
    expect(isSupportedPlatform(isWeb: true), isTrue);
  });

  testWidgets('The unsupported platform screen explains what to do', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const UnsupportedPlatformApp());
    expect(find.textContaining('Android and web'), findsOneWidget);
  });
```

Run `flutter test` to confirm all tests still pass. You can also run `flutter run -d chrome` to check that the menu, order and settings screens open in Chrome. Note that tapping **Checkout** on the basket screen or opening the orders screen in Chrome will still fail until we replace `sqflite` with Cloud Firestore later in [Store and read orders](#store-and-read-orders), so keep testing order saving on your Android emulator until then.

## Why apps use the cloud

So far, our app has stored its data locally in JSON or on a SQL database on a single device. If someone switches devices or opens the app in a web browser, that local data is unavailable.

Most real-world apps avoid this by storing data on remote servers over the internet, known as cloud. Keeping the data (as well as other services of the app) on the cloud lets every customer access it from anywhere (and on any device or browser).

## Choosing cloud services

In this worksheet, we will walk you through provisioning cloud services that let your app store data and verify user accounts. In this worksheet we connect the Sandwich Shop app to Firebase for user sign-in (`firebase_auth`) and cloud database storage (`cloud_firestore`).

Firebase is a cloud service provided by Google that provides a variety of services for app development, including user authentication, database storage, and more. We have selected Firebase over the other providers such as Azure or Amazon AWS because it generally has a better integration with Flutter.

### Billing

Firebase offers two billing tiers on its [Firebase pricing](https://firebase.google.com/pricing) page: the no-cost Spark plan and the pay-as-you-go Blaze plan. Firebase Authentication and Cloud Firestore both include generous free daily quotas on the Spark plan without attaching a payment card.

In our case we don't require cloud storage (e.g., storing user profile pictures or PDF receipts) so we can make do with the Spark plan. Just be aware as the need for your app grows, you may be asked to upgrade to the Blaze plan. Alternatively, you can also explore the [Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite) to simulate Firebase services locally.

## Setting up Firebase

Before writing any Dart code, create a Firebase project in the web dashboard and link it to your Flutter project.

### Create a Firebase project

Before the app can use any cloud features, we need a project on Firebase to hold our authentication settings, database and app configuration in one place.

Open the [Firebase dashboard](https://console.firebase.google.com/) in your browser and confirm that the profile icon in the top-right corner shows the Google account you want to use.

Select **Create a new Firebase project** (or **Create a project**), enter a project name such as `Sandwich Shop`, review the generated project ID underneath, and select **Continue**.

![Firebase create project page](images/9/firebase_create_project.png)

Disable Google Analytics when prompted if you want a simpler setup, otherwise create an account when prompted and set the analytics location to United Kingdom as shown below, then select **Create project**.

![Firebase analytics setup](images/9/firebase_analytics_setup.png)

Once Firebase finishes provisioning, select **Continue** to open your project overview, as shown below:

![The Firebase dashboard project overview showing the newly created project on the Spark plan](images/9/firebase_project_overview.png)

Notice **Gemini in Firebase** on the right-hand side of the project overview, which is available at no cost on the Spark plan. You can ask it general questions about Firebase services or Firestore queries, though it cannot edit your Flutter project files, so keep using GitHub Copilot in VS Code if you need an AI agent that can access your codebase.

### Set up user authentication

So far our app does not have any authentication mechanism, meaning customers cannot register or sign in yet. Ideally we would like to let users create accounts, sign in securely, and manage their orders and preferences within the app. We would also like their settings and preferences to be tied to their authenticated identity so they can access them across devices.

In the left navigation menu of the Firebase dashboard under **Product categories**, open **Security** and select **Authentication**, then select **Get started**. Under the **Sign-in method** tab, choose **Email/Password**, toggle both **Enable** and **Email link (passwordless sign-in)** on if you want both password and email-link sign-in, and select **Save**.

To let customers sign in with their Google account too, select **Add new provider**, choose **Google**, toggle **Enable** on, set the public-facing project name and support email, and select **Save**, as shown below:

![The Firebase Authentication screen with Email/Password and Google listed as Enabled](images/9/firebase_auth_enabled.png)

### Create a Cloud Firestore database

Once user accounts are enabled, the app also needs a cloud database to hold the shared menu alongside each customer's saved settings and order history so nothing stays trapped on one phone.

In this section we will use Firestore which is the cloud-hosted NoSQL (not necessarily relational) database provided by Firebase, designed to store and sync data for client- and server-side development. It allows us to structure our data into collections and documents, making it easy to manage user-specific data such as saved settings and order history while keeping it accessible across devices.

In the left navigation menu under **Product categories**, open **Databases and storage** and select **Firestore**, then select **Create database**. Keep **Standard edition** selected and select **Next**, pick a nearby location such as `europe-west2` (London) and select **Next**, choose **Start in test mode** and select **Next**, then leave scheduled backups skipped and select **Create**, as shown below:

![The Cloud Firestore dashboard showing the new empty database ready for collections](images/9/firebase_firestore_created.png)

Starting in test mode leaves the database open for 30 days so your app can read and write data freely while you build it. Before finishing, we replace those open rules so each signed-in customer can only access their own orders and settings in [Protect user data with security rules](#protect-user-data-with-security-rules).

### Install the Firebase and FlutterFire tools

Before editing any Dart code, your project needs a few setup files linking it to your `Sandwich Shop` project on Firebase. The Firebase CLI lets you control Firebase from the terminal, and the FlutterFire CLI creates those Android and web setup files automatically so you do not have to configure them by hand.

Install the Firebase CLI following the [Firebase CLI documentation](https://firebase.google.com/docs/cli). Once it is installed, verify that it is correctly installed by running the following command in your terminal:

```bash
firebase --version
```

Next, sign in with the same Google account you used in the Firebase dashboard:

```bash
firebase login
```

If you are already signed into a different Google account in the CLI and want to switch accounts, run:

```bash
firebase login --reauth
```

Once signed in, install the FlutterFire CLI using Dart Pub:

```bash
dart pub global activate flutterfire_cli
```

Look at the end of the terminal output. If Dart shows a warning that `.pub-cache/bin` (or `Pub\Cache\bin`) is not on your `PATH`, add it before running `flutterfire`, as shown in the screenshot below:

![Terminal output showing the Dart warning that .pub-cache/bin is not on PATH and flutterfire command not found](images/9/flutterfire_path_warning.png)

On macOS, run the command below in your terminal, then close and reopen the terminal (use `~/.bashrc` instead on Linux):

```bash
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
```

On Windows, run these two lines in PowerShell, then close and reopen the terminal (or search the Start menu for **Edit environment variables for your account** and add `%LOCALAPPDATA%\Pub\Cache\bin` to **Path**):

```powershell
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
[Environment]::SetEnvironmentVariable('Path', "$userPath;$env:LOCALAPPDATA\Pub\Cache\bin", 'User')
```

Finally, open a new terminal and check that the `flutterfire` command responds:

```bash
flutterfire --version
```

You should get its version as shown below:

![Flutterfire CLI version output](images/9/flutterfire_version_output.png)

### Connect the Flutter app

Once the tools are ready, our app needs the official Firebase packages installed and initialised before any widgets read authentication state or database records.

Add the three Firebase packages we need across Android and web by running the following command in your project root:

```bash
flutter pub add firebase_core firebase_auth cloud_firestore
```

Now generate the Firebase configuration for both platforms using FlutterFire. Run the configure command in the root of your repository and select your project from the list when prompted:

```bash
flutterfire configure
```

When asked which platforms to support, use the arrow keys and space bar to select at least `android` and `web`, then press **Enter**. See below for an example of the selection process:

![FlutterFire platform selection example](images/9/flutterfire_platform_selection.png)

FlutterFire creates `android/app/google-services.json`, `lib/firebase_options.dart` and `firebase.json` (and updates your Android Gradle files) so your app knows which Firebase project to connect to, as shown below. These files do not contain private admin passwords — customer data is protected later by user sign-in and database security rules — so it is safe to commit them to Git.

![Terminal output showing flutterfire configure registering Android and Web apps](images/9/flutterfire_configure_output.png)

If you push `lib/firebase_options.dart` to a public GitHub repository, GitHub may send you a secret-scanning alert for a Google API key. As explained in [Learn about Firebase API keys](https://firebase.google.com/docs/projects/api-keys), Firebase client API keys only identify which project to reach and do not grant admin access on their own, so you can dismiss that alert once you lock down your database rules in [Protect user data with security rules](#protect-user-data-with-security-rules) (just never attach paid Google APIs such as Gemini or Google Maps to those Firebase client keys, and never commit downloaded admin service-account JSON files).

<!-- TODO: Done till here -->

Open `lib/main.dart` and add two imports at the top of the file so Dart can load the Firebase core package and the generated options:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:sandwich_shop/firebase_options.dart';
```

Firebase needs to connect before any screen loads, so change `main` to an `async` function that returns `Future<void>`. Calling `WidgetsFlutterBinding.ensureInitialized()` tells Flutter to prepare before the first screen builds, and `await Firebase.initializeApp(...)` loads the matching Android or web settings from `firebase_options.dart`.

Replace `main()` in `lib/main.dart` with the updated function below. Adding an optional `initializeFirebase` parameter (defaulting to `true`) lets the real app connect to Firebase normally while allowing automated tests to start `App` offline:

```dart
Future<void> main({bool initializeFirebase = true}) async {
  if (isSupportedPlatform()) {
    if (initializeFirebase) {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    runApp(const App());
  } else {
    runApp(const UnsupportedPlatformApp());
  }
}
```

Next, open `test/main_test.dart` and pass `initializeFirebase: false` to both `app.main()` calls inside the startup tests (`await app.main(initializeFirebase: false);`), then run `flutter test` to check that all existing tests still pass.

Finally, run the app on Chrome (`flutter run -d chrome`) and on your Android emulator to verify that both platforms connect to Firebase and open the menu screen cleanly, as shown below:

<!-- Capture: Sandwich Shop app running in Chrome web browser alongside Android emulator or device -->
![The Sandwich Shop app running in Chrome after connecting to Firebase](images/9/app_running_web.png)

### Support more platforms

Configuring Android and web gives every student a mobile emulator target and a browser target without extra desktop build tools. If you also want to run the app on iOS, macOS, Windows or Linux, you can enable those optional platforms in your existing Firebase project at any point.

First, generate the native folders for the extra platforms you want with `flutter create --platforms=ios,macos,windows,linux .`, keeping only the platform names you intend to use and deleting any starter `test/widget_test.dart` file if it is created. Check the build tools needed on your operating system (such as Xcode for iOS and macOS, with the **Keychain Sharing** capability enabled for macOS authentication, or the C++ desktop workload for Windows, as covered in [Run on other platforms](worksheet-7.md#run-on-other-platforms)).

Next, re-run `flutterfire configure` and select those additional platforms alongside `android` and `web` so FlutterFire updates `lib/firebase_options.dart` and creates any platform files such as `GoogleService-Info.plist` for Apple devices. Finally, update `isSupportedPlatform()` in `lib/main.dart` and its unit tests in `test/main_test.dart` so each extra `TargetPlatform` returns `true` instead of falling back to `UnsupportedPlatformApp`.

## Firebase Authentication

Before reading or saving any personal data in Cloud Firestore, the app must know which customer is signed in. Every signed-in user receives a unique user ID (`uid`) from Firebase Authentication, which later sections use as the key for storing that customer's own settings and orders.

### Sign up, sign in and sign out

Customers need a simple way to create an account, sign back in on any device, and sign out when someone else shares the browser or phone. Separating authentication logic behind an `AuthRepository` keeps our screens clean and makes testing sign-in flows straightforward.

<!-- TODO: build a dedicated sign-in / registration screen using FirebaseAuth (Email/Password, optional Email link, and Google Sign-In via google_sign_in), wrap auth operations in an AuthRepository, show clear validation/error messages, and react to authStateChanges() across the app. Include an optional Android-only step here (after flutterfire configure has registered the Android app) to get the debug SHA-1 certificate fingerprint from the android/ folder (./gradlew signingReport) and add it in Project settings if testing Google Sign-In on an Android emulator/device (web and Email/Password work without this step). -->

## Cloud Firestore

With authentication in place to identify each customer, we can store both shared shop data and private user data in Cloud Firestore. Rather than SQL tables and joins, Firestore stores data as documents inside collections, which syncs automatically between Android and the web.

### Read the menu from Firestore

Keeping the menu in a bundled JSON file meant changing a sandwich name, description or price required releasing an updated app. Moving sandwich details into a shared Firestore collection lets the shop update the live menu for every customer immediately while keeping the bundled asset images fast to load.

<!-- TODO: seed and read a Cloud Firestore 'sandwiches' collection (including bundled asset image paths) instead of loading menu metadata only from local JSON. -->

### Save user settings in the cloud

In Worksheet 8, settings such as text size were stored locally in `SharedPreferences`, so changing phones or switching to Chrome reset the customer's choices. Saving settings inside a Firestore document under each user's `uid` ties preferences to the account rather than the device.

<!-- TODO: persist user settings (font size, default bread, etc.) per UID under users/<uid> in Cloud Firestore rather than local-only SharedPreferences, syncing settings when the user signs in on Android or web. -->

### Store and read orders

Until now, order history lived in a local SQLite database that could not follow a customer to another device or work in a web browser. Storing each customer's orders in an `orders` list (a subcollection) under their account replaces local SQLite and keeps orders attached to the person who placed them.

<!-- TODO: replace SQLite DatabaseHelper / SqliteOrderRepository with a Cloud Firestore order flow under users/<uid>/orders so orders work cleanly on both Android and web. -->

### Test with multiple users

To prove that cloud storage and authentication keep each person's data separate, we need to test the app with more than one account. Signing in as a second customer should show their own saved settings and their own order history without exposing the first customer's records.

<!-- TODO: walk through registering/signing in with two test accounts across Chrome and Android, updating settings and placing orders in each, and inspecting the users/<uid> documents in the Cloud Firestore dashboard to show per-user isolation and cross-device sync. -->

### Protect user data with security rules

We started Cloud Firestore in test mode so our app can read and write documents while we build it, which leaves customer records open to anyone. Replacing those temporary rules with Firestore Security Rules lets anyone read the public menu, while each customer can only read or change their own settings and orders once signed in.

<!-- TODO: replace temporary test mode rules with Firestore Security Rules allowing public read on the menu collection and owner-only read/write (request.auth != null && request.auth.uid == userId) on users/<uid> and orders. -->

## Testing cloud code

### Fake Firebase in unit tests

Running automated tests against live Firebase servers is slow, needs an internet connection, and writes test records into your real database. Replacing live Firebase connections with fake in-memory versions lets tests check sign-in, settings and orders offline in milliseconds.

<!-- TODO: add firebase_auth_mocks and fake_cloud_firestore as dev dependencies so Auth and Firestore repositories can be tested fast offline without hitting live Firebase servers. -->

### Keep coverage high

Every new repository method, error branch and authentication state introduces paths that could silently break checkout or lock users out if untested. Checking coverage ensures our new cloud code stays just as reliable as the local code from Worksheet 8.

<!-- TODO: run flutter test --coverage and check the new Auth, Firestore repository, and error states with the Flutter Coverage extension, mirroring lib/ inside test/. -->

## Exercises

The exercises below apply these concepts to your Southsea Cinema coursework and prepare you for Demo 5. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw).

<!-- TODO: write numbered exercises:
1. Create a Firebase project on the free Spark plan, enable Email/Password Authentication and Cloud Firestore, and connect Southsea Cinema for Android and web with flutterfire configure.
2. Store the cinema film catalogue details (title, synopsis, ticket price, rating, screening times, and local poster asset path) in a Cloud Firestore collection while keeping poster image files in assets/images/.
3. Add user registration, sign-in and sign-out so customers view only their own bookings and saved cinema preferences in the cloud.
4. Implement transactional Cloud Firestore booking creation and saved booking history replacing SQLite.
5. Add unit and widget tests using fake_cloud_firestore and firebase_auth_mocks and maintain test coverage matching lib/ inside test/.
-->
