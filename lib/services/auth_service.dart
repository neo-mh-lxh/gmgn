import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';
  static const String _allUsersKey = 'all_users_data';

  // 获取所有用户数据（包括默认用户和注册用户）
  static Future<List<Map<String, dynamic>>> _getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final allUsersJson = prefs.getString(_allUsersKey);

    List<Map<String, dynamic>> allUsers = [];

    // 添加默认演示用户
    allUsers.addAll([
      {
        'id': '1',
        'username': 'trader_pro',
        'email': 'trader@gmgn.ai',
        'password': _hashPassword('password123'),
        'avatar': null,
        'created_at':
            DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        'is_verified': true,
        'preferences': {
          'enable_notifications': true,
          'enable_copy_trading': true,
          'default_currency': 'USD',
          'risk_tolerance': 0.7,
        }
      },
      {
        'id': '2',
        'username': 'defi_master',
        'email': 'defi@gmgn.ai',
        'password': _hashPassword('secure456'),
        'avatar': null,
        'created_at':
            DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
        'is_verified': false,
        'preferences': {
          'enable_notifications': false,
          'enable_copy_trading': false,
          'default_currency': 'SOL',
          'risk_tolerance': 0.3,
        }
      }
    ]);

    // 添加本地保存的注册用户
    if (allUsersJson != null) {
      try {
        final savedUsers = json.decode(allUsersJson) as List;
        allUsers.addAll(savedUsers.cast<Map<String, dynamic>>());
      } catch (e) {
        // Error loading saved users
      }
    }

    return allUsers;
  }

  // 保存新注册的用户到本地存储
  static Future<void> _saveNewUser(Map<String, dynamic> newUser) async {
    final prefs = await SharedPreferences.getInstance();
    final allUsersJson = prefs.getString(_allUsersKey);

    List<Map<String, dynamic>> savedUsers = [];
    if (allUsersJson != null) {
      try {
        savedUsers =
            (json.decode(allUsersJson) as List).cast<Map<String, dynamic>>();
      } catch (e) {
        // Error loading existing users
      }
    }

    savedUsers.add(newUser);
    await prefs.setString(_allUsersKey, json.encode(savedUsers));
  }

  static String _hashPassword(String password) {
    var bytes = utf8.encode('${password}gmgn_salt');
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static String _generateToken() {
    final random = Random();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(bytes);
  }

  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);
      final token = prefs.getString(_tokenKey);

      if (userData != null && token != null) {
        final userMap = json.decode(userData);
        return User.fromJson(userMap);
      }
    } catch (e) {
      // Error getting current user: $e
    }
    return null;
  }

  static Future<AuthResult> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000)); // 模拟网络延迟

      final hashedPassword = _hashPassword(password);
      final allUsers = await _getAllUsers();

      final user = allUsers.firstWhere(
        (u) => u['email'] == email && u['password'] == hashedPassword,
        orElse: () => {},
      );

      if (user.isEmpty) {
        return AuthResult.failure('Invalid email or password');
      }

      final token = _generateToken();
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_userKey, json.encode(user));
      await prefs.setString(_tokenKey, token);

      return AuthResult.success(User.fromJson(user));
    } catch (e) {
      return AuthResult.failure('Login failed: $e');
    }
  }

  static Future<AuthResult> register(
      String username, String email, String password) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1200)); // 模拟网络延迟

      // 检查邮箱是否已存在
      final allUsers = await _getAllUsers();
      final existingUser = allUsers.firstWhere(
        (u) => u['email'] == email,
        orElse: () => {},
      );

      if (existingUser.isNotEmpty) {
        return AuthResult.failure('Email already exists');
      }

      // 创建新用户
      final newUser = {
        'id': (Random().nextInt(9999) + 1000).toString(),
        'username': username,
        'email': email,
        'password': _hashPassword(password),
        'avatar': null,
        'created_at': DateTime.now().toIso8601String(),
        'is_verified': false,
        'preferences': {
          'enable_notifications': true,
          'enable_copy_trading': false,
          'default_currency': 'USD',
          'risk_tolerance': 0.5,
        }
      };

      // 保存新用户到本地存储
      await _saveNewUser(newUser);

      final token = _generateToken();
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_userKey, json.encode(newUser));
      await prefs.setString(_tokenKey, token);

      return AuthResult.success(User.fromJson(newUser));
    } catch (e) {
      return AuthResult.failure('Registration failed: $e');
    }
  }

  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
    } catch (e) {
      // Error during logout: $e
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      return token != null;
    } catch (e) {
      return false;
    }
  }

  static Future<AuthResult> updateProfile(User user) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(user.toJson()));

      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure('Update failed: $e');
    }
  }
}

class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? error;

  AuthResult._(this.isSuccess, this.user, this.error);

  factory AuthResult.success(User user) => AuthResult._(true, user, null);
  factory AuthResult.failure(String error) => AuthResult._(false, null, error);
}
