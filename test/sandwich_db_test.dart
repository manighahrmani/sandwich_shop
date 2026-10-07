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
              kitchen_note TEXT NOT NULL,
              nut_free INTEGER NOT NULL,
              gluten_free INTEGER NOT NULL,
              no_onions INTEGER NOT NULL,
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
      itemsSummary: '2 x Italian B.M.T. Footlong',
      kitchenNote: 'Toasted',
      nutFree: 1,
      glutenFree: 0,
      noOnions: 1,
      totalPrice: 13.50,
      date: '18 Apr 2026 12:45',
    );

    final int id = await SandwichDatabase.instance.insertOrder(order);
    expect(id, greaterThan(0));

    final List<OrderRecord> orders =
        await SandwichDatabase.instance.getAllOrders();
    expect(orders.length, 1);
    expect(orders[0].orderNumber, 1001);
    expect(orders[0].itemsSummary, '2 x Italian B.M.T. Footlong');
    expect(orders[0].kitchenNote, 'Toasted');
    expect(orders[0].nutFree, 1);
    expect(orders[0].totalPrice, 13.50);
    expect(orders[0].date, '18 Apr 2026 12:45');
  });

  test('getAllOrders returns orders newest first by order number', () async {
    const OrderRecord older = OrderRecord(
      orderNumber: 1001,
      itemsSummary: '1 x Veggie Delight Six Inch',
      kitchenNote: '',
      nutFree: 0,
      glutenFree: 1,
      noOnions: 0,
      totalPrice: 4.50,
      date: '2 Mar 2026 18:10',
    );
    const OrderRecord newer = OrderRecord(
      orderNumber: 1002,
      itemsSummary: '3 x Tuna Melt Footlong',
      kitchenNote: 'Extra salad',
      nutFree: 0,
      glutenFree: 0,
      noOnions: 0,
      totalPrice: 19.50,
      date: '11 Jan 2026 13:02',
    );

    await SandwichDatabase.instance.insertOrder(older);
    await SandwichDatabase.instance.insertOrder(newer);

    final List<OrderRecord> orders =
        await SandwichDatabase.instance.getAllOrders();
    expect(orders.length, 2);
    expect(orders[0].orderNumber, 1002);
    expect(orders[1].orderNumber, 1001);
  });

  test('getNextOrderNumber returns a starting number for an empty table',
      () async {
    final int next = await SandwichDatabase.instance.getNextOrderNumber();
    expect(next, 1001);
  });

  test('getNextOrderNumber returns the current maximum plus one', () async {
    const OrderRecord order = OrderRecord(
      orderNumber: 1005,
      itemsSummary: '1 x Italian B.M.T. Six Inch',
      kitchenNote: '',
      nutFree: 0,
      glutenFree: 0,
      noOnions: 0,
      totalPrice: 5.00,
      date: '1 Jan 2026 09:00',
    );
    await SandwichDatabase.instance.insertOrder(order);

    final int next = await SandwichDatabase.instance.getNextOrderNumber();
    expect(next, 1006);
  });
}
