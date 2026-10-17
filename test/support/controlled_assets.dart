import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class ControlledAssets {
  String contents = '[]';
  bool missing = false;
  Completer<void>? gate;

  void install() {
    rootBundle.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', load);
  }

  Future<ByteData?> load(ByteData? message) async {
    if (gate != null) {
      await gate!.future;
    }
    if (missing) {
      return null;
    }
    final Uint8List bytes = Uint8List.fromList(utf8.encode(contents));
    return ByteData.sublistView(bytes);
  }

  void uninstall() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
    rootBundle.clear();
  }
}
