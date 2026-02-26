import 'dart:math';
import '../models/crowd_data_model.dart';

class CrowdDensityEngine {
  double calculateHeatScore({
    required double density,
    required int estimatedCount,
    required double areaSize,
    DateTime? peakHour,
  }) {
    final baseDensityScore = density;
    final countScore = (estimatedCount / 1000).clamp(0.0, 1.0);
    final areaDensity = (estimatedCount / areaSize).clamp(0.0, 1.0);
    
    double timeMultiplier = 1.0;
    if (peakHour != null) {
      final hour = peakHour.hour;
      if (hour >= 8 && hour <= 10) timeMultiplier = 1.3;
      if (hour >= 17 && hour <= 19) timeMultiplier = 1.4;
      if (hour >= 12 && hour <= 14) timeMultiplier = 1.2;
    }
    
    final heatScore = ((baseDensityScore * 0.4) +
                       (countScore * 0.3) +
                       (areaDensity * 0.3)) * timeMultiplier;
    
    return heatScore.clamp(0.0, 1.0);
  }
  
  String getDensityLevel(double density) {
    if (density >= 0.8) return 'Very High';
    if (density >= 0.6) return 'High';
    if (density >= 0.4) return 'Moderate';
    if (density >= 0.2) return 'Low';
    return 'Very Low';
  }
  
  String getTrend(List<CrowdDataModel> historicalData) {
    if (historicalData.length < 2) return 'stable';
    
    final recent = historicalData.take(5).map((d) => d.density).reduce((a, b) => a + b) / 5;
    final older = historicalData.skip(5).take(5).map((d) => d.density).fold(0.0, (a, b) => a + b);
    final olderAvg = historicalData.length >= 10 ? older / 5 : recent;
    
    if (recent > olderAvg + 0.1) return 'increasing';
    if (recent < olderAvg - 0.1) return 'decreasing';
    return 'stable';
  }
  
  List<String> getPeakHours(String zoneType) {
    switch (zoneType) {
      case 'commercial':
        return ['9:00 AM', '1:00 PM', '6:00 PM'];
      case 'residential':
        return ['7:00 AM', '7:00 PM'];
      case 'industrial':
        return ['8:00 AM', '5:00 PM'];
      default:
        return ['10:00 AM', '5:00 PM'];
    }
  }
  
  double predictDensity(double currentDensity, int hoursAhead) {
    final random = Random();
    final variance = (random.nextDouble() - 0.5) * 0.2;
    final prediction = currentDensity + variance;
    return prediction.clamp(0.0, 1.0);
  }
}
