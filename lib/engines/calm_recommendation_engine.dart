import '../models/recommendation_model.dart';
import '../models/calm_zone_model.dart';

class CalmRecommendationEngine {
  List<RecommendationModel> generateRecommendations({
    required double cognitiveLoadScore,
    required double crowdDensity,
    List<CalmZoneModel>? availableCalmZones,
  }) {
    final recommendations = <RecommendationModel>[];
    
    if (cognitiveLoadScore >= 0.7) {
      recommendations.add(RecommendationModel(
        id: 'REC001',
        type: RecommendationType.breathing,
        title: 'Deep Breathing Exercise',
        description: 'Take 5 minutes for deep breathing. Inhale for 4 seconds, hold for 4, exhale for 6.',
        priority: 0.95,
        iconName: 'air',
      ));
      
      if (availableCalmZones != null && availableCalmZones.isNotEmpty) {
        final bestZone = availableCalmZones.reduce(
          (a, b) => a.calmScore > b.calmScore ? a : b
        );
        recommendations.add(RecommendationModel(
          id: 'REC002',
          type: RecommendationType.calmZone,
          title: 'Visit ${bestZone.name}',
          description: 'A nearby calm zone with ${(bestZone.calmScore * 100).toInt()}% calm score. Perfect for stress relief.',
          priority: 0.9,
          iconName: 'park',
        ));
      }
      
      recommendations.add(RecommendationModel(
        id: 'REC003',
        type: RecommendationType.hydration,
        title: 'Stay Hydrated',
        description: 'Drink a glass of water. Hydration helps reduce stress and improve focus.',
        priority: 0.85,
        iconName: 'water_drop',
      ));
    }
    
    if (cognitiveLoadScore >= 0.5) {
      recommendations.add(RecommendationModel(
        id: 'REC004',
        type: RecommendationType.music,
        title: 'Listen to Calming Music',
        description: 'Play some ambient or nature sounds to help you relax.',
        actionUrl: 'spotify://playlist/calming',
        priority: 0.75,
        iconName: 'music_note',
      ));
      
      recommendations.add(RecommendationModel(
        id: 'REC005',
        type: RecommendationType.rest,
        title: 'Take a Short Break',
        description: 'Step away from your current task for 10-15 minutes.',
        priority: 0.7,
        iconName: 'pause_circle',
      ));
    }
    
    if (crowdDensity >= 0.6) {
      recommendations.add(RecommendationModel(
        id: 'REC006',
        type: RecommendationType.calmZone,
        title: 'Find a Quieter Area',
        description: 'Current area has high crowd density. Consider moving to a less crowded space.',
        priority: 0.8,
        iconName: 'directions_walk',
      ));
    }
    
    if (cognitiveLoadScore < 0.5 && crowdDensity < 0.4) {
      recommendations.add(RecommendationModel(
        id: 'REC007',
        type: RecommendationType.activity,
        title: 'Great Time for Outdoor Activity',
        description: 'Conditions are optimal for a walk or light exercise.',
        priority: 0.6,
        iconName: 'directions_run',
      ));
    }
    
    recommendations.sort((a, b) => b.priority.compareTo(a.priority));
    return recommendations;
  }
  
  String getOverallAdvice(double cognitiveLoadScore) {
    if (cognitiveLoadScore >= 0.8) {
      return 'Your stress levels are high. Please take immediate steps to relax.';
    }
    if (cognitiveLoadScore >= 0.6) {
      return 'Moderate stress detected. Consider taking a break soon.';
    }
    if (cognitiveLoadScore >= 0.4) {
      return 'You\'re doing well! Keep maintaining your current pace.';
    }
    return 'Excellent! You\'re in a relaxed state. Great time for productivity.';
  }
}
