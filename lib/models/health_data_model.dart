class HealthDataModel {
  final int steps;
  final int heartRate;
  final double activityLevel;
  final double stressLevel;
  final int caloriesBurned;
  final double sleepHours;
  final DateTime timestamp;
  
  HealthDataModel({
    required this.steps,
    required this.heartRate,
    required this.activityLevel,
    required this.stressLevel,
    required this.caloriesBurned,
    required this.sleepHours,
    required this.timestamp,
  });
  
  HealthDataModel copyWith({
    int? steps,
    int? heartRate,
    double? activityLevel,
    double? stressLevel,
    int? caloriesBurned,
    double? sleepHours,
    DateTime? timestamp,
  }) {
    return HealthDataModel(
      steps: steps ?? this.steps,
      heartRate: heartRate ?? this.heartRate,
      activityLevel: activityLevel ?? this.activityLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      sleepHours: sleepHours ?? this.sleepHours,
      timestamp: timestamp ?? this.timestamp,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'heartRate': heartRate,
      'activityLevel': activityLevel,
      'stressLevel': stressLevel,
      'caloriesBurned': caloriesBurned,
      'sleepHours': sleepHours,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  factory HealthDataModel.fromJson(Map<String, dynamic> json) {
    return HealthDataModel(
      steps: json['steps'],
      heartRate: json['heartRate'],
      activityLevel: json['activityLevel'],
      stressLevel: json['stressLevel'],
      caloriesBurned: json['caloriesBurned'],
      sleepHours: json['sleepHours'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
