enum RecommendationType { calmZone, music, hydration, rest, activity, breathing }

class RecommendationModel {
  final String id;
  final RecommendationType type;
  final String title;
  final String description;
  final String? actionUrl;
  final double priority;
  final String iconName;
  
  RecommendationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.actionUrl,
    required this.priority,
    required this.iconName,
  });
  
  RecommendationModel copyWith({
    String? id,
    RecommendationType? type,
    String? title,
    String? description,
    String? actionUrl,
    double? priority,
    String? iconName,
  }) {
    return RecommendationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      actionUrl: actionUrl ?? this.actionUrl,
      priority: priority ?? this.priority,
      iconName: iconName ?? this.iconName,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'actionUrl': actionUrl,
      'priority': priority,
      'iconName': iconName,
    };
  }
  
  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['id'],
      type: RecommendationType.values.firstWhere((e) => e.name == json['type']),
      title: json['title'],
      description: json['description'],
      actionUrl: json['actionUrl'],
      priority: json['priority'],
      iconName: json['iconName'],
    );
  }
}
