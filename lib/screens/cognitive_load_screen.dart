import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/utilities/helpers.dart';
import '../services/crowd_service.dart';
import '../services/health_service.dart';
import '../services/iot_service.dart';
import '../engines/cognitive_load_engine.dart';
import '../widgets/elevated_card.dart';
import '../widgets/animated_gauge.dart';

class CognitiveLoadScreen extends StatelessWidget {
  const CognitiveLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final crowdService = context.watch<CrowdService>();
    final healthService = context.watch<HealthService>();
    final iotService = context.watch<IoTService>();
    final cognitiveEngine = context.read<CognitiveLoadEngine>();

    final cognitiveLoad = cognitiveEngine.calculateFromModels(
      healthData: healthService.currentData,
      sensorData: iotService.latestData,
      crowdData: crowdService.crowdData.isNotEmpty
          ? crowdService.crowdData.first
          : null,
    );

    final stressFactors = cognitiveEngine.getStressFactors(cognitiveLoad);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Helpers.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                const SizedBox(height: 24),
                _buildMainGauge(context, cognitiveLoad),
                const SizedBox(height: 24),
                _buildFactorCards(
                    context, crowdService, healthService, iotService),
                const SizedBox(height: 24),
                if (stressFactors.isNotEmpty)
                  _buildStressFactors(context, stressFactors),
                const SizedBox(height: 24),
                _buildHealthMetrics(context, healthService),
              ],
            ),
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
                'Cognitive Load',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Monitor your mental wellness',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainGauge(BuildContext context, double cognitiveLoad) {
    return ElevatedCard(
      child: Column(
        children: [
          Text(
            'Cognitive Load Score',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          AnimatedGauge(
            value: cognitiveLoad,
            size: 200,
            strokeWidth: 20,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _getLoadColor(cognitiveLoad).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getLoadLabel(cognitiveLoad),
              style: TextStyle(
                color: _getLoadColor(cognitiveLoad),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'CLS = (Screen × 0.25) + (Crowd × 0.25) + (Temp × 0.2) + (Time × 0.15) + (HR × 0.15)',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFactorCards(BuildContext context, CrowdService crowdService,
      HealthService healthService, IoTService iotService) {
    return Row(
      children: [
        Expanded(
          child: ElevatedCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.groups_rounded,
                    color: AppColors.warmPeach, size: 32),
                const SizedBox(height: 8),
                Text(
                  'Crowd',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(crowdService.getAverageDensity() * 100).toInt()}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.favorite_rounded,
                    color: AppColors.critical, size: 32),
                const SizedBox(height: 8),
                Text(
                  'Heart Rate',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '${healthService.currentData?.heartRate ?? 0}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.thermostat_rounded,
                    color: AppColors.softTeal, size: 32),
                const SizedBox(height: 8),
                Text(
                  'Temp',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '${iotService.latestData?.temperature.toStringAsFixed(0) ?? 0}°',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStressFactors(BuildContext context, List<String> factors) {
    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.warning),
              const SizedBox(width: 8),
              Text(
                'Stress Factors',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...factors.map((factor) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(factor),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildHealthMetrics(
      BuildContext context, HealthService healthService) {
    final data = healthService.currentData;

    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Metrics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'From connected devices (mock)',
            style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  context,
                  Icons.directions_walk_rounded,
                  'Steps',
                  '${data?.steps ?? 0}',
                  AppColors.mintGreen,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  context,
                  Icons.local_fire_department_rounded,
                  'Calories',
                  '${data?.caloriesBurned ?? 0}',
                  AppColors.warmPeach,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  context,
                  Icons.bedtime_rounded,
                  'Sleep',
                  '${data?.sleepHours.toStringAsFixed(1) ?? 0}h',
                  AppColors.mutedLavender,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(BuildContext context, IconData icon, String label,
      String value, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Color _getLoadColor(double load) {
    if (load >= 0.7) return AppColors.critical;
    if (load >= 0.5) return AppColors.warning;
    return AppColors.success;
  }

  String _getLoadLabel(double load) {
    if (load >= 0.7) return 'High Stress';
    if (load >= 0.5) return 'Moderate';
    if (load >= 0.3) return 'Low';
    return 'Relaxed';
  }
}
