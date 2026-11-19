import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/user_settings.dart';

void main() {
  test('UserSettings defaults to empty values and false booleans', () {
    const UserSettings settings = UserSettings();
    expect(settings.name, isEmpty);
    expect(settings.address, isEmpty);
    expect(settings.email, isEmpty);
    expect(settings.receiveNewsletter, isFalse);
    expect(settings.largeText, isFalse);
  });

  test('UserSettings stores configured values and converts to/from map', () {
    const UserSettings settings = UserSettings(
      name: 'Taylor Reed',
      address: '22 Guildhall Walk',
      email: 'taylor@example.com',
      receiveNewsletter: true,
      largeText: true,
    );
    expect(settings.name, 'Taylor Reed');
    expect(settings.address, '22 Guildhall Walk');
    expect(settings.email, 'taylor@example.com');
    expect(settings.receiveNewsletter, isTrue);
    expect(settings.largeText, isTrue);

    final Map<String, dynamic> map = settings.toMap();
    final UserSettings restored = UserSettings.fromMap(map);
    expect(restored.name, 'Taylor Reed');
    expect(restored.address, '22 Guildhall Walk');
    expect(restored.email, 'taylor@example.com');
    expect(restored.receiveNewsletter, isTrue);
    expect(restored.largeText, isTrue);

    final UserSettings emptyRestored =
        UserSettings.fromMap(<String, dynamic>{});
    expect(emptyRestored.name, isEmpty);
    expect(emptyRestored.largeText, isFalse);
  });
}
