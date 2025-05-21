import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/Component/Inspector/TicketPage/priority_banner.dart';
import '../../../Controller/Inspector/ticket_controller.dart';
import 'info_section.dart';

class TicketDetailView extends GetView<TicketController> {
  const TicketDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> ticketData = Get.arguments;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Issue Detail',
          style: TextStyle(
            fontSize: 16.2.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: () => controller.refreshTickets(),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null) {
          return Center(child: Text(controller.errorMessage.value!));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(14.4.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: OutlinedButton(
                  onPressed: () => controller.generateTicketImage(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.2.r),
                    ),
                  ),
                  child: Text(
                    'Generate Ticket Image',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.6.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14.4.h),

              PriorityBanner(
                priority: ticketData['priority'] ?? '',
                status: ticketData['status'] ?? '',
              ),
              SizedBox(height: 14.4.h),

              InfoCard(
                title: 'Assigned To',
                status: ticketData['status'] ?? '',
                children: [
                  _buildInfoRow('Name:', ticketData['name'] ?? ''),
                  _buildInfoRow('Phone:', ticketData['phone'] ?? ''),
                  _buildInfoRow('Opened:', ticketData['opened'] ?? ''),
                  if (ticketData['status'] == 'closed')
                    _buildInfoRow('Closed:', ticketData['closed'] ?? ''),
                ],
                onCallPressed: () => controller.callContact(ticketData['phone'] ?? ''),
              ),
              SizedBox(height: 14.4.h),

              _buildSection(
                'Title',
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticketData['title'] ?? '',
                        style: TextStyle(
                          fontSize: 14.4.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 7.2.h),
                      Text(
                        'Remark',
                        style: TextStyle(
                          fontSize: 12.6.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        ticketData['remark'] ?? '',
                        style: TextStyle(fontSize: 12.6.sp),
                      ),
                      SizedBox(height: 7.2.h),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 12.6.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        ticketData['description'] ?? '',
                        style: TextStyle(fontSize: 12.6.sp),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14.4.h),

              _buildSection(
                'Abc Plant Name',
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Auto Clean: ',
                            style: TextStyle(
                              fontSize: 12.6.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'hh:mm',
                            style: TextStyle(
                              fontSize: 12.6.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10.8.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10.8.w, vertical: 9.h),
                              child: Text(
                                ticketData['location'] ?? '',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 7.2.w),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.8.r),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.navigation, color: Colors.blue),
                              onPressed: () => controller.navigateToLocation(ticketData['location'] ?? ''),
                              tooltip: 'Navigate',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14.4.h),

              Container(
                padding: EdgeInsets.all(14.4.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4.5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 21.6.r,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 27.r,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(width: 10.8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Plant Owner Info',
                                style: TextStyle(
                                  fontSize: 14.4.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3.6.h),
                              Text(
                                'Name: Owner Name',
                                style: TextStyle(fontSize: 12.6.sp),
                              ),
                              Text(
                                'Phone: +91 8003373561',
                                style: TextStyle(fontSize: 12.6.sp),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.phone, color: Colors.blue),
                          onPressed: () => controller.callContact('+91 8003373561'),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.4.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.8.r),
                      ),
                      padding: EdgeInsets.all(14.4.r),
                      height: 135.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(21.6.r),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: TextField(
                              controller: controller.messageController,
                              decoration: InputDecoration(
                                hintText: 'Send message...',
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.4.w,
                                  vertical: 7.2.h,
                                ),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.send, color: Colors.black),
                                  onPressed: controller.sendMessage,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.4.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.8.r),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 14.4.w),
                      child: TextField(
                        controller: controller.remarkController,
                        decoration: InputDecoration(
                          hintText: 'Add remark...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 21.6.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.reopenTicket,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 14.4.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.8.r),
                    ),
                  ),
                  child: Text(
                    'Reopen Ticket',
                    style: TextStyle(
                      fontSize: 14.4.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Container(
      padding: EdgeInsets.all(14.4.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4.5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.4.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 7.2.h),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.6.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.6.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 3.6.w),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.6.sp,
            ),
          ),
        ],
      ),
    );
  }
}
