# Sandwich Shop

A Flutter application for ordering sandwiches with customizable options and quantity management.

## Description

This Flutter app provides a User Interface (UI) for customers to order sandwiches. Users can select sandwich size (footlong or six-inch), choose bread type, specify quantity, and add custom notes to their orders. The app also features a clean UI real-time order updates and visual feedback.

### Key Features

- **Sandwich Size Selection**: Toggle between footlong and six-inch options
- **Bread Type Selection**: Choose from white, wheat, or wholemeal bread
- **Quantity Management**: Add/remove sandwiches with configurable maximum limits
- **Order Notes**: Add custom instructions (e.g., "no onions")
- **Visual Order Display**: Real-time sandwich emoji display based on quantity
- **Responsive UI**: Clean Material Design interface with custom styling

## Installation and Setup

### Prerequisites

- **Flutter SDK** (>=2.17.0 <4.0.0)
- **Git** for version control
- **IDE**: Visual Studio Code (recommended)

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/manighahrmani/sandwich_shop.git
   cd sandwich_shop
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter Installation**
   ```bash
   flutter doctor
   ```

4. **Run the Application**
   ```bash
   # For web (recommended)
   flutter run -d chrome
   
   # For other platforms
   flutter run
   ```

## Usage Instructions

### Main Features

1. **Selecting Sandwich Size**
   - Use the toggle switch to choose between six-inch and footlong sandwiches
   - The display updates automatically to show your selection

2. **Choosing Bread Type**
   - Select from the dropdown menu: white, wheat, or wholemeal
   - Your choice is reflected in the order display

3. **Managing Quantity**
   - Click the green "Add" button to increase sandwich quantity
   - Click the red "Remove" button to decrease quantity
   - Maximum quantity is configurable (default: 5 sandwiches)
   - Buttons are disabled when limits are reached

4. **Adding Order Notes**
   - Use the text field to add special instructions
   - Example: "no onions", "extra cheese", "toasted"
   - Notes appear in the order summary

5. **Order Display**
   - Real-time visual representation with sandwich emojis (🥪)
   - Shows quantity, bread type, size, and notes
   - Updates automatically as you make changes

### Running Tests

Execute the test suite to verify functionality:

```bash
# Run all tests
flutter test

# Run specific test files
flutter test test/repositories/order_repository_test.dart
flutter test test/views/widget_test.dart
```

## Project Structure

```
lib/
├── main.dart                    # Main app entry point and UI components
├── repositories/
│   └── order_repository.dart    # Order state management and business logic
└── views/
    └── app_styles.dart         # Centralized styling and theme definitions

test/
├── repositories/
│   └── order_repository_test.dart  # Unit tests for order logic
└── views/
    └── widget_test.dart            # Widget and integration tests
```

### Key Files

- **`lib/main.dart`**: Contains the main app structure, OrderScreen widget, and UI components
- **`lib/repositories/order_repository.dart`**: Manages order state, quantity limits, and business logic
- **`lib/views/app_styles.dart`**: Defines consistent text styles and theming
- **`test/repositories/order_repository_test.dart`**: Unit tests for order management functionality