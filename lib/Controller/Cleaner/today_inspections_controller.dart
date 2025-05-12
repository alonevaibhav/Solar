import 'package:get/get.dart';
import '../../Model/inspection_model.dart';

class TodayInspectionsController extends GetxController {
  // Reactive list of inspections
  final RxList<InspectionModel> pendingInspections = <InspectionModel>[].obs;
  final RxList<InspectionModel> completedInspections = <InspectionModel>[].obs;

  // Search functionality
  final RxString searchQuery = ''.obs;

  // Segment control
  final RxInt selectedSegment = 0.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch initial inspections when controller is initialized
    fetchInspections();
  }

  // Fetch inspections (mock implementation)
  Future<void> fetchInspections() async {
    try {
      isLoading.value = true;

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      pendingInspections.value = [
        InspectionModel(
            plantName: 'pune Plant',
            location: 'abc-1 Pune Maharashtra(411052)',
            isCompleted: false)
      ];

      completedInspections.value = [
        InspectionModel(
            plantName: 'mumbai Plant',
            location: 'XYZ-1 Pune Maharashtra(411052)',
            isCompleted: true)
      ];
    } catch (e) {
      // Handle error
      Get.snackbar('Error', 'Failed to load inspections');
    } finally {
      isLoading.value = false;
    }
  }

  // Filter inspections based on search query
  List<InspectionModel> getFilteredPendingInspections() {
    return pendingInspections
        .where((inspection) =>
            inspection.plantName
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            inspection.location
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  List<InspectionModel> getFilteredCompletedInspections() {
    return completedInspections
        .where((inspection) =>
            inspection.plantName
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            inspection.location
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
