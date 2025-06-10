import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Component/Inspector/plantInspectionView/inspection_item.dart';
import '../../Controller/Inspector/plant_inspection_controller.dart';

class PlantInspectionView extends GetView<PlantInspectionController> {
  const PlantInspectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF8F9FA), // Professional light grey background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Plant Inspection Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.2.sp,
            color: const Color(0xFF2D3748), // Dark grey text
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 25.2.h,
                  color: const Color(0xFF718096), // Medium grey
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1.8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF48BB78), // Green for notifications
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14.4,
                      minHeight: 14.4,
                    ),
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          SizedBox(width: 7.2.w),
        ],
      ),
      body: Obx(() => controller.isLoadingDashboard.value
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(const Color(0xFF718096)),
            ),
            SizedBox(height: 14.4.h),
            Text(
              'Loading inspection data...',
              style: TextStyle(
                fontSize: 14.4.sp,
                color: const Color(0xFF718096),
              ),
            ),
          ],
        ),
      )
          : controller.errorMessageDashboard.value != null
          ? Center(
        child: Container(
          margin: EdgeInsets.all(18.0.w),
          padding: EdgeInsets.all(21.6.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.4.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE2E8F0),
                blurRadius: 9.0,
                offset: const Offset(0, 3.6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 57.6.sp,
                color: const Color(0xFFF56565), // Professional red
              ),
              SizedBox(height: 14.4.h),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 16.2.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 7.2.h),
              Text(
                controller.errorMessageDashboard.value.toString(),
                style: TextStyle(
                  fontSize: 12.6.sp,
                  color: const Color(0xFF718096),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 21.6.h),
              ElevatedButton.icon(
                onPressed: controller.refreshDashboard,
                icon: Icon(Icons.refresh),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF718096),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 21.6.w,
                    vertical: 10.8.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.8.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        color: const Color(0xFF718096),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(18.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsSection(),
                SizedBox(height: 21.6.h),
                _buildInspectionTabs(),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE2E8F0).withOpacity(0.6),
            blurRadius: 8.0,
            offset: const Offset(0, 2.0),
            spreadRadius: 0.5,
          ),
        ],
        border: Border.all(
          color: const Color(0xFFF7FAFC),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact header section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),
                      child: Icon(
                        Icons.assessment,
                        color: const Color(0xFF4A5568),
                        size: 20.0.sp,
                      ),
                    ),
                    SizedBox(width: 12.0.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Inspections",
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3748),
                            ),
                          ),
                          SizedBox(height: 2.0.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                controller.todaysInspections.value?['count']?.toString() ?? '0',
                                style: TextStyle(
                                  fontSize: 24.0.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A202C),
                                ),
                              ),
                              SizedBox(width: 4.0.w),
                              Padding(
                                padding: EdgeInsets.only(bottom: 2.0.h),
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    color: const Color(0xFF718096),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Status cards section - more compact
          if (controller.todaysInspections.value?['status'] != null) ...[
            SizedBox(height: 12.0.h),
            _buildCompactStatusCards(),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactStatusCards() {
    final status = controller.todaysInspections.value!['status'] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.all(12.0.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(12.0.r),
        border: Border.all(
          color: const Color(0xFFEDF2F7),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCompactStatusItem(
              'Complete',
              status['complete']?.toString() ?? '0',
              const Color(0xFF48BB78),
              Icons.check_circle_outline,
            ),
          ),
          Container(
            width: 1,
            height: 30.h,
            color: const Color(0xFFE2E8F0),
            margin: EdgeInsets.symmetric(horizontal: 8.0.w),
          ),
          Expanded(
            child: _buildCompactStatusItem(
              'Pending',
              status['pending']?.toString() ?? '0',
              const Color(0xFF718096),
              Icons.schedule_outlined,
            ),
          ),
          Container(
            width: 1,
            height: 30.h,
            color: const Color(0xFFE2E8F0),
            margin: EdgeInsets.symmetric(horizontal: 8.0.w),
          ),
          Expanded(
            child: _buildCompactStatusItem(
              'Cleaning',
              status['cleaning']?.toString() ?? '0',
              const Color(0xFF3182CE),
              Icons.cleaning_services_outlined,
            ),
          ),
          Container(
            width: 1,
            height: 30.h,
            color: const Color(0xFFE2E8F0),
            margin: EdgeInsets.symmetric(horizontal: 8.0.w),
          ),
          Expanded(
            child: _buildCompactStatusItem(
              'Failed',
              status['failed']?.toString() ?? '0',
              const Color(0xFFE53E3E),
              Icons.error_outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatusItem(String title, String count, Color color, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 16.0.sp,
        ),
        SizedBox(height: 4.0.h),
        Text(
          count,
          style: TextStyle(
            fontSize: 16.0.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 2.0.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 9.0.sp,
            color: const Color(0xFF718096),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildInspectionTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scheduled Inspections',
          style: TextStyle(
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 14.4.h),
        // Independent inspection items - no longer inside the white container
        _buildInspectionItems(),
      ],
    );
  }

  Widget _buildInspectionItems() {
    if (controller.inspectionItems.isEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(36.0.w),
          child: Column(
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 57.6.sp,
                color: const Color(0xFFE2E8F0),
              ),
              SizedBox(height: 14.4.h),
              Text(
                'No inspections scheduled',
                style: TextStyle(
                  fontSize: 14.4.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF718096),
                ),
              ),
              SizedBox(height: 7.2.h),
              Text(
                'Pull down to refresh',
                style: TextStyle(
                  fontSize: 12.6.sp,
                  color: const Color(0xFFA0AEC0),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < controller.inspectionItems.length; i++)
          InspectionItem(
            inspectionData: controller.inspectionItems[i],
            onTap: () async {
              // Get the specific item's ID
              int specificItemId = controller.inspectionItems[i]['id'];

              // Fetch inspection data for the specific item
              await controller.fetchInspectorData(specificItemId);

              // Navigate to inspection details after fetching data
              controller.navigateToInspectionDetails(controller.inspectionItems[i]);
            },
          ),
      ],
    );
  }
}