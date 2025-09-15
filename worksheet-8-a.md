# **Worksheet 8 — Integration Testing, Firebase, and Deployment**

## **What you need to know beforehand**

Ensure that you have already completed the following:
- [Worksheet 0 — Introduction to Dart, Git and GitHub](./worksheet-0.md).
- [Worksheet 1 — Introduction to Flutter](./worksheet-1.md).
- [Worksheet 2 — Stateless Widgets](./worksheet-2.md).
- [Worksheet 3 — Stateful widgets](./worksheet-3.md).
- [Worksheet 4 — App Architecture and Testing](./worksheet-4.md).
- [Worksheet 5 — Data Models and Assets](./worksheet-5.md).
- [Worksheet 6 — AI-Driven Development and Navigation](./worksheet-6.md).
- [Worksheet 7 — State Management and Persistence](./worksheet-7.md).

## **Getting help**

To get support with this worksheet, join the [Discord channel](https://portdotacdotuk-my.sharepoint.com/:b:/g/personal/mani_ghahremani_port_ac_uk/EbX583gvURRAhqsnhYqmbSEBwIFw6tXRyz_Br1GxIyE8dg) and ask your questions there. Otherwise, attend your timetabled session and ask a member of staff for help.

## **Getting started**

For this worksheet, you can continue with your code from the previous worksheet. Make sure your app runs correctly and all tests pass before proceeding.

## **Introduction to Integration Testing**

So far, we've written unit tests (testing individual functions and classes) and widget tests (testing individual widgets). While these are essential, they don't tell us if our app works correctly as a whole. **Integration tests** verify that different parts of your app work together properly.

Integration tests are also called **end-to-end tests** or **GUI tests**. They simulate real user interactions with your app, like tapping buttons, entering text, and navigating between screens. This helps catch issues that might not appear in isolated unit or widget tests.

For more comprehensive information about integration testing in Flutter, see the [official documentation](https://docs.flutter.dev/cookbook/testing/integration/introduction).

### **When to use integration tests**

Integration tests are particularly useful for:
- Testing complete user workflows (like placing an order from start to finish)
- Verifying that navigation between screens works correctly
- Ensuring that state management works across multiple screens
- Testing that data persists correctly throughout the app lifecycle

### **Setting up integration tests**

Flutter provides the `integration_test` package for writing integration tests. Let's add it to your project:

```bash
flutter pub add 'dev:integration_test:{"sdk":"flutter"}'
```

Create a new directory called `integration_test` in your project root (at the same level as `lib` and `test`):

```
sandwich_shop/
├── lib/
├── test/
├── integration_test/
└── ...
```

### **Writing your first integration test**

Let's write an integration test that verifies the complete flow of adding a sandwich to the cart and viewing it. Create a file called `integration_test/app_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Sandwich Shop Integration Tests', () {
    testWidgets('Complete order flow test', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify we're on the order screen
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);

      // Add a sandwich to cart
      final addToCartButton = find.text('Add to Cart');
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart summary updated
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      // Navigate to cart view
      final viewCartButton = find.text('View Cart');
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify we're on cart screen and item is there
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);

      // Go back to order screen
      final backButton = find.text('Back to Order');
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify we're back on order screen
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('Settings screen font size test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to settings
      final settingsButton = find.text('Settings');
      await tester.ensureVisible(settingsButton);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // Verify we're on settings screen
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);

      // Find and interact with the slider
      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      // Drag the slider to change font size
      await tester.drag(slider, const Offset(50, 0));
      await tester.pumpAndSettle();

      // Verify the font size changed (text should be different)
      expect(find.text('Current size: 16px'), findsNothing);
    });
  });
}
```

### **Running integration tests**

To run your integration tests, use the following command:

```bash
flutter test integration_test/
```

For more detailed information about writing and running integration tests, see the [Flutter integration testing guide](https://docs.flutter.dev/testing/integration-tests).

#### **Commit your changes**

Commit your integration tests before moving on to the next section.

## **Introduction to Cloud Services and Firebase**

As your app grows, you'll likely need services that go beyond what you can store locally on a device. **Cloud services** provide remote servers that can handle data storage, user authentication, file hosting, and much more.

### **What are cloud providers?**

Cloud providers are companies that offer computing services over the internet. Instead of running your own servers, you can use their infrastructure to:
- Store and retrieve data from anywhere in the world
- Authenticate users securely
- Host your app's files and images
- Send notifications to users
- Scale your app to handle millions of users

Popular cloud providers include Amazon Web Services (AWS), Google Cloud Platform, Microsoft Azure, and Firebase (which is part of Google Cloud).

### **Introduction to Firebase**

**Firebase** is Google's mobile and web application development platform. It provides a suite of tools that make it easier to build, improve, and grow your app. Firebase is particularly popular with Flutter developers because Google maintains both platforms.

Key Firebase features include:
- **Authentication**: Secure user sign-in with email, Google, Facebook, and more
- **Firestore Database**: A flexible, scalable NoSQL database
- **Realtime Database**: A cloud-hosted database with real-time synchronization
- **Storage**: Cloud storage for user-generated content like images and videos
- **Hosting**: Fast and secure web hosting
- **Cloud Functions**: Server-side code that runs in response to events

For your coursework, Firebase can significantly enhance your app by adding features like user accounts, cloud data storage, and image uploads.

### **Getting started with Firebase**

To use Firebase with Flutter, you'll need to:

1. Create a Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/)
2. Configure your Flutter app to work with Firebase
3. Add the necessary Firebase packages to your project

The complete setup process is detailed in the [Firebase for Flutter documentation](https://firebase.google.com/docs/flutter). This includes platform-specific configuration for Android and iOS.

### **JSON and Data Serialization**

Before working with cloud databases, you need to understand **JSON** (JavaScript Object Notation) and **serialization**.

JSON is a lightweight data format that's easy for humans to read and write. It's the standard way to exchange data between your app and web services. Here's an example:

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30,
  "isActive": true
}
```

