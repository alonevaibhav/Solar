//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../API Service/api_service.dart';
// import '../../Model/Inspector/all_inspection_model.dart';
//
// class PlantInspectionController extends GetxController {
//   final isLoading = false.obs;
//   final errorMessage = Rxn<String>();
//   final dashboardData = Rxn<Map<String, dynamic>>();
//   final todaysInspections = Rxn<Map<String, dynamic>>();
//   final activeAlerts = Rxn<Map<String, dynamic>>();
//   final todaysTickets = Rxn<Map<String, dynamic>>();
//   final allInspection = <Map<String, dynamic>>[].obs;
//   final filteredInspections = <Map<String, dynamic>>[].obs;
//   final inspectionItems = <Map<String, dynamic>>[].obs;
//   final selectedTabIndex = 0.obs;
//   final selectedWeekFilter = Rxn<String>();
//   final originalInspections = <Map<String, dynamic>>[];
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchDashboardData();
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//     fetchInspectionItems();
//     fetchAllInspections();
//   }
//
//   Future<void> fetchDashboardData() async {
//     try {
//       isLoading.value = true;
//       await Future.delayed(const Duration(seconds: 1));
//
//       final response = {
//         'todaysInspections': {
//           'count': 10,
//           'status': {'complete': 10, 'cleaning': 90, 'pending': 40},
//           'statusColors': {
//             'complete': Colors.blue,
//             'cleaning': Colors.orange,
//             'pending': Colors.pink
//           }
//         },
//         'activeAlerts': {
//           'count': 32,
//           'status': {'priority': 45, 'medium': 30, 'minor': 25}
//         },
//         'todaysTickets': {
//           'open': 24,
//           'openPercentage': 57,
//           'closed': 18,
//           'closedPercentage': 43,
//           'ticketsByPriority': {
//             'high': [12, 10, 8, 11],
//             'medium': [6, 8, 9, 7]
//           }
//         },
//         'ticketCategories': {
//           'percentages': [25, 35, 25, 15]
//         }
//       };
//
//       dashboardData.value = response;
//       todaysInspections.value = response['todaysInspections'];
//       activeAlerts.value = response['activeAlerts'];
//       todaysTickets.value = response['todaysTickets'];
//     } catch (e) {
//       errorMessage.value = e.toString();
//       Get.snackbar('Error', 'Failed to load dashboard data');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> fetchInspectionItems() async {
//     try {
//       isLoading.value = true;
//       await Future.delayed(const Duration(seconds: 1));
//
//       final items = [
//         {
//           'plantName': 'Momo Plant',
//           'location': 'XYZ-1, Pune Maharashtra(12345)',
//           'progress': 1.0,
//           'status': 'completed',
//           'color': 0xFFFF5252,
//         },
//         {
//           'plantName': 'Abc Plant',
//           'location': 'XYZ-1, Pune Maharashtra(12345)',
//           'progress': 0.7,
//           'status': 'in_progress',
//           'color': 0xFFFF5252,
//         },
//         {
//           'plantName': 'Abc Plant',
//           'location': 'XYZ-1, Pune Maharashtra(12345)',
//           'progress': 0.3,
//           'eta': '30m',
//           'status': 'pending',
//           'color': 0xFFFFC107,
//         },
//       ];
//
//       inspectionItems.value = items;
//
//       final tickets = [
//         {
//           'id': 'T001',
//           'title': 'Machine Maintenance',
//           'priority': 'high',
//           'status': 'pending'
//         },
//         {
//           'id': 'T002',
//           'title': 'Safety Check',
//           'priority': 'medium',
//           'status': 'pending'
//         }
//       ];
//
//       allInspection.value = tickets;
//     } catch (e) {
//       errorMessage.value = e.toString();
//       Get.snackbar('Error', 'Failed to load inspection items');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> fetchAllInspections() async {
//     try {
//       isLoading.value = true;
//
//       final storedUid = await ApiService.getUid();
//       if (storedUid == null) {
//         throw Exception('User ID not found');
//       }
//
//       final response = await ApiService.get<InspectionResponse>(
//         endpoint: '/schedules/inspector-schedules/inspector/$storedUid/weekly',
//         fromJson: (json) => InspectionResponse.fromJson(json),
//       );
//
//       if (response.success && response.data != null) {
//         final data = response.data!.data;
//
//         List<Map<String, dynamic>> flattenedInspections = [];
//
//         // FIXED: Remove .take(3) to get ALL inspections from each week
//         if (data.containsKey('Week 1')) {
//           flattenedInspections.addAll(
//             data['Week 1']!.map((inspection) => inspection.toJson()),
//           );
//         }
//
//         if (data.containsKey('Week 2')) {
//           flattenedInspections.addAll(
//             data['Week 2']!.map((inspection) => inspection.toJson()),
//           );
//         }
//
//         // If you have more weeks, add them here
//         if (data.containsKey('Week 3')) {
//           flattenedInspections.addAll(
//             data['Week 3']!.map((inspection) => inspection.toJson()),
//           );
//         }
//
//         if (data.containsKey('Week 4')) {
//           flattenedInspections.addAll(
//             data['Week 4']!.map((inspection) => inspection.toJson()),
//           );
//         }
//
//         // Alternative approach: Dynamically handle all weeks
//         // data.forEach((weekKey, weekInspections) {
//         //   flattenedInspections.addAll(
//         //     weekInspections.map((inspection) => inspection.toJson()),
//         //   );
//         // });
//
//         originalInspections.clear();
//         originalInspections.addAll(flattenedInspections);
//
//         allInspection.value = flattenedInspections;
//         filteredInspections.value = flattenedInspections;
//
//         print('Total inspections loaded: ${flattenedInspections.length}');
//         print('Week 1 count: ${data['Week 1']?.length ?? 0}');
//         print('Week 2 count: ${data['Week 2']?.length ?? 0}');
//       } else {
//         throw Exception(response.errorMessage ?? 'Failed to load inspection items');
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       Get.snackbar('Error', 'Failed to load inspection items');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void filterByWeek(String? week) {
//     selectedWeekFilter.value = week;
//
//     if (week == null) {
//       filteredInspections.value = List.from(originalInspections);
//       allInspection.value = List.from(originalInspections);
//     } else {
//       final filtered = originalInspections.where((inspection) =>
//       inspection['week'].toString() == week).toList();
//
//       filteredInspections.value = filtered;
//       allInspection.value = filtered;
//     }
//   }
//
//   String get currentFilterText {
//     return selectedWeekFilter.value == null ? 'All Weeks' : 'Week ${selectedWeekFilter.value}';
//   }
//
//   bool isWeekFilterActive(String week) {
//     return selectedWeekFilter.value == week;
//   }
//
//   bool get isAllFilterActive {
//     return selectedWeekFilter.value == null;
//   }
//
//   void changeTab(int index) {
//     selectedTabIndex.value = index;
//   }
//
//   void navigateToInspectionDetails(int index) {
//     Get.toNamed('/inspection-details', arguments: inspectionItems[index]);
//   }
//
//   Future<void> refreshDashboard() async {
//     await fetchDashboardData();
//     await fetchInspectionItems();
//     await fetchAllInspections();
//     Get.snackbar('Success', 'Dashboard refreshed successfully');
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'all_inspection_controller.dart';

class PlantInspectionController extends GetxController {
  final AllInspectionsController allInspectionsController = Get.put(AllInspectionsController());

  final isLoadingDashboard = false.obs;
  final errorMessageDashboard = Rxn<String>();
  final dashboardData = Rxn<Map<String, dynamic>>();
  final todaysInspections = Rxn<Map<String, dynamic>>();
  final activeAlerts = Rxn<Map<String, dynamic>>();
  final todaysTickets = Rxn<Map<String, dynamic>>();
  final inspectionItems = <Map<String, dynamic>>[].obs;
  final selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  @override
  void onReady() {
    super.onReady();
    fetchInspectionItems();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoadingDashboard.value = true;
      await Future.delayed(const Duration(seconds: 1));

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
      errorMessageDashboard.value = e.toString();
      Get.snackbar('Error', 'Failed to load dashboard data');
    } finally {
      isLoadingDashboard.value = false;
    }
  }

  Future<void> fetchInspectionItems() async {
    try {
      isLoadingDashboard.value = true;
      await Future.delayed(const Duration(seconds: 1));

      final items = [
        {
          'plantName': 'Momo Plant',
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
    } catch (e) {
      Get.snackbar('Error', 'Failed to load inspection items');
    } finally {
      isLoadingDashboard.value = false;
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void navigateToInspectionDetails(int index) {
    if (index >= 0 && index < inspectionItems.length) {
      Get.toNamed('/inspection-details', arguments: inspectionItems[index]);
    } else {
      Get.snackbar('Error', 'Invalid inspection item selected');
    }
  }

  Future<void> refreshDashboard() async {
    await fetchDashboardData();
    await fetchInspectionItems();
    await allInspectionsController.fetchAllInspections();
    Get.snackbar('Success', 'Dashboard refreshed successfully');
  }
}
