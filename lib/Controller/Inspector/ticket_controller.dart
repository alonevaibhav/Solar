//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../API Service/Model/Request/ticket_model.dart';
// import '../../API Service/api_service.dart';
//
// class TicketController extends GetxController {
//   // Observable variables for reactive state
//   final isLoading = false.obs;
//   final errorMessage = Rxn<String>();
//
//
//   // Separate storage for different ticket types
//   final allTickets = <Map<String, dynamic>>[].obs;
//   final myTickets = <Map<String, dynamic>>[].obs;
//   final filteredTickets = <Map<String, dynamic>>[].obs;
//
//   // Tab management
//   var selectedTicketTab = 'all'.obs;
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
//     // Initialize data - load both types
//     fetchAllTickets();
//     fetchMyTickets();
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
//
//     // React to tab changes
//     ever(selectedTicketTab, (_) => applyFilters());
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//   }
//
//   @override
//   void onClose() {
//     messageController.dispose();
//     remarkController.dispose();
//     super.onClose();
//   }
//
//   // Set ticket tab and refresh data
//   void setTicketTab(String tab) {
//     selectedTicketTab.value = tab;
//
//     // Optionally refetch data when switching tabs
//     if (tab == 'all' && allTickets.isEmpty) {
//       fetchAllTickets();
//     } else if (tab == 'my' && myTickets.isEmpty) {
//       fetchMyTickets();
//     }
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
//   // Apply filters to the current ticket list
//   void applyFilters() {
//     // Get current data source based on selected tab
//     List<Map<String, dynamic>> currentTickets = selectedTicketTab.value == 'all'
//         ? allTickets
//         : myTickets;
//
//     if (currentTickets.isEmpty) {
//       filteredTickets.clear();
//       return;
//     }
//
//     // Start with current tickets
//     List<Map<String, dynamic>> result = List.from(currentTickets);
//
//     // Apply search filter if query is not empty
//     if (searchQuery.value.isNotEmpty) {
//       final query = searchQuery.value.toLowerCase();
//       result = result.where((ticket) {
//         return (ticket['title']?.toString().toLowerCase().contains(query) ?? false) ||
//             (ticket['description']?.toString().toLowerCase().contains(query) ?? false) ||
//             (ticket['name']?.toString().toLowerCase().contains(query) ?? false) ||
//             (ticket['location']?.toString().toLowerCase().contains(query) ?? false);
//       }).toList();
//     }
//
//     // Apply category filter
//     if (selectedFilter.value != 'All') {
//       switch (selectedFilter.value) {
//         case 'Priority High':
//           result = result.where((ticket) => ticket['priority'] == 'high').toList();
//           break;
//         case 'Priority Low':
//           result = result.where((ticket) => ticket['priority'] == 'low').toList();
//           break;
//         case 'Ticket Open':
//           result = result.where((ticket) => ticket['status'] == 'open').toList();
//           break;
//         case 'Ticket Closed':
//           result = result.where((ticket) => ticket['status'] == 'closed').toList();
//           break;
//       }
//     }
//
//     // Update filtered tickets
//     filteredTickets.value = result;
//   }
//
//   // Fetch ALL tickets from API
//   Future<void> fetchAllTickets() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = null;
//
//       final inspectorId = await ApiService.getUid();
//
//       if (inspectorId == null) {
//         throw Exception('No UID found');
//       }
//
//       final response = await ApiService.get<TicketsResponse>(
//         endpoint: "/api/tickets/inspector/$inspectorId",
//         fromJson: (json) => TicketsResponse.fromJson(json),
//       );
//
//       if (response.success && response.data != null) {
//         allTickets.value = response.data!.tickets.map((ticket) {
//           return {
//             'id': ticket.id.toString(),
//             'title': ticket.title,
//             'description': ticket.description,
//             'plant_id': ticket.plantId,
//             'user_id': ticket.userId,
//             'inspector_id': ticket.inspectorId,
//             'distributor_admin_id': ticket.distributorAdminId,
//             'department': ticket.department,
//             'created_by': ticket.createdBy,
//             'creator_type': ticket.creatorType,
//             'ticket_type': ticket.ticketType,
//             'cleaning_id': ticket.cleaningId,
//             'status': ticket.status,
//             'createdAt': ticket.createdAt.toString(),
//             'updatedAt': ticket.updatedAt.toString(),
//             'priority': ticket.priority == '2' ? 'high' : 'low',
//             'assigned_to': ticket.assignedTo,
//             'ip': ticket.ip,
//             'creator_name': ticket.creatorName,
//             'inspector_assigned': ticket.inspectorAssigned,
//             'chat_count': ticket.chatCount,
//             'location': 'Location details', // Placeholder, update as needed
//             'phone': 'Phone details', // Placeholder, update as needed
//             'remark': 'Remark details', // Placeholder, update as needed
//           };
//         }).toList();
//
//         if (selectedTicketTab.value == 'all') {
//           applyFilters();
//         }
//       } else {
//         errorMessage.value = response.errorMessage ?? 'Failed to load all tickets';
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to load all tickets: ${e.toString()}';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> fetchMyTickets() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = null;
//
//       final inspectorId = await ApiService.getUid();
//
//       if (inspectorId == null) {
//         throw Exception('No UID found');
//       }
//
//       final response = await ApiService.get<TicketsResponse>(
//         endpoint: "/api/tickets/created-by-inspector/$inspectorId",
//         fromJson: (json) => TicketsResponse.fromJson(json),
//       );
//
//       if (response.success && response.data != null) {
//         myTickets.value = response.data!.tickets.map((ticket) {
//           return {
//             'id': ticket.id.toString(),
//             'title': ticket.title,
//             'description': ticket.description,
//             'plant_id': ticket.plantId,
//             'user_id': ticket.userId,
//             'inspector_id': ticket.inspectorId,
//             'distributor_admin_id': ticket.distributorAdminId,
//             'department': ticket.department,
//             'created_by': ticket.createdBy,
//             'creator_type': ticket.creatorType,
//             'ticket_type': ticket.ticketType,
//             'cleaning_id': ticket.cleaningId,
//             'status': ticket.status,
//             'createdAt': ticket.createdAt.toString(),
//             'updatedAt': ticket.updatedAt.toString(),
//             'priority': ticket.priority == '2' ? 'high' : 'low',
//             'assigned_to': ticket.assignedTo,
//             'ip': ticket.ip,
//             'creator_name': ticket.creatorName,
//             'inspector_assigned': ticket.inspectorAssigned,
//             'chat_count': ticket.chatCount,
//             'location': 'Location details', // Placeholder, update as needed
//             'phone': 'Phone details', // Placeholder, update as needed
//             'remark': 'Remark details', // Placeholder, update as needed
//           };
//         }).toList();
//
//         if (selectedTicketTab.value == 'my') {
//           applyFilters();
//         }
//       } else {
//         errorMessage.value = response.errorMessage ?? 'Failed to load my tickets';
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to load my tickets: ${e.toString()}';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//
//   // Fetch tickets (legacy method - now calls both)
//   Future<void> fetchTickets() async {
//     await Future.wait([
//       fetchAllTickets(),
//       fetchMyTickets(),
//     ]);
//   }
//
//   // Refresh ticket list based on current tab
//   Future<void> refreshTickets() async {
//     if (selectedTicketTab.value == 'all') {
//       await fetchAllTickets();
//     } else {
//       await fetchMyTickets();
//     }
//   }
//
//   // Refresh both ticket lists
//   Future<void> refreshAllTickets() async {
//     await Future.wait([
//       fetchAllTickets(),
//       fetchMyTickets(),
//     ]);
//   }
//
//   // Get current tickets based on selected tab
//   List<Map<String, dynamic>> get currentTickets {
//     return selectedTicketTab.value == 'all' ? allTickets : myTickets;
//   }
//
//   // Get ticket details from current data source
//   Map<String, dynamic>? getTicketDetails(String id) {
//     try {
//       return currentTickets.firstWhere((ticket) => ticket['id'] == id);
//     } catch (e) {
//       // Try searching in both lists
//       try {
//         return allTickets.firstWhere((ticket) => ticket['id'] == id);
//       } catch (e) {
//         try {
//           return myTickets.firstWhere((ticket) => ticket['id'] == id);
//         } catch (e) {
//           errorMessage.value = 'Ticket not found';
//           return null;
//         }
//       }
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
//     Get.snackbar(
//       'Calling',
//       'Calling $phoneNumber',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   // Navigate to location
//   void navigateToLocation(String location) {
//     Get.snackbar(
//       'Navigation',
//       'Navigating to $location',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   // Send a message in the ticket detail view
//   Future<void> sendMessage() async {
//     if (messageController.text.trim().isEmpty) {
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
//       await Future.delayed(Duration(seconds: 1));
//
//       Get.snackbar(
//         'Success',
//         'Message sent successfully',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//
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
//     if (remarkController.text.trim().isEmpty) {
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
//       await Future.delayed(Duration(seconds: 1));
//
//       if (currentTicket.value != null) {
//         final updatedTicket = Map<String, dynamic>.from(currentTicket.value!);
//         updatedTicket['remark'] = remarkController.text;
//
//         // Update in both lists if present
//         final allIndex = allTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
//         if (allIndex != -1) {
//           allTickets[allIndex] = updatedTicket;
//         }
//
//         final myIndex = myTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
//         if (myIndex != -1) {
//           myTickets[myIndex] = updatedTicket;
//         }
//
//         currentTicket.value = updatedTicket;
//         applyFilters(); // Refresh filtered list
//
//         Get.snackbar(
//           'Success',
//           'Remark added successfully',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//
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
//       await Future.delayed(Duration(seconds: 1));
//
//       final updatedTicket = Map<String, dynamic>.from(currentTicket.value!);
//       updatedTicket['status'] = 'open';
//       updatedTicket['closed'] = '';
//
//       // Update in both lists if present
//       final allIndex = allTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
//       if (allIndex != -1) {
//         allTickets[allIndex] = updatedTicket;
//       }
//
//       final myIndex = myTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
//       if (myIndex != -1) {
//         myTickets[myIndex] = updatedTicket;
//       }
//
//       currentTicket.value = updatedTicket;
//       applyFilters(); // Refresh filtered list
//
//       Get.snackbar(
//         'Success',
//         'Ticket reopened successfully',
//         snackPosition: SnackPosition.BOTTOM,
//       );
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
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../API Service/Model/Request/ticket_model.dart';
import '../../API Service/api_service.dart';

