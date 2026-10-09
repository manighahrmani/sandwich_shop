import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sandwich_shop/models/order_record.dart';
import 'package:sqflite/sqflite.dart' as sqflite_plugin;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SandwichDatabase {
  SandwichDatabase._internal();

  static final SandwichDatabase instance = SandwichDatabase._internal();

  static Database? _database;

  void setDatabase(Database? db) {
    _database = db;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    final Database db = await _initDB('sandwich_data.db');
    _database = db;
    return db;
  }

  Future<Database> _initDB(String fileName) async {
    final OpenDatabaseOptions options = OpenDatabaseOptions(
      version: 1,
      onCreate: _createDB,
    );

    // Tests run with the FLUTTER_TEST environment flag set. In that case we
    // keep the fast, isolated in-memory FFI database so the existing tests
    // behave exactly as before.
    const bool runningInTest = bool.fromEnvironment('FLUTTER_TEST');
    if (runningInTest) {
      sqfliteFfiInit();
      final DatabaseFactory testFactory = databaseFactoryFfi;
      final Database testDatabase = await testFactory.openDatabase(
        inMemoryDatabasePath,
        options: options,
      );
      return testDatabase;
    }

    // On the web we use the WebAssembly build of SQLite through the dedicated
    // web factory. The database name is enough here because the browser stores
    // the data for us, so there is no file path to build.
    if (kIsWeb) {
      final DatabaseFactory webFactory = databaseFactoryFfiWebNoWebWorker;
      final Database webDatabase = await webFactory.openDatabase(
        fileName,
        options: options,
      );
      return webDatabase;
    }

    // On Android and iOS the standard sqflite plugin owns the SQLite engine.
    // A bare file name cannot be opened on a phone (it fails with "unable to
    // open database file"), so we build a full path inside the folder the
    // plugin gives us with getDatabasesPath().
    final TargetPlatform platform = defaultTargetPlatform;
    final bool runningOnMobile =
        platform == TargetPlatform.android || platform == TargetPlatform.iOS;
    if (runningOnMobile) {
      final DatabaseFactory mobileFactory = sqflite_plugin.databaseFactory;
      final String databasesFolder = await sqflite_plugin.getDatabasesPath();
      final String mobilePath = join(databasesFolder, fileName);
      final Database mobileDatabase = await mobileFactory.openDatabase(
        mobilePath,
        options: options,
      );
      return mobileDatabase;
    }

    // On desktop (Windows, macOS, Linux) we keep the FFI engine, but we still
    // open a real file in a writable folder rather than a bare file name.
    sqfliteFfiInit();
    final DatabaseFactory desktopFactory = databaseFactoryFfi;
    final String desktopFolder = await sqflite_plugin.getDatabasesPath();
    final String desktopPath = join(desktopFolder, fileName);
    final Database desktopDatabase = await desktopFactory.openDatabase(
      desktopPath,
      options: options,
    );
    return desktopDatabase;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS orders (
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
    // Seed a few past orders so the orders screen has content on first run.
    await db.insert('orders', <String, Object?>{
      'order_number': 1003,
      'summary': '2 x Footlong Sub',
      'note': 'Extra napkins please',
      'toasted': 1,
      'vegan': 0,
      'total': 15.00,
      'date': '18 Apr 2026 12:45',
    });
    await db.insert('orders', <String, Object?>{
      'order_number': 1002,
      'summary': '1 x Six-Inch Sub',
      'note': '',
      'toasted': 0,
      'vegan': 1,
      'total': 4.50,
      'date': '2 Mar 2026 18:10',
    });
    await db.insert('orders', <String, Object?>{
      'order_number': 1001,
      'summary': '3 x Footlong Sub',
      'note': 'No onions',
      'toasted': 1,
      'vegan': 0,
      'total': 22.50,
      'date': '11 Jan 2026 13:02',
    });
  }

  Future<int> insertOrder(OrderRecord order) async {
    final Database db = await database;
    final int id = await db.insert('orders', order.toMap());
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
      orders.add(OrderRecord.fromMap(row));
    }
    return orders;
  }

  Future<int> getNextOrderNumber() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.rawQuery(
      'SELECT MAX(order_number) as max_num FROM orders',
    );
    if (records.isNotEmpty && records[0]['max_num'] != null) {
      final int currentMax = records[0]['max_num'] as int;
      return currentMax + 1;
    }
    return 1001;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
