import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/utilities/helpers.dart';
import '../models/calm_zone_model.dart';
import '../models/recommendation_model.dart';
import '../services/calm_zone_service.dart';
import '../services/crowd_service.dart';
import '../services/health_service.dart';
import '../engines/cognitive_load_engine.dart';
import '../engines/calm_recommendation_engine.dart';
import '../widgets/elevated_card.dart';
import '../widgets/circular_meter.dart';
import '../widgets/calm_zone_card.dart';
import '../widgets/recommendation_card.dart';

class CalmZoneScreen extends StatelessWidget {
  const CalmZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calmZoneService = context.watch<CalmZoneService>();
    final crowdService = context.watch<CrowdService>();
    final healthService = context.watch<HealthService>();
    final cognitiveEngine = context.read<CognitiveLoadEngine>();
    final recommendationEngine = context.read<CalmRecommendationEngine>();

    final cognitiveLoad = cognitiveEngine.calculateCognitiveLoadScore(
      crowdDensity: crowdService.getAverageDensity(),
      heartRate: healthService.currentData?.heartRate,
    );

    final recommendations = recommendationEngine.generateRecommendations(
      cognitiveLoadScore: cognitiveLoad,
      crowdDensity: crowdService.getAverageDensity(),
      availableCalmZones: calmZoneService.calmZones,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Helpers.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAppBar(context),
                      const SizedBox(height: 24),
                      _buildStressOverview(
                          context, cognitiveLoad, recommendationEngine),
                      const SizedBox(height: 24),
                      _buildRecommendations(context, recommendations),
                      const SizedBox(height: 24),
                      _buildCalmZones(context, calmZoneService.calmZones),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Helpers.getCardColor(context),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calm Zones',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Find your peace',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.mintGreen.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.spa_rounded,
            color: AppColors.mintGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildStressOverview(BuildContext context, double cognitiveLoad,
      CalmRecommendationEngine engine) {
    return ElevatedCard(
      child: Column(
        children: [
          Row(
            children: [
              CircularMeter(
                value: cognitiveLoad,
                size: 100,
                label: 'Stress Level',
                color: cognitiveLoad > 0.6
                    ? AppColors.critical
                    : AppColors.mintGreen,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      engine.getOverallAdvice(cognitiveLoad),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(
      BuildContext context, List<RecommendationModel> recommendations) {
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...recommendations.take(3).map((rec) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RecommendationCard(recommendation: rec),
            )),
      ],
    );
  }

  Widget _buildCalmZones(BuildContext context, List<CalmZoneModel> zones) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nearby Calm Zones',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...zones.map((zone) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CalmZoneCard(zone: zone),
            )),
      ],
    );
  }
}
