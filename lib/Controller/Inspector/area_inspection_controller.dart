
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solar_app/Route%20Manager/app_routes.dart';

class AreaInspectionController extends GetxController {
  // Status filter
  final RxString currentTab = 'Ongoing Cleaning'.obs;

  // Search functionality
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;

  // Error handling
  final RxString errorMessage = ''.obs;

  // Area data
  final areaData = Rxn<Map<String, dynamic>>();

  // List of plants based on filter
  final filteredPlants = <Map<String, dynamic>>[].obs;

  // Mock data for demonstration
  final allPlants = <Map<String, dynamic>>[].obs;

  //image picker
  final RxBool isUploadingImage = false.obs;

  // Plant inspection specific fields
  final selectedPlantId = RxnString();
  final plantDetail = Rxn<Map<String, dynamic>>();
  final cleaningChecklist = <bool>[false, false, false].obs;
  final Rxn<String> uploadedImagePath = Rxn<String>();
  final TextEditingController issueController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Setup search listener
    debounce(searchQuery, (_) => filterPlants(),
        time: const Duration(milliseconds: 500));

    // Load initial data
    fetchAreaData();
  }

  @override
  void onReady() {
    super.onReady();
    // Additional initialization if needed
  }

  @override
  void onClose() {
    searchController.dispose();
    issueController.dispose();
    remarkController.dispose();
    super.onClose();
  }

  // Change current tab filter
  void changeTab(String tabName) {
    currentTab.value = tabName;
    filterPlants();
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Fetch area data from API
  Future<void> fetchAreaData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Mock API call with delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock area data response
      areaData.value = {
        'areaId': 'area-1',
        'areaName': 'Area -1',
        'totalPlants': 6,
      };

      // Mock plants data
      allPlants.value = [
        {
          'id': 'plant-001',
          'name': 'Abc Plant Name',
          'location': 'XYZ-1 Pune Maharashtra(411052)',
          'contact': 'Plant Owner Name',
          'totalPanels': 32,
          'greenPanels': 20,
          'redPanels': 7,
          'status': 'Ongoing Cleaning',
          'eta': '32 Minutes',
          'time': 'hh:mm',
          'cleanerName': 'Cleaner Name',
          'cleanerPhone': '+91 8001372561',
        },
        {
          'id': 'plant-002',
          'name': 'Def Plant Name',
          'location': 'XYZ-2 Pune Maharashtra(411052)',
          'contact': 'Plant Owner Name 2',
          'totalPanels': 42,
          'greenPanels': 30,
          'redPanels': 12,
          'status': 'Pending Inspection',
          'eta': '45 Minutes',
          'time': '7:30 pm',
          'cleanerName': 'Cleaner Name 2',
          'cleanerPhone': '+91 8001372562',
        },
        {
          'id': 'plant-003',
          'name': 'Ghi Plant Name',
          'location': 'XYZ-3 Pune Maharashtra(411052)',
          'contact': 'Plant Owner Name 3',
          'totalPanels': 28,
          'greenPanels': 22,
          'redPanels': 6,
          'status': 'Inspection Complete',
          'eta': '0 Minutes',
          'time': '5:15 pm',
          'cleanerName': 'Cleaner Name 3',
          'cleanerPhone': '+91 8001372563',
        },
      ];

      // Apply initial filter
      filterPlants();
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load area data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Filter plants based on current tab and search query
  void filterPlants() {
    if (allPlants.isEmpty) return;

    isSearching.value = true;

    try {
      final List<Map<String, dynamic>> result = allPlants
          .where((plant) =>
              plant['status'] == currentTab.value &&
              (searchQuery.isEmpty ||
                  plant['name']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.value.toLowerCase()) ||
                  plant['location']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.value.toLowerCase())))
          .toList();

      filteredPlants.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isSearching.value = false;
    }
  }

  // Start inspection action
  Future<void> startInspection(String plantId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Mock API call
      await Future.delayed(const Duration(seconds: 1));

      // Update plant status
      final int index = allPlants.indexWhere((plant) => plant['id'] == plantId);
      if (index != -1) {
        final Map<String, dynamic> updatedPlant =
            Map<String, dynamic>.from(allPlants[index]);
        updatedPlant['status'] = 'Pending Inspection';

        allPlants[index] = updatedPlant;
        filterPlants();

        Get.snackbar(
          'Success',
          'Inspection started for ${allPlants[index]['name']}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to start inspection: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Send remark action
  Future<void> sendRemark(String plantId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate form data
      if (!formKey.currentState!.validate()) {
        throw Exception('Please fill all required fields');
      }

      // Prepare inspection data
      final Map<String, dynamic> inspectionData = {
        'plantId': plantId,
        'cleaningItems': cleaningChecklist.toList(),
        'issue': issueController.text,
        'remark': remarkController.text,
        'hasImage': uploadedImagePath.value != null,
      };

      // Mock API call
      await Future.delayed(const Duration(seconds: 1));

      // Update plant status in our mocked data
      final int index = allPlants.indexWhere((plant) => plant['id'] == plantId);
      if (index != -1) {
        final Map<String, dynamic> updatedPlant =
            Map<String, dynamic>.from(allPlants[index]);
        updatedPlant['status'] = 'Inspection Complete';
        updatedPlant['lastInspection'] = DateTime.now().toString();

        allPlants[index] = updatedPlant;
        filterPlants();
      }

      // Reset form data
      resetInspectionForm();

      Get.snackbar(
        'Success',
        'Inspection submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );

      // Navigate back
      Get.back();
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to send inspection data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Reset form data
  void resetInspectionForm() {
    issueController.clear();
    remarkController.clear();
    cleaningChecklist.value = [false, false, false];
    uploadedImagePath.value = null;
  }

  // Load plant detail for inspection
  void loadPlantDetail(String plantId) {
    selectedPlantId.value = plantId;
    final plant = allPlants.firstWhereOrNull((p) => p['id'] == plantId);

    if (plant != null) {
      plantDetail.value = Map<String, dynamic>.from(plant);
    } else {
      errorMessage.value = 'Plant not found';
      Get.snackbar(
        'Error',
        'Plant details not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Handle image upload
// Handle image upload
  Future<void> uploadImage() async {
    try {
      isUploadingImage.value = true;

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Print the file path to the console for verification
        print('Picked file path: ${pickedFile.path}');

        // Set the file path
        uploadedImagePath.value = pickedFile.path;

        Get.snackbar(
          'Success',
          'Image uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'No image selected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to upload image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  // Show plant history
  void showHistory() {
    Get.toNamed(AppRoutes.inspectorHistoryPage);
  }

  // Get color for status card
  Color getStatusColor(String status) {
    switch (status) {
      case 'Ongoing Cleaning':
        return const Color(0xFFFFD180); // Orange
      case 'Pending Inspection':
        return const Color(0xFFE0E0E0); // Grey
      case 'Inspection Complete':
        return const Color(0xFFA5D6A7); // Green
      default:
        return Colors.white;
    }
  }
}
