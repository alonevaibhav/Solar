class LoginModel {
  final String email;
  final String password;

  const LoginModel({
    required this.email,
    required this.password,
  });

  /// Creates a LoginModel from JSON data
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  /// Converts the LoginModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  /// Creates a copy of the LoginModel with updated values
  LoginModel copyWith({
    String? email,
    String? password,
  }) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }


  // Add this method:
  static LoginModel empty() {
    return const LoginModel(
      email: '',
      password: '',
    );
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
  user,
  cleaner,
  inspector;

  /// Creates UserRole from string value
  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'cleaner':
        return UserRole.cleaner;
      case 'inspector':
        return UserRole.inspector;
      default:
        return UserRole.user;
    }
  }
}

/// Response model for login API call
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