
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
  final allInspection = <Map<String, dynamic>>[].obs;
  final filteredInspections = <Map<String, dynamic>>[].obs;
  final inspectionItems = <Map<String, dynamic>>[].obs;

  // Tab selection
  final selectedTabIndex = 0.obs;

  // Week filter
  final selectedWeekFilter = Rxn<String>(); // null means show all, "1" or "2" for specific weeks
  final originalInspections = <Map<String, dynamic>>[]; // Store original data

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
    fetchAllInspections(); // Add this to fetch all inspections
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
          'status': {'complete': 10, 'cleaning': 90, 'pending': 40},
          'statusColors': {
            'complete': Colors.blue,
            'cleaning': Colors.orange,
            'pending': Colors.pink
          }
        },
        'activeAlerts': {
          'count': 32,
          'status': {'priority': 45, 'medium': 30, 'minor': 25}
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
          'plantName': 'momo Plant',
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

      allInspection.value = tickets;

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load inspection items');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch all inspections with new JSON structure
  Future<void> fetchAllInspections() async {
    try {
      isLoading.value = true;

      // Mock API delay
      await Future.delayed(const Duration(seconds: 1));

      // Sample API response matching your structure
      final response = {
        "message": "Inspector schedules retrieved and sorted by week successfully",
        "success": true,
        "data": {
          "Week 1": [
            {
              "id": 1,
              "plant_id": 25,
              "inspector_id": 8,
              "week": "1",
              "day": "mo",
              "time": "00:00:00",
              "isActive": 1,
              "assignedBy": 49,
              "schedule_date": "2023-10-09T18:30:00.000Z",
              "status": "scheduled",
              "notes": "Initial inspection"
            },
            {
              "id": 2,
              "plant_id": 25,
              "inspector_id": 8,
              "week": "1",
              "day": "mo",
              "time": "00:00:00",
              "isActive": 1,
              "assignedBy": 0,
              "schedule_date": "2023-10-09T18:30:00.000Z",
              "status": "scheduled",
              "notes": "Initial inspection"
            },
            {
              "id": 3,
              "plant_id": 25,
              "inspector_id": 8,
              "week": "1",
              "day": "mo",
              "time": "00:00:00",
              "isActive": 1,
              "assignedBy": 0,
              "schedule_date": "2023-10-09T18:30:00.000Z",
              "status": "scheduled",
              "notes": "Initial inspection"
            },
            {
              "id": 13,
              "plant_id": 48,
              "inspector_id": 8,
              "week": "1",
              "day": "mo",
              "time": "00:00:00",
              "isActive": 1,
              "assignedBy": 28,
              "schedule_date": "2025-05-26T18:30:00.000Z",
              "status": "cancelled",
              "notes": "na"
            },
            {
              "id": 14,
              "plant_id": 36,
              "inspector_id": 8,
              "week": "1",
              "day": "mo",
              "time": "00:00:00",
              "isActive": 1,
              "assignedBy": 28,
              "schedule_date": "2025-05-29T18:30:00.000Z",
              "status": "completed",
              "notes": "na"
            }
          ],
          "Week 2": [
            {
              "id": 8,
              "plant_id": 25,
              "inspector_id": 8,
              "week": "2",
              "day": "mo",
              "time": "00:00:00",
              "isActive": 1,
              "assignedBy": 28,
              "schedule_date": "2025-05-20T18:30:00.000Z",
              "status": "completed",
              "notes": "na"
            },
            {
              "id": 16,
              "plant_id": 36,
              "inspector_id": 8,
              "week": "2",
              "day": "mo",
              "time": "00:00:00",
              "isActive": 1,
              "assignedBy": 28,
              "schedule_date": "2025-05-21T18:30:00.000Z",
              "status": "completed",
              "notes": "na"
            },
            {
              "id": 17,
              "plant_id": 49,
              "inspector_id": 8,
              "week": "2",
              "day": "mo",
              "time": "00:00:00",
              "isActive": 1,
              "assignedBy": 28,
              "schedule_date": "2025-05-30T18:30:00.000Z",
              "status": "completed",
              "notes": "nnnnnn"
            },
            {
              "id": 22,
              "plant_id": 36,
              "inspector_id": 8,
              "week": "2",
              "day": "mo",
              "time": "00:00:00",
              "isActive": 1,
              "assignedBy": 28,
              "schedule_date": "2025-05-30T18:30:00.000Z",
              "status": "completed",
              "notes": "na"
            }
          ]
        },
        "errors": []
      };

      final data = response['data'] as Map<String, dynamic>;

      List<Map<String, dynamic>> flattenedInspections = [];

      // Add 3 from Week 1
      if (data.containsKey('Week 1')) {
        flattenedInspections.addAll(
          (data['Week 1'] as List).cast<Map<String, dynamic>>().take(3),
        );
      }

      // Add 3 from Week 2
      if (data.containsKey('Week 2')) {
        flattenedInspections.addAll(
          (data['Week 2'] as List).cast<Map<String, dynamic>>().take(3),
        );
      }

      // Store original data
      originalInspections.clear();
      originalInspections.addAll(flattenedInspections);

      // Update state
      allInspection.value = flattenedInspections;
      filteredInspections.value = flattenedInspections;

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load inspection items');
    } finally {
      isLoading.value = false;
    }
  }


  // Filter inspections by week
  void filterByWeek(String? week) {
    selectedWeekFilter.value = week;

    if (week == null) {
      // Show all inspections
      filteredInspections.value = List.from(originalInspections);
      allInspection.value = List.from(originalInspections);
    } else {
      // Filter by specific week
      final filtered = originalInspections.where((inspection) =>
      inspection['week'].toString() == week
      ).toList();

      filteredInspections.value = filtered;
      allInspection.value = filtered;
    }
  }

  // Get current filter display text
  String get currentFilterText {
    if (selectedWeekFilter.value == null) {
      return 'All Weeks';
    } else {
      return 'Week ${selectedWeekFilter.value}';
    }
  }

  // Check if specific week filter is active
  bool isWeekFilterActive(String week) {
    return selectedWeekFilter.value == week;
  }

  // Check if "All" filter is active
  bool get isAllFilterActive {
    return selectedWeekFilter.value == null;
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
    await fetchAllInspections();
    Get.snackbar('Success', 'Dashboard refreshed successfully');
  }
}