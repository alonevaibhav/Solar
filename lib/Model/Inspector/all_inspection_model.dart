class Inspection {
  final int id;
  final int plantId;
  final int inspectorId;
  final String week;
  final String day;
  final String time;
  final int isActive;
  final int assignedBy;
  final DateTime scheduleDate;
  final String status;
  final String notes;

  Inspection({
    required this.id,
    required this.plantId,
    required this.inspectorId,
    required this.week,
    required this.day,
    required this.time,
    required this.isActive,
    required this.assignedBy,
    required this.scheduleDate,
    required this.status,
    required this.notes,
  });

  factory Inspection.fromJson(Map<String, dynamic> json) {
    return Inspection(
      id: json['id'] ?? 0,
      plantId: json['plant_id'] ?? 0,
      inspectorId: json['inspector_id'] ?? 0,
      week: json['week'] ?? '1',
      day: json['day'] ?? 'mo',
      time: json['time'] ?? '00:00:00',
      isActive: json['isActive'] ?? 1,
      assignedBy: json['assignedBy'] ?? 0,
      scheduleDate: _parseDate(json['schedule_date']),
      status: json['status'] ?? 'scheduled',
      notes: json['notes'] ?? '',
    );
  }

  static DateTime _parseDate(String? dateString) {
    if (dateString == null) {
      return DateTime.now();
    }
    final parsedDate = DateTime.tryParse(dateString);
    return parsedDate ?? DateTime.now();
  }
}
