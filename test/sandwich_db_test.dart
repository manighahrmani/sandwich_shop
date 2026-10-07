import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final Database db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS orders (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              order_number INTEGER NOT NULL,
              items_summary TEXT NOT NULL,
              note TEXT NOT NULL,
              toasted INTEGER NOT NULL,
              vegan INTEGER NOT NULL,
              total_price REAL NOT NULL,
              date TEXT NOT NULL
            )
          ''');
        },
      ),
    );
    SandwichDatabase.instance.setDatabase(db);
  });

  tearDown(() async {
    await SandwichDatabase.instance.close();
  });

  test('insertOrder stores an order that getAllOrders returns', () async {
    const OrderRecord order = OrderRecord(
      orderNumber: 1001,
      itemsSummary: '2 x Footlong Sub',
      note: 'No onions',
      toasted: 1,
      vegan: 0,
      totalPrice: 15.00,
      date: '18 Apr 2026 12:45',
    );

    final int id = await SandwichDatabase.instance.insertOrder(order);
    expect(id, greaterThan(0));

    final List<OrderRecord> orders = await SandwichDatabase.instance
        .getAllOrders();
    expect(orders.length, 1);
    expect(orders[0].orderNumber, 1001);
    expect(orders[0].itemsSummary, '2 x Footlong Sub');
    expect(orders[0].note, 'No onions');
    expect(orders[0].toasted, 1);
    expect(orders[0].vegan, 0);
    expect(orders[0].totalPrice, 15.00);
    expect(orders[0].date, '18 Apr 2026 12:45');
  });

  test('getAllOrders returns orders newest first by order number', () async {
    const OrderRecord older = OrderRecord(
      orderNumber: 1001,
      itemsSummary: '1 x Six-Inch Sub',
      note: '',
      toasted: 0,
      vegan: 1,
      totalPrice: 4.50,
      date: '2 Mar 2026 18:10',
    );
    const OrderRecord newer = OrderRecord(
      orderNumber: 1002,
      itemsSummary: '3 x Footlong Sub',
      note: 'Extra salad',
      toasted: 1,
      vegan: 0,
      totalPrice: 22.50,
      date: '11 Jan 2026 13:02',
    );

    await SandwichDatabase.instance.insertOrder(older);
    await SandwichDatabase.instance.insertOrder(newer);

    final List<OrderRecord> orders = await SandwichDatabase.instance
        .getAllOrders();
    expect(orders.length, 2);
    expect(orders[0].orderNumber, 1002);
    expect(orders[1].orderNumber, 1001);
  });

  test(
    'getNextOrderNumber returns a starting number for an empty table',
    () async {
      final int next = await SandwichDatabase.instance.getNextOrderNumber();
      expect(next, 1001);
    },
  );

  test('getNextOrderNumber returns the current maximum plus one', () async {
    const OrderRecord order = OrderRecord(
      orderNumber: 1005,
      itemsSummary: '1 x Six-Inch Sub',
      note: '',
      toasted: 0,
      vegan: 0,
      totalPrice: 5.00,
      date: '1 Jan 2026 09:00',
    );
    await SandwichDatabase.instance.insertOrder(order);

    final int next = await SandwichDatabase.instance.getNextOrderNumber();
    expect(next, 1006);
  });
}
