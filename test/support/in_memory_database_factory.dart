import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class InMemoryDatabaseFactory implements DatabaseFactory {
  String? requestedPath;
  int openCount = 0;

  @override
  Future<String> getDatabasesPath() async {
    return '.';
  }

  @override
  Future<Database> openDatabase(
    String path, {
    OpenDatabaseOptions? options,
  }) async {
    requestedPath = path;
    openCount++;
    return databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: options,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
