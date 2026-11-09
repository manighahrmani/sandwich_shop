import 'package:path/path.dart';
import 'package:sandwich_shop/models/order_item.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sqflite/sqflite.dart';

class SandwichDatabase {
  SandwichDatabase._internal();

  static final SandwichDatabase instance = SandwichDatabase._internal();

  static Database? _database;

  void setDatabase(Database? db) {
    _database = db;
  }

  Future<Database> get database async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      return cachedDatabase;
    }
    final Database db = await _initDB('sandwich_data.db');
    _database = db;
    return db;
  }

  Future<Database> _initDB(String fileName) async {
    final String folder = await getDatabasesPath();
    final String filePath = join(folder, fileName);
    return open(filePath);
  }

  Future<Database> open(String filePath) async {
    final Database db = await openDatabase(
      filePath,
      version: 2,
      onConfigure: configureDatabase,
      onCreate: _createDB,
      onUpgrade: upgradeDatabase,
    );
    return db;
  }

  Future<void> configureDatabase(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_number INTEGER NOT NULL,
        summary TEXT NOT NULL,
        total REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
    await _createOrderItemsTable(db);
  }

  Future<void> _createOrderItemsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL REFERENCES orders(id),
        sandwich_id TEXT NOT NULL,
        sandwich_name TEXT NOT NULL,
        unit_price REAL NOT NULL CHECK (unit_price >= 0),
        quantity INTEGER NOT NULL CHECK (quantity > 0)
      )
    ''');
  }

  Future<void> upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createOrderItemsTable(db);
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await createTables(db, version);
    await db.insert('orders', <String, Object?>{
      'order_number': 1003,
      'summary': '2 x Footlong Sub',
      'total': 15.00,
      'date': '18/04/2026 12:45',
    });
    await db.insert('orders', <String, Object?>{
      'order_number': 1002,
      'summary': '1 x Six-Inch Sub',
      'total': 4.50,
      'date': '02/03/2026 18:10',
    });
    await db.insert('orders', <String, Object?>{
      'order_number': 1001,
      'summary': '3 x Footlong Sub',
      'total': 22.50,
      'date': '11/01/2026 13:02',
    });
  }

  Future<int> insertOrder(OrderRecord order) async {
    final Database db = await database;
    final int id = await db.transaction((Transaction transaction) async {
      final int orderId = await transaction.insert('orders', order.toMap());
      for (final OrderItem item in order.items) {
        await transaction.insert('order_items', item.toMap(orderId));
      }
      return orderId;
    });
    return id;
  }

  Future<List<OrderRecord>> getAllOrders() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.query(
      'orders',
      orderBy: 'order_number DESC',
    );
    final List<OrderRecord> orders = [];
    for (final Map<String, Object?> row in records) {
      final List<Map<String, Object?>> itemRecords = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [row['id']],
        orderBy: 'id',
      );
      final List<OrderItem> items = [];
      for (final Map<String, Object?> itemRow in itemRecords) {
        items.add(OrderItem.fromMap(itemRow));
      }
      orders.add(OrderRecord.fromMap(row, items: items));
    }
    return orders;
  }

  Future<int> getNextOrderNumber() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.rawQuery(
      'SELECT MAX(order_number) as max_num FROM orders',
    );
    if (records.isEmpty) {
      return 1001;
    }
    final Object? maxValue = records[0]['max_num'];
    if (maxValue == null) {
      return 1001;
    }
    final int currentMax = maxValue as int;
    return currentMax + 1;
  }

  Future<void> close() async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      await cachedDatabase.close();
      _database = null;
    }
  }
}
