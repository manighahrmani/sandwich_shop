# Worksheet 3 — Data Models, Repositories, Assets and In-Page Navigation

## Table of contents

- [What you need to know beforehand](#what-you-need-to-know-beforehand)
- [Getting help](#getting-help)
- [Getting started](#getting-started)
- [The need for structured data](#the-need-for-structured-data)
- [Define the Sandwich data model](#define-the-sandwich-data-model)
  - [Create the model class](#create-the-model-class)
  - [Implement the Sandwich constructor](#implement-the-sandwich-constructor)
  - [Commit your changes (1)](#commit-your-changes-1)
- [Add asset images to the project](#add-asset-images-to-the-project)
  - [Create the assets folder](#create-the-assets-folder)
  - [Register assets in pubspec](#register-assets-in-pubspec)
  - [Commit your changes (2)](#commit-your-changes-2)
- [Abstract data access with a repository](#abstract-data-access-with-a-repository)
  - [Understand the repository pattern](#understand-the-repository-pattern)
  - [Create the SandwichRepository class](#create-the-sandwichrepository-class)
  - [Return mock sandwich items](#return-mock-sandwich-items)
  - [Commit your changes (3)](#commit-your-changes-3)
- [Build the menu interface](#build-the-menu-interface)
  - [Create the SandwichCard widget](#create-the-sandwichcard-widget)
  - [Commit your changes (4)](#commit-your-changes-4)
  - [Build the MenuScreen widget](#build-the-menuscreen-widget)
  - [Set MenuScreen as the home screen](#set-menuscreen-as-the-home-screen)
  - [Commit your changes (5)](#commit-your-changes-5)
- [Navigate between screens and pass data](#navigate-between-screens-and-pass-data)
  - [Understand stack-based navigation](#understand-stack-based-navigation)
  - [Update OrderScreen to accept a Sandwich](#update-orderscreen-to-accept-a-sandwich)
  - [Commit your changes (6)](#commit-your-changes-6)
  - [Connect SandwichCard to OrderScreen](#connect-sandwichcard-to-orderscreen)
  - [Test the complete navigation flow](#test-the-complete-navigation-flow)
  - [Commit your changes (7)](#commit-your-changes-7)
- [Exercises](#exercises)

## What you need to know beforehand

Ensure that you have completed [Worksheet 1 — Dart, Git, GitHub and Flutter](./worksheet-1.md) and [Worksheet 2 — Stateless and Stateful Widgets](./worksheet-2.md). You should be familiar with creating `StatelessWidget` and `StatefulWidget` classes, calling `setState()` to update user interfaces, and managing basic layout widgets like `Row`, `Column`, and `Scaffold`.

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

You can continue directly with the repository you updated in Worksheet 2. Alternatively, switch to branch `2` of the [Sandwich Shop repository](https://github.com/manighahrmani/sandwich_shop/tree/2), which holds the complete solution from Worksheet 2:

```bash
git checkout 2
```

Ensure that your working tree is clean before starting. If you have uncommitted changes from earlier exercises, commit or stash them first.

## The need for structured data

At the end of Worksheet 2, the Sandwich Shop app displayed a single counter on a single screen. The word "Footlong" and the maximum order quantity were hardcoded directly into the widgets. In a real application, a shop offers multiple items with distinct names, descriptions, prices, and photographs.

Putting all of this information directly inside widget build methods creates code that is difficult to read and maintain. If you change a price or add a new sandwich, you should not need to rewrite your user interface widgets. To solve this, we separate our application into distinct layers:

1. **Models:** Plain Dart classes that define the structure of our data.
2. **Repositories:** Classes responsible for fetching and providing data to the application.
3. **Views and Widgets:** User interface classes that display the data and respond to user gestures.

This principle is known as separation of concerns. In this worksheet, we will refactor our app to follow this structure and introduce navigation between screens.

## Define the Sandwich data model

A data model is a class that represents a business concept in your application. For our sandwich shop, we need a model that holds the details of an individual sandwich.

### Create the model class

Create a new directory called `lib/models/`. Inside it, create a new file named `sandwich.dart`.

Every sandwich on our menu needs an identifier, a display name, a descriptive text summary, a price, and a path to an image file. Open `lib/models/sandwich.dart` and define the class with five `final` fields:

```dart
class Sandwich {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;
}
```

Marking fields as `final` ensures that once a `Sandwich` instance is created, its attributes cannot be accidentally modified. This immutability prevents unexpected side effects across your app.

### Implement the Sandwich constructor

Now add a constructor so you can create instances of `Sandwich`. We use named arguments marked with the `required` keyword so that anyone creating a sandwich must explicitly supply every attribute:

```dart
class Sandwich {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;

  const Sandwich({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
  });
}
```

The `const` constructor enables Flutter to create compile-time constants when fixed values are used, which reduces memory allocations. If you need a reminder on Dart constructor syntax, refer to the [official Dart classes documentation](https://dart.dev/language/classes) and the module [Dart software and resources guide](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQAeCWXLehKuTou1gTpjrNKRAcCHcRGxPJSinskA7x1opXg?e=lfIK0S).

Your `lib/models/sandwich.dart` file should look like this in VS Code:

![The Sandwich model class defined in lib/models/sandwich.dart](images/3/sandwich_model_code.png)

### Commit your changes (1)

Save your new file. In the Source Control panel, stage `lib/models/sandwich.dart` and commit your changes with the message `Add Sandwich data model`.

## Add asset images to the project

Mobile and web applications frequently bundle image assets alongside source code, such as product photos and icons. In Flutter, static assets must be stored in your project directory and declared in `pubspec.yaml`.

### Create the assets folder

Create a new folder in the root of your project called `assets/images/`.

Place two image files inside this directory: one for a footlong sandwich called `footlong.png` and one for a six-inch sandwich called `six_inch.png`. You can use your own image files or download sample sandwich illustrations.

Your project folder structure should look like this:

```text
sandwich_shop/
├── assets/
│   └── images/
│       ├── footlong.png
│       └── six_inch.png
├── lib/
│   ├── models/
│   │   └── sandwich.dart
│   └── main.dart
└── pubspec.yaml
```

### Register assets in pubspec

Flutter does not include files in your app bundle automatically. You must register the assets folder in `pubspec.yaml` so Flutter knows to package them.

Open `pubspec.yaml`. Scroll down to the `flutter:` section at the bottom of the file and add an `assets:` entry:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

YAML files are sensitive to indentation. Ensure that `assets:` is indented by two spaces beneath `flutter:`, and the list dash is indented by four spaces. Listing the directory with a trailing slash tells Flutter to include every file inside `assets/images/`.

The `pubspec.yaml` assets configuration should look like this:

![The assets declaration in pubspec.yaml with two-space indentation](images/3/pubspec_assets_indentation.png)

Save the file and run `flutter pub get` in your terminal to update your project configuration.

### Commit your changes (2)

Stage your two image files and the modified `pubspec.yaml`. Commit your work with the message `Register sandwich image assets in pubspec`.

## Abstract data access with a repository

Now that we have a model and images, we need a place to store and retrieve our menu items.

### Understand the repository pattern

A repository is a class that acts as a boundary between your application data and your user interface. It provides high-level methods to read and write data.

In this worksheet, our repository returns a fixed list of mock sandwiches. Later in the module, you will replace mock data with local database queries and cloud network requests. Because the widgets only interact with the repository, you will not have to rewrite your UI when your data source changes.

### Create the SandwichRepository class

Create a new directory called `lib/repositories/`. Inside it, create a new file named `sandwich_repository.dart`.

Import your `Sandwich` model at the top of the file, then declare the `SandwichRepository` class:

```dart
import 'package:sandwich_shop/models/sandwich.dart';

class SandwichRepository {
  List<Sandwich> getSandwiches() {
    return const [];
  }
}
```

### Return mock sandwich items

Update the `getSandwiches()` method to return a list containing two sandwiches, using the asset image paths you registered earlier:

```dart
import 'package:sandwich_shop/models/sandwich.dart';

class SandwichRepository {
  List<Sandwich> getSandwiches() {
    return const [
      Sandwich(
        id: 'footlong',
        name: 'Footlong Sub',
        description:
            'A freshly baked 12-inch sandwich filled with savoury ingredients and fresh salad.',
        price: 7.50,
        imagePath: 'assets/images/footlong.png',
      ),
      Sandwich(
        id: 'six-inch',
        name: 'Six-Inch Sub',
        description:
            'A lighter 6-inch sandwich made to order with your favourite toppings.',
        price: 4.50,
        imagePath: 'assets/images/six_inch.png',
      ),
    ];
  }
}
```

Notice that each sandwich specifies its own `name`, `price`, and `imagePath`. This repository is now the single source of truth for menu data in our app.

Your `lib/repositories/sandwich_repository.dart` file should look like this:

![The SandwichRepository class returning mock menu items](images/3/sandwich_repository_code.png)

### Commit your changes (3)

Stage `lib/repositories/sandwich_repository.dart` and commit your changes with the message `Create SandwichRepository with mock menu data`.

## Build the menu interface

With data and images ready, we can construct a menu screen that displays each sandwich.

### Create the SandwichCard widget

Create a new directory called `lib/widgets/`. Inside it, create a file named `sandwich_card.dart`.

This widget is responsible for presenting one sandwich item. It displays the sandwich image, name, description, price, and an **Order** button inside a `Card` widget.

Add the following code to `lib/widgets/sandwich_card.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/sandwich.dart';

class SandwichCard extends StatelessWidget {
  final Sandwich sandwich;

  const SandwichCard({super.key, required this.sandwich});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  sandwich.imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sandwich.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sandwich.description,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '£${sandwich.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Order'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

Notice the use of `Image.asset(sandwich.imagePath)`. This widget loads the image from the bundle using the path specified in our model. `toStringAsFixed(2)` formats the price to two decimal places.

Your `lib/widgets/sandwich_card.dart` file should look like this:

![The SandwichCard widget build method](images/3/sandwich_card_widget.png)

### Commit your changes (4)

Stage `lib/widgets/sandwich_card.dart` and commit your changes with the message `Create SandwichCard widget`.

### Build the MenuScreen widget

Create a new directory called `lib/screens/`. Inside it, create a file named `menu_screen.dart`.

`MenuScreen` instantiates our `SandwichRepository`, fetches the sandwich list, and uses a `ListView.builder` to display a `SandwichCard` for each item.

Add the following code to `lib/screens/menu_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/sandwich_repository.dart';
import 'package:sandwich_shop/widgets/sandwich_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SandwichRepository repository = SandwichRepository();
    final List<Sandwich> sandwiches = repository.getSandwiches();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Menu'),
      ),
      body: ListView.builder(
        itemCount: sandwiches.length,
        itemBuilder: (context, index) {
          return SandwichCard(sandwich: sandwiches[index]);
        },
      ),
    );
  }
}
```

`ListView.builder` is a performant scrolling widget. It builds children on demand as they scroll into view rather than creating them all at once.

### Set MenuScreen as the home screen

Open `lib/main.dart`. Update your `App` widget so that its `home:` property points to `MenuScreen()` instead of `OrderScreen()`:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/screens/menu_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: MenuScreen(),
    );
  }
}
```

Run your app with `flutter run -d chrome`. You should see the Sandwich Menu screen showing cards for the Footlong Sub and the Six-Inch Sub, complete with images and formatted prices as shown below:

![The Sandwich Menu screen in Chrome showing sub cards with images and prices](images/3/sandwich_menu_screen.png)

### Commit your changes (5)

Stage `lib/screens/menu_screen.dart` and `lib/main.dart`. Commit your changes with the message `Display menu items using MenuScreen and ListView.builder`.

## Navigate between screens and pass data

Now when you tap **Order**, nothing happens. We need to navigate from `MenuScreen` to an order screen and pass along the selected sandwich.

### Understand stack-based navigation

Flutter handles multi-page navigation using a stack data structure managed by the `Navigator` widget. When you navigate to a new screen, you push a route onto the top of the stack. When the user taps the back button or pops the screen, the top route is removed, revealing the previous screen underneath.

To navigate, we call `Navigator.push()` with a `BuildContext` and a `PageRoute`. In Flutter Material apps, we use `MaterialPageRoute`, which creates a standard platform transition animation.

For more details on stack navigation, review the [Stack-based navigation tutorial](https://docs.flutter.dev/learn/pathway/tutorial/navigation) in the Flutter learning pathway and the [Send data to a new screen recipe](https://docs.flutter.dev/cookbook/navigation/passing-data) in the Flutter cookbook.

### Update OrderScreen to accept a Sandwich

We need our ordering screen to know which sandwich the customer wants to buy. Rather than hardcoding the item name, we pass the selected `Sandwich` model into its constructor.

Create a new file `lib/screens/order_screen.dart`. Move `OrderScreen` and `OrderItemDisplay` from `lib/main.dart` into this file, updating `OrderScreen` to require a `Sandwich` parameter:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/sandwich.dart';

class OrderScreen extends StatefulWidget {
  final Sandwich sandwich;
  final int maxQuantity;

  const OrderScreen({
    super.key,
    required this.sandwich,
    this.maxQuantity = 10,
  });

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${widget.sandwich.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(
              _quantity,
              widget.sandwich.name,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _increaseQuantity,
                  child: const Text('Add'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _decreaseQuantity,
                  child: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}');
  }
}
```

Notice that the app bar title now uses `widget.sandwich.name`, and `OrderItemDisplay` displays the selected sandwich name next to the counter.

Your `lib/screens/order_screen.dart` file should look like this:

![The OrderScreen widget configured to accept a Sandwich parameter](images/3/order_screen_widget.png)

### Commit your changes (6)

Stage `lib/screens/order_screen.dart` and commit your changes with the message `Refactor OrderScreen to receive a Sandwich model`.

### Connect SandwichCard to OrderScreen

Now connect the **Order** button in `SandwichCard` to navigate to `OrderScreen`. Open `lib/widgets/sandwich_card.dart`. Add an import for `order_screen.dart` at the top of the file:

```dart
import 'package:sandwich_shop/screens/order_screen.dart';
```

Then update the `onPressed` callback of the `ElevatedButton`:

```dart
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return OrderScreen(sandwich: sandwich);
        },
      ),
    );
  },
  child: const Text('Order'),
),
```

When the user taps **Order**, `Navigator.push()` pushes `OrderScreen` onto the navigation stack, passing the specific `sandwich` object represented by that card.

### Test the complete navigation flow

Run your app in Chrome. When the menu appears:

1. Tap **Order** on the Footlong Sub card. The app transitions to the order screen with the title "Order Footlong Sub".
2. Tap **Add** several times to increment the sandwich counter and watch the emojis appear.
3. Tap the back arrow in the top left of the app bar. The order screen pops off the stack and you return to the menu.
4. Tap **Order** on the Six-Inch Sub card. You arrive at an order screen specifically configured for the six-inch sub, with an independent counter starting at zero.

The order screen for the Footlong Sub should look like this after navigation:

![The OrderScreen displayed in Chrome after navigating from the menu](images/3/order_screen_navigation.png)

### Commit your changes (7)

Stage `lib/widgets/sandwich_card.dart` and commit your work with the message `Implement in-page navigation from SandwichCard to OrderScreen`.

## Exercises

As in Worksheet 1 and Worksheet 2, these exercises apply to your Southsea Cinema coursework and, together with the Worksheet 4 exercises, prepare you for Demo 2 (by Friday 16 October 2026). See the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw). Commit after each exercise. You must demonstrate your work for a sign-off during your own timetabled practical session.

In Worksheet 2, you built a hardcoded movie listing page for Dracula. For Demo 2, your cinema application must present a browseable home page with cards for currently screening films, and clicking a booking button must navigate directly to the listing page for that film.

1. Create a `Movie` data model in `lib/models/movie.dart` inside your `southsea_cinema` fork. Include `id`, `title`, `ageRating`, `synopsis`, `imagePath`, `screeningTime`, and `ticketPrice` as `final` fields, with a `const` constructor. Commit your changes with the message `Add Movie data model`.

2. Create an `assets/images/` folder in your `southsea_cinema` project. Download the poster images for *The Phantom of the Opera* and *Halloween 1978* from the Southsea Cinema website and place them in this folder. Register `assets/images/` under the `flutter:` section of your `pubspec.yaml`. Commit your changes with the message `Add movie poster assets`.

3. Create a `MovieRepository` in `lib/repositories/movie_repository.dart`. Implement a `getMovies()` method that returns mock `Movie` instances for *The Phantom of the Opera* (12A) and *Halloween 1978* (15) with their screening times, descriptions, and poster paths. Commit your changes with the message `Create MovieRepository with mock screening data`.

4. Create a reusable `MovieCard` widget in `lib/widgets/movie_card.dart`. Display the title with age rating, the poster image using `Image.asset`, the synopsis, and the screening time. Add a **BOOK NOW** button styled with `cinemaBrand` background and white text. Commit your changes with the message `Create MovieCard widget`.

5. Update `lib/views/home_view.dart` to retrieve movies from `MovieRepository` and render them in a scrollable list using `ListView.builder`. Your home screen should display film cards with poster images and booking buttons as shown below:

    ![Southsea Cinema home screen showing film cards with poster images and booking buttons](images/3/southsea_cinema_home_view.png)

    Commit your changes with the message `Display movie cards on HomeView`.

6. Refactor `lib/views/movie_listing.dart` so its constructor requires a `Movie` instance (`final Movie movie;`). Replace all hardcoded Dracula details with the fields from `widget.movie`. Connect the **BOOK NOW** button in `MovieCard` to call `Navigator.push()` with `MaterialPageRoute`, passing the selected `movie` into `MovieListing`. When you click **BOOK NOW** on a film card, the dynamic listing page should open as shown below:

    ![Southsea Cinema dynamic film listing page](images/3/southsea_cinema_dynamic_listing.png)

    Commit your changes with the message `Enable in-page navigation from HomeView to MovieListing`.
