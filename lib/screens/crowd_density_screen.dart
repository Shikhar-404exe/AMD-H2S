import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/utilities/helpers.dart';
import '../services/crowd_service.dart';
import '../engines/crowd_density_engine.dart';
import '../widgets/elevated_card.dart';
import '../widgets/heat_map_widget.dart';

class CrowdDensityScreen extends StatelessWidget {
  const CrowdDensityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final crowdService = context.watch<CrowdService>();
    final densityEngine = context.read<CrowdDensityEngine>();

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
                _buildHeatMap(context, crowdService),
                const SizedBox(height: 24),
                _buildZoneList(context, crowdService, densityEngine),
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
                'Crowd Density',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Real-time crowd monitoring',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeatMap(BuildContext context, CrowdService crowdService) {
    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Zone Heat Map',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: HeatMapWidget(data: crowdService.crowdData),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneList(BuildContext context, CrowdService crowdService,
      CrowdDensityEngine engine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Zone Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...crowdService.crowdData.map((data) {
          final densityLevel = engine.getDensityLevel(data.density);
          final color = Helpers.getDensityColor(data.density);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        '${(data.density * 100).toInt()}%',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.zoneName.split(' - ').last,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  densityLevel,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              data.trend == 'increasing'
                                  ? Icons.trending_up_rounded
                                  : data.trend == 'decreasing'
                                      ? Icons.trending_down_rounded
                                      : Icons.trending_flat_rounded,
                              size: 14,
                              color: data.trend == 'increasing'
                                  ? AppColors.critical
                                  : data.trend == 'decreasing'
                                      ? AppColors.success
                                      : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                data.trend,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '~${data.estimatedCount}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
