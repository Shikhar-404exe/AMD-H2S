import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../services/iot_service.dart';
import 'elevated_card.dart';

class LiveIoTWidget extends StatelessWidget {
  const LiveIoTWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final iotService = context.watch<IoTService>();
    final latestData = iotService.latestData;

    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Live IoT Feed',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              StreamBuilder(
                stream: iotService.getSensorStream(),
                builder: (context, snapshot) {
                  return Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: snapshot.hasData ? AppColors.success : AppColors.textTertiary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (snapshot.hasData ? AppColors.success : AppColors.textTertiary).withOpacity(0.5),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        snapshot.hasData ? 'Live' : 'Connecting...',
                        style: TextStyle(
                          color: snapshot.hasData ? AppColors.success : AppColors.textTertiary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildMetricTile(
                context,
                Icons.thermostat_rounded,
                'Temp',
                '${latestData?.temperature.toStringAsFixed(1) ?? '--'}°C',
                AppColors.warmPeach,
              ),
              const SizedBox(width: 12),
              _buildMetricTile(
                context,
                Icons.water_drop_rounded,
                'Humidity',
                '${latestData?.humidity.toStringAsFixed(0) ?? '--'}%',
                AppColors.powderBlue,
              ),
              const SizedBox(width: 12),
              _buildMetricTile(
                context,
                Icons.air_rounded,
                'AQI',
                '${latestData?.airQualityIndex.toStringAsFixed(0) ?? '--'}',
                AppColors.mintGreen,
              ),
              const SizedBox(width: 12),
              _buildMetricTile(
                context,
                Icons.volume_up_rounded,
                'Noise',
                '${latestData?.noiseLevel.toStringAsFixed(0) ?? '--'}dB',
                AppColors.mutedLavender,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Zone: ${latestData?.zoneId ?? 'N/A'}',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(BuildContext context, IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
