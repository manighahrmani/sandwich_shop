import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database database;

  setUp(() async {
    database = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE orders (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              order_number INTEGER NOT NULL,
              summary TEXT NOT NULL,
              note TEXT NOT NULL,
              toasted INTEGER NOT NULL,
              vegan INTEGER NOT NULL,
              total REAL NOT NULL,
              date TEXT NOT NULL
            )
          ''');
        },
      ),
    );
    SandwichDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await database.close();
    SandwichDatabase.instance.setDatabase(null);
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

    final List<OrderRecord> orders =
        await SandwichDatabase.instance.getAllOrders();
    expect(orders.length, 1);
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
}