class TicketController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  final allTickets = <Map<String, dynamic>>[].obs;
  final myTickets = <Map<String, dynamic>>[].obs;
  final filteredTickets = <Map<String, dynamic>>[].obs;

  var selectedTicketTab = 'all'.obs;

  final searchQuery = ''.obs;
  final selectedFilter = 'All'.obs;

  final showFilters = false.obs;

  final messageController = TextEditingController();
  final remarkController = TextEditingController();

  final currentTicket = Rxn<Map<String, dynamic>>();

  final Map<String, String> priorityLabels = {
    '1': 'Critical',
    '2': 'High',
    '3': 'Medium',
    '4': 'Low',
    '5': 'Very Low'
  };

  final filterOptions = [
    'All',
    'Ticket Open',
    'Ticket Closed',
    'Priority Critical',
    'Priority High',
    'Priority Medium',
    'Priority Low',
    'Priority Very Low',
  ];

  Map<String, dynamic> _getPriorityData(String priority) {
    switch (priority) {
      case '1':
        return {
          'label': 'Critical',
          'description': 'Urgent attention required',
          'color': const Color(0xFFDC2626),
          'icon': Icons.error,
        };
      case '2':
        return {
          'label': 'High',
          'description': 'High priority issue',
          'color': const Color(0xFFEA580C),
          'icon': Icons.warning,
        };
      case '3':
        return {
          'label': 'Medium',
          'description': 'Normal priority',
          'color': const Color(0xFFCA8A04),
          'icon': Icons.info,
        };
      case '4':
        return {
          'label': 'Low',
          'description': 'Low priority issue',
          'color': const Color(0xFF059669),
          'icon': Icons.schedule,
        };
      case '5':
        return {
          'label': 'Very Low',
          'description': 'Minimal impact',
          'color': const Color(0xFF0284C7),
          'icon': Icons.remove,
        };
      default:
        return {
          'label': 'Medium',
          'description': 'Normal priority',
          'color': const Color(0xFFCA8A04),
          'icon': Icons.info,
        };
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllTickets();
    fetchMyTickets();

    debounce(
      searchQuery,
          (_) => applyFilters(),
      time: const Duration(milliseconds: 500),
    );

    ever(selectedFilter, (_) => applyFilters());
    ever(selectedTicketTab, (_) => applyFilters());
  }

  @override
  void onClose() {
    messageController.dispose();
    remarkController.dispose();
    super.onClose();
  }

  void setTicketTab(String tab) {
    selectedTicketTab.value = tab;

    if (tab == 'all' && allTickets.isEmpty) {
      fetchAllTickets();
    } else if (tab == 'my' && myTickets.isEmpty) {
      fetchMyTickets();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setSelectedFilter(String filter) {
    selectedFilter.value = filter;
  }

  void toggleFilterVisibility() {
    showFilters.value = !showFilters.value;
  }

  void applyFilters() {
    List<Map<String, dynamic>> currentTickets = selectedTicketTab.value == 'all'
        ? allTickets
        : myTickets;

    if (currentTickets.isEmpty) {
      filteredTickets.clear();
      return;
    }

    List<Map<String, dynamic>> result = List.from(currentTickets);

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((ticket) {
        return (ticket['title']?.toString().toLowerCase().contains(query) ?? false) ||
            (ticket['description']?.toString().toLowerCase().contains(query) ?? false) ||
            (ticket['name']?.toString().toLowerCase().contains(query) ?? false) ||
            (ticket['location']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (selectedFilter.value != 'All') {
      switch (selectedFilter.value) {
        case 'Ticket Open':
          result = result.where((ticket) => ticket['status'] == 'open').toList();
          break;
        case 'Ticket Closed':
          result = result.where((ticket) => ticket['status'] == 'closed').toList();
          break;
        case 'Priority Critical':
          result = result.where((ticket) => ticket['priority'] == '1').toList();
          break;
        case 'Priority High':
          result = result.where((ticket) => ticket['priority'] == '2').toList();
          break;
        case 'Priority Medium':
          result = result.where((ticket) => ticket['priority'] == '3').toList();
          break;
        case 'Priority Low':
          result = result.where((ticket) => ticket['priority'] == '4').toList();
          break;
        case 'Priority Very Low':
          result = result.where((ticket) => ticket['priority'] == '5').toList();
          break;
      }
    }

    filteredTickets.value = result;
  }

  Future<void> fetchAllTickets() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final inspectorId = await ApiService.getUid();

      if (inspectorId == null) {
        throw Exception('No UID found');
      }

      final response = await ApiService.get<TicketsResponse>(
        endpoint: "/api/tickets/inspector/$inspectorId",
        fromJson: (json) => TicketsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        allTickets.value = response.data!.tickets.map((ticket) {
          return {
            'id': ticket.id.toString(),
            'title': ticket.title,
            'description': ticket.description,
            'plant_id': ticket.plantId,
            'user_id': ticket.userId,
            'inspector_id': ticket.inspectorId,
            'distributor_admin_id': ticket.distributorAdminId,
            'department': ticket.department,
            'created_by': ticket.createdBy,
            'creator_type': ticket.creatorType,
            'ticket_type': ticket.ticketType,
            'cleaning_id': ticket.cleaningId,
            'status': ticket.status,
            'createdAt': ticket.createdAt.toString(),
            'updatedAt': ticket.updatedAt.toString(),
            'priority': ticket.priority,
            'assigned_to': ticket.assignedTo,
            'ip': ticket.ip,
            'creator_name': ticket.creatorName,
            'inspector_assigned': ticket.inspectorAssigned,
            'chat_count': ticket.chatCount,
            'location': 'Location details',
            'phone': 'Phone details',
            'remark': 'Remark details',
          };
        }).toList();

        if (selectedTicketTab.value == 'all') {
          applyFilters();
        }
      } else {
        errorMessage.value = response.errorMessage ?? 'Failed to load all tickets';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load all tickets: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMyTickets() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final inspectorId = await ApiService.getUid();

      if (inspectorId == null) {
        throw Exception('No UID found');
      }

      final response = await ApiService.get<TicketsResponse>(
        endpoint: "/api/tickets/created-by-inspector/$inspectorId",
        fromJson: (json) => TicketsResponse.fromJson(json),
      );

      if (response.success && response.data != null) {
        myTickets.value = response.data!.tickets.map((ticket) {
          return {
            'id': ticket.id.toString(),
            'title': ticket.title,
            'description': ticket.description,
            'plant_id': ticket.plantId,
            'user_id': ticket.userId,
            'inspector_id': ticket.inspectorId,
            'distributor_admin_id': ticket.distributorAdminId,
            'department': ticket.department,
            'created_by': ticket.createdBy,
            'creator_type': ticket.creatorType,
            'ticket_type': ticket.ticketType,
            'cleaning_id': ticket.cleaningId,
            'status': ticket.status,
            'createdAt': ticket.createdAt.toString(),
            'updatedAt': ticket.updatedAt.toString(),
            'priority': ticket.priority,
            'assigned_to': ticket.assignedTo,
            'ip': ticket.ip,
            'creator_name': ticket.creatorName,
            'inspector_assigned': ticket.inspectorAssigned,
            'chat_count': ticket.chatCount,
            'location': 'Location details',
            'phone': 'Phone details',
            'remark': 'Remark details',
          };
        }).toList();

        if (selectedTicketTab.value == 'my') {
          applyFilters();
        }
      } else {
        errorMessage.value = response.errorMessage ?? 'Failed to load my tickets';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load my tickets: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTickets() async {
    await Future.wait([
      fetchAllTickets(),
      fetchMyTickets(),
    ]);
  }

  Future<void> refreshTickets() async {
    if (selectedTicketTab.value == 'all') {
      await fetchAllTickets();
    } else {
      await fetchMyTickets();
    }
  }

  Future<void> refreshAllTickets() async {
    await Future.wait([
      fetchAllTickets(),
      fetchMyTickets(),
    ]);
  }

  List<Map<String, dynamic>> get currentTickets {
    return selectedTicketTab.value == 'all' ? allTickets : myTickets;
  }

  Map<String, dynamic>? getTicketDetails(String id) {
    try {
      return currentTickets.firstWhere((ticket) => ticket['id'] == id);
    } catch (e) {
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

  void navigateToTicketDetails(String id) {
    final ticket = getTicketDetails(id);
    if (ticket != null) {
      currentTicket.value = ticket;
      Get.toNamed('/ticket-details', arguments: ticket);
    }
  }

  void callContact(String phoneNumber) {
    Get.snackbar(
      'Calling',
      'Calling $phoneNumber',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void navigateToLocation(String location) {
    Get.snackbar(
      'Navigation',
      'Navigating to $location',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

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

        final allIndex = allTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
        if (allIndex != -1) {
          allTickets[allIndex] = updatedTicket;
        }

        final myIndex = myTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
        if (myIndex != -1) {
          myTickets[myIndex] = updatedTicket;
        }

        currentTicket.value = updatedTicket;
        applyFilters();

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

      final allIndex = allTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
      if (allIndex != -1) {
        allTickets[allIndex] = updatedTicket;
      }

      final myIndex = myTickets.indexWhere((t) => t['id'] == updatedTicket['id']);
      if (myIndex != -1) {
        myTickets[myIndex] = updatedTicket;
      }

      currentTicket.value = updatedTicket;
      applyFilters();

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

  void generateTicketImage() {
    Get.snackbar(
      'Feature',
      'Generating ticket image...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
