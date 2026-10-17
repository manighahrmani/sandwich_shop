import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  test('Android, iOS and macOS are supported', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(isSupportedPlatform(), isTrue);
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(isSupportedPlatform(), isTrue);
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    expect(isSupportedPlatform(), isTrue);
    debugDefaultTargetPlatformOverride = null;
  });

  test('Windows and Linux desktop are not supported', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    expect(isSupportedPlatform(), isFalse);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('The unsupported platform screen explains what to do',
      (WidgetTester tester) async {
    await tester.pumpWidget(const UnsupportedPlatformApp());
    expect(find.textContaining('Android emulator'), findsOneWidget);
  });
}
