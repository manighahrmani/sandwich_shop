import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandwich_shop/models/user_settings.dart';

class SettingsRepository {
  SettingsRepository._internal();

  static final SettingsRepository instance = SettingsRepository._internal();

  FirebaseFirestore? _firestore;

  void setFirestore(FirebaseFirestore? firestore) {
    _firestore = firestore;
  }

  FirebaseFirestore get firestore {
    final FirebaseFirestore? existingFirestore = _firestore;
    if (existingFirestore != null) {
      return existingFirestore;
    }
    return FirebaseFirestore.instance;
  }

  Future<UserSettings?> loadSettings(String userId) async {
    final CollectionReference<Map<String, dynamic>> usersCollection =
        firestore.collection('users');
    final DocumentReference<Map<String, dynamic>> userDocument =
        usersCollection.doc(userId);
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await userDocument.get();

    final Map<String, dynamic>? documentData = snapshot.data();
    if (!snapshot.exists || documentData == null) {
      return null;
    }
    return UserSettings.fromMap(documentData);
  }

  Future<void> saveSettings(String userId, UserSettings settings) async {
    final CollectionReference<Map<String, dynamic>> usersCollection =
        firestore.collection('users');
    final DocumentReference<Map<String, dynamic>> userDocument =
        usersCollection.doc(userId);
    final Map<String, dynamic> settingsData = settings.toMap();
    await userDocument.set(settingsData);
  }
}
