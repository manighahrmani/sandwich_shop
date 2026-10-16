import 'dart:async';

import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

class ControlledPreferences extends SharedPreferencesStorePlatform {
  final Map<String, Object> values = <String, Object>{};
  Completer<void>? loadGate;
  Completer<void>? writeGate;
  bool failLoad = false;
  bool failWrite = false;
  String? rejectedKey;
  int writeCount = 0;

  @override
  Future<Map<String, Object>> getAll() async {
    if (loadGate != null) {
      await loadGate!.future;
    }
    if (failLoad) {
      throw StateError('Test load failure');
    }
    return Map<String, Object>.from(values);
  }

  @override
  Future<bool> setValue(String valueType, String key, Object value) async {
    writeCount++;
    if (writeGate != null) {
      await writeGate!.future;
    }
    if (failWrite) {
      throw StateError('Test save failure');
    }
    if (key == rejectedKey) {
      return false;
    }
    values[key] = value;
    return true;
  }
}
