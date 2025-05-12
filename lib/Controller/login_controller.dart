import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/login_model.dart';
import '../Route Manager/app_routes.dart';

class LoginController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable states
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var errorMessage = ''.obs;

  // Reactive form data
  var loginModel = LoginModel.empty().obs;

  @override
  void onInit() {
    super.onInit();

    // Add listeners to update loginModel when fields change
    emailController.addListener(() {
      updateLoginModel();
    });

    passwordController.addListener(() {
      updateLoginModel();
    });
  }

  @override
  void onClose() {
    // Dispose controllers
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Updates the login model with current field values
  void updateLoginModel() {
    loginModel.value = LoginModel(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Validates email format
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  /// Validates password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Handles form submission
  Future<void> login() async {
    try {
      // Clear previous error messages
      errorMessage.value = '';

      // Validate form
      if (!formKey.currentState!.validate()) {
        return;
      }

      // Set loading state
      isLoading.value = true;

      // TODO: Replace with actual API implementation
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful response with role determination
      final mockResponse = _mockLogin(loginModel.value);

      if (mockResponse.success && mockResponse.user != null) {
        // Success handling
        Get.snackbar(
          'Success',
          'Welcome back!',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 2),
        );

        // Navigate based on user role
        _navigateByRole(mockResponse.user!.role);
      } else {
        // Handle login failure
        throw Exception(mockResponse.message ?? 'Login failed');
      }
    } catch (e) {
      // Error handling
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate user based on their role
  void _navigateByRole(UserRole role) {
    switch (role) {
      case UserRole.user:
        Get.offAllNamed(AppRoutes.user);
        break;
      case UserRole.cleaner:
        Get.offAllNamed(AppRoutes.cleaner);
        break;
      case UserRole.inspector:
        Get.offAllNamed(AppRoutes.inspector);
        break;
    }
  }

  /// Mock login implementation for testing
  LoginResponse _mockLogin(LoginModel credentials) {
    // Predefined dummy accounts for each role
    final Map<String, Map<String, dynamic>> dummyAccounts = {
      // User accounts
      'user@test.com': {
        'password': 'password123',
        'role': UserRole.user,
        'name': 'John Doe',
        'id': 'user_001',
      },
      'user1@test.com': {
        'password': 'user123456',
        'role': UserRole.user,
        'name': 'Jane Smith',
        'id': 'user_002',
      },
      // Cleaner accounts
      'cleaner@test.com': {
        'password': 'clean123456',
        'role': UserRole.cleaner,
        'name': 'Mike Johnson',
        'id': 'cleaner_001',
      },
      'cleaner1@test.com': {
        'password': 'cleaner123',
        'role': UserRole.cleaner,
        'name': 'Sarah Wilson',
        'id': 'cleaner_002',
      },
      // Inspector accounts
      'inspector@test.com': {
        'password': 'inspect123',
        'role': UserRole.inspector,
        'name': 'David Brown',
        'id': 'inspector_001',
      },
      'inspector1@test.com': {
        'password': 'inspector123',
        'role': UserRole.inspector,
        'name': 'Lisa Garcia',
        'id': 'inspector_002',
      },
    };

    // Check if email exists in dummy accounts
    final account = dummyAccounts[credentials.email.toLowerCase()];

    if (account == null) {
      return const LoginResponse(
        success: false,
        message: 'Email not found. Please use one of the provided test accounts.',
      );
    }

    // Check password
    if (account['password'] != credentials.password) {
      return const LoginResponse(
        success: false,
        message: 'Invalid password. Please check your credentials.',
      );
    }

    // Successful login
    return LoginResponse(
      success: true,
      message: 'Login successful',
      user: UserModel(
        id: account['id'],
        email: credentials.email,
        name: account['name'],
        role: account['role'],
        token: 'mock_jwt_token_${account['id']}',
      ),
    );
  }

  /// Clears all form fields
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    errorMessage.value = '';
  }
}

extension LoginModelExtension on LoginModel {
  static LoginModel empty() => const LoginModel(
    email: '',
    password: '',
  );
}