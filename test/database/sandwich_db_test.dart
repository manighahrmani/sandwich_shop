import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_item.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
  });

  setUp(() async {
    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 2,
        onConfigure: SandwichDatabase.instance.configureDatabase,
        onCreate: SandwichDatabase.instance.createTables,
      ),
    );
    SandwichDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await SandwichDatabase.instance.close();
  });

  OrderRecord buildRecord(int orderNumber, String summary, double total) {
    return OrderRecord(
      orderNumber: orderNumber,
      summary: summary,
      total: total,
      date: '01/01/2026 10:00',
    );
  }

  const OrderItem item = OrderItem(
    sandwichId: 'footlong',
    sandwichName: 'Footlong Sub',
    unitPrice: 7.50,
    quantity: 2,
  );

  test('application creates version 2 with both tables and foreign keys',
      () async {
    await SandwichDatabase.instance.close();
    final Database db = await SandwichDatabase.instance.open(
      inMemoryDatabasePath,
    );
    try {
      expect(await db.getVersion(), 2);
      final List<Map<String, Object?>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table'",
      );
      final List<String> names = [];
      for (final Map<String, Object?> table in tables) {
        names.add(table['name'] as String);
      }
      expect(names, containsAll(['orders', 'order_items']));
      expect(await db.query('orders'), hasLength(3));
      expect(await db.query('order_items'), isEmpty);
      final List<Map<String, Object?>> foreignKeys = await db.rawQuery(
        'PRAGMA foreign_keys',
      );
      expect(foreignKeys[0]['foreign_keys'], 1);
      final List<Map<String, Object?>> links = await db.rawQuery(
        'PRAGMA foreign_key_list(order_items)',
      );
      expect(links[0]['table'], 'orders');
      expect(links[0]['from'], 'order_id');
      expect(links[0]['to'], 'id');
    } finally {
      await db.close();
    }
  });

  test('reopening a version 1 file preserves orders and adds linked items',
      () async {
    final Directory folder = await Directory.systemTemp.createTemp(
      'sandwich_migration_',
    );
    final String filePath = join(folder.path, 'orders.db');
    final Map<String, Object?> oldOrder = <String, Object?>{
      'id': 42,
      'order_number': 1042,
      'summary': '2 x Old sandwich',
      'total': 16.50,
      'date': '01/01/2026 10:00',
    };
    final Map<String, Object?> otherOrder = <String, Object?>{
      'id': 43,
      'order_number': 1043,
      'summary': '1 x Other sandwich',
      'total': 9.0,
      'date': '02/01/2026 10:00',
    };
    try {
      final Database oldDatabase =
          await databaseFactoryFfiNoIsolate.openDatabase(
        filePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (Database db, int version) async {
            await db.execute('''
              CREATE TABLE orders (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                order_number INTEGER NOT NULL,
                summary TEXT NOT NULL,
                total REAL NOT NULL,
                date TEXT NOT NULL
              )
            ''');
          },
        ),
      );
      try {
        await oldDatabase.transaction((Transaction transaction) async {
          await transaction.insert('orders', oldOrder);
          await transaction.insert('orders', otherOrder);
        });
      } finally {
        await oldDatabase.close();
      }

      await SandwichDatabase.instance.close();
      final Database upgraded = await SandwichDatabase.instance.open(filePath);
      SandwichDatabase.instance.setDatabase(upgraded);
      expect(await upgraded.getVersion(), 2);
      expect(await upgraded.query('orders', orderBy: 'id'), [
        oldOrder,
        otherOrder,
      ]);
      expect(await upgraded.query('order_items'), isEmpty);
      final List<Map<String, Object?>> foreignKeys = await upgraded.rawQuery(
        'PRAGMA foreign_keys',
      );
      expect(foreignKeys[0]['foreign_keys'], 1);
      final List<OrderRecord> oldOrders =
          await SandwichDatabase.instance.getAllOrders();
      expect(oldOrders[1].summary, oldOrder['summary']);
      expect(oldOrders[1].total, 16.50);
      expect(oldOrders[1].items, isEmpty);
      expect(await SandwichDatabase.instance.getNextOrderNumber(), 1044);

      final int id = await SandwichDatabase.instance.insertOrder(
        const OrderRecord(
          orderNumber: 1044,
          summary: '2 x Footlong Sub',
          total: 16.50,
          date: '03/01/2026 10:00',
          items: [item],
        ),
      );
      expect(id, greaterThan(43));
      expect((await upgraded.query('order_items'))[0]['order_id'], id);
      await SandwichDatabase.instance.close();

      final Database reopened = await SandwichDatabase.instance.open(filePath);
      SandwichDatabase.instance.setDatabase(reopened);
      final List<OrderRecord> orders =
          await SandwichDatabase.instance.getAllOrders();
      expect(orders, hasLength(3));
      expect(orders[0].items[0].sandwichName, 'Footlong Sub');
      expect(orders[0].total, 16.50);
      expect(orders[2].toMap(), oldOrder);
      expect(await reopened.rawQuery('PRAGMA foreign_key_check'), isEmpty);
    } finally {
      await SandwichDatabase.instance.close();
      await folder.delete(recursive: true);
    }
  });

  test('insertOrder stores an order and returns its id', () async {
    final int id = await SandwichDatabase.instance.insertOrder(
      buildRecord(1001, '1 x Footlong Sub', 7.50),
    );
    expect(id, greaterThan(0));

    final List<OrderRecord> orders =
        await SandwichDatabase.instance.getAllOrders();
    expect(orders.length, 1);
    expect(orders[0].id, id);
    expect(orders[0].summary, '1 x Footlong Sub');
    expect(orders[0].total, 7.50);
  });

  test('getAllOrders returns newest order number first', () async {
    await SandwichDatabase.instance.insertOrder(
      buildRecord(1001, 'First', 5.0),
    );
    await SandwichDatabase.instance.insertOrder(
      buildRecord(1003, 'Third', 9.0),
    );
    await SandwichDatabase.instance.insertOrder(
      buildRecord(1002, 'Second', 7.0),
    );

    final List<OrderRecord> orders =
        await SandwichDatabase.instance.getAllOrders();
    expect(orders[0].orderNumber, 1003);
    expect(orders[1].orderNumber, 1002);
    expect(orders[2].orderNumber, 1001);
  });

  test('getNextOrderNumber increments the current maximum', () async {
    expect(await SandwichDatabase.instance.getNextOrderNumber(), 1001);

    await SandwichDatabase.instance.insertOrder(
      buildRecord(1005, 'Order', 5.0),
    );
    expect(await SandwichDatabase.instance.getNextOrderNumber(), 1006);
  });

  test('items are linked to their order and retain purchase details', () async {
    await SandwichDatabase.instance.insertOrder(buildRecord(1001, 'Old', 9.0));
    final int id = await SandwichDatabase.instance.insertOrder(
      const OrderRecord(
        orderNumber: 1002,
        summary: 'Purchased items',
        total: 21.0,
        date: '01/01/2026 10:00',
        items: [
          item,
          OrderItem(
            sandwichId: 'six_inch',
            sandwichName: 'Six-Inch Sub',
            unitPrice: 4.50,
            quantity: 1,
          ),
        ],
      ),
    );
    final Database db = await SandwichDatabase.instance.database;
    final List<Map<String, Object?>> rows = await db.query(
      'order_items',
      orderBy: 'id',
    );
    expect(rows, hasLength(2));
    expect(rows[0], {'id': rows[0]['id'], ...item.toMap(id)});
    expect(rows[1]['order_id'], id);
    final List<OrderRecord> orders =
        await SandwichDatabase.instance.getAllOrders();
    expect(orders[0].items, hasLength(2));
    expect(orders[0].items[0].sandwichId, 'footlong');
    expect(orders[0].items[0].sandwichName, 'Footlong Sub');
    expect(orders[0].items[0].unitPrice, 7.50);
    expect(orders[0].items[0].quantity, 2);
    expect(orders[0].items[0].lineTotal, 15.0);
    expect(orders[0].total, 21.0);
    expect(orders[1].items, isEmpty);
  });

  test('foreign keys reject orphan items and deleting a linked order',
      () async {
    final Database db = await SandwichDatabase.instance.database;
    await expectLater(
      db.transaction((Transaction transaction) async {
        await transaction.insert('order_items', item.toMap(999));
      }),
      throwsA(isA<DatabaseException>()),
    );
    final int id = await SandwichDatabase.instance.insertOrder(
      const OrderRecord(
        orderNumber: 1001,
        summary: 'Purchased items',
        total: 16.50,
        date: '01/01/2026 10:00',
        items: [item],
      ),
    );
    await expectLater(
      db.transaction((Transaction transaction) async {
        await transaction.delete('orders', where: 'id = ?', whereArgs: [id]);
      }),
      throwsA(isA<DatabaseException>()),
    );
    expect(await db.query('orders'), hasLength(1));
    expect(await db.query('order_items'), hasLength(1));
  });

  test('a failed item rolls back the order and all earlier items', () async {
    final OrderRecord existing = buildRecord(1001, 'Existing order', 9.0);
    await SandwichDatabase.instance.insertOrder(existing);
    await expectLater(
      SandwichDatabase.instance.insertOrder(
        const OrderRecord(
          orderNumber: 1002,
          summary: 'Invalid purchase',
          total: 16.50,
          date: '01/01/2026 10:00',
          items: [
            item,
            OrderItem(
              sandwichId: 'invalid',
              sandwichName: 'Invalid sandwich',
              unitPrice: 4.50,
              quantity: 0,
            ),
          ],
        ),
      ),
      throwsA(isA<DatabaseException>()),
    );
    final List<OrderRecord> orders =
        await SandwichDatabase.instance.getAllOrders();
    expect(orders, hasLength(1));
    expect(orders[0].summary, existing.summary);
    final Database db = await SandwichDatabase.instance.database;
    expect(await db.query('order_items'), isEmpty);
    expect(await SandwichDatabase.instance.getNextOrderNumber(), 1002);
  });

  test('the shared database opens at the default path with version 2',
      () async {
    await SandwichDatabase.instance.close();
    final Directory folder = Directory.systemTemp.createTempSync('sandwich');
    await databaseFactoryFfiNoIsolate.setDatabasesPath(folder.path);
    try {
      final Database db = await SandwichDatabase.instance.database;
      expect(await db.getVersion(), 2);
      expect(await SandwichDatabase.instance.getAllOrders(), isNotEmpty);
      expect(File(join(folder.path, 'sandwich_data.db')).existsSync(), isTrue);
    } finally {
      await SandwichDatabase.instance.close();
      folder.deleteSync(recursive: true);
    }
  });
}
