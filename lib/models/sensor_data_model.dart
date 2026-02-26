class SensorDataModel {
  final String sensorId;
  final String zoneId;
  final double temperature;
  final double humidity;
  final double lightLevel;
  final double airQualityIndex;
  final double noiseLevel;
  final double powerConsumption;
  final DateTime timestamp;
  
  SensorDataModel({
    required this.sensorId,
    required this.zoneId,
    required this.temperature,
    required this.humidity,
    required this.lightLevel,
    required this.airQualityIndex,
    required this.noiseLevel,
    required this.powerConsumption,
    required this.timestamp,
  });
  
  SensorDataModel copyWith({
    String? sensorId,
    String? zoneId,
    double? temperature,
    double? humidity,
    double? lightLevel,
    double? airQualityIndex,
    double? noiseLevel,
    double? powerConsumption,
    DateTime? timestamp,
  }) {
    return SensorDataModel(
      sensorId: sensorId ?? this.sensorId,
      zoneId: zoneId ?? this.zoneId,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      lightLevel: lightLevel ?? this.lightLevel,
      airQualityIndex: airQualityIndex ?? this.airQualityIndex,
      noiseLevel: noiseLevel ?? this.noiseLevel,
      powerConsumption: powerConsumption ?? this.powerConsumption,
      timestamp: timestamp ?? this.timestamp,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'sensorId': sensorId,
      'zoneId': zoneId,
      'temperature': temperature,
      'humidity': humidity,
      'lightLevel': lightLevel,
      'airQualityIndex': airQualityIndex,
      'noiseLevel': noiseLevel,
      'powerConsumption': powerConsumption,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  factory SensorDataModel.fromJson(Map<String, dynamic> json) {
    return SensorDataModel(
      sensorId: json['sensorId'],
      zoneId: json['zoneId'],
      temperature: json['temperature'],
      humidity: json['humidity'],
      lightLevel: json['lightLevel'],
      airQualityIndex: json['airQualityIndex'],
      noiseLevel: json['noiseLevel'],
      powerConsumption: json['powerConsumption'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
