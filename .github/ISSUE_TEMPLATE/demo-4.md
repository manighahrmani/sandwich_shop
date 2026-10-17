---
name: Demo 4 Sign-off
about: Assessment checklist and marking rubric for Coursework Demo 4
title: "Demo 4: [Student Name / Student ID]"
labels: demo-4
assignees: ''
---

## Demo 4 Assessment Checklist

- **Student Name**:
- **Student ID**:
- **Repository URL**:
- **Date**:
- **Assessor**:

## 1. Functionality (9% of Item 1)

Students run the Southsea Cinema application and demonstrate the features implemented during Weeks 7 and 8 (Worksheets 7 and 8).

- [ ] Database-backed checkout: Checkout on the basket page saves the booking to SQLite before clearing the basket.
- [ ] SQLite persistence: Past orders on the basket page still list earlier bookings after fully closing and reopening the app on an Android emulator.
- [ ] User flow: Patron can browse films, configure bookings, open the basket page and complete checkout without Provider, notifiers or an app-bar basket badge.
- [ ] Visual polish: Squared button styling matches the Southsea Cinema site design.

**Functionality Mark (out of 9)**: _____

## 2. Code Quality and Project Structure (8% of Item 1)

Staff inspect code architecture, directory structure, and automated test coverage. **Significant marks are allocated to project structure and coverage from Demo 4 onwards.**

### Project Directory Organisation

- [ ] Subfolders in `test/` strictly mirror `lib/`:
  - `test/models/` mirrors `lib/models/`
  - `test/views/` mirrors `lib/views/` (or `test/screens/` for `lib/screens/`)
  - `test/widgets/` mirrors `lib/widgets/`
  - `test/repositories/` mirrors `lib/repositories/`
  - `test/database/` mirrors `lib/database/`
- [ ] Test files are grouped under the matching application folders; shared helpers may use `test/support/`.

### Automated Test Coverage

- [ ] Tests run and pass cleanly with `flutter test --coverage`.
- [ ] Coverage demonstrated live in VS Code using the Flutter Coverage extension.
- [ ] Coverage includes model conversion, repositories, database creation and queries, saving a booking at checkout and listing past orders.

### Code Style and Standards

- [ ] Clear naming conventions, immutability with `final`, and explicit types.
- [ ] Clean separation of concerns (UI, state, repository, and database).
- [ ] Regular Git commit history with descriptive messages.

**Code Quality Mark (out of 8)**: _____

## 3. Understanding (8% of Item 1)

Student answers two questions about their own code and architectural decisions.

- **Question 1**:
  - Response:
  - [ ] Demonstrated clear understanding (up to 4 marks)
- **Question 2**:
  - Response:
  - [ ] Demonstrated clear understanding (up to 4 marks)

**Understanding Mark (out of 8)**: _____

---

### Total Demo 4 Mark

Total mark (out of 25% of Item 1): _____

**Sign-off Status**:

- [ ] Approved
- [ ] Action required for re-attempt within demo window

**Staff Notes**:
