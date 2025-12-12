Cart Modification Requirements

Subtask 1: Feature Description & Purpose

Allow shoppers to modify items already in their cart from the cart screen: change quantities, remove items, and edit item options (if applicable).
Keep cart totals accurate and in sync across order and cart screens, with clear feedback and safeguards against invalid states (e.g., negative quantities).
Subtask 2: User Stories

As a shopper, I can increase or decrease the quantity of a cart item so I can adjust my order without re-adding the item.
As a shopper, I can remove an item from my cart so unwanted items don’t affect my total or checkout.
As a shopper, I can edit an item’s options (bread, extras, etc.) so I can fix or change customization without starting over.
As a shopper, I can see the cart total update immediately after any change so I always know what I’ll pay.
As a shopper, if the cart becomes empty after removals, I see an empty-state message and checkout is disabled so I’m not confused about next steps.
Subtask 3: Acceptance Criteria

Quantity changes

Tapping “+” increases quantity by 1; tapping “–” decreases by 1 but never below 1 unless the item is removed.
If decrement would hit 0, the flow either confirms removal or auto-removes (choose one policy and apply consistently).
Line subtotal and cart total update immediately after the change.
Any stock/limit rule is enforced (if present), preventing quantities above the limit and showing feedback.
Remove item

Tapping “Remove”/swipe-delete deletes the line item from the cart.
Cart total recalculates; if the cart is empty, an empty-state view appears and checkout is disabled.
(Optional) An undo/snackbar can restore the item within a short window.
Edit item options (if applicable)

Tapping “Edit” on a cart line reopens customization with current selections pre-filled.
Saving updates the same line (preserving quantity) and recalculates price based on new options; totals refresh.
Canceling leaves the cart unchanged.
State & data integrity

Cart line tracks: sandwich id/name, selected options, unit price, quantity, computed subtotal.
Cart total equals the sum of line subtotals and stays in sync across order and cart screens (single source of truth).
UI shows responsive feedback during updates (e.g., disabled buttons/spinner) and recovers from failures without leaving stale totals.
Completion definition

All user stories above are implemented and manually verifiable.
Unit tests cover cart math and state transitions; widget tests cover quantity changes, removals, empty state, and total updates.
No regressions in adding items from the order screen; order and cart screens reflect the same cart state.