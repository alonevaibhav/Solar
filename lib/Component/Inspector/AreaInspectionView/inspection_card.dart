import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controller/Inspector/area_inspection_controller.dart';

class InspectionForm extends StatelessWidget {
  final String plantId;
  final AreaInspectionController controller = Get.find<AreaInspectionController>();

  InspectionForm({
    Key? key,
    required this.plantId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cleaning checklist
          ...List.generate(
            controller.cleaningChecklist.length,
                (index) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Obx(
                    () => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Cleaning',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: controller.cleaningChecklist[index],
                  onChanged: (value) {
                    controller.cleaningChecklist[index] = value ?? false;
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.blue,
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Image upload section
          GestureDetector(
            onTap: () => controller.uploadImage(),
            child: Container(
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Obx(() {
                if (controller.uploadedImagePath.value != null) {
                  // Show uploaded image
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(
                      controller.uploadedImagePath.value!,
                      fit: BoxFit.cover,
                    ),
                  );
                }

                // Show upload placeholder
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 40.r,
                      color: Colors.grey[500],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Upload Image',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          SizedBox(height: 16.h),

          // Issue description field
          TextFormField(
            controller: controller.issueController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe issue...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              contentPadding: EdgeInsets.all(16.r),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please describe the issue';
              }
              return null;
            },
          ),

          SizedBox(height: 16.h),

          // Remark field
          TextFormField(
            controller: controller.remarkController,
            decoration: InputDecoration(
              hintText: 'Add remark...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              contentPadding: EdgeInsets.all(16.r),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please add a remark';
              }
              return null;
            },
          ),

          SizedBox(height: 24.h),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.sendRemark(plantId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                disabledBackgroundColor: Colors.grey,
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}