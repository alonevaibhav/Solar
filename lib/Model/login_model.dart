
import 'package:shared_preferences/shared_preferences.dart';
/// Login request model
class LoginModel {
  final String username; // Changed from email to username
  final String password;
  final String role;

  const LoginModel({
    required this.username, // Changed from email to username
    required this.password,
    required this.role,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      username: json['username'] ?? '', // Changed from email to username
      password: json['password'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username, // Changed from email to username
      'password': password,
      'role': role,
    };
  }

  LoginModel copyWith({
    String? username, // Changed from email to username
    String? password,
    String? role,
  }) {
    return LoginModel(
      username: username ?? this.username, // Changed from email to username
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  static LoginModel empty() {
    return const LoginModel(
      username: '', // Changed from email to username
      password: '',
      role: '',
    );
  }
}


/// API Response model matching your API structure
class LoginApiResponse {
  final String message;
  final bool success;
  final LoginData? data;
  final List<String> errors;

  const LoginApiResponse({
    required this.message,
    required this.success,
    this.data,
    required this.errors,
  });

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) {
    return LoginApiResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
      errors: List<String>.from(json['errors'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
      'data': data?.toJson(),
      'errors': errors,
    };
  }
}

/// Login data model containing token and role
class LoginData {
  final String token;
  final String role;
  final String uid;
  final String? expirationTime; // Optional expiration time

  const LoginData({
    required this.token,
    required this.role,
    required this.uid,
    this.expirationTime, // Optional expiration time
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'] ?? '',
      role: json['role'] ?? '',
      uid: json['uid'] ?? '',
      expirationTime: json['expirationTime'], // Optional expiration time
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'role': role,
      'expirationTime': expirationTime, // Optional expiration time
    };
  }
}


/// User model for authenticated user with role
class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? token;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.token,
  });

  /// Creates a UserModel from JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: UserRole.fromString(json['role'] ?? 'user'),
      token: json['token'],
    );
  }

  /// Converts the UserModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'token': token,
    };
  }
}

/// Enum for user roles
enum UserRole {
  cleaner,
  inspector, user;

  /// Creates UserRole from string value
  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'cleaner':
        return UserRole.cleaner;
      case 'inspector':
        return UserRole.inspector;
      default:
        return UserRole.cleaner;

    }
  }

  /// Get display name for role
  String get displayName {
    switch (this) {
      case UserRole.cleaner:
        return 'Cleaner';
      case UserRole.inspector:
        return 'Inspector';
      case UserRole.user:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}

/// Response model for login API call (keeping for backward compatibility)
class LoginResponse {
  final bool success;
  final String? message;
  final UserModel? user;

  const LoginResponse({
    required this.success,
    this.message,
    this.user,
  });

  /// Creates a LoginResponse from JSON data
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  /// Converts the LoginResponse to JSON data
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user?.toJson(),
    };
  }
}

/// Utility class for handling user session
class UserSession {
  static const String _tokenKey = 'user_token';
  static const String _roleKey = 'user_role';
  static const String _emailKey = 'user_email';

  /// Save user session data
  static Future<void> saveSession({
    required String token,
    required String role,
    String? email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_roleKey, role);
    if (email != null) {
      await prefs.setString(_emailKey, email);
    }
  }

  /// Get saved token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Get saved role
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  /// Get saved email
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all session data
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_emailKey);
  }

  /// Get user role as enum
  static Future<UserRole?> getUserRole() async {
    final role = await getRole();
    if (role != null) {
      return UserRole.fromString(role);
    }
    return null;
  }
}