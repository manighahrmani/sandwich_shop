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

- [ ] State management: Cart and booking state updates reactively across screens (for example adding tickets updates basket indicator and basket screen).
- [ ] Data persistence or cloud integration: Booking records or cinema state persist across app restarts (SQLite or shared preferences).
- [ ] User flow: Patron can browse films, configure bookings, view basket, and complete checkout.
- [ ] Visual polish: Squared button styling matches the Southsea Cinema site design.

**Functionality Mark (out of 9)**: _____

## 2. Code Quality and Project Structure (8% of Item 1)

Staff inspect code architecture, directory structure, and automated test coverage. **Significant marks are allocated to project structure and coverage from Demo 4 onwards.**

### Project Directory Organisation

- [ ] Subfolders in `test/` strictly mirror `lib/`:
  - `test/models/` mirrors `lib/models/`
  - `test/screens/` mirrors `lib/screens/`
  - `test/widgets/` mirrors `lib/widgets/`
  - `test/repositories/` mirrors `lib/repositories/`
  - `test/database/` mirrors `lib/database/`
- [ ] No loose test files remain in the root of `test/`.

### Automated Test Coverage

- [ ] Tests run and pass cleanly with `flutter test --coverage`.
- [ ] Coverage demonstrated live in VS Code using the Flutter Coverage extension.
- [ ] Comprehensive coverage of models, repositories, and critical UI widgets.

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
