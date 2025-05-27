//
// import 'package:get/get.dart';
// import '../../Route Manager/app_routes.dart';
//
// class PlantInfoController extends GetxController {
//   // Observable lists and variables
//   final plants = <Map<String, dynamic>>[].obs;
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;
//   final selectedPlant = Rx<Map<String, dynamic>?>(null);
//   final plantDetails = Rx<Map<String, dynamic>?>(null);
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchPlants();
//   }
//
//   // Fetch all assigned plants
//   Future<void> fetchPlants() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       // Mock API call
//       await Future.delayed(Duration(seconds: 1));
//
//       // Single plant data from your JSON - using the complete data structure
//       plants.value = [
//         {
//           "id": 25,
//           "name": "Sunflower Plant",
//           "uuid": "unique-plant-id",
//           "user_id": 3,
//           "distributor_id": 49,
//           "distributor_admin_id": 28,
//           "inspector_id": 8,
//           "cleaner_id": 3,
//           "state_id": 15,
//           "dist_id": 28,
//           "taluka_id": 13,
//           "area_id": 4,
//           "address": "123 Sunflower Street",
//           "total_panels": 10,
//           "capacity_w": 5.5,
//           "area_squrM": 200,
//           "location": "Building A, Floor 1",
//           "latlng": null,
//           "isActive": 0,
//           "isDeleted": 0,
//           "createAt": "2025-05-21T12:31:13.000Z",
//           "UpdatedAt": null,
//           "installed_by": 16,
//           "under_maintenance": 0,
//           "info": "",
//           "inspector_name": "John Doe",
//           "cleaner_name": "Alice Smith",
//           "installed_by_name": "InstallerUser1",
//           "state_name": "Maharashtra",
//           "district_name": "Pune",
//           "taluka_name": "Pune City",
//           "area_name": "Baner",
//           // Additional fields for card display
//           "autoCleanTime": "08:00",
//           "isOnline": true,
//         }   ,
//         {
//           "id": 30,
//           "name": "Sunflower Plant",
//           "uuid": "unique-plant-id",
//           "user_id": 3,
//           "distributor_id": 49,
//           "distributor_admin_id": 28,
//           "inspector_id": 8,
//           "cleaner_id": 3,
//           "state_id": 15,
//           "dist_id": 28,
//           "taluka_id": 13,
//           "area_id": 4,
//           "address": "123 Sunflower Street",
//           "total_panels": 10,
//           "capacity_w": 5.5,
//           "area_squrM": 200,
//           "location": "Building A, Floor 1",
//           "latlng": null,
//           "isActive": 0,
//           "isDeleted": 0,
//           "createAt": "2025-05-21T12:31:13.000Z",
//           "UpdatedAt": null,
//           "installed_by": 16,
//           "under_maintenance": 0,
//           "info": "",
//           "inspector_name": "John Doe",
//           "cleaner_name": "Alice Smith",
//           "installed_by_name": "InstallerUser1",
//           "state_name": "Maharashtra",
//           "district_name": "Pune",
//           "taluka_name": "Pune City",
//           "area_name": "Baner",
//           // Additional fields for card display
//           "autoCleanTime": "08:00",
//           "isOnline": true,
//         }
//       ];
//     } catch (e) {
//       errorMessage.value = e.toString();
//       Get.snackbar('Error', 'Failed to fetch plants');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Fetch plant details by ID
//   Future<Map<String, dynamic>?> fetchPlantDetails(String plantId) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       // Mock API call
//       await Future.delayed(Duration(seconds: 1));
//
//       // Return the same plant data that's already in the plants list
//       final plant = plants.firstWhere(
//             (p) => p['id'].toString() == plantId,
//         orElse: () => <String, dynamic>{},
//       );
//
//       if (plant.isEmpty) {
//         throw Exception('Plant not found');
//       }
//
//       // Mock API response structure
//       final mockPlantDetails = {
//         "message": "Plant retrieved successfully",
//         "success": true,
//         "data": plant,
//         "errors": []
//       };
//
//       plantDetails.value = plant;
//       return plant;
//
//     } catch (e) {
//       errorMessage.value = e.toString();
//       Get.snackbar('Error', 'Failed to fetch plant details');
//       return null;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // View plant details
//
//   void viewPlantDetails(int plantId) {
//     final plant = plants.firstWhere((plant) => plant['id'] == plantId);
//     selectedPlant.value = plant;
//     Get.toNamed(AppRoutes.inspectorDetailsSection, arguments: plant);
//   }
//
//
//
//   // Refresh plants data
//   Future<void> refreshPlants() async {
//     await fetchPlants();
//   }
//
//   @override
//   void onClose() {
//     // Clean up resources
//     super.onClose();
//   }
// }

import 'package:get/get.dart';
import '../../API Service/Model/Request/plant_model.dart';
import '../../API Service/api_service.dart';
import '../../Route Manager/app_routes.dart';
import '../../utils/constants.dart';

class PlantInfoController extends GetxController {
  // Observable lists and variables
  final plants = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedPlant = Rx<Map<String, dynamic>?>(null);
  final plantDetails = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchPlants();
  }

  // Fetch all assigned plants
  Future<void> fetchPlants() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Retrieve the stored UID
      final storedUid = await ApiService.getUid();

      if (storedUid == null) {
        throw Exception('No UID found');
      }

      // Use the UID as the inspector ID to fetch plants
      final response = await ApiService.get<Map<String, dynamic>>(
        endpoint: getInspectorPlantsUrl(int.parse(storedUid)),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success) {
        // Access the 'data' key in the response which contains the list of plants
        final responseData = response.data;
        if (responseData != null && responseData.containsKey('data')) {
          final List<dynamic> plantsList = responseData['data'];
          plants.value = plantsList.map((plant) => Plant.fromJson(plant).toJson()).toList();
        } else {
          throw Exception('Unexpected API response format');
        }
      } else {
        throw Exception(response.errorMessage);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to fetch plants');
    } finally {
      isLoading.value = false;
    }
  }


  // Fetch plant details by ID
  Future<Map<String, dynamic>?> fetchPlantDetails(String plantId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Mock API call
      await Future.delayed(Duration(seconds: 1));

      // Return the same plant data that's already in the plants list
      final plant = plants.firstWhere((p) => p['id'].toString() == plantId, orElse: () => <String, dynamic>{},);

      if (plant.isEmpty) {
        throw Exception('Plant not found');
      }


      plantDetails.value = plant;
      return plant;

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to fetch plant details');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // View plant details
  void viewPlantDetails(int plantId) {
    final plant = plants.firstWhere((plant) => plant['id'] == plantId);
    selectedPlant.value = plant;
    Get.toNamed(AppRoutes.inspectorDetailsSection, arguments: plant);
  }

  // Refresh plants data
  Future<void> refreshPlants() async {
    await fetchPlants();
  }

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}
