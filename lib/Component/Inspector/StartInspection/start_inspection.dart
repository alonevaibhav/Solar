// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:solar_app/Controller/Inspector/plant_inspection_controller.dart';
// import '../../../utils/drop_down.dart';
//
// class StartInspection extends StatefulWidget {
//   const StartInspection({super.key});
//
//   @override
//   State<StartInspection> createState() => _StartInspectionState();
// }
//
// class _StartInspectionState extends State<StartInspection> {
//   late PlantInspectionController controller;
//   final Map<String, dynamic> inspectionData = Get.arguments ?? {};
//   late String controllerTag;
//
//   @override
//   void initState() {
//     super.initState();
//     controllerTag = "inspection_${inspectionData['id'] ?? DateTime.now().millisecondsSinceEpoch}";
//
//     // Schedule the initialization of the controller after the frame is rendered
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller = Get.put(PlantInspectionController(), tag: controllerTag);
//       _initializeFormData();
//     });
//   }
//
//   void _initializeFormData() {
//     // Set default values specific to this inspection
//     controller.dateController.text = DateTime.now().toString().split(' ')[0];
//     controller.timeController.text = TimeOfDay.now().format(context);
//
//     // Reset all form fields to ensure clean state
//     controller.selectedStatus.value = 'pending';
//     controller.uploadedImagePath.value = null;
//     controller.inspectorReviewController.clear();
//     controller.clientReviewController.clear();
//   }
//
//   @override
//   void dispose() {
//     // Clean up the controller when leaving this screen
//     Get.delete<PlantInspectionController>(tag: controllerTag);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           'Start Inspection',
//           style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.w500,
//               fontSize: 18 * 0.9.sp),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black, size: 24 * 0.9.sp),
//           onPressed: () => Get.back(),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh, color: Colors.black, size: 24 * 0.9.sp),
//             onPressed: () => controller.fetchInspectionItems(),
//           ),
//         ],
//       ),
//       body: GetBuilder<PlantInspectionController>(
//         tag: controllerTag,
//         init: PlantInspectionController(),
//         builder: (controller) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16 * 0.9.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 16 * 0.9.h),
//                   Row(
//                     children: [
//                       Container(
//                         width: 8 * 0.9.w,
//                         height: 8 * 0.9.h,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.blue,
//                         ),
//                       ),
//                       SizedBox(width: 8 * 0.9.w),
//                       Text(
//                         'Ready for Inspection',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: 12 * 0.9.sp,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16 * 0.9.h),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.all(16 * 0.9.r),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12 * 0.9.r),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 8 * 0.9.r,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           inspectionData['plant_name'] ?? 'Unknown Plant',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18 * 0.9.sp,
//                           ),
//                         ),
//                         SizedBox(height: 8 * 0.9.h),
//                         RichText(
//                           text: TextSpan(
//                             style: TextStyle(
//                               color: Colors.black87,
//                               fontSize: 14 * 0.9.sp,
//                             ),
//                             children: [
//                               const TextSpan(
//                                 text: 'Scheduled: ',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               TextSpan(
//                                 text: inspectionData['time'] ?? 'Not set',
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 4 * 0.9.h),
//                         Row(
//                           children: [
//                             Text(
//                               'Inspector: ',
//                               style: TextStyle(
//                                 fontSize: 14 * 0.9.sp,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Text(
//                               inspectionData['inspector_name'] ??
//                                   'Not assigned',
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 fontSize: 14 * 0.9.sp,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16 * 0.9.h),
//                         Container(
//                           padding: EdgeInsets.all(8 * 0.9.r),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             borderRadius: BorderRadius.circular(8 * 0.9.r),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Location',
//                                 style: TextStyle(
//                                   fontSize: 11 * 0.9.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.grey[700],
//                                 ),
//                               ),
//                               SizedBox(height: 4 * 0.9.h),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       inspectionData['plant_address'] ??
//                                           'Unknown Location',
//                                       style: TextStyle(
//                                         fontSize: 12 * 0.9.sp,
//                                         color: Colors.grey[600],
//                                       ),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   Icon(
//                                     Icons.near_me,
//                                     color: Colors.blue,
//                                     size: 20 * 0.9.r,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 24 * 0.9.h),
//                   Form(
//                     key: controller.formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Cleaner Status',
//                           style: TextStyle(
//                             fontSize: 18 * 0.9.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 15 * 0.9.h),
//
//                         Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.all(16 * 0.9.r),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12 * 0.9.r),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 8 * 0.9.r,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             children: [
//                               CircleAvatar(
//                                 radius: 24 * 0.9.r,
//                                 backgroundColor: Colors.blue[100],
//                                 child: Icon(
//                                   Icons.cleaning_services,
//                                   color: Colors.blue,
//                                   size: 24 * 0.9.r,
//                                 ),
//                               ),
//                               SizedBox(width: 16 * 0.9.w),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       inspectionData['cleaner_name'] ??
//                                           'Cleaner Name',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16 * 0.9.sp,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // SizedBox(height: 24 * 0.9.h),
//                         SizedBox(height: 30 * 0.9.h),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: TextFormField(
//                                 controller: controller.dateController,
//                                 readOnly: true,
//                                 decoration: InputDecoration(
//                                   labelText: 'Date *',
//                                   hintText: 'Select date',
//                                   prefixIcon: Icon(Icons.calendar_today,
//                                       size: 20 * 0.9.sp),
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(12 * 0.9.r),
//                                   ),
//                                 ),
//                                 onTap: () async {
//                                   final date = await showDatePicker(
//                                     context: context,
//                                     initialDate: DateTime.now(),
//                                     firstDate: DateTime.now()
//                                         .subtract(const Duration(days: 30)),
//                                     lastDate: DateTime.now()
//                                         .add(const Duration(days: 30)),
//                                   );
//                                   if (date != null) {
//                                     controller.dateController.text =
//                                         date.toString().split(' ')[0];
//                                   }
//                                 },
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please select date';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             SizedBox(width: 12 * 0.9.w),
//                             Expanded(
//                               child: TextFormField(
//                                 controller: controller.timeController,
//                                 readOnly: true,
//                                 decoration: InputDecoration(
//                                   labelText: 'Time *',
//                                   hintText: 'Select time',
//                                   prefixIcon: Icon(Icons.access_time,
//                                       size: 20 * 0.9.sp),
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(12 * 0.9.r),
//                                   ),
//                                 ),
//                                 onTap: () async {
//                                   final time = await showTimePicker(
//                                     context: context,
//                                     initialTime: TimeOfDay.now(),
//                                   );
//                                   if (time != null) {
//                                     controller.timeController.text =
//                                         time.format(context);
//                                   }
//                                 },
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please select time';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16 * 0.9.h),
//                         Obx(() => CustomDropdownField<String>(
//                               value: controller.selectedStatus.value.isEmpty
//                                   ? null
//                                   : controller.selectedStatus.value,
//                               labelText: 'Status',
//                               prefixIcon: Icons.flag,
//                               items: controller.statusOptions,
//                               itemLabelBuilder: (status) => status,
//                               isRequired: true,
//                               onChanged: (value) {
//                                 if (value != null) {
//                                   controller.selectedStatus.value = value;
//                                 }
//                               },
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please select status';
//                                 }
//                                 return null;
//                               },
//                             )),
//                         SizedBox(height: 16 * 0.9.h),
//
//                         // Upload Inspection Photos Section
//                         Text(
//                           'Upload Inspection Photos',
//                           style: TextStyle(
//                             fontSize: 16 * 0.9.sp,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         SizedBox(height: 8 * 0.9.h),
//
//                         // Photos Grid Display
//                         Obx(() {
//                           final imagePaths = controller.uploadedImagePaths;
//                           final isUploading = controller.isUploadingImage.value;
//
//                           if (imagePaths.isEmpty && !isUploading) {
//                             // Empty state - show add button
//                             return GestureDetector(
//                               onTap: controller.uploadImage,
//                               child: Container(
//                                 width: double.infinity,
//                                 height: 120 * 0.9.h,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   borderRadius:
//                                       BorderRadius.circular(12 * 0.9.r),
//                                   border: Border.all(color: Colors.grey[300]!),
//                                 ),
//                                 child: Center(
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Container(
//                                         padding: EdgeInsets.all(12 * 0.9.r),
//                                         decoration: BoxDecoration(
//                                           color: Colors.blue.withOpacity(0.1),
//                                           borderRadius:
//                                               BorderRadius.circular(12 * 0.9.r),
//                                         ),
//                                         child: Icon(
//                                           Icons.add_a_photo,
//                                           color: Colors.blue,
//                                           size: 32 * 0.9.r,
//                                         ),
//                                       ),
//                                       SizedBox(height: 8 * 0.9.h),
//                                       Text(
//                                         'Add Inspection Photos',
//                                         style: TextStyle(
//                                           fontSize: 14 * 0.9.sp,
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.grey[700],
//                                         ),
//                                       ),
//                                       SizedBox(height: 4 * 0.9.h),
//                                       Text(
//                                         'Camera • Gallery • Multiple',
//                                         style: TextStyle(
//                                           fontSize: 12 * 0.9.sp,
//                                           color: Colors.grey[500],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }
//
//                           // Photos grid with add button
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Photos count and add button row
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     '${imagePaths.length} Photo${imagePaths.length == 1 ? '' : 's'} Added',
//                                     style: TextStyle(
//                                       fontSize: 14 * 0.9.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: isUploading
//                                         ? null
//                                         : controller.uploadImage,
//                                     child: Container(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 12 * 0.9.w,
//                                         vertical: 6 * 0.9.h,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Colors.blue,
//                                         borderRadius:
//                                             BorderRadius.circular(20 * 0.9.r),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Icon(
//                                             Icons.add,
//                                             color: Colors.white,
//                                             size: 16 * 0.9.r,
//                                           ),
//                                           SizedBox(width: 4 * 0.9.w),
//                                           Text(
//                                             'Add More',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 12 * 0.9.sp,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 12 * 0.9.h),
//
//                               // Photos grid
//                               GridView.builder(
//                                 shrinkWrap: true,
//                                 physics: NeverScrollableScrollPhysics(),
//                                 gridDelegate:
//                                     SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 3,
//                                   crossAxisSpacing: 8 * 0.9.w,
//                                   mainAxisSpacing: 8 * 0.9.h,
//                                   childAspectRatio: 1,
//                                 ),
//                                 itemCount:
//                                     imagePaths.length + (isUploading ? 1 : 0),
//                                 itemBuilder: (context, index) {
//                                   // Show loading indicator for the last item while uploading
//                                   if (isUploading &&
//                                       index == imagePaths.length) {
//                                     return Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey[200],
//                                         borderRadius:
//                                             BorderRadius.circular(12 * 0.9.r),
//                                         border: Border.all(
//                                             color: Colors.grey[300]!),
//                                       ),
//                                       child: Center(
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           valueColor:
//                                               AlwaysStoppedAnimation<Color>(
//                                                   Colors.blue),
//                                         ),
//                                       ),
//                                     );
//                                   }
//
//                                   final imagePath = imagePaths[index];
//                                   return GestureDetector(
//                                     onTap: () => controller
//                                         .viewImageFullScreen(imagePath),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius:
//                                             BorderRadius.circular(12 * 0.9.r),
//                                         border: Border.all(
//                                             color: Colors.grey[300]!),
//                                       ),
//                                       child: Stack(
//                                         children: [
//                                           // Image
//                                           ClipRRect(
//                                             borderRadius: BorderRadius.circular(
//                                                 12 * 0.9.r),
//                                             child: Image.file(
//                                               File(imagePath),
//                                               fit: BoxFit.cover,
//                                               width: double.infinity,
//                                               height: double.infinity,
//                                             ),
//                                           ),
//                                           // Remove button
//                                           Positioned(
//                                             top: 4 * 0.9.h,
//                                             right: 4 * 0.9.w,
//                                             child: GestureDetector(
//                                               onTap: () =>
//                                                   controller.removeImage(index),
//                                               child: Container(
//                                                 padding:
//                                                     EdgeInsets.all(4 * 0.9.r),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.red
//                                                       .withOpacity(0.8),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           12 * 0.9.r),
//                                                 ),
//                                                 child: Icon(
//                                                   Icons.close,
//                                                   color: Colors.white,
//                                                   size: 12 * 0.9.r,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           // View indicator
//                                           Positioned(
//                                             bottom: 4 * 0.9.h,
//                                             right: 4 * 0.9.w,
//                                             child: Container(
//                                               padding:
//                                                   EdgeInsets.all(4 * 0.9.r),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.black
//                                                     .withOpacity(0.6),
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         12 * 0.9.r),
//                                               ),
//                                               child: Icon(
//                                                 Icons.zoom_in,
//                                                 color: Colors.white,
//                                                 size: 12 * 0.9.r,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           );
//                         }),
//                         SizedBox(height: 16 * 0.9.h),
//                         TextFormField(
//                           controller: controller.inspectorReviewController,
//                           maxLines: 4,
//                           maxLength: 255,
//                           decoration: InputDecoration(
//                             labelText: 'Inspector Review *',
//                             hintText: 'Describe inspection findings...',
//                             hintStyle: TextStyle(
//                                 color: Colors.grey[400], fontSize: 14 * 0.9.sp),
//                             prefixIcon:
//                                 Icon(Icons.rate_review, size: 20 * 0.9.sp),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12 * 0.9.r),
//                             ),
//                             alignLabelWithHint: true,
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please provide inspector review';
//                             }
//                             if (value.length > 255) {
//                               return 'Review cannot exceed 255 characters';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 16 * 0.9.h),
//                         TextFormField(
//                           controller: controller.clientReviewController,
//                           maxLines: 3,
//                           maxLength: 255,
//                           decoration: InputDecoration(
//                             labelText: 'Client Review (Optional)',
//                             hintText: 'Add client feedback...',
//                             hintStyle: TextStyle(
//                                 color: Colors.grey[400], fontSize: 14 * 0.9.sp),
//                             prefixIcon: Icon(Icons.comment, size: 20 * 0.9.sp),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12 * 0.9.r),
//                             ),
//                             alignLabelWithHint: true,
//                           ),
//                           validator: (value) {
//                             if (value != null && value.length > 255) {
//                               return 'Review cannot exceed 255 characters';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 24 * 0.9.h),
//                         SizedBox(
//                           width: double.infinity,
//                           height: 50 * 0.9.h,
//                           child: Obx(() => ElevatedButton(
//                                 onPressed: controller.isSubmitting.value
//                                     ? null
//                                     : () => controller
//                                         .submitInspectionReport(inspectionData),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.black,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(12 * 0.9.r),
//                                   ),
//                                   disabledBackgroundColor: Colors.grey,
//                                 ),
//                                 child: controller.isSubmitting.value
//                                     ? const CircularProgressIndicator(
//                                         color: Colors.white)
//                                     : Text(
//                                         'Submit Inspection Report',
//                                         style: TextStyle(
//                                           fontSize: 16 * 0.9.sp,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                               )),
//                         ),
//                         SizedBox(height: 24 * 0.9.h),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/Controller/Inspector/plant_inspection_controller.dart';
import '../../../utils/drop_down.dart';

