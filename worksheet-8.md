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

For this worksheet, you need to start with the code from branch 8 of our [GitHub repository](https://github.com/manighahrmani/sandwich_shop/tree/8). You can either clone the repository and checkout branch 8:

```bash
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
git checkout 8
```

Or manually ensure your code matches the repository. Run the app to make sure everything works as expected before proceeding.

## **Integration Testing**

So far, we have written **unit tests** to check individual functions or classes and **widget tests** to verify that our widgets look and behave as expected. However, these tests don't tell us if the different parts of our app work together correctly. **Integration tests** verify that different parts of your app work together properly.

Integration tests verify the behaviour of the complete app. They simulate an end-to-end user flow from launching the app to navigating between screens and performing various actions.

For a more detailed introduction to integration testing in Flutter, you can read the official documentation on the topic: [Introduction to integration testing](https://docs.flutter.dev/cookbook/testing/integration/introduction). In this worksheet, we'll provide a brief example of integration tests to verify the functionality of our app.

### **Writing Integration Tests**

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

Inside the `integration_test` directory, create a new file called `app_test.dart`. Below is an example of the integration test code that you can write in such file:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('add a sandwich to the cart and verify it is in the cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test the initial state of the app (on the order screen)
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsWidgets);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton); // Scroll if needed
      await tester.pumpAndSettle();

      // Add a sandwich to the cart
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart summary updated
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      // Find the View Cart button to navigate to the cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify that we're on the cart screen and the sandwich is there
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
    });

    testWidgets('change sandwich type and add to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();

      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('modify quantity and add to cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final quantitySection = find.text('Quantity: ');
      expect(quantitySection, findsOneWidget);

      // Find the + button that's near the quantity text
      final addButtons = find.byIcon(Icons.add);
      // The + button should be the first one (before the cart + button)
      final quantityAddButton = addButtons.first;

      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('complete checkout flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);

      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pumpAndSettle();

      // Wait for payment processing (2 seconds + buffer)
      await tester.pump(const Duration(seconds: 3));

      // Should be back on order screen with empty cart
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

    // Feel free to add more tests (e.g., to check saved orders, etc.)
  });
}
```

Run the integration tests, use the following command or using the Run button on top of the `main` function in VS Code:

```bash
flutter test integration_test/
```

Note that the integration tests must be run on a real device or an emulator/simulator.

## **Firebase**

So far, our app has been completely self-contained. All the data is stored on the device, and there is no communication with a server. However, most real-world apps need to communicate with a server to store and retrieve data.

**Cloud providers** like Amazon Web Services (AWS), Google Cloud Platform (GCP), and Microsoft Azure offer a wide range of services that you can use to build and deploy your app. These services include things like databases, authentication, and hosting.

**Firebase** is a platform developed by Google for creating mobile and web applications. It provides a suite of tools and services that can help you build your app faster and with less effort.

Some of the key features of Firebase include:

  - **Authentication**: Firebase Authentication allows you to easily add user authentication to your app. You can use a variety of authentication providers, including email and password, phone numbers, and social media providers like Google, Facebook, and Twitter.
  - **Firestore Database**: Firestore is a NoSQL database that you can use to store and sync data for your app. It is a flexible, scalable database for mobile, web, and server development from Firebase and Google Cloud.
  - **Hosting**: Firebase Hosting provides fast and secure hosting for your web app.
  - **Storage**: Firebase Storage allows you to store and serve user-generated content, such as photos and videos.

This is an advanced topic that you can explore if you have extra time. Using Firebase in your coursework can earn you extra marks, but you will need to explore it independently.

### **Using Firebase with Flutter**

To use Firebase with Flutter, you will need to add the Firebase SDK to your app. You can find more information on how to do this in the official Firebase documentation: [Get started with Firebase for Flutter](https://firebase.google.com/docs/flutter/setup).

You can also check out this interactive codelab to learn more about using Firebase with Flutter: [Get to know Firebase for Flutter](https://firebase.google.com/codelabs/firebase-get-to-know-flutter#0).

### **JSON Serialization**

When you are working with data from a server, you will often need to convert it from a JSON format to a Dart object. This process is called **JSON serialization**.

You can learn more about JSON serialization in the official Flutter documentation: [JSON and serialization](https://docs.flutter.dev/data-and-backend/serialization/json).

### **Factory Constructors**

When you are working with JSON serialization, you will often need to use **factory constructors**. A factory constructor is a special type of constructor that can return an instance of a class that is not the same as the class it is defined in.

For example, you could use a factory constructor to create a `User` object from a JSON map:

```dart
class User {
  final String name;
  final String email;

