enum IssueStatus { pending, inProgress, resolved, closed }

class IssueModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String zone;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final IssueStatus status;
  final double priorityScore;
  final double severity;
  final String reportedBy;
  
  IssueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.zone,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    required this.createdAt,
    this.resolvedAt,
    required this.status,
    required this.priorityScore,
    required this.severity,
    required this.reportedBy,
  });
  
  IssueModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? zone,
    double? latitude,
    double? longitude,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? resolvedAt,
    IssueStatus? status,
    double? priorityScore,
    double? severity,
    String? reportedBy,
  }) {
    return IssueModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      zone: zone ?? this.zone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      status: status ?? this.status,
      priorityScore: priorityScore ?? this.priorityScore,
      severity: severity ?? this.severity,
      reportedBy: reportedBy ?? this.reportedBy,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'zone': zone,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'status': status.name,
      'priorityScore': priorityScore,
      'severity': severity,
      'reportedBy': reportedBy,
    };
  }
  
  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      zone: json['zone'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt']) : null,
      status: IssueStatus.values.firstWhere((e) => e.name == json['status']),
      priorityScore: json['priorityScore'],
      severity: json['severity'],
      reportedBy: json['reportedBy'],
    );
  }
}
