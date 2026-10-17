import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/test_database.dart';
import '../support/in_memory_database_factory.dart';

void main() {
  setUp(() async {
    await openTestDatabase();
  });

  tearDown(() async {
    await SandwichDatabase.instance.close();
  });

  OrderRecord buildRecord(int orderNumber, String summary, double total) {
    return OrderRecord(
      orderNumber: orderNumber,
      summary: summary,
      note: '',
      toasted: 0,
      vegan: 0,
      total: total,
      date: '01/01/2026 10:00',
    );
  }

  test('insertOrder stores an order and returns its id', () async {
    final int id = await SandwichDatabase.instance.insertOrder(
      buildRecord(1001, '1 x Footlong Sub', 7.50),
    );
    expect(id, greaterThan(0));

    final List<OrderRecord> orders = await SandwichDatabase.instance
        .getAllOrders();
    expect(orders.length, 1);
    expect(orders.first.id, id);
    expect(orders.first.summary, '1 x Footlong Sub');
    expect(orders.first.total, 7.50);
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

    final List<OrderRecord> orders = await SandwichDatabase.instance
        .getAllOrders();
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

  test(
    'Creating the production tables twice preserves existing orders',
    () async {
      final SandwichDatabase store = SandwichDatabase.instance;
      final Database database = await store.database;
      await store.insertOrder(buildRecord(1001, 'Keep me', 4.5));
      await store.createTables(database, 1);
      expect(await store.getAllOrders(), hasLength(1));
      expect(await store.database, same(database));
    },
  );

  test(
    'Closing repeatedly is safe and permits a new injected database',
    () async {
      final SandwichDatabase store = SandwichDatabase.instance;
      final Database original = await store.database;
      await store.close();
      await store.close();
      expect(original.isOpen, isFalse);
      final Database replacement = await openTestDatabase();
      expect(replacement.isOpen, isTrue);
      expect(await store.database, same(replacement));
      expect(await store.getAllOrders(), isEmpty);
    },
  );

  test(
    'Insertion preserves options, note, date and explicit database id',
    () async {
      const OrderRecord original = OrderRecord(
        id: 42,
        orderNumber: 1010,
        summary: '1 x Six-Inch Sub',
        note: 'No onions',
        toasted: 1,
        vegan: 1,
        total: 6.0,
        date: '02/01/2026 10:00',
      );
      expect(await SandwichDatabase.instance.insertOrder(original), 42);
      final List<OrderRecord> orders = await SandwichDatabase.instance
          .getAllOrders();
      expect(orders.single.toMap(), original.toMap());
    },
  );

  test(
    'SQLite failures propagate rather than reporting an empty result',
    () async {
      final Database database = await SandwichDatabase.instance.database;
      await database.execute('DROP TABLE orders');
      await expectLater(
        SandwichDatabase.instance.getAllOrders(),
        throwsA(isA<DatabaseException>()),
      );
      await expectLater(
        SandwichDatabase.instance.getNextOrderNumber(),
        throwsA(isA<DatabaseException>()),
      );
      await expectLater(
        SandwichDatabase.instance.insertOrder(buildRecord(1001, 'Fail', 1)),
        throwsA(isA<DatabaseException>()),
      );
    },
  );

  test(
    'Production initialisation opens, seeds and caches the real schema',
    () async {
      await SandwichDatabase.instance.close();
      sqfliteFfiInit();
      final DatabaseFactory originalFactory = databaseFactory;
      final InMemoryDatabaseFactory factory = InMemoryDatabaseFactory();
      databaseFactory = factory;
      try {
        final Database database = await SandwichDatabase.instance.database;
        final List<OrderRecord> orders = await SandwichDatabase.instance
            .getAllOrders();
        expect(orders, hasLength(3));
        expect(orders.first.orderNumber, 1003);
        expect(orders.first.note, 'Extra napkins please');
        expect(orders.first.toasted, 1);
        expect(orders[1].vegan, 1);
        expect(orders.last.orderNumber, 1001);
        expect(await SandwichDatabase.instance.getNextOrderNumber(), 1004);
        expect(await SandwichDatabase.instance.database, same(database));
        expect(factory.openCount, 1);
        expect(factory.requestedPath, endsWith('sandwich_data.db'));
      } finally {
        await SandwichDatabase.instance.close();
        databaseFactory = originalFactory;
      }
    },
  );
}
