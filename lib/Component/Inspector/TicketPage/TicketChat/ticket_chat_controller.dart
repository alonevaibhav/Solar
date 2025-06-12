import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TicketChatController extends GetxController {
  // Current user info (Inspector)
  final currentUserId = 8;
  final currentUserType = "inspector";

  // Reactive variables
  final messages = <Map<String, dynamic>>[].obs;
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final isLoading = false.obs;
  final isSending = false.obs;
  final ticketId = 65.obs;

  // Timer for polling messages
  Timer? _pollingTimer;

  // API Base URL (replace with your actual URL)
  final String baseUrl = "https://your-api-base-url.com";

  // Mock data for testing with attachments
  List<Map<String, dynamic>> mockMessages = [
    {
      "id": 14,
      "date": "2025-06-11T11:45:09.000Z",
      "ticket_id": 65,
      "time": "17:15:09",
      "sender_id": 8,
      "msg": "Hello, I need help with this ticket issue.",
      "created_at": "2025-06-11T11:45:09.000Z",
      "updatedAt": "2025-06-11T11:45:09.000Z",
      "sender_type": "inspector",
      "ip": "::ffff:127.0.0.1",
      "ticket_title": "Yes bbb",
      "ticket_status": "open",
      "sender_name": "John Doe",
      "attachments": [
        {
          "id": 29,
          "ticket_id": 65,
          "chat_id": 14,
          "uploaded_by": "inspector",
          "uploaded_by_id": 0,
          "path": "https://picsum.photos/400/300?random=1",
          "createdAt": "2025-06-11T05:54:46.000Z",
          "updatedAt": "2025-06-11T05:54:46.000Z",
          "ip": 0
        }
      ]
    },
    {
      "id": 15,
      "date": "2025-06-11T11:45:13.000Z",
      "ticket_id": 65,
      "time": "17:15:13",
      "sender_id": 28,
      "msg": "Hi! I'm here to help you with your issue. What exactly seems to be the problem?",
      "created_at": "2025-06-11T11:45:13.000Z",
      "updatedAt": "2025-06-11T11:45:13.000Z",
      "sender_type": "distributor_admin",
      "ip": "192.168.1.1",
      "ticket_title": "Yes bbb",
      "ticket_status": "open",
      "sender_name": "Admin One",
      "attachments": []
    },
    {
      "id": 16,
      "date": "2025-06-11T11:45:14.000Z",
      "ticket_id": 65,
      "time": "17:15:14",
      "sender_id": 8,
      "msg": "The system is not responding properly when I try to submit the form. Here are some screenshots:",
      "created_at": "2025-06-11T11:45:14.000Z",
      "updatedAt": "2025-06-11T11:45:14.000Z",
      "sender_type": "inspector",
      "ip": "::ffff:127.0.0.1",
      "ticket_title": "Yes bbb",
      "ticket_status": "open",
      "sender_name": "John Doe",
      "attachments": [
        {
          "id": 30,
          "ticket_id": 65,
          "chat_id": 16,
          "uploaded_by": "inspector",
          "uploaded_by_id": 8,
          "path": "https://picsum.photos/400/300?random=2",
          "createdAt": "2025-06-11T05:54:46.000Z",
          "updatedAt": "2025-06-11T05:54:46.000Z",
          "ip": 0
        },
        {
          "id": 31,
          "ticket_id": 65,
          "chat_id": 16,
          "uploaded_by": "inspector",
          "uploaded_by_id": 8,
          "path": "https://picsum.photos/400/300?random=3",
          "createdAt": "2025-06-11T06:10:34.000Z",
          "updatedAt": "2025-06-11T06:10:34.000Z",
          "ip": 0
        },
        {
          "id": 32,
          "ticket_id": 65,
          "chat_id": 16,
          "uploaded_by": "inspector",
          "uploaded_by_id": 8,
          "path": "https://picsum.photos/400/300?random=4",
          "createdAt": "2025-06-11T06:10:34.000Z",
          "updatedAt": "2025-06-11T06:10:34.000Z",
          "ip": 0
        }
      ]
    },
    {
      "id": 17,
      "date": "2025-06-11T11:45:15.000Z",
      "ticket_id": 65,
      "time": "17:15:15",
      "sender_id": 28,
      "msg": "I understand the issue. Let me check the logs and get back to you shortly.",
      "created_at": "2025-06-11T11:45:15.000Z",
      "updatedAt": "2025-06-11T11:45:15.000Z",
      "sender_type": "distributor_admin",
      "ip": "192.168.1.1",
      "ticket_title": "Yes bbb",
      "ticket_status": "open",
      "sender_name": "Admin One",
      "attachments": []
    }
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
    startPolling();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // Start polling for new messages every 2 seconds
  void startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      fetchMessages(showLoading: false);
    });
  }

  // Stop polling
  void stopPolling() {
    _pollingTimer?.cancel();
  }

  // Fetch messages from API (using mock data for now)
  Future<void> fetchMessages({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock response structure matching your API
      final mockResponse = {
        "message": "Ticket conversation retrieved successfully",
        "success": true,
        "data": {
          "data": mockMessages,
          "pagination": {
            "page": 1,
            "limit": 50
          },
          "ticketId": 65,
          "totalMessages": mockMessages.length
        },
        "errors": <String>[]
      };

      // Process mock data
      if (mockResponse['success'] == true) {
        // Safely access nested data
        var data = mockResponse['data'];
        if (data != null && data is Map<String, dynamic> && data['data'] != null) {
          final newMessages = List<Map<String, dynamic>>.from(data['data']);

          // Only update if messages changed to avoid unnecessary rebuilds
          if (!_areMessagesEqual(messages, newMessages)) {
            messages.assignAll(newMessages);
            _scrollToBottom();
          }
        }
      }
    } catch (e) {
      _showError('Network error: ${e.toString()}');
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  // Send message via POST API (using mock for now)
  Future<void> sendMessage() async {
    final message = messageController.text.trim();
    if (message.isEmpty) return;

    try {
      isSending.value = true;

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Create mock response matching your POST API structure
      final now = DateTime.now();
      final newMessageId = mockMessages.isNotEmpty ? mockMessages.last['id'] + 1 : 1;

      final mockSentMessage = {
        "id": newMessageId,
        "date": now.toIso8601String(),
        "ticket_id": ticketId.value,
        "time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
        "sender_id": currentUserId,
        "msg": message,
        "created_at": now.toIso8601String(),
        "updatedAt": now.toIso8601String(),
        "sender_type": currentUserType,
        "ip": "::ffff:127.0.0.1",
        "ticket_title": "Yes bbb",
        "ticket_status": "open",
        "sender_name": "John Doe",
        "attachments": []
      };

      final mockPostResponse = {
        "message": "Ticket chat created successfully",
        "success": true,
        "data": mockSentMessage,
        "errors": []
      };

      // Process mock response
      if (mockPostResponse['success'] == true) {
        messageController.clear();

        // Add to mock data and update UI
        mockMessages.add(mockSentMessage);
        messages.add(mockSentMessage);
        _scrollToBottom();

        // Show success feedback
        Get.snackbar(
          'Success',
          'Message sent successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );
      } else {
        _showError('Failed to send message');
      }
    } catch (e) {
      _showError('Network error: ${e.toString()}');
    } finally {
      isSending.value = false;
    }
  }

  // Check if current user is the sender
  bool isMyMessage(Map<String, dynamic> message) {
    return message['sender_id'] == currentUserId &&
        message['sender_type'] == currentUserType;
  }

  // Get sender display name
  String getSenderName(Map<String, dynamic> message) {
    if (isMyMessage(message)) {
      return 'You';
    }
    return message['sender_name'] ?? 'Unknown';
  }

  // Get message time
  String getMessageTime(Map<String, dynamic> message) {
    try {
      final time = message['time'] as String;
      return time.substring(0, 5); // Extract HH:mm
    } catch (e) {
      return '';
    }
  }

  // Format message date
  String getMessageDate(Map<String, dynamic> message) {
    try {
      final dateStr = message['date'] as String;
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();

      if (date.day == now.day && date.month == now.month && date.year == now.year) {
        return 'Today';
      } else if (date.day == now.day - 1 && date.month == now.month && date.year == now.year) {
        return 'Yesterday';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return '';
    }
  }

  // Get attachments from message
  List<Map<String, dynamic>> getAttachments(Map<String, dynamic> message) {
    try {
      final attachments = message['attachments'];
      if (attachments != null && attachments is List) {
        return List<Map<String, dynamic>>.from(attachments);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Convert local file path to usable URL
  String getImageUrl(String path) {
    // If it's already a URL, return as is
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    // Convert local path to server URL
    // Replace this with your actual server URL structure
    final fileName = path.split('\\').last;
    return '$baseUrl/uploads/$fileName';
  }

  // Open image in full screen
  void openImageFullScreen(String imageUrl, List<String> allImages, int initialIndex) {
    Get.to(() => ImageFullScreenView(
      imageUrl: imageUrl,
      allImages: allImages,
      initialIndex: initialIndex,
    ));
  }

  // Refresh messages manually
  Future<void> refreshMessages() async {
    await fetchMessages();
  }

  // Helper methods
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  bool _areMessagesEqual(List<Map<String, dynamic>> list1, List<Map<String, dynamic>> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i]['id'] != list2[i]['id']) return false;
    }
    return true;
  }
}

// Full screen image viewer
class ImageFullScreenView extends StatefulWidget {
  final String imageUrl;
  final List<String> allImages;
  final int initialIndex;

  const ImageFullScreenView({
    Key? key,
    required this.imageUrl,
    required this.allImages,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<ImageFullScreenView> createState() => _ImageFullScreenViewState();
}

class _ImageFullScreenViewState extends State<ImageFullScreenView> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '${_currentIndex + 1} of ${widget.allImages.length}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.allImages.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: Image.network(
                widget.allImages[index],
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}