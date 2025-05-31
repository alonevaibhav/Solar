// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'all_inspection_controller.dart';
//
// class PlantInspectionController extends GetxController {
//   final AllInspectionsController allInspectionsController = Get.put(AllInspectionsController());
//
//   final isLoadingDashboard = false.obs;
//   final errorMessageDashboard = Rxn();
//   final dashboardData = Rxn<Map<String, dynamic>>();
//   final todaysInspections = Rxn<Map<String, dynamic>>();
//   final inspectionItems = <Map<String, dynamic>>[].obs;
//   final selectedTabIndex = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchInspectionItems();
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//   }
//
//   // Calculate dashboard statistics from inspection items
//   void _calculateDashboardStats() {
//     if (inspectionItems.isEmpty) {
//       todaysInspections.value = {
//         'count': 0,
//         'status': {
//           'complete': 0,
//           'pending': 0
//         },
//       };
//       dashboardData.value = {
//         'todaysInspections': todaysInspections.value,
//       };
//       return;
//     }
//
//     // Count inspections by status
//     int completedCount = 0;
//     int pendingCount = 0;
//
//     for (var item in inspectionItems) {
//       String status = item['status']?.toString().toLowerCase() ?? '';
//       switch (status) {
//         case 'completed':
//           completedCount++;
//           break;
//         case 'pending':
//           pendingCount++;
//           break;
//       }
//     }
//
//     // Update dashboard data
//     todaysInspections.value = {
//       'count': inspectionItems.length,
//       'status': {
//         'complete': completedCount,
//         'pending': pendingCount,
//       },
//     };
//
//     dashboardData.value = {
//       'todaysInspections': todaysInspections.value,
//     };
//   }
//
//   Future<void> fetchInspectionItems() async {
//     try {
//       isLoadingDashboard.value = true;
//       await Future.delayed(const Duration(seconds: 1));
//
//       // Updated API data with only completed and pending statuses
//       final apiResponse = {
//         "message": "Today's schedules retrieved successfully",
//         "success": true,
//         "data": [
//           {
//             "id": 25,
//             "plant_id": 25,
//             "inspector_id": 8,
//             "week": "1",
//             "day": "fr",
//             "time": "09:00:00",
//             "isActive": 1,
//             "assignedBy": 28,
//             "schedule_date": "2025-05-29T18:30:00.000Z",
//             "status": "completed",
//             "notes": null,
//             "inspector_name": "John Doe",
//             "plant_name": "Sunflower Plant",
//             "plant_address": "123 Sunflower Street",
//             "plant_location": "Building A, Floor 1",
//             "total_panels": 10,
//             "capacity_w": 5.5,
//             "area_squrM": 200,
//             "latlng": null,
//             "plant_isActive": 0,
//             "plant_isDeleted": 0,
//             "cleaner_name": "Alice Smith",
//             "state_name": "Maharashtra",
//             "distributor_name": null,
//             "taluka_name": "Pune City",
//             "area_name": "Baner"
//           },
//           {
//             "id": 26,
//             "plant_id": 26,
//             "inspector_id": 9,
//             "week": "1",
//             "day": "sa",
//             "time": "10:30:00",
//             "isActive": 1,
//             "assignedBy": 28,
//             "schedule_date": "2025-05-30T18:30:00.000Z",
//             "status": "pending",
//             "notes": "Equipment check required",
//             "inspector_name": "Jane Smith",
//             "plant_name": "Rose Garden Plant",
//             "plant_address": "456 Rose Avenue",
//             "plant_location": "Building B, Floor 2",
//             "total_panels": 15,
//             "capacity_w": 8.2,
//             "area_squrM": 350,
//             "latlng": null,
//             "plant_isActive": 1,
//             "plant_isDeleted": 0,
//             "cleaner_name": "Bob Johnson",
//             "state_name": "Maharashtra",
//             "distributor_name": "Green Energy Co.",
//             "taluka_name": "Pune City",
//             "area_name": "Kothrud"
//           },
//           {
//             "id": 27,
//             "plant_id": 27,
//             "inspector_id": 10,
//             "week": "1",
//             "day": "su",
//             "time": "08:00:00",
//             "isActive": 1,
//             "assignedBy": 28,
//             "schedule_date": "2025-05-31T18:30:00.000Z",
//             "status": "pending",
//             "notes": null,
//             "inspector_name": "Mike Wilson",
//             "plant_name": "Lotus Power Plant",
//             "plant_address": "789 Lotus Street",
//             "plant_location": "Building C, Floor 3",
//             "total_panels": 20,
//             "capacity_w": 12.5,
//             "area_squrM": 500,
//             "latlng": null,
//             "plant_isActive": 1,
//             "plant_isDeleted": 0,
//             "cleaner_name": "Carol Davis",
//             "state_name": "Maharashtra",
//             "distributor_name": "Solar Solutions Ltd.",
//             "taluka_name": "Pune City",
//             "area_name": "Hinjewadi"
//           },
//           {
//             "id": 28,
//             "plant_id": 28,
//             "inspector_id": 11,
//             "week": "1",
//             "day": "mo",
//             "time": "11:00:00",
//             "isActive": 1,
//             "assignedBy": 28,
//             "schedule_date": "2025-06-01T18:30:00.000Z",
//             "status": "completed",
//             "notes": "Regular maintenance completed",
//             "inspector_name": "Sarah Johnson",
//             "plant_name": "Orchid Solar Farm",
//             "plant_address": "321 Green Valley Road",
//             "plant_location": "Building D, Ground Floor",
//             "total_panels": 25,
//             "capacity_w": 15.0,
//             "area_squrM": 600,
//             "latlng": null,
//             "plant_isActive": 1,
//             "plant_isDeleted": 0,
//             "cleaner_name": "David Brown",
//             "state_name": "Maharashtra",
//             "distributor_name": "Eco Power Systems",
//             "taluka_name": "Pune City",
//             "area_name": "Wakad"
//           }
//         ],
//         "errors": []
//       };
//
//       if (apiResponse['success'] == true && apiResponse['data'] != null) {
//         final data = apiResponse['data'] as List<dynamic>;
//         inspectionItems.value = data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
//
//         // Calculate dashboard statistics after fetching inspection items
//         _calculateDashboardStats();
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load inspection items');
//     } finally {
//       isLoadingDashboard.value = false;
//     }
//   }
//
//   void changeTab(int index) {
//     selectedTabIndex.value = index;
//   }
//
//   void navigateToInspectionDetails(Map<String, dynamic> item) {
//     Get.toNamed('/inspection-details', arguments: item);
//   }
//
//   Future<void> refreshDashboard() async {
//     await fetchInspectionItems();
//     await allInspectionsController.fetchAllInspections();
//     Get.snackbar('Success', 'Dashboard refreshed successfully');
//   }
//
//   Color getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return const Color(0xFF48BB78); // Professional green
//       case 'pending':
//         return const Color(0xFFA0AEC0); // Professional grey
//       default:
//         return const Color(0xFFA0AEC0); // Light grey
//     }
//   }
//
//   String getStatusDisplayText(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return 'Completed';
//       case 'pending':
//         return 'Pending';
//       default:
//         return 'Unknown';
//     }
//   }
// }
//
// // /------------------------------------------///



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
