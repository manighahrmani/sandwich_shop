import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

// A dummy function to pass to onPressed for enabled state testing.
void dummyFunction() {}

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as the home screen',
        (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Initial State', () {
    testWidgets('displays the initial UI elements correctly',
        (WidgetTester tester) async {
      // Arrange
      const App app = App();
      await tester.pumpWidget(app);

      // Assert
      // Check for the AppBar title.
      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Check that an image is displayed.
      expect(find.byType(Image), findsOneWidget);

      // Check for the default selected sandwich type.
      expect(find.text('Veggie Delight'), findsWidgets);

      // Check that the Switch for size is on (for Footlong).
      final Finder switchFinder = find.byType(Switch);
      final Switch sizeSwitch = tester.widget<Switch>(switchFinder);
      expect(sizeSwitch.value, isTrue);

      // Check for the default selected bread type.
      expect(find.text('white'), findsWidgets);

      // Check for the initial quantity display.
      expect(find.text('1'), findsOneWidget);

      // Check that the "Add to Cart" button is present.
      expect(find.widgetWithText(StyledButton, 'Add to Cart'), findsOneWidget);
    });
  });

  group('OrderScreen - Interactions', () {
    testWidgets('updates sandwich type when a new option is selected',
        (WidgetTester tester) async {
      // Arrange
      const App app = App();
      await tester.pumpWidget(app);

      // Act: Tap the sandwich type dropdown and select a new option.
      final Finder sandwichDropdownFinder =
          find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdownFinder);
      await tester.pumpAndSettle(); // Wait for animation to finish.

      final Finder chickenTeriyakiOptionFinder =
          find.text('Chicken Teriyaki').last;
      await tester.tap(chickenTeriyakiOptionFinder);
      await tester.pumpAndSettle();

      // Assert: Verify the dropdown shows the new selection.
      expect(find.text('Chicken Teriyaki'), findsWidgets);
    });

    testWidgets('updates sandwich size when the switch is toggled',
        (WidgetTester tester) async {
      // Arrange
      const App app = App();
      await tester.pumpWidget(app);

      // Act: Tap the switch to change the size to six-inch.
      final Finder switchFinder = find.byType(Switch);
      await tester.tap(switchFinder);
      await tester.pump();

      // Assert: Verify the switch's value has changed to false.
      final Switch sizeSwitch = tester.widget<Switch>(switchFinder);
      expect(sizeSwitch.value, isFalse);
    });

    testWidgets('updates bread type when a new option is selected',
        (WidgetTester tester) async {
      // Arrange
      const App app = App();
      await tester.pumpWidget(app);

      // Act: Tap the bread type dropdown and select a new option.
      final Finder breadDropdownFinder = find.byType(DropdownMenu<BreadType>);
      await tester.tap(breadDropdownFinder);
      await tester.pumpAndSettle();

      final Finder wheatOptionFinder = find.text('wheat').last;
      await tester.tap(wheatOptionFinder);
      await tester.pumpAndSettle();

      // Assert: Verify the dropdown shows the new selection.
      expect(find.text('wheat'), findsWidgets);
    });

    testWidgets('increases quantity when add button is tapped',
        (WidgetTester tester) async {
      // Arrange
      const App app = App();
      await tester.pumpWidget(app);

      // Act: Tap the add icon button.
      final Finder addButtonFinder = find.byIcon(Icons.add);
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Assert: Verify the quantity text is updated to '2'.
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('decreases quantity when remove button is tapped',
        (WidgetTester tester) async {
      // Arrange
      const App app = App();
      await tester.pumpWidget(app);

      // Act: First increase quantity to 2, then tap the remove icon button.
      final Finder addButtonFinder = find.byIcon(Icons.add);
      await tester.tap(addButtonFinder);
      await tester.pump();
      expect(find.text('2'), findsOneWidget); // Pre-condition check

      final Finder removeButtonFinder = find.byIcon(Icons.remove);
      await tester.tap(removeButtonFinder);
      await tester.pump();

      // Assert: Verify the quantity text is updated back to '1'.
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('quantity does not go below zero and buttons are disabled',
        (WidgetTester tester) async {
      // Arrange
      const App app = App();
      await tester.pumpWidget(app);

      // Act: Find the correct IconButton and tap it to decrease quantity to 0.
      // This is the corrected finder:
      final Finder removeButtonFinder =
          find.widgetWithIcon(IconButton, Icons.remove);
      await tester.tap(removeButtonFinder);
      await tester.pump();

      // Assert: Quantity is 0 and the remove button is disabled.
      expect(find.text('0'), findsOneWidget);
      IconButton removeButton = tester.widget<IconButton>(removeButtonFinder);
      expect(removeButton.onPressed, isNull);

      // Assert: The "Add to Cart" button is also disabled.
      final Finder addToCartButtonFinder =
          find.widgetWithText(StyledButton, 'Add to Cart');
      final StyledButton styledButton =
          tester.widget<StyledButton>(addToCartButtonFinder);
      expect(styledButton.onPressed, isNull);

      // Act: Try to tap the remove button again (it should do nothing).
      await tester.tap(removeButtonFinder);
      await tester.pump();

      // Assert: The quantity remains 0.
      expect(find.text('0'), findsOneWidget);
    });
  });

  group('StyledButton', () {
    testWidgets('renders correctly with icon and label when enabled',
        (WidgetTester tester) async {
      // Arrange: Create a test button that is enabled.
      StyledButton testButton = const StyledButton(
        onPressed: dummyFunction, // A non-null function
        icon: Icons.add_shopping_cart,
        label: 'Test Button',
        backgroundColor: Colors.green,
      );

      MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      // Act: Build the widget.
      await tester.pumpWidget(testApp);

      // Assert: Verify the icon, text, and enabled state.
      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);

      final Finder elevatedButtonFinder = find.byType(ElevatedButton);
      final ElevatedButton button =
          tester.widget<ElevatedButton>(elevatedButtonFinder);
      expect(button.enabled, isTrue);
    });

    testWidgets('renders correctly and is disabled when onPressed is null',
        (WidgetTester tester) async {
      // Arrange: Create a test button that is disabled.
      const StyledButton testButton = StyledButton(
        onPressed: null,
        icon: Icons.add_shopping_cart,
        label: 'Test Button',
        backgroundColor: Colors.green,
      );

      const MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      // Act: Build the widget.
      await tester.pumpWidget(testApp);

      // Assert: Verify the icon, text, and disabled state.
      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);

      final Finder elevatedButtonFinder = find.byType(ElevatedButton);
      final ElevatedButton button =
          tester.widget<ElevatedButton>(elevatedButtonFinder);
      expect(button.enabled, isFalse);
    });
  });
}