  User(this.name, this.email);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['name'],
      json['email'],
    );
  }
}
```

### **Firebase Realtime Database**

For your coursework, you might want to use the Firebase Realtime Database to store and sync data for your app. The Realtime Database is a cloud-hosted database. Data is stored as JSON and synchronised in realtime to every connected client.

You can learn more about using the Firebase Realtime Database with Flutter in the official documentation: [Get Started with Firebase Realtime Database for Flutter](https://firebase.google.com/docs/database/flutter/start).

## **Deployment**

Once you have finished developing and testing your app, you may want to deploy it to your users. The deployment process involves creating a release build of your app, which is an optimised version of your app that is ready for production.

You can find more information about deploying Flutter apps in the official documentation: [Deployment](https://docs.flutter.dev/deployment).

### **Build Modes**

Flutter has three build modes:

  - **Debug mode**: This is the mode you use when you are developing your app. It includes features like hot reload and a debugger, but it is not optimised for performance.
  - **Profile mode**: This mode is used to analyse the performance of your app. It is similar to release mode, but it includes some extra debugging information.
  - **Release mode**: This is the mode you should use when you are ready to deploy your app. It is optimised for performance and does not include any debugging information.

When you are submitting your coursework, you should always create a release build of your app. You can do this by running the following command:

```bash
flutter build <target> --release
```

Replace `<target>` with the platform you want to build for (e.g., `apk` for Android, `ipa` for iOS).

### **Code Obfuscation**

When you create a release build of your app, you should also consider obfuscating your code. **Code obfuscation** is the process of modifying your app's binary to make it harder for humans to understand. This can help protect your app from reverse engineering and other security threats.

You can learn more about code obfuscation in the official Flutter documentation: [Obfuscate your app](https://docs.flutter.dev/deployment/obfuscate).

### **Preparing for Submission**

Before you submit your coursework, there are a few things you should do to make sure your app is ready:

  - **Clean your project**: Run `flutter clean` to remove any temporary files from your project.
  - **Update your `README.md`**: Your `README.md` file should include instructions on how to build and run your app, as well as any other relevant information.
  - **Create a release build**: Create a release build of your app for the platform you are targeting.

For more information on building and releasing apps for different platforms, you can check out the following guides:

  - [Build and release an Android app](https://docs.flutter.dev/deployment/android)
  - [Build and release an iOS app](https://docs.flutter.dev/deployment/ios)
  - [Build and release a macOS app](https://docs.flutter.dev/deployment/macos)
  - [Build and release a Linux app](https://docs.flutter.dev/deployment/linux)
  - [Build and release a Windows app](https://docs.flutter.dev/deployment/windows)
  - [Build and release a web app](https://docs.flutter.dev/deployment/web)


## **Exercises**

This has been a very heavy worksheet, so the exercises for this week are a bit lighter.

1.  **Write an integration test**: Write an integration test for a key user flow in your app. For example, you could write a test that adds an item to the cart, navigates to the checkout screen, and completes the order.
2.  **Set up Firebase**: Set up a Firebase project and implement one feature using Firebase. For example, you could use Firebase Authentication to add user authentication to your app, or you could use Firestore to store your order history.
3.  **Deploy your app**: Prepare your app for submission by creating a release build and updating your `README.md` file.