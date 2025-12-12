## User Signup & Profile Requirements

- **Goal:** Enable new users to create an account quickly and manage a basic profile for ordering and tracking.

### Signup
- **Fields (required):** `email`, `password`, `firstName`, `lastName`.
- **Fields (optional):** `phone`, `marketingOptIn` (boolean).
- **Validation:**
	- `email`: valid format, unique in system.
	- `password`: minimum 8 chars, at least 1 letter and 1 number.
	- `firstName`/`lastName`: 1–50 chars, alphabetic plus basic punctuation.
	- `phone` (if provided): E.164 format or local format with country default.
- **UX:**
	- Real-time validation with inline error messages.
	- Password visibility toggle.
	- Link to Login and “Forgot password”.
	- Submit disabled until valid; loading state on submit.
- **Security:**
	- Hash passwords using a strong algorithm (e.g., bcrypt/argon2).
	- Rate-limit signup attempts to mitigate abuse.
	- Email verification link required before first order; resend verification.
	- CSRF protection for form posts.
- **Privacy & Consent:**
	- Show Terms of Service and Privacy Policy links.
	- Explicit checkbox for marketingOptIn (unchecked by default).

### Login (related)
- **Fields:** `email`, `password`.
- **Controls:** “Remember me” (30-day session), “Forgot password”.
- **Security:** Account lockout after N failed attempts; device-based session tokens; secure cookie storage.

### Profile
- **View/Update:** `firstName`, `lastName`, `email` (read-only until verified), `phone`, `marketingOptIn`.
- **Avatar (optional):** Upload JPG/PNG ≤ 2MB; square crop; stored in CDN/static bucket.
- **Addresses (optional, if needed for orders):**
	- Manage list of delivery addresses: `label`, `street`, `city`, `state`, `postalCode`, `country`.
	- Set one address as default.
- **Security:**
	- Re-auth required to change sensitive fields (email, password).
	- Email change triggers re-verification and disables orders until confirmed.

### Password Management
- **Change Password:** Current password + new password with same policy; success toast.
- **Reset Password:** Email flow with time-limited token (15–60 min); single-use.

### Verification
- **Email Verification:**
	- Send signed token with userId + expiry.
	- Verification status displayed in profile; option to resend.
	- Block checkout if unverified; allow browsing/cart.

### Accessibility & i18n
- **A11y:** Form labels, ARIA for errors, keyboard navigable.
- **Localization:** Copy and validation errors translatable; phone formats per locale.

### Telemetry & Analytics
- **Events:** `SignupStarted`, `SignupCompleted`, `SignupFailed`, `EmailVerified`, `ProfileUpdated`, `PasswordChanged`.
- **PII Handling:** Do not log raw email/phone; use hashed IDs where possible.

### Error States
- **Common Errors:** Duplicate email, weak password, invalid token, network failure.
- **Handling:** Clear messages, non-destructive; allow retry; support contact link.

### Non-Functional
- **Performance:** Form submit round-trip < 1s on typical network.
- **Scalability:** Support burst signups; background email delivery.
- **Reliability:** Verification and reset tokens stored server-side with audit trail.

### APIs (high level)
- `POST /api/auth/signup`: create account; returns userId & verification status.
- `POST /api/auth/login`: authenticate; returns session token.
- `POST /api/auth/verify-email`: confirm via token.
- `POST /api/auth/password/reset/request`: start reset.
- `POST /api/auth/password/reset/confirm`: finalize reset.
- `GET /api/profile`: get profile.
- `PUT /api/profile`: update profile.
- `GET /api/addresses`: list addresses.
- `POST /api/addresses`: add address.
- `PUT /api/addresses/{id}`: update address.
- `DELETE /api/addresses/{id}`: remove address.

### Data Model (simplified)
- **User:** `id`, `email`, `passwordHash`, `firstName`, `lastName`, `phone?`, `emailVerifiedAt?`, `marketingOptIn` (bool), `createdAt`, `updatedAt`.
- **Address:** `id`, `userId`, `label`, `street`, `city`, `state`, `postalCode`, `country`, `isDefault` (bool), `createdAt`, `updatedAt`.

### Acceptance Criteria
- User can create account with valid details and receives verification email.
- Unverified users cannot complete checkout; verified users can.
- Users can update non-sensitive profile fields without re-auth.
- Changing email or password requires re-auth and triggers appropriate flows.
- All forms are accessible, localized-ready, and show clear validation.

### Navigation (Drawer) to Sign Up
- **Availability:** A drawer menu is accessible via the AppBar hamburger on main customer screens (e.g., Order, Cart, Checkout, About).
- **Entry:** Drawer includes a “Sign Up” item that navigates to the Sign Up screen.
- **Context awareness:** If already on Sign Up, tapping the item provides a non-destructive hint (e.g., toast/snackbar) instead of re-pushing.
- **Persistence:** Drawer remains available across the listed screens so users can reach Sign Up at any time before checkout.
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