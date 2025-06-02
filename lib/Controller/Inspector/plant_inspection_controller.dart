
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../API Service/api_service.dart';
import '../../utils/constants.dart';
import 'all_inspection_controller.dart';

class PlantInspectionController extends GetxController {
  final AllInspectionsController allInspectionsController = Get.put(AllInspectionsController());

  final isLoadingDashboard = false.obs;
  final errorMessageDashboard = Rxn<String>();
  final dashboardData = Rxn<Map<String, dynamic>>();
  final todaysInspections = Rxn<Map<String, dynamic>>();
  final inspectionItems = <Map<String, dynamic>>[].obs;
  final selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInspectionItems();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void _calculateDashboardStats() {
    if (inspectionItems.isEmpty) {
      todaysInspections.value = {
        'count': 0,
        'status': {
          'complete': 0,
          'pending': 0
        },
      };
      dashboardData.value = {
        'todaysInspections': todaysInspections.value,
      };
      return;
    }

    int completedCount = 0;
    int pendingCount = 0;

    for (var item in inspectionItems) {
      String status = item['status']?.toString().toLowerCase() ?? '';
      switch (status) {
        case 'completed':
          completedCount++;
          break;
        case 'pending':
          pendingCount++;
          break;
      }
    }

    todaysInspections.value = {
      'count': inspectionItems.length,
      'status': {
        'complete': completedCount,
        'pending': pendingCount,
      },
    };

    dashboardData.value = {
      'todaysInspections': todaysInspections.value,
    };
  }

  Future<void> fetchInspectionItems() async {
    try {
      isLoadingDashboard.value = true;

      // Fetch the UID from SharedPreferences
      String? uid = await ApiService.getUid();

      if (uid == null) {
        errorMessageDashboard.value = 'User ID not found';
        return;
      }

      // Make the API call to fetch inspection items
      final response = await ApiService.get<Map<String, dynamic>>(
        endpoint: getTodaySchedule(int.parse(uid)),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final data = response.data!['data'] as List<dynamic>;
        inspectionItems.value = data.map((item) => Map<String, dynamic>.from(item as Map)).toList();

        // Calculate dashboard statistics after fetching inspection items
        _calculateDashboardStats();
      } else {
        errorMessageDashboard.value = response.errorMessage ?? 'Failed to load inspection items';
      }
    } catch (e) {
      errorMessageDashboard.value = 'Failed to load inspection items: $e';
      Get.snackbar('Error', 'Failed to load inspection items');
    } finally {
      isLoadingDashboard.value = false;
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void navigateToInspectionDetails(Map<String, dynamic> item) {
    Get.toNamed('/inspection-details', arguments: item);
  }

  Future<void> refreshDashboard() async {
    await fetchInspectionItems();
    await allInspectionsController.fetchAllInspections();
    Get.snackbar('Success', 'Dashboard refreshed successfully');
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF48BB78); // Professional green
      case 'pending':
        return const Color(0xFFA0AEC0); // Professional grey
      default:
        return const Color(0xFFA0AEC0); // Light grey
    }
  }

  String getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }
}
