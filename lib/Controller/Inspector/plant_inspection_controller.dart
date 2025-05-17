import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlantInspectionController extends GetxController {
  // Observable variables for reactive state
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  // Dashboard data
  final dashboardData = Rxn<Map<String, dynamic>>();

  // Inspections data
  final todaysInspections = Rxn<Map<String, dynamic>>();
  final activeAlerts = Rxn<Map<String, dynamic>>();
  final todaysTickets = Rxn<Map<String, dynamic>>();
  final pendingTickets = <Map<String, dynamic>>[].obs;
  final inspectionItems = <Map<String, dynamic>>[].obs;

  // Tab selection
  final selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize data when controller is created
    fetchDashboardData();
  }

  @override
  void onReady() {
    super.onReady();
    // Additional initialization after the widget is rendered
    fetchInspectionItems();
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }

  // Fetch main dashboard data
  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      // Mock API call
      await Future.delayed(const Duration(seconds: 1));

      // Store response directly as Map (no model conversion)
      final response = {
        'todaysInspections': {
          'count': 10,
          'status': {
            'complete': 10,
            'cleaning': 90,
            'pending': 40
          },
          'statusColors': {
            'complete': Colors.blue,
            'cleaning': Colors.orange,
            'pending': Colors.pink
          }
        },
        'activeAlerts': {
          'count': 32,
          'status': {
            'priority': 45,
            'medium': 30,
            'minor': 25
          }
        },
        'todaysTickets': {
          'open': 24,
          'openPercentage': 57,
          'closed': 18,
          'closedPercentage': 43,
          'ticketsByPriority': {
            'high': [12, 10, 8, 11],
            'medium': [6, 8, 9, 7]
          }
        },
        'ticketCategories': {
          'percentages': [25, 35, 25, 15]
        }
      };

      dashboardData.value = response;
      todaysInspections.value = response['todaysInspections'];
      activeAlerts.value = response['activeAlerts'];
      todaysTickets.value = response['todaysTickets'];

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load dashboard data');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch inspection items
  Future<void> fetchInspectionItems() async {
    try {
      isLoading.value = true;

      // Mock API call
      await Future.delayed(const Duration(seconds: 1));

      // Sample inspection items
      final items = [
        {
          'plantName': 'Abc Plant',
          'location': 'XYZ-1, Pune Maharashtra(12345)',
          'progress': 1.0,
          'status': 'completed',
          'color': 0xFFFF5252,
        },
        {
          'plantName': 'Abc Plant',
          'location': 'XYZ-1, Pune Maharashtra(12345)',
          'progress': 0.7,
          'status': 'in_progress',
          'color': 0xFFFF5252,
        },
        {
          'plantName': 'Abc Plant',
          'location': 'XYZ-1, Pune Maharashtra(12345)',
          'progress': 0.3,
          'eta': '30m',
          'status': 'pending',
          'color': 0xFFFFC107,
        },
      ];

      inspectionItems.value = items;

      // Sample pending tickets
      final tickets = [
        {
          'id': 'T001',
          'title': 'Machine Maintenance',
          'priority': 'high',
          'status': 'pending'
        },
        {
          'id': 'T002',
          'title': 'Safety Check',
          'priority': 'medium',
          'status': 'pending'
        }
      ];

      pendingTickets.value = tickets;

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load inspection items');
    } finally {
      isLoading.value = false;
    }
  }

  // Change tab
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  // Navigate to inspection details
  void navigateToInspectionDetails(int index) {
    Get.toNamed('/inspection-details', arguments: inspectionItems[index]);
  }

  // Refresh dashboard data
  Future<void> refreshDashboard() async {
    await fetchDashboardData();
    await fetchInspectionItems();
    Get.snackbar('Success', 'Dashboard refreshed successfully');
  }
}