**Serialization** is the process of converting your Dart objects into JSON format (and vice versa). This is essential when storing data in Firebase or sending data over the internet.

For detailed information about JSON serialization in Flutter, see the [official serialization guide](https://docs.flutter.dev/data-and-backend/serialization/json).

### **Factory constructors in Dart**

When working with JSON serialization, you'll often see **factory constructors**. A factory constructor is a special type of constructor that doesn't always create a new instance of the class. Instead, it can return an existing instance or perform some logic before creating the instance.

Here's an example of how you might use a factory constructor for JSON deserialization:

```dart
class User {
  final String name;
  final String email;

  User(this.name, this.email);

  // Factory constructor for creating User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['name'] as String,
      json['email'] as String,
    );
  }

  // Method for converting User to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}
```

The `factory` keyword tells Dart that this constructor might not return a new instance every time it's called.

### **Firebase Realtime Database example**

If you decide to integrate Firebase, the [Realtime Database](https://firebase.google.com/docs/database/flutter/start) is a good starting point. It allows you to store and sync data in real-time across all connected devices.

Here's a simple example of how you might store order data:

```dart
import 'package:firebase_database/firebase_database.dart';

class FirebaseOrderService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> saveOrder(Map<String, dynamic> orderData) async {
    try {
      await _database.child('orders').push().set(orderData);
    } catch (e) {
      print('Error saving order: $e');
    }
  }

  Stream<DatabaseEvent> getOrders() {
    return _database.child('orders').onValue;
  }
}
```

For hands-on practice with Firebase and Flutter, consider working through the [Firebase Flutter codelab](https://firebase.google.com/codelabs/firebase-get-to-know-flutter#0).

## **Deployment and Production Builds**

When you're ready to share your app with others, you need to create a **production build**. This is different from the debug builds you've been using during development.

### **Build modes in Flutter**

Flutter has three build modes:

- **Debug mode**: Used during development. Includes debugging information and hot reload. Apps are larger and slower.
- **Profile mode**: Used for performance testing. Includes some debugging features but is optimized for performance analysis.
- **Release mode**: Used for production. Fully optimized, smallest size, fastest performance, no debugging features.

Always use release mode for apps you distribute to users.

### **Creating a release build**

Before creating a release build, it's good practice to clean your project:

```bash
flutter clean
flutter pub get
```

Then create a release build for your target platform:

```bash
# For Android APK
flutter build apk --release

# For Android App Bundle (recommended for Play Store)
flutter build appbundle --release

# For iOS
flutter build ios --release

# For web
flutter build web --release
```

### **Code obfuscation**

**Code obfuscation** makes your compiled code harder for others to reverse engineer by replacing class and function names with meaningless symbols. While it's not foolproof security, it adds a layer of protection for your intellectual property.

To build with obfuscation:

```bash
flutter build apk --obfuscate --split-debug-info=build/app/outputs/symbols
```

The `--split-debug-info` flag creates symbol files that you'll need if you want to debug crash reports from obfuscated builds. Keep these files safe!

**Important notes about obfuscation:**
- Only works on release builds
- Web apps use minification instead of obfuscation
- Don't store secrets in your app code - obfuscation won't protect them
- Code that relies on specific class names (like some reflection) may break

For more details, see the [Flutter obfuscation guide](https://docs.flutter.dev/deployment/obfuscate).

### **Platform-specific deployment**

Each platform has its own deployment process:

- **Android**: [Build and release an Android app](https://docs.flutter.dev/deployment/android)
- **iOS**: [Build and release an iOS app](https://docs.flutter.dev/deployment/ios)
- **Web**: [Build and release a web app](https://docs.flutter.dev/deployment/web)
- **Desktop**: Guides for [Windows](https://docs.flutter.dev/deployment/windows), [macOS](https://docs.flutter.dev/deployment/macos), and [Linux](https://docs.flutter.dev/deployment/linux)

### **Preparing your project for submission**

When submitting your coursework or sharing your project, make sure to:

1. **Clean your project**: Run `flutter clean` to remove build artifacts
2. **Update your README.md**: Include setup instructions, features, and how to run the app
3. **Test thoroughly**: Run all tests and verify the app works on different devices
4. **Check your pubspec.yaml**: Ensure all dependencies are properly listed
5. **Remove sensitive data**: Don't commit API keys or personal information

### **Writing a good README.md**

Your README.md should include:

```markdown
# Sandwich Shop App

A Flutter app for ordering sandwiches with cart functionality and user preferences.

## Features

- Browse sandwich options with different sizes and bread types
- Add items to cart with quantity selection
- View and modify cart contents
- User profile management
- Settings with customizable font size
- Order history with local storage

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/sandwich_shop.git
   cd sandwich_shop
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Running Tests

```bash
# Unit and widget tests
flutter test

# Integration tests
flutter test integration_test/
```

### Building for Release

```bash
flutter build apk --release
```

## Architecture

The app follows a clean architecture pattern with:
- Models for data representation
- Repositories for business logic
- Views for UI components
- State management using Provider

## Dependencies

- `provider`: State management
- `shared_preferences`: Local data persistence
- `sqflite`: Local database storage
```

## **Exercises**

Complete the exercises below to practice integration testing and explore deployment options.

1. **Write comprehensive integration tests**

   Create integration tests that cover the main user journeys in your app. Your tests should include:
   - Adding multiple different sandwiches to the cart
   - Modifying quantities in the cart
   - Completing the checkout process
   - Testing the profile screen functionality

   Use your AI assistant to help you identify edge cases and write thorough tests. Remember to test both happy paths (everything works correctly) and error scenarios.

   ⚠️ **Show your running integration tests to a member of staff** for a sign-off.

2. **Create a production-ready build**

   Create a release build of your app and test it thoroughly. Your tasks:
   - Clean your project and create a release build
   - Test the release build on a device or emulator
   - Create an obfuscated build and verify it still works
   - Update your README.md with clear setup and build instructions

   Compare the size and performance of your debug vs release builds. What differences do you notice?

   ⚠️ **Show your release build running and your updated README to a member of staff** for a sign-off.

3. **Explore Firebase integration (Advanced)**

   This exercise is optional but will significantly enhance your coursework if completed. Choose one Firebase feature to integrate into your app:

   - **Authentication**: Add user sign-in/sign-up functionality
   - **Firestore Database**: Store orders in the cloud instead of locally
   - **Storage**: Allow users to upload profile pictures
   - **Hosting**: Deploy your web version to Firebase Hosting

   Start with the [Firebase Flutter setup guide](https://firebase.google.com/docs/flutter) and work through the relevant documentation for your chosen feature. Use your AI assistant to help you understand the concepts and implement the integration.

   This task is **optional** and there's no need to show it to a member of staff for a sign-off, but it will demonstrate advanced skills in your coursework.

4. **Performance and optimization (Advanced)**

   Analyze your app's performance and implement optimizations:
   - Use Flutter's performance profiling tools to identify bottlenecks
   - Optimize your widget rebuilds using `const` constructors where possible
   - Implement lazy loading for large lists if applicable
   - Consider using `ListView.builder` instead of `Column` for dynamic content

   Document your findings and optimizations in your README.md.

   This task is **optional** and there's no need to show it to a member of staff for a sign-off.

## **Conclusion**

Congratulations on completing the Flutter development worksheets! You've learned to build a complete mobile app with:
- Clean architecture and proper testing
- State management and data persistence
- Navigation and user interface design
- Integration testing and deployment

These skills form a solid foundation for mobile app development. As you continue your journey, consider exploring:
- Advanced state management solutions (Bloc, Riverpod)
- Backend integration and APIs
- Advanced animations and custom widgets
- Platform-specific features and plugins
- Continuous integration and deployment (CI/CD)

Remember to keep practicing and building projects to reinforce what you've learned. The Flutter community is vibrant and helpful - don't hesitate to engage with it as you continue developing your skills.