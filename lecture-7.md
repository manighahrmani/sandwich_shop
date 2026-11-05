# Lecture 7 — Emulators and SQLite

> This mirrors `finalised_lectures/lecture-7.pptx`. Slides are minimal; detail lives in Worksheet 7 and in what I say when each slide is shown. This is a short lecture before the guest lecture, so there is no tech news slide and no live demo. Update this file whenever the deck changes.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 7:

- Emulators
- SQL databases
- SQLite in Flutter

---

## Emulators — leaving the browser

- Some packages call native code on the device, so they do not work on the web.
- `sqflite` is one of them: it talks to SQLite in Android, iOS and macOS.
- An emulator is a virtual Android phone that runs on your computer.
- A physical phone works too once USB debugging is turned on.
- Pick the device in the VS Code status bar, or list devices in the terminal:

```bash
flutter devices
```

- Set-up guide: [Set up an Android emulator](https://docs.flutter.dev/platform-integration/android/setup)

---

## Emulators — checking the platform

- `kIsWeb` is `true` in a browser; `defaultTargetPlatform` names the operating system.
- Use them to stop the app where a package cannot work:

```dart
bool isSupported() {
  if (kIsWeb) {
    return false;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return true;
  }
  return false;
}
```

- `main` can then start a simple fallback screen instead of the real app.

---

## Emulators — data on the device

- The app writes its files to its own private folder on the device.
- These files survive a restart of the app.
- Uninstalling the app or clearing its storage deletes them.
- `adb` (Android Debug Bridge) lets you copy files from the device to inspect them.

---

## SQL databases — choosing where to store data

| Need | Store |
| --- | --- |
| Fixed data shipped with the app | JSON asset (read-only) |
| A few small settings | Shared preferences (key-value) |
| A growing list of records to search and sort | SQL database |

- MySQL and PostgreSQL run on a server; SQLite is a single file on the device, with no server.
- Flutter's recipe: [Persist data with SQLite](https://docs.flutter.dev/cookbook/persistence/sqlite)

---

## SQL databases — tables, rows and keys

- A table has named, typed columns; each row is one record.
- A primary key gives every row a unique id.

```sql
CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  rating REAL
);
```

- `INTEGER`, `TEXT` and `REAL` hold whole numbers, strings and decimals.
- `NOT NULL` means a value is required.

---

## SQL databases — writing and reading

```sql
INSERT INTO notes (title, rating) VALUES ('First note', 4.5);

SELECT * FROM notes ORDER BY id DESC;

SELECT MAX(id) FROM notes;
```

- `INSERT` adds a row; `SELECT` reads rows.
- `ORDER BY ... DESC` sorts from highest to lowest.
- `MAX` returns the largest value, or `NULL` if the table is empty.
- Try them online: [SQLite tutorial](https://www.sqlitetutorial.net/)

---

## SQLite in Flutter — opening a database

```bash
flutter pub add sqflite path
```

```dart
final String folder = await getDatabasesPath();
final Database db = await openDatabase(
  join(folder, 'notes.db'),
  version: 1,
  onCreate: createTables,
);
```

- `openDatabase` creates the file the first time and reopens it after that.
- `onCreate` runs only once, when the file is created; here `createTables` runs the `CREATE TABLE` with `db.execute`.
- Keep one shared helper (a singleton) that owns the connection.

---

## SQLite in Flutter — rows are maps

- Each row comes back as a `Map<String, Object?>`, much like JSON in Lecture 6.

```dart
await db.insert('notes', <String, Object?>{
  'title': 'First note',
  'rating': 4.5,
});

final List<Map<String, Object?>> rows =
    await db.query('notes', orderBy: 'id DESC');
```

- `insert` and `query` build the `INSERT` and `SELECT` for you.
- A model class turns rows into objects with `toMap` and `fromMap`.

---

## SQLite in Flutter — testing without a device

- `sqflite_common_ffi` runs SQLite on your computer, so tests need no emulator.

```bash
flutter pub add --dev sqflite_common_ffi
```

```dart
sqfliteFfiInit();
final Database db = await databaseFactoryFfiNoIsolate
    .openDatabase(inMemoryDatabasePath);
```

- An in-memory database starts empty and disappears when it is closed.
- Open one in `setUp` and close it in `tearDown`, so every test starts clean.
- Keep the `test` folders mirroring the `lib` folders.

---

## Demo 4 (footnote)

- Union of Worksheet 7 and Worksheet 8 exercises: SQLite bookings, past bookings, tests and working with AI.
- Test coverage and a `test` folder that mirrors `lib` carry a significant portion of the marks.
- Demonstrate in your own timetabled practical session.
- You can only do one demo in each window.
- More information on the web page: [manighahrmani.github.io/sandwich_shop](https://manighahrmani.github.io/sandwich_shop/)

---

## Module feedback

Give us your feedback, comments, criticisms, or insults by filling out the following form.

- It is anonymous; you need to sign in with your student account, but your details are not recorded.
- Use this link or the QR code: [forms.cloud.microsoft/e/88jd4UGAui](https://forms.cloud.microsoft/e/88jd4UGAui)
