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
    String name = '';
    final Object? rawName = map['name'];
    if (rawName is String) {
      name = rawName;
    }
    String address = '';
    final Object? rawAddress = map['address'];
    if (rawAddress is String) {
      address = rawAddress;
    }
    String email = '';
    final Object? rawEmail = map['email'];
    if (rawEmail is String) {
      email = rawEmail;
    }
    bool receiveNewsletter = false;
    final Object? rawNewsletter = map['receiveNewsletter'];
    if (rawNewsletter is bool) {
      receiveNewsletter = rawNewsletter;
    }
    bool largeText = false;
    final Object? rawLargeText = map['largeText'];
    if (rawLargeText is bool) {
      largeText = rawLargeText;
    }

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
