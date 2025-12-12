You are helping implement cart item modifications in a Flutter sandwich shop app. The app has:
- Order screen: users browse sandwiches and add them to a cart.
- Cart screen: users see cart items and total price.

Implement cart modification features below. For each, describe expected UI behavior, data updates, and edge cases.

Features:
1) Change quantity (increment/decrement)
   - Action: User taps + or - on a cart line.
   - Behavior: Update quantity in cart state; recalc line subtotal and cart total; enforce min 1; if decrement reaches 0, prompt removal or auto-remove (pick one and keep consistent).
   - Edge cases: Avoid negative quantities; handle stock limits if present; keep totals in sync; ensure UI updates optimistically with error fallback.

2) Remove item
   - Action: User taps remove (trash/bin) or swipes item to delete.
   - Behavior: Remove line from cart; recalc totals; if cart becomes empty, show empty-state UI and disable checkout button.
   - Edge cases: Confirm before removal if required; undo/snackbar option if desired; handle failure by restoring item.

3) Edit item options (if applicable, e.g., bread type/extras)
   - Action: User taps “Edit” on a cart line to reopen customization modal or sheet.
   - Behavior: Reload current selections, allow edits, save updates back to that cart line (do not create a new line unless options differ and app policy says to split).
   - Edge cases: Validate required options; price should update based on new options; preserve quantity; handle cancel gracefully.

Data/logic notes:
- Cart line should track: sandwich id/name, selected options, unit price, quantity, computed subtotal.
- Cart total = sum of line subtotals; keep derived values in one place to avoid drift.
- Provide state updates through a single source of truth (e.g., provider/BLoC/state notifier) used by both order and cart screens.

UX hints:
- Show inline feedback on updates (spinners/disabled buttons during async).
- Use snackbars for remove undo.
- Keep controls accessible for keyboard/screen readers.

Deliverables:
- Flutter/Dart changes to models, state management, and UI for both screens reflecting behaviors above.
- Brief test plan: unit tests for cart math and state transitions; widget tests for button taps updating quantities/totals and empty-state rendering.