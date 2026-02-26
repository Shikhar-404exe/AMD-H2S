class CrowdDataModel {
  final String zoneId;
  final String zoneName;
  final double density;
  final int estimatedCount;
  final double heatScore;
  final String trend;
  final DateTime timestamp;
  
  CrowdDataModel({
    required this.zoneId,
    required this.zoneName,
    required this.density,
    required this.estimatedCount,
    required this.heatScore,
    required this.trend,
    required this.timestamp,
  });
  
  CrowdDataModel copyWith({
    String? zoneId,
    String? zoneName,
    double? density,
    int? estimatedCount,
    double? heatScore,
    String? trend,
    DateTime? timestamp,
  }) {
    return CrowdDataModel(
      zoneId: zoneId ?? this.zoneId,
      zoneName: zoneName ?? this.zoneName,
      density: density ?? this.density,
      estimatedCount: estimatedCount ?? this.estimatedCount,
      heatScore: heatScore ?? this.heatScore,
      trend: trend ?? this.trend,
      timestamp: timestamp ?? this.timestamp,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'zoneId': zoneId,
      'zoneName': zoneName,
      'density': density,
      'estimatedCount': estimatedCount,
      'heatScore': heatScore,
      'trend': trend,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  factory CrowdDataModel.fromJson(Map<String, dynamic> json) {
    return CrowdDataModel(
      zoneId: json['zoneId'],
      zoneName: json['zoneName'],
      density: json['density'],
      estimatedCount: json['estimatedCount'],
      heatScore: json['heatScore'],
      trend: json['trend'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
