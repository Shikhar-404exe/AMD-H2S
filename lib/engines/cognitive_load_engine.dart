import '../models/health_data_model.dart';
import '../models/sensor_data_model.dart';
import '../models/crowd_data_model.dart';

class CognitiveLoadEngine {
  static const double screenUsageWeight = 0.25;
  static const double crowdDensityWeight = 0.25;
  static const double temperatureWeight = 0.2;
  static const double timeOfDayWeight = 0.15;
  static const double heartRateWeight = 0.15;
  
  double calculateCognitiveLoadScore({
    double? screenUsage,
    double? crowdDensity,
    double? temperature,
    int? heartRate,
    DateTime? currentTime,
  }) {
    final screenScore = _normalizeScreenUsage(screenUsage ?? 0.5);
    final crowdScore = crowdDensity ?? 0.5;
    final tempScore = _normalizeTemperature(temperature ?? 25);
    final timeScore = _getTimeOfDayFactor(currentTime ?? DateTime.now());
    final heartRateScore = _normalizeHeartRate(heartRate ?? 70);
    
    final cls = (screenScore * screenUsageWeight) +
                (crowdScore * crowdDensityWeight) +
                (tempScore * temperatureWeight) +
                (timeScore * timeOfDayWeight) +
                (heartRateScore * heartRateWeight);
    
    return cls.clamp(0.0, 1.0);
  }
  
  double calculateFromModels({
    HealthDataModel? healthData,
    SensorDataModel? sensorData,
    CrowdDataModel? crowdData,
  }) {
    return calculateCognitiveLoadScore(
      screenUsage: healthData?.activityLevel,
      crowdDensity: crowdData?.density,
      temperature: sensorData?.temperature,
      heartRate: healthData?.heartRate,
      currentTime: DateTime.now(),
    );
  }
  
  double _normalizeScreenUsage(double usage) {
    return usage.clamp(0.0, 1.0);
  }
  
  double _normalizeTemperature(double temp) {
    if (temp < 18) return ((18 - temp) / 18).clamp(0.0, 0.8);
    if (temp > 28) return ((temp - 28) / 15).clamp(0.0, 0.8);
    return 0.0;
  }
  
  double _getTimeOfDayFactor(DateTime time) {
    final hour = time.hour;
    
    if (hour >= 9 && hour <= 11) return 0.2;
    if (hour >= 14 && hour <= 16) return 0.4;
    if (hour >= 17 && hour <= 19) return 0.6;
    if (hour >= 22 || hour <= 5) return 0.8;
    return 0.3;
  }
  
  double _normalizeHeartRate(int heartRate) {
    if (heartRate < 60) return 0.2;
    if (heartRate <= 80) return 0.3;
    if (heartRate <= 100) return 0.5;
    if (heartRate <= 120) return 0.7;
    return 0.9;
  }
  
  String getStressLevel(double cls) {
    if (cls >= 0.7) return 'High';
    if (cls >= 0.5) return 'Moderate';
    if (cls >= 0.3) return 'Low';
    return 'Relaxed';
  }
  
  List<String> getStressFactors(double cls) {
    final factors = <String>[];
    if (cls >= 0.5) factors.add('Consider taking a break');
    if (cls >= 0.6) factors.add('High crowd density detected');
    if (cls >= 0.7) factors.add('Elevated stress indicators');
    return factors;
  }
}
