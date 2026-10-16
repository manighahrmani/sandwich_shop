import 'dart:async';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ControlledDatabase implements Database {
  final Database delegate;
  Completer<void>? numberGate;
  Completer<void>? insertGate;
  Completer<void>? queryGate;
  int numberRequests = 0;
  int insertRequests = 0;
  final Completer<void> numberCompleted = Completer<void>();
  final Completer<void> insertCompleted = Completer<void>();
  final Completer<void> queryCompleted = Completer<void>();

  ControlledDatabase(this.delegate);

  @override
  Future<List<Map<String, Object?>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    numberRequests++;
    if (numberGate != null) {
      await numberGate!.future;
    }
    try {
      return await delegate.rawQuery(sql, arguments);
    } finally {
      if (!numberCompleted.isCompleted) {
        numberCompleted.complete();
      }
    }
  }

  @override
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    insertRequests++;
    if (insertGate != null) {
      await insertGate!.future;
    }
    try {
      return await delegate.insert(
        table,
        values,
        nullColumnHack: nullColumnHack,
        conflictAlgorithm: conflictAlgorithm,
      );
    } finally {
      if (!insertCompleted.isCompleted) {
        insertCompleted.complete();
      }
    }
  }

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    if (queryGate != null) {
      await queryGate!.future;
    }
    try {
      return await delegate.query(
        table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
    } finally {
      if (!queryCompleted.isCompleted) {
        queryCompleted.complete();
      }
    }
  }

  @override
  Future<void> close() async {
    await delegate.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
