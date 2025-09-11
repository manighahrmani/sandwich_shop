# Cart Modification Feature Requirements

## 1. Feature Description and Purpose

The Cart Modification feature enables users of the Sandwich Shop Flutter app to manage the contents of their cart before checkout. Users can adjust the quantity of each sandwich, remove items, and (optionally) edit sandwich details such as bread type or size. This feature aims to provide a flexible and user-friendly shopping experience, ensuring users can easily correct mistakes or change their order without starting over.

---

## 2. User Stories

### 2.1. Adjust Quantity

- **As a user**, I want to increase or decrease the quantity of a sandwich in my cart, so I can order the exact number I want.
- **As a user**, I want the cart to automatically remove an item if I decrease its quantity below 1, so my cart never contains items with zero or negative quantity.

### 2.2. Remove Item

- **As a user**, I want to remove a sandwich from my cart with a single action, so I can quickly update my order if I change my mind.

### 2.3. Edit Item Details (Optional)

- **As a user**, I want to edit the details of a sandwich in my cart (e.g., change bread type, size, or sandwich type), so I can correct mistakes or change my preferences without removing and re-adding the item.

### 2.4. Feedback and UI Responsiveness

- **As a user**, I want the cart and total price to update immediately when I make changes, so I always see an accurate summary of my order.
- **As a user**, I want to receive feedback (such as a snackbar) when I remove or update an item, so I know my action was successful.
- **As a user**, I want to see a clear message if my cart is empty, so I know I need to add items before checking out.

---

## 3. Acceptance Criteria

### 3.1. Quantity Adjustment

- [ ] Each cart item displays "+" and "–" buttons for quantity adjustment.
- [ ] Tapping "+" increases the quantity by 1, up to the maximum allowed (as defined in `OrderScreen.maxQuantity`).
- [ ] Tapping "–" decreases the quantity by 1.
- [ ] If the quantity is reduced below 1, the item is removed from the cart.
- [ ] The total price updates automatically and accurately.
- [ ] The UI updates immediately to reflect changes.

### 3.2. Remove Item

- [ ] Each cart item has a "Remove" button (e.g., trash icon).
- [ ] Tapping "Remove" deletes the item from the cart.
- [ ] The total price updates accordingly.
- [ ] A snackbar or similar feedback is shown when an item is removed.

### 3.3. Edit Item Details (Optional)

- [ ] Each cart item has an "Edit" button.
- [ ] Tapping "Edit" opens a dialog or navigates to a screen for modifying sandwich options.
- [ ] After saving, the cart updates the item (or replaces it if the combination is new).
- [ ] The price and UI update accordingly.

### 3.4. General UI and Behavior

- [ ] All changes are reflected immediately in the UI.
- [ ] The cart's total price is always accurate.
- [ ] The cart handles empty states gracefully (e.g., displays a message if empty).
- [ ] The UI prevents negative quantities and enforces the maximum allowed quantity.
- [ ] User feedback is provided for all cart modification actions.

---

## 4. Subtasks

1. Implement "+" and "–" quantity adjustment buttons for each cart item.
2. Implement logic to remove an item if its quantity is reduced below 1.
3. Add a "Remove" button for each cart item.
4. (Optional) Add an "Edit" button for each cart item and implement the edit flow.
5. Ensure the total price and UI update immediately after any change.
6. Provide user feedback (snackbar) for remove and update actions.
7. Handle empty cart states with a clear message.
8. Enforce maximum quantity limits as defined in the order screen.