class Ticket {
  final int id;
  final String title;
  final String description;
  final int? plantId;
  final int? userId;
  final int? inspectorId;
  final int? distributorAdminId;
  final String department;
  final int? createdBy;
  final String creatorType;
  final String ticketType;
  final int? cleaningId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String priority;
  final int? assignedTo;
  final String ip;
  final String creatorName;
  final String inspectorAssigned;
  final int? chatCount;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    this.plantId,
    this.userId,
    this.inspectorId,
    this.distributorAdminId,
    required this.department,
    this.createdBy,
    required this.creatorType,
    required this.ticketType,
    this.cleaningId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.priority,
    this.assignedTo,
    required this.ip,
    required this.creatorName,
    required this.inspectorAssigned,
    this.chatCount,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      plantId: json['plant_id'],
      userId: json['user_id'],
      inspectorId: json['inspector_id'],
      distributorAdminId: json['distributor_admin_id'],
      department: json['department'] ?? '',
      createdBy: json['created_by'],
      creatorType: json['creator_type'] ?? '',
      ticketType: json['ticket_type'] ?? '',
      cleaningId: json['cleaning_id'],
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      priority: json['priority'] ?? '',
      assignedTo: json['assigned_to'],
      ip: json['ip'] ?? '',
      creatorName: json['creator_name'] ?? '',
      inspectorAssigned: json['inspector_assigned'] ?? '',
      chatCount: json['chat_count'],
    );
  }
}

class TicketsResponse {
  final String message;
  final bool success;
  final List<Ticket> tickets;
  final int total;

  TicketsResponse({
    required this.message,
    required this.success,
    required this.tickets,
    required this.total,
  });

  factory TicketsResponse.fromJson(Map<String, dynamic> json) {
    var ticketsList = json['data']['tickets'] as List;
    List<Ticket> tickets = ticketsList.map((i) => Ticket.fromJson(i)).toList();

    return TicketsResponse(
      message: json['message'],
      success: json['success'],
      tickets: tickets,
      total: json['data']['total'],
    );
  }
}
