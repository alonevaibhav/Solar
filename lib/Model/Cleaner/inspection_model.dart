class InspectionModel {
  final String plantName;
  final String location;
  final bool isCompleted;
  final String? additionalDetails;

  InspectionModel({
    required this.plantName,
    required this.location,
    required this.isCompleted,
    this.additionalDetails,
  });

  // JSON serialization
  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    return InspectionModel(
      plantName: json['plantName'] ?? '',
      location: json['location'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      additionalDetails: json['additionalDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plantName': plantName,
      'location': location,
      'isCompleted': isCompleted,
      'additionalDetails': additionalDetails,
    };
  }

  // Method to copy with modifications
  InspectionModel copyWith({
    String? plantName,
    String? location,
    bool? isCompleted,
    String? additionalDetails,
  }) {
    return InspectionModel(
      plantName: plantName ?? this.plantName,
      location: location ?? this.location,
      isCompleted: isCompleted ?? this.isCompleted,
      additionalDetails: additionalDetails ?? this.additionalDetails,
    );
  }
}