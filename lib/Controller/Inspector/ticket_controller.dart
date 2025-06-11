//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class TicketController extends GetxController {
//   // Observable variables for reactive state
//   final isLoading = false.obs;
//   final errorMessage = Rxn<String>();
//
//   // Direct storage of ticket data as Map<String, dynamic>
//   final tickets = <Map<String, dynamic>>[].obs;
//   final filteredTickets = <Map<String, dynamic>>[].obs;
//
//   var selectedTicketTab = 'all'.obs;
//   void setTicketTab(String tab) {
//     selectedTicketTab.value = tab;
//     // Add logic to filter tickets based on tab selection
//     // For example: filter by user ID for 'my' tickets
//   }
//
//   // Search and filter states
//   final searchQuery = ''.obs;
//   final selectedFilter = 'All'.obs;
//
//   // Filter visibility control
//   final showFilters = false.obs;
//
//   // Text controllers for ticket detail page
//   final messageController = TextEditingController();
//   final remarkController = TextEditingController();
//
//   // Current ticket data for detail page
//   final currentTicket = Rxn<Map<String, dynamic>>();
//
//   // Filter options
//   final filterOptions = [
//     'All',
//     'Priority High',
//     'Priority Low',
//     'Ticket Open',
//     'Ticket Closed',
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize data
//     fetchTickets();
//
//     // Set up reactive search
//     debounce(
//       searchQuery,
//           (_) => applyFilters(),
//       time: const Duration(milliseconds: 500),
//     );
//
//     // React to filter changes
//     ever(selectedFilter, (_) => applyFilters());
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//     // Additional setup after the widget is rendered
//   }
//
//   @override
//   void onClose() {
//     // Clean up resources
//     messageController.dispose();
//     remarkController.dispose();
//     super.onClose();
//   }
//
//   // Set search query
//   void setSearchQuery(String query) {
//     searchQuery.value = query;
//   }
//
//   // Set selected filter
//   void setSelectedFilter(String filter) {
//     selectedFilter.value = filter;
//   }
//
//   // Toggle filter options visibility
//   void toggleFilterVisibility() {
//     showFilters.value = !showFilters.value;
//   }
//
//   // Apply filters to the ticket list
//   void applyFilters() {
//     if (tickets.isEmpty) return;
//
//     // Start with all tickets
//     List<Map<String, dynamic>> result = List.from(tickets);
//
//     // Apply search filter if query is not empty
//     if (searchQuery.value.isNotEmpty) {
//       final query = searchQuery.value.toLowerCase();
//       result = result.where((ticket) {
//         return (ticket['title']?.toString().toLowerCase().contains(query) ??
//             false) ||
//             (ticket['description']?.toString().toLowerCase().contains(query) ??
//                 false) ||
//             (ticket['name']?.toString().toLowerCase().contains(query) ??
//                 false) ||
//             (ticket['location']?.toString().toLowerCase().contains(query) ??
//                 false);
//       }).toList();
//     }
//
//     // Apply category filter
//     if (selectedFilter.value != 'All') {
//       switch (selectedFilter.value) {
//         case 'Priority High':
//           result =
//               result.where((ticket) => ticket['priority'] == 'high').toList();
//           break;
//         case 'Priority Low':
//           result =
//               result.where((ticket) => ticket['priority'] == 'low').toList();
//           break;
//         case 'Ticket Open':
//           result =
//               result.where((ticket) => ticket['status'] == 'open').toList();
//           break;
//         case 'Ticket Closed':
//           result =
//               result.where((ticket) => ticket['status'] == 'closed').toList();
//           break;
//       }
//     }
//
//     // Update filtered tickets
//     filteredTickets.value = result;
//   }
//
//   // Fetch tickets from API
//   Future<void> fetchTickets() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = null;
//
//       // Mock API call - replace with actual API call
//       await Future.delayed(const Duration(seconds: 1));
//
//       // Sample mock data based on the provided screenshots
//       final response = [
//         {
//           'id': '1',
//           'title': 'Network Issue',
//           'description': 'Unable to connect to server',
//           'assignedTo': 'Tech Support',
//           'priority': 'high',
//           'status': 'closed',
//           'remark': 'Server restarted',
//           'name': 'John',
//           'phone': '+91 9876543210',
//           'opened': '20/2/25 2:25Pm',
//           'closed': '20/2/25 2:25Pm',
//           'location': 'XYZ-1 Pune Maharashtra(411052)',
//           'plantName': 'Abc Plant Name',
//           'autoClean': 'hh:mm',
//           'ownerName': 'Owner Name',
//           'ownerPhone': '+91 8003373561'
//         },
//         {
//           'id': '2',
//           'title': 'Software Update',
//           'description': 'Need to update application',
//           'assignedTo': 'Dev Team',
//           'priority': 'low',
//           'status': 'open',
//           'remark': 'Pending approval',
//           'name': 'John',
//           'phone': '+91 9876543210',
//           'opened': '20/2/25 2:25Pm',
//           'closed': '',
//           'location': 'XYZ-1 Pune Maharashtra(411052)',
//           'plantName': 'Abc Plant Name',
//           'autoClean': 'hh:mm',
//           'ownerName': 'Owner Name',
//           'ownerPhone': '+91 8003373561'
//         },
//         {
//           'id': '3',
//           'title': 'Hardware Replacement',
//           'description': 'Keyboard not working',
//           'assignedTo': 'Hardware Team',
//           'priority': 'high',
//           'status': 'open',
//           'remark': 'Ordered replacement',
//           'name': 'Sarah',
//           'phone': '+91 9876543211',
//           'opened': '19/2/25 10:15Am',
//           'closed': '',
//           'location': 'ABC-2 Mumbai Maharashtra(400001)',
//           'plantName': 'Abc Plant Name',
//           'autoClean': 'hh:mm',
//           'ownerName': 'Owner Name',
//           'ownerPhone': '+91 8003373561'
//         },
//         {
//           'id': '4',
//           'title': 'Access Request',
//           'description': 'Need access to database',
//           'assignedTo': 'Admin',
//           'priority': 'low',
//           'status': 'closed',
//           'remark': 'Access granted',
//           'name': 'Mike',
//           'phone': '+91 9876543212',
//           'opened': '18/2/25 9:30Am',
//           'closed': '18/2/25 2:45Pm',
//           'location': 'DEF-3 Bangalore Karnataka(560001)',
//           'plantName': 'Abc Plant Name',
//           'autoClean': 'hh:mm',
//           'ownerName': 'Owner Name',
//           'ownerPhone': '+91 8003373561'
//         },
//       ];
//
//       tickets.value = response;
//
//       // Apply initial filters
//       applyFilters();
//     } catch (e) {
//       errorMessage.value = 'Failed to load tickets: ${e.toString()}';
//       Get.snackbar(
//         'Error',
//         'Failed to load tickets',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Refresh ticket list
//   Future<void> refreshTickets() async {
//     await fetchTickets();
//   }
//
//   // Get ticket details
//   Map<String, dynamic>? getTicketDetails(String id) {
//     try {
//       return tickets.firstWhere((ticket) => ticket['id'] == id);
//     } catch (e) {
//       errorMessage.value = 'Ticket not found';
//       return null;
//     }
//   }
//
//   // Navigate to ticket details
//   void navigateToTicketDetails(String id) {
//     final ticket = getTicketDetails(id);
//     if (ticket != null) {
//       currentTicket.value = ticket;
//       Get.toNamed('/ticket-details', arguments: ticket);
//     }
//   }
//
//   // Call the ticket contact
//   void callContact(String phoneNumber) {
//     // In a real app, you would use url_launcher to make a phone call
//     Get.snackbar(
//       'Calling',
//       'Calling $phoneNumber',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   // Navigate to location
//   void navigateToLocation(String location) {
//     // In a real app, you would use maps integration
//     Get.snackbar(
//       'Navigation',
//       'Navigating to $location',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   // Send a message in the ticket detail view
//   Future<void> sendMessage() async {
//     if (messageController.text
//         .trim()
//         .isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please enter a message',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       // Mock API call - replace with actual API call
//       await Future.delayed(Duration(seconds: 1));
//
//       // In a real app, you would send the message to the API
//       Get.snackbar(
//         'Success',
//         'Message sent successfully',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//
//       // Clear the message input
//       messageController.clear();
//     } catch (e) {
//       errorMessage.value = 'Failed to send message: ${e.toString()}';
//       Get.snackbar(
//         'Error',
//         'Failed to send message',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Add a remark to the ticket
//   Future<void> addRemark() async {
//     if (remarkController.text
//         .trim()
//         .isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please enter a remark',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       // Mock API call - replace with actual API call
//       await Future.delayed(Duration(seconds: 1));
//
//       // In a real app, you would update the ticket with the new remark
//       if (currentTicket.value != null) {
//         final updatedTicket = Map<String, dynamic>.from(currentTicket.value!);
//         updatedTicket['remark'] = remarkController.text;
//
//         // Update the ticket in the list
//         final index = tickets.indexWhere((t) => t['id'] == updatedTicket['id']);
//         if (index != -1) {
//           tickets[index] = updatedTicket;
//           currentTicket.value = updatedTicket;
//         }
//
//         Get.snackbar(
//           'Success',
//           'Remark added successfully',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//
//         // Clear the remark input
//         remarkController.clear();
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to add remark: ${e.toString()}';
//       Get.snackbar(
//         'Error',
//         'Failed to add remark',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Reopen a closed ticket
//   Future<void> reopenTicket() async {
//     if (currentTicket.value == null) {
//       Get.snackbar(
//         'Error',
//         'No ticket selected',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     // Check if ticket is already open
//     if (currentTicket.value!['status'] == 'open') {
//       Get.snackbar(
//         'Information',
//         'Ticket is already open',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       // Mock API call - replace with actual API call
//       await Future.delayed(Duration(seconds: 1));
//
//       // Update the ticket status to open
//       final updatedTicket = Map<String, dynamic>.from(currentTicket.value!);
//       updatedTicket['status'] = 'open';
//       updatedTicket['closed'] = '';
//
//       // Update the ticket in the list
//       final index = tickets.indexWhere((t) => t['id'] == updatedTicket['id']);
//       if (index != -1) {
//         tickets[index] = updatedTicket;
//         currentTicket.value = updatedTicket;
//       }
//
//       Get.snackbar(
//         'Success',
//         'Ticket reopened successfully',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//
//       // Apply filters to update the filtered list
//       applyFilters();
//     } catch (e) {
//       errorMessage.value = 'Failed to reopen ticket: ${e.toString()}';
//       Get.snackbar(
//         'Error',
//         'Failed to reopen ticket',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Generate ticket image (mock functionality)
//   void generateTicketImage() {
//     Get.snackbar(
//       'Feature',
//       'Generating ticket image...',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//     // In a real app, you would generate an image of the ticket
//     // and allow the user to download or share it
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketController extends GetxController {
  // Observable variables for reactive state
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();


  // Separate storage for different ticket types
  final allTickets = <Map<String, dynamic>>[].obs;
  final myTickets = <Map<String, dynamic>>[].obs;
  final filteredTickets = <Map<String, dynamic>>[].obs;

  // Tab management
  var selectedTicketTab = 'all'.obs;

  // Search and filter states
  final searchQuery = ''.obs;
  final selectedFilter = 'All'.obs;

  // Filter visibility control
  final showFilters = false.obs;

  // Text controllers for ticket detail page
  final messageController = TextEditingController();
  final remarkController = TextEditingController();

  // Current ticket data for detail page
  final currentTicket = Rxn<Map<String, dynamic>>();

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
    // Initialize data - load both types
    fetchAllTickets();
    fetchMyTickets();

    // Set up reactive search
    debounce(
      searchQuery,
          (_) => applyFilters(),
      time: const Duration(milliseconds: 500),
    );

    // React to filter changes
    ever(selectedFilter, (_) => applyFilters());

    // React to tab changes
    ever(selectedTicketTab, (_) => applyFilters());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    messageController.dispose();
    remarkController.dispose();
    super.onClose();
  }

  // Set ticket tab and refresh data
  void setTicketTab(String tab) {
    selectedTicketTab.value = tab;

    // Optionally refetch data when switching tabs
    if (tab == 'all' && allTickets.isEmpty) {
      fetchAllTickets();
    } else if (tab == 'my' && myTickets.isEmpty) {
      fetchMyTickets();
    }
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

  // Apply filters to the current ticket list
  void applyFilters() {
    // Get current data source based on selected tab
    List<Map<String, dynamic>> currentTickets = selectedTicketTab.value == 'all'
        ? allTickets
        : myTickets;

    if (currentTickets.isEmpty) {
      filteredTickets.clear();
      return;
    }

    // Start with current tickets
    List<Map<String, dynamic>> result = List.from(currentTickets);

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

  // Fetch ALL tickets from API
  Future<void> fetchAllTickets() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // Replace with your actual API call
      // Example: final response = await ApiService.getAllTickets();

      // Mock API call
      await Future.delayed(const Duration(seconds: 1));

      // Sample mock data for ALL tickets
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
          'location': 'XYZ-1 Pune Maharashtra(411052)',
          'plantName': 'Abc Plant Name',
          'autoClean': 'hh:mm',
          'ownerName': 'Owner Name',
          'ownerPhone': '+91 8003373561',
          'assignedBy': 'Admin'
        },
        {
          'id': '2',
          'title': 'Software Update',
          'description': 'Need to update application',
          'assignedTo': 'Dev Team',
          'priority': 'low',
          'status': 'open',
          'remark': 'Pending approval',
          'name': 'Sarah',
          'phone': '+91 9876543210',
          'opened': '20/2/25 2:25Pm',
          'closed': '',
          'location': 'XYZ-1 Pune Maharashtra(411052)',
          'plantName': 'Abc Plant Name',
          'autoClean': 'hh:mm',
          'ownerName': 'Owner Name',
          'ownerPhone': '+91 8003373561',
          'assignedBy': 'Manager'
        },
        {
          'id': '3',
          'title': 'Hardware Replacement',
          'description': 'Keyboard not working',
          'assignedTo': 'Hardware Team',
          'priority': 'high',
          'status': 'open',
          'remark': 'Ordered replacement',
          'name': 'Mike',
          'phone': '+91 9876543211',
          'opened': '19/2/25 10:15Am',
          'closed': '',
          'location': 'ABC-2 Mumbai Maharashtra(400001)',
          'plantName': 'Xyz Plant Name',
          'autoClean': 'hh:mm',
          'ownerName': 'Owner Name',
          'ownerPhone': '+91 8003373561',
          'assignedBy': 'Admin'
        },
      ];

      allTickets.value = response;

      // Apply initial filters if current tab is 'all'
      if (selectedTicketTab.value == 'all') {
        applyFilters();
      }
    } catch (e) {
      errorMessage.value = 'Failed to load all tickets: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to load all tickets',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch MY tickets from API (tickets assigned to current user)
  Future<void> fetchMyTickets() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // Replace with your actual API call
      // Example: final response = await ApiService.getMyTickets(userId);

      // Mock API call
      await Future.delayed(const Duration(seconds: 1));

      // Sample mock data for MY tickets (subset of all tickets assigned to current user)
      final response = [
        {
          'id': '4',
          'title': 'My Network Issue',
          'description': 'Personal network troubleshooting',
          'assignedTo': 'Current User', // This would be current user ID/name
          'priority': 'high',
          'status': 'open',
          'remark': 'Working on it',
          'name': 'Alice',
          'phone': '+91 9876543212',
          'opened': '21/2/25 10:00Am',
          'closed': '',
          'location': 'DEF-3 Bangalore Karnataka(560001)',
          'plantName': 'My Plant Name',
          'autoClean': 'hh:mm',
          'ownerName': 'Owner Name',
          'ownerPhone': '+91 8003373561',
          'assignedBy': 'Manager'
        },
        {
          'id': '5',
          'title': 'My Software Bug',
          'description': 'Bug in my assigned module',
          'assignedTo': 'Current User',
          'priority': 'low',
          'status': 'closed',
          'remark': 'Fixed and deployed',
          'name': 'Bob',
          'phone': '+91 9876543213',
          'opened': '19/2/25 9:00Am',
          'closed': '20/2/25 5:00Pm',
          'location': 'GHI-4 Chennai Tamil Nadu(600001)',
          'plantName': 'My Plant Name',
          'autoClean': 'hh:mm',
          'ownerName': 'Owner Name',
          'ownerPhone': '+91 8003373561',
          'assignedBy': 'Admin'
        },
      ];

      myTickets.value = response;

      // Apply initial filters if current tab is 'my'
      if (selectedTicketTab.value == 'my') {
        applyFilters();
      }
    } catch (e) {
      errorMessage.value = 'Failed to load my tickets: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to load my tickets',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch tickets (legacy method - now calls both)
  Future<void> fetchTickets() async {
    await Future.wait([
      fetchAllTickets(),
      fetchMyTickets(),
    ]);
  }

  // Refresh ticket list based on current tab
  Future<void> refreshTickets() async {
    if (selectedTicketTab.value == 'all') {
      await fetchAllTickets();
    } else {
      await fetchMyTickets();
    }
  }

  // Refresh both ticket lists
  Future<void> refreshAllTickets() async {
    await Future.wait([
      fetchAllTickets(),
      fetchMyTickets(),
    ]);
  }

  // Get current tickets based on selected tab
  List<Map<String, dynamic>> get currentTickets {
    return selectedTicketTab.value == 'all' ? allTickets : myTickets;
  }

  // Get ticket details from current data source
  Map<String, dynamic>? getTicketDetails(String id) {
    try {
      return currentTickets.firstWhere((ticket) => ticket['id'] == id);
    } catch (e) {
      // Try searching in both lists
      try {
        return allTickets.firstWhere((ticket) => ticket['id'] == id);
      } catch (e) {
        try {
          return myTickets.firstWhere((ticket) => ticket['id'] == id);
        } catch (e) {
          errorMessage.value = 'Ticket not found';
          return null;
        }
      }
    }
  }

  // Navigate to ticket details
  void navigateToTicketDetails(String id) {
    final ticket = getTicketDetails(id);
    if (ticket != null) {
      currentTicket.value = ticket;
      Get.toNamed('/ticket-details', arguments: ticket);
    }
  }

  // Call the ticket contact
  void callContact(String phoneNumber) {
    Get.snackbar(
      'Calling',
      'Calling $phoneNumber',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Navigate to location
  void navigateToLocation(String location) {
    Get.snackbar(
      'Navigation',
      'Navigating to $location',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Send a message in the ticket detail view
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a message',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Message sent successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      messageController.clear();
    } catch (e) {
      errorMessage.value = 'Failed to send message: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Add a remark to the ticket
  Future<void> addRemark() async {
    if (remarkController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a remark',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 1));

      if (currentTicket.value != null) {
        final updatedTicket = Map<String, dynamic>.from(currentTicket.value!);
        updatedTicket['remark'] = remarkController.text;

        // Update in both lists if present
        final allIndex = allTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
        if (allIndex != -1) {
          allTickets[allIndex] = updatedTicket;
        }

        final myIndex = myTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
        if (myIndex != -1) {
          myTickets[myIndex] = updatedTicket;
        }

        currentTicket.value = updatedTicket;
        applyFilters(); // Refresh filtered list

        Get.snackbar(
          'Success',
          'Remark added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        remarkController.clear();
      }
    } catch (e) {
      errorMessage.value = 'Failed to add remark: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to add remark',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Reopen a closed ticket
  Future<void> reopenTicket() async {
    if (currentTicket.value == null) {
      Get.snackbar(
        'Error',
        'No ticket selected',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (currentTicket.value!['status'] == 'open') {
      Get.snackbar(
        'Information',
        'Ticket is already open',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 1));

      final updatedTicket = Map<String, dynamic>.from(currentTicket.value!);
      updatedTicket['status'] = 'open';
      updatedTicket['closed'] = '';

      // Update in both lists if present
      final allIndex = allTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
      if (allIndex != -1) {
        allTickets[allIndex] = updatedTicket;
      }

      final myIndex = myTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
      if (myIndex != -1) {
        myTickets[myIndex] = updatedTicket;
      }

      currentTicket.value = updatedTicket;
      applyFilters(); // Refresh filtered list

      Get.snackbar(
        'Success',
        'Ticket reopened successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Failed to reopen ticket: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to reopen ticket',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Generate ticket image (mock functionality)
  void generateTicketImage() {
    Get.snackbar(
      'Feature',
      'Generating ticket image...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}