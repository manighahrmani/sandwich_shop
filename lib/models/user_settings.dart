class UserSettings {
  final String name;
  final String address;
  final String email;
  final bool receiveNewsletter;
  final bool largeText;

  const UserSettings({
    this.name = '',
    this.address = '',
    this.email = '',
    this.receiveNewsletter = false,
    this.largeText = false,
  });

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    final String name = (map['name'] as String?) ?? '';
    final String address = (map['address'] as String?) ?? '';
    final String email = (map['email'] as String?) ?? '';
    final bool receiveNewsletter = (map['receiveNewsletter'] as bool?) ?? false;
    final bool largeText = (map['largeText'] as bool?) ?? false;

    return UserSettings(
      name: name,
      address: address,
      email: email,
      receiveNewsletter: receiveNewsletter,
      largeText: largeText,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'address': address,
      'email': email,
      'receiveNewsletter': receiveNewsletter,
      'largeText': largeText,
    };
    return data;
  }
}
