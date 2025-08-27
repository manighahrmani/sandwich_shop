
Talk about async await and futures.

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