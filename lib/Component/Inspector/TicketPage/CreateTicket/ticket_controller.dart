import 'package:get/get.dart';
import 'package:flutter/material.dart';

// Extension method for string capitalization
extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

class TicketRaisingController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Observable variables for form state
  final selectedTicketType = Rxn<String>();
  final selectedPriority = Rxn<String>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Observable for ticket data
  final ticketData = Rxn<Map<String, dynamic>>();

  // Dropdown options
  final List<String> ticketTypes = ['software', 'hardware', 'accounts'];

  final List<String> priorities = [
    '1', // Critical
    '2', // High
    '3', // Medium
    '4', // Low
    '5' // Very Low
  ];

  // Priority labels for better UX
  final Map<String, String> priorityLabels = {
    '1': 'Critical',
    '2': 'High',
    '3': 'Medium',
    '4': 'Low',
    '5': 'Very Low'
  };

  // Ticket type labels for better UX
  final Map<String, String> ticketTypeLabels = {
    'software': 'Software Issue',
    'hardware': 'Hardware Issue',
    'accounts': 'Account Related'
  };

  @override
  void onInit() {
    super.onInit();
    // Initialize with default medium priority
    selectedPriority.value = '3';
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Validation methods
  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ticket title is required';
    }
    if (value.trim().length < 5) {
      return 'Title must be at least 5 characters long';
    }
    if (value.trim().length > 100) {
      return 'Title must not exceed 100 characters';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters long';
    }
    if (value.trim().length > 1000) {
      return 'Description must not exceed 1000 characters';
    }
    return null;
  }

  String? validateTicketType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a ticket type';
    }
    return null;
  }

  String? validatePriority(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select priority level';
    }
    return null;
  }

  // Get priority label with color coding info
  String getPriorityLabel(String priority) {
    // return '${priorityLabels[priority]} ($priority)';
    return '${priorityLabels[priority]} ';
  }

  // Get ticket type label
  String getTicketTypeLabel(String type) {
    return ticketTypeLabels[type] ?? type;
  }

  // Clear form
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    selectedTicketType.value = null;
    selectedPriority.value = '3'; // Reset to medium
    errorMessage.value = '';
    ticketData.value = null;
  }

  // Submit ticket
  Future<void> submitTicket() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields correctly',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful response
      final response = <String, Object?>{
        'id': DateTime.now().millisecondsSinceEpoch, // Mock ID
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'created_by': 101, // Mock user ID (would come from auth)
        'creator_type': 'inspector',
        'ticket_type': selectedTicketType.value,
        'status': 'open',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'priority': selectedPriority.value,
        'assigned_to': null,
      };

      // Store response
      ticketData.value = response;

      // Show success message
      Get.snackbar(
        'Success',
        'Ticket #${response['id']} has been created successfully',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        icon: const Icon(Icons.check_circle_outline, color: Colors.green),
        duration: const Duration(seconds: 3),
      );

      // Navigate back or to tickets list
      Get.back(result: response);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to create ticket. Please try again.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
