# Sandwich Shop

A Flutter app for browsing a small menu, adding items to a basket, and saving completed orders. The app is set up for Android only.

## Features

- Browse sandwiches and loaded nachos from the bundled menu.
- Adjust quantities, review the basket total, and check out.
- View saved orders. Orders are stored locally in SQLite; the basket is held in memory.
- Save customer profile details and preferences on the device, including a bigger-text setting.

## Platform

The app runs on Android only, because it saves orders in a SQLite database file on the device. Use an Android emulator or a physical Android device. Running it in a browser or on a desktop is not supported.

## Getting started

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) with the Android toolchain set up.
- An Android emulator or device.
- Git.

### Clone

```bash
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
```

### Install dependencies

```bash
flutter pub get
```

### Run

Start an Android emulator or connect a device, then run:

```bash
flutter run
```

## Tests

Run the automated unit and widget tests with:

```bash
flutter test
```

These tests use in-memory and temporary file-backed SQLite databases and do not require an Android emulator. Running the app itself does require an Android emulator or device.

To measure test coverage, run `flutter test --coverage`. The report is written to `coverage/lcov.info`.

## Project structure

- `lib/models/` holds the data classes, such as `Sandwich`, `OrderRecord` and `UserSettings`.
- `lib/repositories/` holds the menu and the in-memory basket.
- `lib/database/` holds the SQLite database for saved orders.
- `lib/screens/` holds the menu, basket, orders and settings screens.
- `lib/widgets/` holds the reusable buttons and the sandwich card.
- `test/` mirrors the folders in `lib/`.

## Screenshots

### Menu

Our shop has a menu that is currently selling two sandwiches and a nacho as starter.

![A screenshot of sandwich shop's menu](images/menu_screenshot.png)

### Basket

The user can add some menu items to their basket and then proceed to check out.

![A screenshot of sandwich shop's basket with a few items](images/basket_screenshot.png)
