class UserSettings {
  final String name;
  final String address;
  final String email;
  final String customerId;
  final bool receiveNewsEmail;

  const UserSettings({
    required this.name,
    required this.address,
    required this.email,
    required this.customerId,
    required this.receiveNewsEmail,
  });

  UserSettings copyWith({
    String? name,
    String? address,
    String? email,
    String? customerId,
    bool? receiveNewsEmail,
  }) {
    return UserSettings(
      name: name ?? this.name,
      address: address ?? this.address,
      email: email ?? this.email,
      customerId: customerId ?? this.customerId,
      receiveNewsEmail: receiveNewsEmail ?? this.receiveNewsEmail,
    );
  }
}
