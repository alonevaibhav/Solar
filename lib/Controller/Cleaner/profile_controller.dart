import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_app/Route%20Manager/app_routes.dart';

class ProfileController extends GetxController {
  // User information
  final RxString userName = 'Ravi Sharma'.obs;
  final RxString userPhone = '9876543210'.obs;
  final RxString userAddress = 'Rajnagar, Punjab'.obs;

  // Theme state
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  @override
  void onReady() {
    super.onReady();
    // Additional initialization if needed
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }

  // Load user profile data from storage or API
  void loadUserProfile() async {
    try {
      // TODO: Replace with actual API or storage implementation
      await Future.delayed(const Duration(milliseconds: 300));

      // Mock data loading (in a real app, this would come from API or local storage)
      userName.value = 'Ravi Sharma';
      userPhone.value = '9876543210';
      userAddress.value = 'Rajnagar, Punjab';
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile information',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Edit profile action
  void editProfile() {
    // Navigate to edit profile screen
    Get.toNamed(AppRoutes.cleanerUpdateProfile);
  }

  // Navigate to assigned plants screen
  void goToAssignedPlants() {
    Get.toNamed(AppRoutes.cleanerAssignPlant);
  }

  // Navigate to help and support screen
  void goToHelpAndSupport() {
    Get.toNamed(AppRoutes.cleanerHelp);
  }

  // Navigate to cleanup history screen
  void goToCleanupHistory() {
    Get.toNamed(AppRoutes.cleanerCleanupHistory);
  }

  // Toggle theme function
  void toggleTheme(bool value) {
    isDarkMode.value = value;

    // Implement theme change logic - this would depend on your theme implementation
    if (value) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }
  }

  // Logout function
  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement actual logout logic
              Get.back();
              Get.offAllNamed('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  // Delete account function
  void showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement actual account deletion logic
              Get.back();

              // Show loading dialog
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(),
                ),
                barrierDismissible: false,
              );

              // Simulate API call
              Future.delayed(const Duration(seconds: 2), () {
                Get.back(); // Close loading dialog
                Get.offAllNamed('/login');
                Get.snackbar(
                  'Account Deleted',
                  'Your account has been successfully deleted',
                  snackPosition: SnackPosition.BOTTOM,
                );
              });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }





  // Navigate to home
  void goToHome() {
    Get.offAllNamed('/home');
  }
}