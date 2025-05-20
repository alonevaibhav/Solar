import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketController extends GetxController {
  // Observable variables for reactive state
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  // Direct storage of ticket data as Map<String, dynamic>
  final tickets = <Map<String, dynamic>>[].obs;
  final filteredTickets = <Map<String, dynamic>>[].obs;

  // Search and filter states
  final searchQuery = ''.obs;
  final selectedFilter = 'All'.obs;

  // Filter visibility control
  final showFilters = false.obs;

  // Filter options
  final filterOptions = [
    'All',
    'Priority High',
    'Priority Low',
    'Ticket Open',
    'Ticket Closed',
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize data
    fetchTickets();

    // Set up reactive search
    debounce(
      searchQuery,
          (_) => applyFilters(),
      time: const Duration(milliseconds: 500),
    );

    // React to filter changes
    ever(selectedFilter, (_) => applyFilters());
  }

  @override
  void onReady() {
    super.onReady();
    // Additional setup after the widget is rendered
  }

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }

  // Set search query
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Set selected filter
  void setSelectedFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Toggle filter options visibility
  void toggleFilterVisibility() {
    showFilters.value = !showFilters.value;
  }

  // Apply filters to the ticket list
  void applyFilters() {
    if (tickets.isEmpty) return;

    // Start with all tickets
    List<Map<String, dynamic>> result = List.from(tickets);

    // Apply search filter if query is not empty
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((ticket) {
        return (ticket['title']?.toString().toLowerCase().contains(query) ?? false) ||
            (ticket['description']?.toString().toLowerCase().contains(query) ?? false) ||
            (ticket['name']?.toString().toLowerCase().contains(query) ?? false) ||
            (ticket['location']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply category filter
    if (selectedFilter.value != 'All') {
      switch (selectedFilter.value) {
        case 'Priority High':
          result = result.where((ticket) => ticket['priority'] == 'high').toList();
          break;
        case 'Priority Low':
          result = result.where((ticket) => ticket['priority'] == 'low').toList();
          break;
        case 'Ticket Open':
          result = result.where((ticket) => ticket['status'] == 'open').toList();
          break;
        case 'Ticket Closed':
          result = result.where((ticket) => ticket['status'] == 'closed').toList();
          break;
      }
    }

    // Update filtered tickets
    filteredTickets.value = result;
  }

  // Fetch tickets from API
  Future<void> fetchTickets() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // Mock API call - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Sample mock data based on the provided screenshots
      final response = [
        {
          'id': '1',
          'title': 'Network Issue',
          'description': 'Unable to connect to server',
          'assignedTo': 'Tech Support',
          'priority': 'high',
          'status': 'closed',
          'remark': 'Server restarted',
          'name': 'John',
          'phone': '+91 9876543210',
          'opened': '20/2/25 2:25Pm',
          'closed': '20/2/25 2:25Pm',
          'location': 'XYZ-1 Pune Maharashtra(411052)'
        },
        {
          'id': '2',
          'title': 'Software Update',
          'description': 'Need to update application',
          'assignedTo': 'Dev Team',
          'priority': 'low',
          'status': 'open',
          'remark': 'Pending approval',
          'name': 'John',
          'phone': '+91 9876543210',
          'opened': '20/2/25 2:25Pm',
          'closed': '',
          'location': 'XYZ-1 Pune Maharashtra(411052)'
        },
        {
          'id': '3',
          'title': 'Hardware Replacement',
          'description': 'Keyboard not working',
          'assignedTo': 'Hardware Team',
          'priority': 'high',
          'status': 'open',
          'remark': 'Ordered replacement',
          'name': 'Sarah',
          'phone': '+91 9876543211',
          'opened': '19/2/25 10:15Am',
          'closed': '',
          'location': 'ABC-2 Mumbai Maharashtra(400001)'
        },
        {
          'id': '4',
          'title': 'Access Request',
          'description': 'Need access to database',
          'assignedTo': 'Admin',
          'priority': 'low',
          'status': 'closed',
          'remark': 'Access granted',
          'name': 'Mike',
          'phone': '+91 9876543212',
          'opened': '18/2/25 9:30Am',
          'closed': '18/2/25 2:45Pm',
          'location': 'DEF-3 Bangalore Karnataka(560001)'
        },
      ];

      tickets.value = response;

      // Apply initial filters
      applyFilters();

    } catch (e) {
      errorMessage.value = 'Failed to load tickets: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to load tickets',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh ticket list
  Future<void> refreshTickets() async {
    await fetchTickets();
  }

  // Get ticket details
  Map<String, dynamic>? getTicketDetails(String id) {
    try {
      return tickets.firstWhere((ticket) => ticket['id'] == id);
    } catch (e) {
      errorMessage.value = 'Ticket not found';
      return null;
    }
  }

  // Navigate to ticket details
  void navigateToTicketDetails(String id) {
    final ticket = getTicketDetails(id);
    if (ticket != null) {
      Get.toNamed('/ticket-details', arguments: ticket);
    }
  }

  // Call the ticket contact
  void callContact(String phoneNumber) {
    // In a real app, you would use url_launcher to make a phone call
    Get.snackbar(
      'Calling',
      'Calling $phoneNumber',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Navigate to location
  void navigateToLocation(String location) {
    // In a real app, you would use maps integration
    Get.snackbar(
      'Navigation',
      'Navigating to $location',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}