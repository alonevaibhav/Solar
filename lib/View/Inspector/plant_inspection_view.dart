import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Component/Inspector/all_inspection_card.dart';
import '../../Component/Inspector/plantInspectionView/dashboard_card.dart';
import '../../Component/Inspector/plantInspectionView/inspection_item.dart';
import '../../Component/Inspector/plantInspectionView/progress_chart.dart';
import '../../Component/Inspector/plantInspectionView/tickets_chart.dart';
import '../../Component/Inspector/week_filter.dart';
import '../../Controller/Inspector/plant_inspection_controller.dart';

class PlantInspectionView extends GetView<PlantInspectionController> {
  const PlantInspectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Plant Inspection Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_outlined, size: 25.h),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.h,
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
        ],
      ),
      body: Obx(() => controller.isLoadingDashboard.value
          ? const Center(child: CircularProgressIndicator())
          : controller.errorMessageDashboard.value != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${controller.errorMessageDashboard.value}',
              style: TextStyle(color: Colors.red, fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: controller.refreshDashboard,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsSection(),
                SizedBox(height: 16.h),
                _buildInspectionTabs(),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: DashboardCard(
            color: const Color(0xFFF5C84F),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.list_alt,
                              color: Colors.amber, size: 20.sp),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Today's Inspections : ",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          controller.todaysInspections.value?['count']
                              ?.toString() ??
                              '0',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_outward,
                          color: Colors.blue, size: 16.sp),
                    ),
                  ],
                ),
                SizedBox(height: 11.h),
                Center(
                  child: ProgressChart(
                    complete: (controller.todaysInspections
                        .value?['status']?['complete'] ??
                        0)
                        .toDouble(),
                    cleaning: (controller.todaysInspections
                        .value?['status']?['cleaning'] ??
                        0)
                        .toDouble(),
                    pending: (controller.todaysInspections
                        .value?['status']?['pending'] ??
                        0)
                        .toDouble(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInspectionTabs() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Obx(() => Row(
            children: [
              _buildTab("Today's Inspection", 0),
            ],
          )),
        ),
        SizedBox(height: 16.h),
        Obx(() => _buildInspectionItems()),
      ],
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = controller.selectedTabIndex.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildInspectionItems() {
    return Column(
      children: [
        for (int i = 0; i < controller.inspectionItems.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: InspectionItem(
              plantName: controller.inspectionItems[i]['plantName'] ?? '',
              location: controller.inspectionItems[i]['location'] ?? '',
              progress:
              (controller.inspectionItems[i]['progress'] ?? 0.0).toDouble(),
              eta: controller.inspectionItems[i]['eta'],
              color: Color(controller.inspectionItems[i]['color'] ?? 0xFFFF5252),
              onTap: () => controller.navigateToInspectionDetails(i),
            ),
          ),
      ],
    );
  }
}
