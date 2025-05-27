// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../API Service/api_service.dart';
// import '../Model/login_model.dart';
// import '../Route Manager/app_routes.dart';
// import '../utils/constants.dart';
//
// class LoginController extends GetxController {
//   // Form key for validation
//   final formKey = GlobalKey<FormState>();
//
//   // Text editing controllers
//   final usernameController =
//       TextEditingController(); // Changed from emailController
//   final passwordController = TextEditingController();
//
//   // Observable states
//   var isLoading = false.obs;
//   var isPasswordVisible = false.obs;
//   var errorMessage = ''.obs;
//   var selectedRole = ''.obs;
//
//   // Reactive form data
//   var loginModel = LoginModel.empty().obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // Add listeners to update loginModel when fields change
//     usernameController.addListener(() {
//       // Changed from emailController
//       updateLoginModel();
//     });
//
//     passwordController.addListener(() {
//       updateLoginModel();
//     });
//   }
//
//   @override
//   void onClose() {
//     // Dispose controllers
//     usernameController.dispose(); // Changed from emailController
//     passwordController.dispose();
//     super.onClose();
//   }
//
//   /// Updates the login model with current field values
//   void updateLoginModel() {
//     loginModel.value = LoginModel(
//       username: usernameController.text, // Changed from email to username
//       password: passwordController.text,
//       role: selectedRole.value,
//     );
//   }
//
//   /// Set selected role
//   void setSelectedRole(String role) {
//     selectedRole.value = role;
//     updateLoginModel();
//   }
//
//   /// Toggle password visibility
//   void togglePasswordVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }
//
//   /// Validates username format
//   String? validateUsername(String? value) {
//     // Changed from validateEmail
//     if (value == null || value.isEmpty) {
//       return 'Username is required'; // Changed message
//     }
//
//     // Add any additional username validation logic if needed
//     return null;
//   }
//
//   /// Validates password
//   String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Password is required';
//     }
//
//     if (value.length < 6) {
//       return 'Password must be at least 6 characters';
//     }
//
//     return null;
//   }
//
//   /// Validates role selection
//   String? validateRole(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please select your role';
//     }
//     return null;
//   }
//
//   /// Handles form submission with real API integration
//   Future<void> login() async {
//     try {
//       // Clear previous error messages
//       errorMessage.value = '';
//
//       // Validate form
//       if (!formKey.currentState!.validate()) {
//         return;
//       }
//
//       // Set loading state
//       isLoading.value = true;
//
//       // Prepare API request body
//       final requestBody = {
//         'username': loginModel.value.username, // Changed from email to username
//         'password': loginModel.value.password,
//         'role': loginModel.value.role,
//       };
//
//       // Make API call
//       final response = await ApiService.post<LoginApiResponse>(
//         endpoint: loginUrl, // Adjust endpoint as per your API
//         body: requestBody,
//         fromJson: (json) => LoginApiResponse.fromJson(json),
//         includeToken: false, // No token needed for login
//       );
//
//       if (response.success && response.data != null) {
//         final loginResponse = response.data!;
//
//         if (loginResponse.success && loginResponse.data != null) {
//           // Save token and user data to SharedPreferences
//           await ApiService.setToken(loginResponse.data!.token);
//
//           // You can also save additional user data
//           await _saveUserData(loginResponse.data!);
//
//           // Success handling
//           Get.snackbar(
//             'Success',
//             loginResponse.message ?? 'Login successful!',
//             backgroundColor: Colors.green.withOpacity(0.1),
//             colorText: Colors.green,
//             duration: const Duration(seconds: 2),
//           );
//
//           // Navigate based on user role
//           _navigateByRole(UserRole.fromString(loginResponse.data!.role));
//         } else {
//           // Handle login failure from API response
//           throw Exception(loginResponse.message ?? 'Login failed');
//         }
//       } else {
//         // Handle API error
//         throw Exception(response.errorMessage ?? 'Login failed');
//       }
//     } catch (e) {
//       // Error handling
//       String errorMsg = e.toString().replaceAll('Exception: ', '');
//       errorMessage.value = errorMsg;
//       Get.snackbar(
//         'Error',
//         'Login failed: $errorMsg',
//         backgroundColor: Colors.red.withOpacity(0.1),
//         colorText: Colors.red,
//         duration: const Duration(seconds: 3),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Save additional user data to SharedPreferences
//   Future<void> _saveUserData(LoginData userData) async {
//     try {
//       // You can save additional user information here
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_role', userData.role);
//       await prefs.setString('user_token', userData.token);
//
//       // Add more user data as needed
//       // await prefs.setString('user_id', userData.id);
//       // await prefs.setString('user_email', userData.email);
//     } catch (e) {
//       print('Error saving user data: $e');
//     }
//   }
//
//   /// Navigate user based on their role
//   void _navigateByRole(UserRole role) {
//     switch (role) {
//       case UserRole.cleaner:
//         Get.offAllNamed(AppRoutes.cleaner);
//         break;
//       case UserRole.inspector:
//         Get.offAllNamed(AppRoutes.inspector);
//         break;
//       case UserRole.user:
//         // Handle user role or redirect to appropriate screen
//         Get.snackbar('Info', 'User role navigation not implemented yet');
//         break;
//     }
//   }
//
//   /// Clears all form fields
//   void clearForm() {
//     usernameController.clear(); // Changed from emailController
//     passwordController.clear();
//     selectedRole.value = '';
//     errorMessage.value = '';
//   }
//
//   /// Check if user is already logged in
//   Future<bool> isLoggedIn() async {
//     final token = ApiService.getToken();
//     return token != null && token.isNotEmpty;
//   }
//
//   /// Logout user and clear stored data
//   Future<void> logout() async {
//     try {
//       isLoading.value = true;
//
//       // Clear API service stored data
//       await ApiService.clearAuthData();
//
//       // Clear additional user data
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('user_role');
//
//       // Clear form
//       clearForm();
//
//       // Navigate to login screen
//       Get.offAllNamed(AppRoutes.login);
//
//       Get.snackbar(
//         'Success',
//         'Logged out successfully',
//         backgroundColor: Colors.green.withOpacity(0.1),
//         colorText: Colors.green,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Logout failed: ${e.toString()}',
//         backgroundColor: Colors.red.withOpacity(0.1),
//         colorText: Colors.red,
//         duration: const Duration(seconds: 3),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
//
// extension LoginModelExtension on LoginModel {
//   static LoginModel empty() => const LoginModel(
//         username: '', // Changed from email to username
//         password: '',
//         role: '',
//       );
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API Service/api_service.dart';
import '../Model/login_model.dart';
import '../Route Manager/app_routes.dart';
import '../View/Auth/token_manager.dart';
import '../utils/constants.dart';

