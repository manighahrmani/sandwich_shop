import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/user_settings.dart';

void main() {
  test('UserSettings defaults to empty values and false newsletter', () {
    const UserSettings settings = UserSettings();
    expect(settings.name, isEmpty);
    expect(settings.address, isEmpty);
    expect(settings.email, isEmpty);
    expect(settings.receiveNewsletter, isFalse);
  });

  test('UserSettings stores configured values', () {
    const UserSettings settings = UserSettings(
      name: 'Taylor Reed',
      address: '22 Guildhall Walk',
      email: 'taylor@example.com',
      receiveNewsletter: true,
    );
    expect(settings.name, 'Taylor Reed');
    expect(settings.address, '22 Guildhall Walk');
    expect(settings.email, 'taylor@example.com');
    expect(settings.receiveNewsletter, isTrue);
  });
}
