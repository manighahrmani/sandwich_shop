import 'package:sandwich_shop/database/sandwich_db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> openTestDatabase() async {
  sqfliteFfiInit();
  final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: SandwichDatabase.instance.createTables,
    ),
  );
  SandwichDatabase.instance.setDatabase(database);
  return database;
}