class LoginController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  final usernameController = TextEditingController(); // Changed from emailController
  final passwordController = TextEditingController();

  // Observable states
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var errorMessage = ''.obs;
  var selectedRole = ''.obs;

  // Reactive form data
  var loginModel = LoginModel.empty().obs;

  @override
  void onInit() {
    super.onInit();

    // No need to check token expiration here since it's handled in main.dart
    // Just set up the form listeners
    usernameController.addListener(() {
      updateLoginModel();
    });

    passwordController.addListener(() {
      updateLoginModel();
    });
  }

  @override
  void onClose() {
    // Dispose controllers
    usernameController.dispose(); // Changed from emailController
    passwordController.dispose();
    TokenManager.stopTokenExpirationTimer();
    super.onClose();
  }

  /// Updates the login model with current field values
  void updateLoginModel() {
    loginModel.value = LoginModel(
      username: usernameController.text, // Changed from email to username
      password: passwordController.text,
      role: selectedRole.value,
    );
  }

  /// Set selected role
  void setSelectedRole(String role) {
    selectedRole.value = role;
    updateLoginModel();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Validates username format
  String? validateUsername(String? value) {
    // Changed from validateEmail
    if (value == null || value.isEmpty) {
      return 'Username is required'; // Changed message
    }

    // Add any additional username validation logic if needed
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

  /// Validates role selection
  String? validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your role';
    }
    return null;
  }

  /// Handles form submission with real API integration
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

      // Prepare API request body
      final requestBody = {
        'username': loginModel.value.username, // Changed from email to username
        'password': loginModel.value.password,
        'role': loginModel.value.role,
      };

      // Make API call
      final response = await ApiService.post<LoginApiResponse>(
        endpoint: loginUrl, // Adjust endpoint as per your API
        body: requestBody,
        fromJson: (json) => LoginApiResponse.fromJson(json),
        includeToken: false, // No token needed for login
      );

      if (response.success && response.data != null) {
        final loginResponse = response.data!;

        if (loginResponse.success && loginResponse.data != null) {
          // Save token and user data to SharedPreferences
          await ApiService.setToken(loginResponse.data!.token);

          // Save token and expiration time using TokenManager
          await TokenManager.saveToken(loginResponse.data!.token, expirationTime: loginResponse.data!.expirationTime);

          // You can also save additional user data
          await _saveUserData(loginResponse.data!);

          // Success handling
          Get.snackbar(
            'Success',
            loginResponse.message ?? 'Login successful!',
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
            duration: const Duration(seconds: 2),
          );

          // Navigate based on user role
          _navigateByRole(UserRole.fromString(loginResponse.data!.role));
        } else {
          // Handle login failure from API response
          throw Exception(loginResponse.message ?? 'Login failed');
        }
      } else {
        // Handle API error
        throw Exception(response.errorMessage ?? 'Login failed');
      }
    } catch (e) {
      // Error handling
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      errorMessage.value = errorMsg;
      Get.snackbar(
        'Error',
        'Login failed: $errorMsg',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Save additional user data to SharedPreferences
  Future<void> _saveUserData(LoginData userData) async {
    try {
      // You can save additional user information here
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', userData.role);
      await prefs.setString('user_token', userData.token);

      // Add more user data as needed
      // await prefs.setString('user_id', userData.id);
      // await prefs.setString('user_email', userData.email);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  /// Navigate user based on their role
  void _navigateByRole(UserRole role) {
    switch (role) {
      case UserRole.cleaner:
        Get.offAllNamed(AppRoutes.cleaner);
        break;
      case UserRole.inspector:
        Get.offAllNamed(AppRoutes.inspector);
        break;
      case UserRole.user:
      // Handle user role or redirect to appropriate screen
        Get.snackbar('Info', 'User role navigation not implemented yet');
        break;
    }
  }

  /// Clears all form fields
  void clearForm() {
    usernameController.clear(); // Changed from emailController
    passwordController.clear();
    selectedRole.value = '';
    errorMessage.value = '';
  }

  /// Check if user is already logged in
  Future<bool> isLoggedIn() async {
    final token = ApiService.getToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout user and clear stored data
  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Clear API service stored data
      await ApiService.clearAuthData();

      // Clear token and expiration time
      await TokenManager.clearToken();

      // Clear additional user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_role');

      // Clear form
      clearForm();

      // Navigate to login screen
      Get.offAllNamed(AppRoutes.login);

      Get.snackbar(
        'Success',
        'Logged out successfully',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}

extension LoginModelExtension on LoginModel {
  static LoginModel empty() => const LoginModel(
    username: '', // Changed from email to username
    password: '',
    role: '',
  );
}

