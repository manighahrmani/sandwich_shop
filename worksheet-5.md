# **Worksheet 5 — Data Models and Assets**

## **What you need to know beforehand**

Ensure that you have already completed the following:

  - [Worksheet 0 — Introduction to Dart, Git and GitHub](https://www.google.com/search?q=./worksheet-0.md).
  - [Worksheet 1 — Introduction to Flutter](https://www.google.com/search?q=./worksheet-1.md).
  - [Worksheet 2 — Stateless Widgets](https://www.google.com/search?q=./worksheet-2.md).
  - [Worksheet 3 — Stateful widgets](https://www.google.com/search?q=./worksheet-3.md).
  - [Worksheet 4 — App Architecture and Testing](https://www.google.com/search?q=./worksheet-4.md).

## **Getting help**

To get support with this worksheet, join the [Discord channel](https://portdotacdotuk-my.sharepoint.com/:b:/g/personal/mani_ghahremani_port_ac_uk/EbX583gvURRAhqsnhYqmbSEBwIFw6tXRyz_Br1GxIyE8dg) and ask your questions there. Otherwise, attend your timetabled session and ask a member of staff for help.

## **Introduction to Data Models**

So far, we've been passing simple data types like `String` and `int` between our widgets. As our app grows in complexity, it's better to group related data into custom data types (classes). We call these **data models**.

If you've worked with databases before, you can think of data models as being similar to **entities**. An entity is a real-world object or concept that can be distinctly identified. In our case, a "Sandwich" is a perfect example of an entity that we can represent with a data model.

### **Creating the `Sandwich` model**

Let's start by defining a `Sandwich` model. This will help us manage all the properties of a sandwich in one place.

In your `lib` folder, create a new folder called `models`. Inside this folder, create a new file called `sandwich.dart`. This is what your project structure may look like:

```
lib/
  ├── views/
  │   ├── app_styles.dart
  │   └── main.dart
  ├── view_models/
  │   └── order_view_model.dart
  ├── models/
  │   └── sandwich.dart
  └── repositories/
      ├── order_repository.dart
      └── pricing_repository.dart
```

Add the following code to `sandwich.dart`:

```dart
enum BreadType { white, wheat, wholemeal }

class Sandwich {
  final String name;
  final bool isFootlong;
  final BreadType breadType;
  final String image;

  Sandwich({
    required this.name,
    required this.isFootlong,
    required this.breadType,
    required this.image,
  }) {
    if (name.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    if (image.isEmpty || !image.startsWith('assets/images/')) {
      throw ArgumentError('Image must be a valid asset path');
    }
  }
}
```

Here we have defined a `Sandwich` class with a few properties. The `image` property will hold the path to an image of the sandwich hence it is a `String`. We will come back to this later.

Does the `throw` statements make sense to you? If not, ask your AI assistant to explain them. Also, we are not storing the price of a sandwich here as it is determined by the `PricingRepository` based on the size of the sandwich (`isFootlong`).

Before moving on, use your AI assistant to write a unit test for the `Sandwich` model. Remember to create a `models` folder inside the `test` folder to mirror the structure of the `lib` folder. Your test file should ideally be named `sandwich_test.dart`.

#### **Commit your changes**

Here's a reminder to commit your changes (commit them individually, the addition of the model and the test).

### **The `Cart` model**

Now that we can represent a single sandwich, we need a way to manage a collection of them in an order. For this, we'll create a `Cart` model. In the `models` folder, create a new file called `cart.dart` and add the following code:

```dart
import 'sandwich.dart';

class Cart {
  final List<Sandwich> _items = [];

  List<Sandwich> get items => _items;

  void add(Sandwich sandwich) {
    _items.add(sandwich);
  }

  void remove(Sandwich sandwich) {
    _items.remove(sandwich);
  }

  double get totalPrice {
    // We will implement this later
    return 0.0;
  }
}
```

This `Cart` class has a private list of `Sandwich` objects and provides methods to add and remove sandwiches. For a deeper understanding of lists in Dart, you can refer to the [official documentation](https://www.google.com/search?q=https://dart.dev/guides/language/language-tour%23lists).

#### **Commit your changes**

Now is a good time to commit your changes. Use a descriptive commit message, such as `Create Sandwich and Cart models`.

## **Managing Assets**

Our `Sandwich` model has an `image` property, but we haven't provided any images yet. In Flutter, static files like images, fonts, and configuration files are called **assets**.

First, create an `assets` folder in the root of your project, at the same level as the `lib` and `test` folders. Inside the `assets` folder, create another folder called `images`. You can find some example sandwich images [here](https://www.google.com/search?q=https://github.com/manighahrmani/sandwich_shop/tree/main/assets/images). Download them and place them in your new `assets/images` folder.

Next, you need to tell Flutter about these new assets. Open the `pubspec.yaml` file and add an `assets` section like this:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

Make sure the indentation is correct, as `pubspec.yaml` is sensitive to whitespace. The line `assets:` should be at the same indentation level as `uses-material-design:`.

Now you can use these images in your app. For more information, you can read the official Flutter documentation on [adding assets and images](https://docs.flutter.dev/ui/assets/assets-and-images).

#### **Commit your changes**

Commit your new assets with the message `Add sandwich images as assets`.

## **Updating the UI**

Now that we have our models and assets, let's update our UI to use them.

### **Updating the `OrderItemDisplay` widget**

Open `lib/views/main.dart` and update the `OrderItemDisplay` widget to display the sandwich image.

```dart
class OrderItemDisplay extends StatelessWidget {
  final Sandwich sandwich;
  final int quantity;
  final String orderNote;

  const OrderItemDisplay({
    super.key,
    required this.sandwich,
    required this.quantity,
    required this.orderNote,
  });

  @override
  Widget build(BuildContext context) {
    String displayText =
        '$quantity ${sandwich.breadType.name} ${sandwich.name} sandwich(es): ${'🥪' * quantity}';

    return Column(
      children: [
        Image.asset(sandwich.image),
        const SizedBox(height: 8),
        Text(
          displayText,
          style: normalText,
        ),
        const SizedBox(height: 8),
        Text(
          'Note: $orderNote',
          style: normalText,
        ),
      ],
    );
  }
}
```

### **Updating `_OrderScreenState`**

We need to refactor the `_OrderScreenState` to manage a list of different sandwiches in a cart. This is a significant change, so take your time to understand it. Use your AI assistant to help you answer questions like: "How do I use a `ListView.builder` to display a list of items?"

Here is the updated `_OrderScreenState`:

```dart
class _OrderScreenState extends State<OrderScreen> {
  final Cart _cart = Cart();
  final TextEditingController _notesController = TextEditingController();

  void _addSandwichToCart() {
    setState(() {
      _cart.add(
        Sandwich(
          name: 'Footlong',
          isFootlong: true,
          breadType: BreadType.wheat,
          image: 'assets/images/footlong.png',
        ),
      );
    });
  }

  void _removeSandwichFromCart(Sandwich sandwich) {
    setState(() {
      _cart.remove(sandwich);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sandwich Counter',
          style: heading1,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cart.items.length,
              itemBuilder: (context, index) {
                final sandwich = _cart.items[index];
                return ListTile(
                  leading: Image.asset(sandwich.image),
                  title: Text(sandwich.name),
                  subtitle: Text(sandwich.breadType.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => _removeSandwichFromCart(sandwich),
                  ),
                );
              },
            ),
          ),
          // We will add the rest of the UI back in later
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSandwichToCart,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

For now, we have simplified the UI to focus on the cart functionality. When you run the app, you will see a floating action button that adds a hardcoded "Footlong" sandwich to the cart. You can then remove sandwiches from the cart by tapping the remove icon.

#### **Commit your changes**

Commit your work with a message like `Implement cart functionality with data models`.

In the next worksheet, we will re-implement the UI for customising sandwiches and calculating the total price based on the items in the cart.