class User {
  final String id;
  final String username;
  final String email;
  final String? avatar;
  final DateTime createdAt;
  final bool isVerified;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
    required this.createdAt,
    this.isVerified = false,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['created_at']),
      isVerified: json['is_verified'] ?? false,
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar': avatar,
      'created_at': createdAt.toIso8601String(),
      'is_verified': isVerified,
      'preferences': preferences.toJson(),
    };
  }
}

class UserPreferences {
  final bool enableNotifications;
  final bool enableCopyTrading;
  final String defaultCurrency;
  final double riskTolerance;

  UserPreferences({
    this.enableNotifications = true,
    this.enableCopyTrading = false,
    this.defaultCurrency = 'USD',
    this.riskTolerance = 0.5,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      enableNotifications: json['enable_notifications'] ?? true,
      enableCopyTrading: json['enable_copy_trading'] ?? false,
      defaultCurrency: json['default_currency'] ?? 'USD',
      riskTolerance: (json['risk_tolerance'] ?? 0.5).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enable_notifications': enableNotifications,
      'enable_copy_trading': enableCopyTrading,
      'default_currency': defaultCurrency,
      'risk_tolerance': riskTolerance,
    };
  }
}
