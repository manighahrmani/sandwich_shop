
## Widget testing


Start with this: https://docs.flutter.dev/cookbook/testing/widget/introduction
## More notes on pumping
Read notes on pumping widget (e.g., schedule a pump after a delay to allow for animations or `pumpAndSettle()`)
https://docs.flutter.dev/cookbook/testing/widget/introduction#notes-about-the-pump-methods


A `WidgetTester` is a core utility class in Flutter's flutter_test package that allows developers to programmatically build and interact with widgets in an isolated test environment. It acts as a controller for widget tests, simulating user interactions and the passage of time to verify that a widget's UI and behavior are correct.

The WidgetTester provides a suite of methods that make it possible to test widgets without running the full application on a device or emulator. Its key responsibilities include: 

## Building the widget tree
pumpWidget(): This method inflates a single widget and its descendants, rendering them into a test environment. This is the starting point for most widget tests.
pump(): After a widget's state has changed (e.g., after a user interaction), this method rebuilds the widget tree to reflect the new state, and can advance the "fake" clock by a specified duration.
pumpAndSettle(): This repeatedly calls pump() until all animations have completed and the widget tree is stable. It's useful for testing scenarios with animations or asynchronous changes. 
## Simulating user interactions
The WidgetTester has methods for simulating common user gestures. 
tap(): Simulates a tap on a widget found by a Finder.
drag() / dragFrom(): Simulates a drag gesture on a widget.
enterText(): Enters text into a TextField or similar input widget. 
## Finding widgets in the tree
While not a method of WidgetTester itself, the find constant from flutter_test is used in conjunction with WidgetTester to locate widgets within the test environment. 
find.byType(): Finds a widget by its type.
find.byKey(): Finds a widget using a unique key.
find.text(): Finds a Text widget containing a specific string. 

Talk about async await and futures.
**BUT DON'T USE NAMED FUNCTIONS FOR TESTS AS THIS MAKES THINGS WAY TOO COMPLICATED. SIMPLIFY IT AND PASS TEST FUNCTIONS AS ANONYMOUS FUNCTIONS AS THE SECOND PARAMETER TO TEST()**, SIMPLIFY THE WIDGET_TEST FILE.

Also start talking about separation of code into multiple files (starting with a separate file for styles).

Add a note about this (what if we have multiple of one widget type?):
```dart
              child: TextField(
                // We need a key to distinguish this TextField from the
                // TextFields that are used in the DropdownMenu (for testing).
                key: const Key('notes_textfield'),
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Add a note (e.g., no onions)',
                ),
              ),
```

Copilot video, talks about Test Driven Development (TDD) too (but in TS): https://youtu.be/smdBqEu7fx4?feature=shared

Example of unit test for Python:
https://docs.github.com/en/copilot/tutorials/write-tests