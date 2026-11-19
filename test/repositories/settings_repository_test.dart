import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/user_settings.dart';
import 'package:sandwich_shop/repositories/settings_repository.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    SettingsRepository.instance.setFirestore(fakeFirestore);
  });

  tearDown(() {
    SettingsRepository.instance.setFirestore(null);
  });

  test('firestore falls back to FirebaseFirestore.instance when null', () {
    SettingsRepository.instance.setFirestore(null);

    FirebaseFirestore readFirestore() {
      return SettingsRepository.instance.firestore;
    }

    expect(readFirestore, throwsA(isA<FirebaseException>()));
  });

  test('loadSettings returns null when user document does not exist', () async {
    final UserSettings? result =
        await SettingsRepository.instance.loadSettings('missing-uid');
    expect(result, isNull);
  });

  test('saveSettings stores and loadSettings restores user preferences',
      () async {
    const UserSettings expected = UserSettings(
      name: 'Taylor Reed',
      address: '22 Guildhall Walk',
      email: 'taylor@example.com',
      receiveNewsletter: true,
      largeText: true,
    );

    await SettingsRepository.instance.saveSettings('user-42', expected);

    final UserSettings? loaded =
        await SettingsRepository.instance.loadSettings('user-42');
    expect(loaded, isNotNull);
    expect(loaded!.name, 'Taylor Reed');
    expect(loaded.address, '22 Guildhall Walk');
    expect(loaded.email, 'taylor@example.com');
    expect(loaded.receiveNewsletter, isTrue);
    expect(loaded.largeText, isTrue);
  });
}
