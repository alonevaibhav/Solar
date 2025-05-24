import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Component/Inspector/plantInspectionView/dashboard_card.dart';
import '../../Component/Inspector/plantInspectionView/inspection_item.dart';
import '../../Component/Inspector/plantInspectionView/progress_chart.dart';
import '../../Component/Inspector/plantInspectionView/tickets_chart.dart';
import '../../Controller/Inspector/plant_inspection_controller.dart';

class PlantInspectionView extends GetView<PlantInspectionController> {
  const PlantInspectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title:  Text(
          'Plant Inspection Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                 Icon(Icons.notifications_outlined,size: 25.h,),
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
                    child:  Text(
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
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.errorMessage.value != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${controller.errorMessage.value}',
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
                            // _buildTicketsSection(),
                            SizedBox(height: 16.h),
                            _buildInspectionTabs(),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
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
                          controller.todaysInspections.value?['count']?.toString() ?? '0',
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
                    complete: (controller.todaysInspections.value?['status']
                                ?['complete'] ??
                            0)
                        .toDouble(),
                    cleaning: (controller.todaysInspections.value?['status']
                                ?['cleaning'] ??
                            0)
                        .toDouble(),
                    pending: (controller.todaysInspections.value?['status']
                                ?['pending'] ??
                            0)
                        .toDouble(),
                  ),
                ),
              ],
            ),
          ),
        ),
        // SizedBox(width: 16.w),
        // Expanded(
        //   child: DashboardCard(
        //     color: const Color(0xFFFF8A80),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Row(
        //               children: [
        //                 Container(
        //                   padding: EdgeInsets.all(8.w),
        //                   decoration: BoxDecoration(
        //                     color: Colors.red[100],
        //                     shape: BoxShape.circle,
        //                   ),
        //                   child: Icon(Icons.warning_amber, color: Colors.red, size: 20.sp),
        //                 ),
        //                 SizedBox(width: 8.w),
        //                 Text(
        //                   "Active Alerts",
        //                   style: TextStyle(
        //                     fontSize: 12.sp,
        //                     fontWeight: FontWeight.w500,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             Container(
        //               padding: EdgeInsets.all(4.w),
        //               decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 shape: BoxShape.circle,
        //               ),
        //               child: Icon(Icons.arrow_outward, color: Colors.blue, size: 16.sp),
        //             ),
        //           ],
        //         ),
        //         SizedBox(height: 6.h),
        //         Text(
        //           controller.activeAlerts.value?['count']?.toString() ?? '0',
        //           style: TextStyle(
        //             fontSize: 36.sp,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         SizedBox(height: 16.h),
        //         Expanded(
        //           child: ProgressChart(
        //             complete: (controller.activeAlerts.value?['status']?['priority'] ?? 0).toDouble(),
        //             cleaning: (controller.activeAlerts.value?['status']?['medium'] ?? 0).toDouble(),
        //             pending: (controller.activeAlerts.value?['status']?['minor'] ?? 0).toDouble(),
        //             colors: [
        //               Colors.purple,
        //               Colors.teal,
        //               Colors.blue,
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildTicketsSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: DashboardCard(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Tickets",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.bar_chart, color: Colors.grey, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          "42",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  height: 150.h,
                  child: TicketsChart(
                    highPriorityData: controller.todaysTickets
                            .value?['ticketsByPriority']?['high'] ??
                        [],
                    mediumPriorityData: controller.todaysTickets
                            .value?['ticketsByPriority']?['medium'] ??
                        [],
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTicketStatusCard(
                      "Open",
                      controller.todaysTickets.value?['open']?.toString() ??
                          '0',
                      "${controller.todaysTickets.value?['openPercentage']}%",
                    ),
                    _buildTicketStatusCard(
                      "Closed",
                      controller.todaysTickets.value?['closed']?.toString() ??
                          '0',
                      "${controller.todaysTickets.value?['closedPercentage']}%",
                      isPositive: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          flex: 2,
          child: DashboardCard(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Task Categories",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildCategoryProgressBar(
                  "HR",
                  controller.dashboardData.value?['ticketCategories']
                          ?['percentages']?[0] ??
                      0,
                ),
                SizedBox(height: 12.h),
                _buildCategoryProgressBar(
                  "Finance",
                  controller.dashboardData.value?['ticketCategories']?['percentages']?[1] ??
                      0,
                  color: Colors.amber,
                ),
                SizedBox(height: 12.h),
                _buildCategoryProgressBar(
                  "Tech",
                  controller.dashboardData.value?['ticketCategories']
                          ?['percentages']?[2] ??
                      0,
                  color: Colors.blue,
                ),
                SizedBox(height: 12.h),
                _buildCategoryProgressBar(
                  "Other",
                  controller.dashboardData.value?['ticketCategories']
                          ?['percentages']?[3] ??
                      0,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketStatusCard(String label, String count, String percentage,
      {bool isPositive = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
        Row(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isPositive ? Colors.green[50] : Colors.amber[50],
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                percentage,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isPositive ? Colors.green : Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryProgressBar(String label, double percentage,
      {Color color = Colors.amber}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8.h,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "$percentage%",
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey,
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
          child: Obx(
            () => Row(
              children: [
                _buildTab("Today's Inspection", 0),
                _buildTab("Pending Tickets", 1),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Obx(
          () => controller.selectedTabIndex.value == 0
              ? _buildInspectionItems()
              : _buildPendingTickets(),
        ),
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
              progress: (controller.inspectionItems[i]['progress'] ?? 0.0).toDouble(), // Convert to double
              eta: controller.inspectionItems[i]['eta'],
              color: Color(controller.inspectionItems[i]['color'] ?? 0xFFFF5252),
              onTap: () => controller.navigateToInspectionDetails(i),
            ),
          ),
      ],
    );
  }

  Widget _buildPendingTickets() {
    return Column(
      children: [
        for (final ticket in controller.pendingTickets)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: ticket['priority'] == 'high'
                          ? Colors.red[50]
                          : Colors.amber[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber,
                      color: ticket['priority'] == 'high'
                          ? Colors.red
                          : Colors.amber,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket['title'] ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "ID: ${ticket['id']}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      "Pending",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../Component/Inspector/plantInspectionView/dashboard_card.dart';
// import '../../Component/Inspector/plantInspectionView/inspection_item.dart';
// import '../../Component/Inspector/plantInspectionView/progress_chart.dart';
// import '../../Component/Inspector/plantInspectionView/tickets_chart.dart';
// import '../../Controller/Inspector/plant_inspection_controller.dart';
//
// class PlantInspectionView extends GetView<PlantInspectionController> {
//   const PlantInspectionView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text(
//           'Plant Inspection Dashboard',
//           style: TextStyle(fontWeight: FontWeight.w200),
//         ),
//         actions: [
//           IconButton(
//             icon: Stack(
//               children: [
//                 const Icon(Icons.notifications_outlined),
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     constraints: const BoxConstraints(
//                       minWidth: 16,
//                       minHeight: 16,
//                     ),
//                     child: const Text(
//                       '2',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Obx(
//             () => controller.isLoading.value
//             ? const Center(child: CircularProgressIndicator())
//             : controller.errorMessage.value != null
//             ? Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Error: ${controller.errorMessage.value}',
//                 style: TextStyle(color: Colors.red, fontSize: 16.sp),
//               ),
//               SizedBox(height: 16.h),
//               ElevatedButton(
//                 onPressed: controller.refreshDashboard,
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         )
//             : RefreshIndicator(
//           onRefresh: controller.refreshDashboard,
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             child: Padding(
//               padding: EdgeInsets.all(16.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   StatsSection(controller: controller),
//                   SizedBox(height: 16.h),
//                   // TicketsSection(controller: controller),
//                   SizedBox(height: 16.h),
//                   InspectionTabs(controller: controller),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class StatsSection extends StatelessWidget {
//   final PlantInspectionController controller;
//
//   const StatsSection({Key? key, required this.controller}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: DashboardCard(
//             color: const Color(0xFFFFD54F),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(8.w),
//                           decoration: BoxDecoration(
//                             color: Colors.amber[100],
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(Icons.list_alt,
//                               color: Colors.amber, size: 20.sp),
//                         ),
//                         SizedBox(width: 8.w),
//                         Text(
//                           "Today's Inspections : ",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Text(
//                           controller.todaysInspections.value?['count']?.toString() ?? '0',
//                           style: TextStyle(
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(4.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(Icons.arrow_outward,
//                           color: Colors.blue, size: 16.sp),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 11.h),
//                 Center(
//                   child: ProgressChart(
//                     complete: (controller.todaysInspections.value?['status']?['complete'] ?? 0).toDouble(),
//                     cleaning: (controller.todaysInspections.value?['status']?['cleaning'] ?? 0).toDouble(),
//                     pending: (controller.todaysInspections.value?['status']?['pending'] ?? 0).toDouble(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class TicketsSection extends StatelessWidget {
//   final PlantInspectionController controller;
//
//   const TicketsSection({Key? key, required this.controller}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 3,
//           child: DashboardCard(
//             color: Colors.white,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Today's Tickets",
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Icon(Icons.bar_chart, color: Colors.grey, size: 16.sp),
//                         SizedBox(width: 4.w),
//                         Text(
//                           "42",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),
//                 SizedBox(
//                   height: 150.h,
//                   child: TicketsChart(
//                     highPriorityData: controller.todaysTickets.value?['ticketsByPriority']?['high'] ?? [],
//                     mediumPriorityData: controller.todaysTickets.value?['ticketsByPriority']?['medium'] ?? [],
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TicketStatusCard(
//                       label: "Open",
//                       count: controller.todaysTickets.value?['open']?.toString() ?? '0',
//                       percentage: "${controller.todaysTickets.value?['openPercentage']}%",
//                     ),
//                     TicketStatusCard(
//                       label: "Closed",
//                       count: controller.todaysTickets.value?['closed']?.toString() ?? '0',
//                       percentage: "${controller.todaysTickets.value?['closedPercentage']}%",
//                       isPositive: true,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class TicketStatusCard extends StatelessWidget {
//   final String label;
//   final String count;
//   final String percentage;
//   final bool isPositive;
//
//   const TicketStatusCard({
//     Key? key,
//     required this.label,
//     required this.count,
//     required this.percentage,
//     this.isPositive = false,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12.sp,
//             color: Colors.grey,
//           ),
//         ),
//         Row(
//           children: [
//             Text(
//               count,
//               style: TextStyle(
//                 fontSize: 24.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(width: 8.w),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
//               decoration: BoxDecoration(
//                 color: isPositive ? Colors.green[50] : Colors.amber[50],
//                 borderRadius: BorderRadius.circular(4.r),
//               ),
//               child: Text(
//                 percentage,
//                 style: TextStyle(
//                   fontSize: 10.sp,
//                   color: isPositive ? Colors.green : Colors.amber,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class CategoryProgressBar extends StatelessWidget {
//   final String label;
//   final double percentage;
//   final Color color;
//
//   const CategoryProgressBar({
//     Key? key,
//     required this.label,
//     required this.percentage,
//     this.color = Colors.amber,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         SizedBox(height: 6.h),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(10.r),
//           child: LinearProgressIndicator(
//             value: percentage / 100,
//             backgroundColor: Colors.grey[200],
//             valueColor: AlwaysStoppedAnimation<Color>(color),
//             minHeight: 8.h,
//           ),
//         ),
//         SizedBox(height: 4.h),
//         Text(
//           "$percentage%",
//           style: TextStyle(
//             fontSize: 10.sp,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }
// }
// class InspectionTabs extends StatelessWidget {
//   final PlantInspectionController controller;
//
//   const InspectionTabs({Key? key, required this.controller}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12.r),
//           ),
//           child: Row(
//             children: [
//               TabItem(title: "Today's Inspection", index: 0, controller: controller),
//               TabItem(title: "Pending Tickets", index: 1, controller: controller),
//             ],
//           ),
//         ),
//         SizedBox(height: 16.h),
//         Obx(
//               () => controller.selectedTabIndex.value == 0
//               ? InspectionItems(controller: controller)
//               : PendingTickets(controller: controller),
//         ),
//       ],
//     );
//   }
// }
//
// class TabItem extends StatelessWidget {
//   final String title;
//   final int index;
//   final PlantInspectionController controller;
//
//   const TabItem({
//     Key? key,
//     required this.title,
//     required this.index,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isSelected = controller.selectedTabIndex.value == index;
//
//       return Expanded(
//         child: GestureDetector(
//           onTap: () => controller.changeTab(index),
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 16.h),
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: isSelected ? Colors.black : Colors.transparent,
//                   width: 2,
//                 ),
//               ),
//             ),
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 color: isSelected ? Colors.black : Colors.grey,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
//
// class InspectionItems extends StatelessWidget {
//   final PlantInspectionController controller;
//
//   const InspectionItems({Key? key, required this.controller}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         for (int i = 0; i < controller.inspectionItems.length; i++)
//           Padding(
//             padding: EdgeInsets.only(bottom: 12.h),
//             child: InspectionItem(
//               plantName: controller.inspectionItems[i]['plantName'] ?? '',
//               location: controller.inspectionItems[i]['location'] ?? '',
//               progress: (controller.inspectionItems[i]['progress'] ?? 0.0).toDouble(),
//               eta: controller.inspectionItems[i]['eta'],
//               color: Color(controller.inspectionItems[i]['color'] ?? 0xFFFF5252),
//               onTap: () => controller.navigateToInspectionDetails(i),
//             ),
//           ),
//       ],
//     );
//   }
// }
//
// class PendingTickets extends StatelessWidget {
//   final PlantInspectionController controller;
//
//   const PendingTickets({Key? key, required this.controller}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         for (final ticket in controller.pendingTickets)
//           Padding(
//             padding: EdgeInsets.only(bottom: 12.h),
//             child: Container(
//               padding: EdgeInsets.all(16.w),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12.r),
//                 border: Border.all(color: Colors.grey[200]!),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8.w),
//                     decoration: BoxDecoration(
//                       color: ticket['priority'] == 'high' ? Colors.red[50] : Colors.amber[50],
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.warning_amber,
//                       color: ticket['priority'] == 'high' ? Colors.red : Colors.amber,
//                       size: 20.sp,
//                     ),
//                   ),
//                   SizedBox(width: 16.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           ticket['title'] ?? '',
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 4.h),
//                         Text(
//                           "ID: ${ticket['id']}",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(16.r),
//                     ),
//                     child: Text(
//                       "Pending",
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
//
