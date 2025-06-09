// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../API Service/Model/get_status_data.dart';
// import '../../API Service/api_service.dart';
// import '../../Route Manager/app_routes.dart';
// import '../../utils/constants.dart';
// import 'all_inspection_controller.dart';
//
// class PlantInspectionController extends GetxController {
//   final AllInspectionsController allInspectionsController = Get.put(AllInspectionsController());
//
//   final isLoadingDashboard = false.obs;
//   final errorMessageDashboard = Rxn<String>();
//   final dashboardData = Rxn<Map<String, dynamic>>();
//   final todaysInspections = Rxn<Map<String, dynamic>>();
//   final inspectionItems = <Map<String, dynamic>>[].obs;
//   InspectorDataResponse? inspectorDataResponse; // Store the response data
//   final selectedTabIndex = 0.obs;
//
//   // Form state variables - these will be unique per instance
//   late final TextEditingController dateController;
//   late final TextEditingController timeController;
//   late final TextEditingController inspectorReviewController;
//   late final TextEditingController clientReviewController;
//   late final GlobalKey<FormState> formKey;
//   final selectedStatus = 'pending'.obs;
//   final isSubmitting = false.obs;
//
//   // Changed from single image to multiple images
//   final uploadedImagePaths = <String>[].obs;
//   final isUploadingImage = false.obs;
//   final uploadedImagePath = Rxn<String>();
//
//
//   final statusOptions = ['pending', 'cleaning', 'done', 'failed'];
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // Initialize controllers in onInit to ensure unique instances
//     dateController = TextEditingController();
//     timeController = TextEditingController();
//     inspectorReviewController = TextEditingController();
//     clientReviewController = TextEditingController();
//     formKey = GlobalKey<FormState>();
//
//     // Set initial values
//     _resetFormData();
//
//     // Only fetch inspection items for dashboard instances (not form instances)
//     if (Get.currentRoute.contains('dashboard') || Get.currentRoute.contains('inspection_list')) {
//       fetchInspectionItems();
//     }
//
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//   }
//
//   @override
//   void onClose() {
//     // Dispose controllers to prevent memory leaks
//     dateController.dispose();
//     timeController.dispose();
//     inspectorReviewController.dispose();
//     clientReviewController.dispose();
//     super.onClose();
//   }
//
//   // Reset form data to initial state
//   void _resetFormData() {
//     dateController.text = DateTime.now().toString().split(' ')[0];
//     timeController.text = TimeOfDay.now().format(Get.context!);
//     selectedStatus.value = 'pending';
//     uploadedImagePaths.clear(); // Clear the list instead of setting to null
//     inspectorReviewController.clear();
//     clientReviewController.clear();
//   }
//
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
//
//       // Fetch the UID from SharedPreferences
//       String? uid = await ApiService.getUid();
//
//       if (uid == null) {
//         errorMessageDashboard.value = 'User ID not found';
//         return;
//       }
//
//       // Make the API call to fetch inspection items
//       final response = await ApiService.get<Map<String, dynamic>>(
//         endpoint: getTodayScheduleInspector(int.parse(uid)),
//         fromJson: (json) => json as Map<String, dynamic>,
//       );
//
//       if (response.success && response.data != null) {
//         final data = response.data!['data'] as List<dynamic>;
//         inspectionItems.value = data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
//
//         // Calculate dashboard statistics after fetching inspection items
//         _calculateDashboardStats();
//       } else {
//         errorMessageDashboard.value = response.errorMessage ?? 'Failed to load inspection items';
//       }
//     } catch (e) {
//       errorMessageDashboard.value = 'Failed to load inspection items: $e';
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
//     Get.toNamed(AppRoutes.inspectorStartInspection, arguments: item);
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
//
//   void _showImageSourceDialog() {
//     Get.bottomSheet(
//       Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Select Image Source',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             ListTile(
//               leading: Icon(Icons.camera_alt, color: Colors.blue),
//               title: Text('Camera'),
//               subtitle: Text('Take a new photo'),
//               onTap: () {
//                 Get.back();
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library, color: Colors.green),
//               title: Text('Gallery'),
//               subtitle: Text('Choose from gallery'),
//               onTap: () {
//                 Get.back();
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library_outlined, color: Colors.orange),
//               title: Text('Multiple from Gallery'),
//               subtitle: Text('Choose multiple photos'),
//               onTap: () {
//                 Get.back();
//                 _pickMultipleImages();
//               },
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//     );
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       isUploadingImage.value = true;
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(
//         source: source,
//         maxWidth: 1800,
//         maxHeight: 1800,
//         imageQuality: 85,
//       );
//
//       if (image != null) {
//         uploadedImagePaths.add(image.path);
//         Get.snackbar(
//           'Success',
//           'Photo added successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           duration: Duration(seconds: 2),
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to pick image: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isUploadingImage.value = false;
//     }
//   }
//
//   Future<void> _pickMultipleImages() async {
//     try {
//       isUploadingImage.value = true;
//       final ImagePicker picker = ImagePicker();
//       final List<XFile> images = await picker.pickMultiImage(
//         maxWidth: 1800,
//         maxHeight: 1800,
//         imageQuality: 85,
//       );
//
//       if (images.isNotEmpty) {
//         for (XFile image in images) {
//           uploadedImagePaths.add(image.path);
//         }
//         Get.snackbar(
//           'Success',
//           '${images.length} photos added successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           duration: Duration(seconds: 2),
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to pick images: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isUploadingImage.value = false;
//     }
//   }
//
//   void uploadImage() {
//     _showImageSourceDialog();
//   }
//
//   void removeImage(int index) {
//     if (index >= 0 && index < uploadedImagePaths.length) {
//       uploadedImagePaths.removeAt(index);
//       Get.snackbar(
//         'Success',
//         'Photo removed successfully',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         duration: Duration(seconds: 1),
//       );
//     }
//   }
//
//   void viewImageFullScreen(String imagePath) {
//     Get.dialog(
//       Dialog(
//         backgroundColor: Colors.black,
//         child: Stack(
//           children: [
//             Center(
//               child: InteractiveViewer(
//                 child: Image.file(
//                   File(imagePath),
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 40,
//               right: 20,
//               child: IconButton(
//                 onPressed: () => Get.back(),
//                 icon: Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> submitInspectionReport(Map<String, dynamic> inspectionData) async {
//     if (formKey.currentState!.validate()) {
//       isSubmitting.value = true;
//       try {
//         // Here you would typically make an API call to submit the inspection report
//         // You can access all uploaded images via uploadedImagePaths.value
//         print('Submitting with ${uploadedImagePaths.length} images');
//
//         // For now, we'll just simulate a delay
//         await Future.delayed(const Duration(seconds: 2));
//
//         Get.snackbar(
//           'Success',
//           'Inspection report submitted successfully with ${uploadedImagePaths.length} photos',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//
//         // Navigate back or to another screen as needed
//         Get.back();
//       } catch (e) {
//         Get.snackbar(
//           'Error',
//           'Failed to submit inspection report: $e',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       } finally {
//         isSubmitting.value = false;
//       }
//     }
//   }
//
//   // ✅ FIXED CONTROLLER METHOD
//   Future<void> fetchInspectorData(int inspectionCardId) async {
//     try {
//       String endpoint = getInspectorDataByID(inspectionCardId);
//
//       var response = await ApiService.get<InspectorDataResponse>(
//         endpoint: endpoint,
//         fromJson: (json) => InspectorDataResponse.fromJson(json),
//         includeToken: true,
//       );
//
//       if (response.success) {
//         inspectorDataResponse = response.data; // Store the response data
//         print('Fetched data: ${inspectorDataResponse?.data.date}');
//       } else {
//         print('Error fetching data: ${response.errorMessage}');
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//     }
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../API Service/Model/get_status_data.dart';
import '../../API Service/api_service.dart';
import '../../Route Manager/app_routes.dart';
import '../../utils/constants.dart';
import 'all_inspection_controller.dart';

class PlantInspectionController extends GetxController {
  final AllInspectionsController allInspectionsController = Get.put(AllInspectionsController());

  final isLoadingDashboard = false.obs;
  final errorMessageDashboard = Rxn<String>();
  final dashboardData = Rxn<Map<String, dynamic>>();
  final todaysInspections = Rxn<Map<String, dynamic>>();
  final inspectionItems = <Map<String, dynamic>>[].obs;
  InspectorDataResponse? inspectorDataResponse; // Store the response data
  final selectedTabIndex = 0.obs;

  // Form state variables - these will be unique per instance
  late final TextEditingController dateController;
  late final TextEditingController timeController;
  late final TextEditingController inspectorReviewController;
  late final TextEditingController clientReviewController;
  late final GlobalKey<FormState> formKey;
  final selectedStatus = 'pending'.obs;
  final isSubmitting = false.obs;
  final isDataLoaded = false.obs; // Track if inspector data is loaded

  // Changed from single image to multiple images
  final uploadedImagePaths = <String>[].obs;
  final isUploadingImage = false.obs;
  final uploadedImagePath = Rxn<String>();

  final statusOptions = ['pending', 'cleaning', 'done', 'failed'];

  @override
  void onInit() {
    super.onInit();

    // Initialize controllers in onInit to ensure unique instances
    dateController = TextEditingController();
    timeController = TextEditingController();
    inspectorReviewController = TextEditingController();
    clientReviewController = TextEditingController();
    formKey = GlobalKey<FormState>();

    // Set initial values only if data is not loaded from API
    if (!isDataLoaded.value) {
      _resetFormData();
    }

    // Only fetch inspection items for dashboard instances (not form instances)
    if (Get.currentRoute.contains('dashboard') || Get.currentRoute.contains('inspection_list')) {
      fetchInspectionItems();
    }
    _populateFormWithInspectorData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    dateController.dispose();
    timeController.dispose();
    inspectorReviewController.dispose();
    clientReviewController.dispose();
    super.onClose();
  }

  // Reset form data to initial state
  void _resetFormData() {
    dateController.text = DateTime.now().toString().split(' ')[0];
    timeController.text = TimeOfDay.now().format(Get.context!);
    selectedStatus.value = 'pending';
    uploadedImagePaths.clear(); // Clear the list instead of setting to null
    inspectorReviewController.clear();
    clientReviewController.clear();
  }
  void _populateFormWithInspectorData() {
    if (inspectorDataResponse?.data != null) {
      final data = inspectorDataResponse!.data;

      // Debug prints to verify the data
      print('Cleaning Date: ${data.cleaningDate}');
      print('Cleaning Time: ${data.cleaningTime}');

      // Populate date and time
      dateController.text = data.cleaningDate != null
          ? data.cleaningDate.toString().split(' ')[0]
          : DateTime.now().toString().split(' ')[0];

      // Ensure the context is valid for time formatting
      if (Get.context != null) {
        timeController.text = data.cleaningTime ?? TimeOfDay.now().format(Get.context!);
      } else {
        print('Error: Context is null');
        timeController.text = DateTime.now().toString().split(' ')[1].split('.')[0];
      }

      // Populate status
      selectedStatus.value = data.status ?? 'pending';

      // Populate reviews if they exist
      if (data.inspectorReview != null && data.inspectorReview!.isNotEmpty) {
        inspectorReviewController.text = data.inspectorReview!;
      }

      if (data.clientReview != null && data.clientReview!.isNotEmpty) {
        clientReviewController.text = data.clientReview!;
      }

      // Mark data as loaded AFTER setting all values
      isDataLoaded.value = true;

      // Force UI refresh
      update();

      print('Form populated with data:');
      print('Date: ${dateController.text}');
      print('Time: ${timeController.text}');
      print('Status: ${selectedStatus.value}');
      print('Data loaded: ${isDataLoaded.value}');
    } else {
      print('Error: inspectorDataResponse or data is null');
    }
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
        endpoint: getTodayScheduleInspector(int.parse(uid)),
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
    Get.toNamed(AppRoutes.inspectorStartInspection, arguments: item);
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

  void _showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.blue),
              title: Text('Camera'),
              subtitle: Text('Take a new photo'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.green),
              title: Text('Gallery'),
              subtitle: Text('Choose from gallery'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: Colors.orange),
              title: Text('Multiple from Gallery'),
              subtitle: Text('Choose multiple photos'),
              onTap: () {
                Get.back();
                _pickMultipleImages();
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      isUploadingImage.value = true;
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        uploadedImagePaths.add(image.path);
        Get.snackbar(
          'Success',
          'Photo added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      isUploadingImage.value = true;
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        for (XFile image in images) {
          uploadedImagePaths.add(image.path);
        }
        Get.snackbar(
          'Success',
          '${images.length} photos added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  void uploadImage() {
    _showImageSourceDialog();
  }

  void removeImage(int index) {
    if (index >= 0 && index < uploadedImagePaths.length) {
      uploadedImagePaths.removeAt(index);
      Get.snackbar(
        'Success',
        'Photo removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 1),
      );
    }
  }

  void viewImageFullScreen(String imagePath) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitInspectionReport(Map<String, dynamic> inspectionData) async {
    if (formKey.currentState!.validate()) {
      isSubmitting.value = true;
      try {
        // Here you would typically make an API call to submit the inspection report
        // You can access all uploaded images via uploadedImagePaths.value
        print('Submitting with ${uploadedImagePaths.length} images');

        // For now, we'll just simulate a delay
        await Future.delayed(const Duration(seconds: 2));

        Get.snackbar(
          'Success',
          'Inspection report submitted successfully with ${uploadedImagePaths.length} photos',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate back or to another screen as needed
        Get.back();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to submit inspection report: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isSubmitting.value = false;
      }
    }
  }

  // ✅ UPDATED CONTROLLER METHOD - Now populates form after fetching
  Future<void> fetchInspectorData(int inspectionCardId) async {
    try {
      String endpoint = getInspectorDataByID(inspectionCardId);

      var response = await ApiService.get<InspectorDataResponse>(
        endpoint: endpoint,
        fromJson: (json) => InspectorDataResponse.fromJson(json),
        includeToken: true,
      );

      if (response.success) {
        inspectorDataResponse = response.data; // Store the response data
        print('Fetched data: ${inspectorDataResponse?.data.date}');

        // Populate the form with the fetched data
        _populateFormWithInspectorData();
      } else {
        print('Error fetching data: ${response.errorMessage}');
        Get.snackbar('Error', 'Failed to load inspection data');
      }
    } catch (e) {
      print('An error occurred: $e');
      Get.snackbar('Error', 'An error occurred while loading data');
    }
  }
}