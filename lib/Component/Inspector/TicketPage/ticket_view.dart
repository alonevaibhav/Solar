import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_app/Component/Inspector/TicketPage/ticket_card.dart';
import '../../../Controller/Inspector/ticket_controller.dart';


class TicketView extends GetView<TicketController> {
  const TicketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildFilterOptions(),
            Expanded(
              child: _buildTicketList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: TextField(
                onChanged: controller.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search Area...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: Color(0xFFFFD380),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TextButton.icon(
              onPressed: () {
                // Handle history button press
                Get.snackbar(
                  'History',
                  'Viewing ticket history',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: Icon(Icons.history, color: Colors.black),
              label: Text(
                'History',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFilterOptions() {
    return Obx(() => Column(
      children: [
        // Sort button
        GestureDetector(
          onTap: () => controller.toggleFilterVisibility(),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.filter_list, size: 20.sp, color: Colors.grey[700]),
                    SizedBox(width: 8.w),
                    Text(
                      'Sort',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                Icon(
                  controller.showFilters.value ? Icons.expand_less : Icons.expand_more,
                  size: 20.sp,
                  color: Colors.grey[700],
                ),
              ],
            ),
          ),
        ),

        // Filter options (only visible when showFilters is true)
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: controller.showFilters.value ? null : 0,
          color: Colors.white,
          padding: EdgeInsets.only(bottom: 8.h),
          child: controller.showFilters.value
              ? Column(
            children: [
              // Divider
              Divider(height: 1, thickness: 1, color: Colors.grey[200]),

              // Filter options list
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  children: [
                    // Priority High
                    _buildFilterOption(
                      'All',
                      Colors.blue,
                      controller.selectedFilter.value == 'All',
                    ),
                    Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                    _buildFilterOption(
                      'Priority High',
                      Colors.red,
                      controller.selectedFilter.value == 'Priority High',
                    ),
                    Divider(height: 1, thickness: 1, color: Colors.grey[200]),

                    // Priority Low
                    _buildFilterOption(
                      'Priority Low',
                      Colors.amber,
                      controller.selectedFilter.value == 'Priority Low',
                    ),
                    Divider(height: 1, thickness: 1, color: Colors.grey[200]),

                    // Ticket Open
                    _buildFilterOption(
                      'Ticket Open',
                      Colors.orange,
                      controller.selectedFilter.value == 'Ticket Open',
                    ),
                    Divider(height: 1, thickness: 1, color: Colors.grey[200]),

                    // Ticket Closed
                    _buildFilterOption(
                      'Ticket Closed',
                      Colors.green,
                      controller.selectedFilter.value == 'Ticket Closed',
                    ),
                  ],
                ),
              ),
            ],
          )
              : SizedBox.shrink(),
        ),
      ],
    ));
  }

// Helper method to build filter option item
  Widget _buildFilterOption(String filter, Color color, bool isSelected) {
    return InkWell(
      onTap: () {
        controller.setSelectedFilter(filter);
        controller.toggleFilterVisibility(); // Hide filter options after selection
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              filter,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
            if (isSelected)
              Icon(Icons.check, color: color),
          ],
        ),
      ),
    );
  }


  Widget _buildTicketList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${controller.errorMessage.value}',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: controller.refreshTickets,
                child: Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.filteredTickets.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.refreshTickets,
          child: ListView(
            children: [
              SizedBox(height: 100.h),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 64.sp, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text(
                      'No tickets found',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshTickets,
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.filteredTickets.length,
          itemBuilder: (context, index) {
            final ticket = controller.filteredTickets[index];
            return TicketCardWidget(
              ticket: ticket,
              onCallPressed: controller.callContact,
              onNavigatePressed: controller.navigateToLocation,
            );
          },
        ),
      );
    });
  }
}