class StartInspection extends StatefulWidget {
  const StartInspection({super.key});

  @override
  State<StartInspection> createState() => _StartInspectionState();
}

class _StartInspectionState extends State<StartInspection> {
  late PlantInspectionController controller;
  final Map<String, dynamic> inspectionData = Get.arguments ?? {};
  late String controllerTag;

  @override
  void initState() {
    super.initState();
    controllerTag = "inspection_${inspectionData['id'] ?? DateTime.now().millisecondsSinceEpoch}";

    // Schedule the initialization of the controller after the frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller = Get.put(PlantInspectionController(), tag: controllerTag);
      _initializeFormData();
    });
  }

  void _initializeFormData() {
    // Set default values specific to this inspection
    controller.dateController.text = DateTime.now().toString().split(' ')[0];
    controller.timeController.text = TimeOfDay.now().format(context);

    // Reset all form fields to ensure clean state
    controller.selectedStatus.value = 'pending';
    controller.uploadedImagePath.value = null;
    controller.inspectorReviewController.clear();
    controller.clientReviewController.clear();
  }

  @override
  void dispose() {
    // Clean up the controller when leaving this screen
    Get.delete<PlantInspectionController>(tag: controllerTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Start Inspection',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18 * 0.9.sp),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24 * 0.9.sp),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black, size: 24 * 0.9.sp),
            onPressed: () => controller.fetchInspectionItems(),
          ),
        ],
      ),
      body: GetBuilder<PlantInspectionController>(
        tag: controllerTag,
        init: PlantInspectionController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 * 0.9.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16 * 0.9.h),
                  Row(
                    children: [
                      Container(
                        width: 8 * 0.9.w,
                        height: 8 * 0.9.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 8 * 0.9.w),
                      Text(
                        'Ready for Inspection',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12 * 0.9.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16 * 0.9.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16 * 0.9.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12 * 0.9.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8 * 0.9.r,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inspectionData['plant_name'] ?? 'Unknown Plant',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18 * 0.9.sp,
                          ),
                        ),
                        SizedBox(height: 8 * 0.9.h),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14 * 0.9.sp,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Scheduled: ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: inspectionData['time'] ?? 'Not set',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4 * 0.9.h),
                        Row(
                          children: [
                            Text(
                              'Inspector: ',
                              style: TextStyle(
                                fontSize: 14 * 0.9.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              inspectionData['inspector_name'] ??
                                  'Not assigned',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14 * 0.9.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16 * 0.9.h),
                        Container(
                          padding: EdgeInsets.all(8 * 0.9.r),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8 * 0.9.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Location',
                                style: TextStyle(
                                  fontSize: 11 * 0.9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4 * 0.9.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      inspectionData['plant_address'] ??
                                          'Unknown Location',
                                      style: TextStyle(
                                        fontSize: 12 * 0.9.sp,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    Icons.near_me,
                                    color: Colors.blue,
                                    size: 20 * 0.9.r,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24 * 0.9.h),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cleaner Status',
                          style: TextStyle(
                            fontSize: 18 * 0.9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15 * 0.9.h),

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16 * 0.9.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12 * 0.9.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8 * 0.9.r,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24 * 0.9.r,
                                backgroundColor: Colors.blue[100],
                                child: Icon(
                                  Icons.cleaning_services,
                                  color: Colors.blue,
                                  size: 24 * 0.9.r,
                                ),
                              ),
                              SizedBox(width: 16 * 0.9.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      inspectionData['cleaner_name'] ??
                                          'Cleaner Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16 * 0.9.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(height: 24 * 0.9.h),
                        SizedBox(height: 30 * 0.9.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.dateController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Date *',
                                  hintText: 'Select date',
                                  prefixIcon: Icon(Icons.calendar_today,
                                      size: 20 * 0.9.sp),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(12 * 0.9.r),
                                  ),
                                ),
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(const Duration(days: 30)),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 30)),
                                  );
                                  if (date != null) {
                                    controller.dateController.text =
                                    date.toString().split(' ')[0];
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 12 * 0.9.w),
                            Expanded(
                              child: TextFormField(
                                controller: controller.timeController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Time *',
                                  hintText: 'Select time',
                                  prefixIcon: Icon(Icons.access_time,
                                      size: 20 * 0.9.sp),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(12 * 0.9.r),
                                  ),
                                ),
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (time != null) {
                                    controller.timeController.text =
                                        time.format(context);
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select time';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16 * 0.9.h),
                        Obx(() => CustomDropdownField<String>(
                          value: controller.selectedStatus.value.isEmpty
                              ? null
                              : controller.selectedStatus.value,
                          labelText: 'Status',
                          prefixIcon: Icons.flag,
                          items: controller.statusOptions,
                          itemLabelBuilder: (status) => status,
                          isRequired: true,
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedStatus.value = value;
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select status';
                            }
                            return null;
                          },
                        )),
                        SizedBox(height: 16 * 0.9.h),

                        // Upload Inspection Photos Section
                        Text(
                          'Upload Inspection Photos',
                          style: TextStyle(
                            fontSize: 16 * 0.9.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8 * 0.9.h),

                        // Photos Grid Display
                        Obx(() {
                          final imagePaths = controller.uploadedImagePaths;
                          final isUploading = controller.isUploadingImage.value;

                          if (imagePaths.isEmpty && !isUploading) {
                            // Empty state - show add button
                            return GestureDetector(
                              onTap: controller.uploadImage,
                              child: Container(
                                width: double.infinity,
                                height: 120 * 0.9.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius:
                                  BorderRadius.circular(12 * 0.9.r),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12 * 0.9.r),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius:
                                          BorderRadius.circular(12 * 0.9.r),
                                        ),
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.blue,
                                          size: 32 * 0.9.r,
                                        ),
                                      ),
                                      SizedBox(height: 8 * 0.9.h),
                                      Text(
                                        'Add Inspection Photos',
                                        style: TextStyle(
                                          fontSize: 14 * 0.9.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: 4 * 0.9.h),
                                      Text(
                                        'Camera • Gallery • Multiple',
                                        style: TextStyle(
                                          fontSize: 12 * 0.9.sp,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                          // Photos grid with add button
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Photos count and add button row
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${imagePaths.length} Photo${imagePaths.length == 1 ? '' : 's'} Added',
                                    style: TextStyle(
                                      fontSize: 14 * 0.9.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: isUploading
                                        ? null
                                        : controller.uploadImage,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12 * 0.9.w,
                                        vertical: 6 * 0.9.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                        BorderRadius.circular(20 * 0.9.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 16 * 0.9.r,
                                          ),
                                          SizedBox(width: 4 * 0.9.w),
                                          Text(
                                            'Add More',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12 * 0.9.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12 * 0.9.h),

                              // Photos grid
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8 * 0.9.w,
                                  mainAxisSpacing: 8 * 0.9.h,
                                  childAspectRatio: 1,
                                ),
                                itemCount:
                                imagePaths.length + (isUploading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  // Show loading indicator for the last item while uploading
                                  if (isUploading &&
                                      index == imagePaths.length) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                        BorderRadius.circular(12 * 0.9.r),
                                        border: Border.all(
                                            color: Colors.grey[300]!),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              Colors.blue),
                                        ),
                                      ),
                                    );
                                  }

                                  final imagePath = imagePaths[index];
                                  return GestureDetector(
                                    onTap: () => controller
                                        .viewImageFullScreen(imagePath),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(12 * 0.9.r),
                                        border: Border.all(
                                            color: Colors.grey[300]!),
                                      ),
                                      child: Stack(
                                        children: [
                                          // Image
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                12 * 0.9.r),
                                            child: Image.file(
                                              File(imagePath),
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ),
                                          // Remove button
                                          Positioned(
                                            top: 4 * 0.9.h,
                                            right: 4 * 0.9.w,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  controller.removeImage(index),
                                              child: Container(
                                                padding:
                                                EdgeInsets.all(4 * 0.9.r),
                                                decoration: BoxDecoration(
                                                  color: Colors.red
                                                      .withOpacity(0.8),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      12 * 0.9.r),
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 12 * 0.9.r,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // View indicator
                                          Positioned(
                                            bottom: 4 * 0.9.h,
                                            right: 4 * 0.9.w,
                                            child: Container(
                                              padding:
                                              EdgeInsets.all(4 * 0.9.r),
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    12 * 0.9.r),
                                              ),
                                              child: Icon(
                                                Icons.zoom_in,
                                                color: Colors.white,
                                                size: 12 * 0.9.r,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        }),
                        SizedBox(height: 16 * 0.9.h),
                        TextFormField(
                          controller: controller.inspectorReviewController,
                          maxLines: 4,
                          maxLength: 255,
                          decoration: InputDecoration(
                            labelText: 'Inspector Review *',
                            hintText: 'Describe inspection findings...',
                            hintStyle: TextStyle(
                                color: Colors.grey[400], fontSize: 14 * 0.9.sp),
                            prefixIcon:
                            Icon(Icons.rate_review, size: 20 * 0.9.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12 * 0.9.r),
                            ),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please provide inspector review';
                            }
                            if (value.length > 255) {
                              return 'Review cannot exceed 255 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16 * 0.9.h),
                        TextFormField(
                          controller: controller.clientReviewController,
                          maxLines: 3,
                          maxLength: 255,
                          decoration: InputDecoration(
                            labelText: 'Client Review (Optional)',
                            hintText: 'Add client feedback...',
                            hintStyle: TextStyle(
                                color: Colors.grey[400], fontSize: 14 * 0.9.sp),
                            prefixIcon: Icon(Icons.comment, size: 20 * 0.9.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12 * 0.9.r),
                            ),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value != null && value.length > 255) {
                              return 'Review cannot exceed 255 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24 * 0.9.h),
                        SizedBox(
                          width: double.infinity,
                          height: 50 * 0.9.h,
                          child: Obx(() => ElevatedButton(
                            onPressed: controller.isSubmitting.value
                                ? null
                                : () => controller
                                .submitInspectionReport(inspectionData),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12 * 0.9.r),
                              ),
                              disabledBackgroundColor: Colors.grey,
                            ),
                            child: controller.isSubmitting.value
                                ? const CircularProgressIndicator(
                                color: Colors.white)
                                : Text(
                              'Submit Inspection Report',
                              style: TextStyle(
                                fontSize: 16 * 0.9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                        ),
                        SizedBox(height: 24 * 0.9.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
