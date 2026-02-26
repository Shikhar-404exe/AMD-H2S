import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../services/environmental_service.dart';
import '../services/iot_service.dart';
import '../widgets/elevated_card.dart';
import '../widgets/circular_meter.dart';
import '../widgets/line_chart_widget.dart';
import '../core/utilities/helpers.dart';

class EnvironmentalScreen extends StatelessWidget {
  const EnvironmentalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final envService = context.watch<EnvironmentalService>();
    final iotService = context.watch<IoTService>();
    final latestData = envService.latestData;

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
                _buildAirQualityCard(context, envService),
                const SizedBox(height: 24),
                _buildEnvironmentMetrics(context, latestData),
                const SizedBox(height: 24),
                _buildTrendChart(context, envService),
                const SizedBox(height: 24),
                _buildIoTStatus(context, iotService),
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
                'Environment',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'IoT sensor monitoring',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        StreamBuilder(
          stream: context.read<EnvironmentalService>().dataStream,
          builder: (context, snapshot) {
            return Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: snapshot.hasData
                    ? AppColors.success
                    : AppColors.textTertiary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (snapshot.hasData
                            ? AppColors.success
                            : AppColors.textTertiary)
                        .withOpacity(0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAirQualityCard(
      BuildContext context, EnvironmentalService envService) {
    final aqi = envService.latestData?.airQualityIndex ?? 0;
    final status = envService.getAirQualityStatus();
    final color = envService.getAirQualityColor();

    return ElevatedCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(0.1),
          color.withOpacity(0.05),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircularMeter(
                value: (aqi / 300).clamp(0.0, 1.0),
                size: 120,
                label: 'AQI',
                centerText: aqi.toStringAsFixed(0),
                color: color,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Air Quality',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Updated just now',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                      ),
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

  Widget _buildEnvironmentMetrics(BuildContext context, dynamic latestData) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            context,
            Icons.thermostat_rounded,
            'Temperature',
            '${latestData?.temperature.toStringAsFixed(1) ?? '--'}°C',
            AppColors.warmPeach,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            context,
            Icons.water_drop_rounded,
            'Humidity',
            '${latestData?.humidity.toStringAsFixed(0) ?? '--'}%',
            AppColors.powderBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, IconData icon, String label,
      String value, Color color) {
    return ElevatedCard(
      child: Column(
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
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
      ),
    );
  }

  Widget _buildTrendChart(
      BuildContext context, EnvironmentalService envService) {
    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temperature Trend',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChartWidget(
              data: envService.environmentalData
                  .map((d) => d.temperature)
                  .toList(),
              color: AppColors.softTeal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIoTStatus(BuildContext context, IoTService iotService) {
    return ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Connected Devices',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: iotService.isConnected
                      ? AppColors.success.withOpacity(0.15)
                      : AppColors.critical.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: iotService.isConnected
                            ? AppColors.success
                            : AppColors.critical,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      iotService.isConnected ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: iotService.isConnected
                            ? AppColors.success
                            : AppColors.critical,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...iotService.connectedDevices.map((device) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.developer_board_rounded,
                      color: AppColors.softTeal,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(device),
                    const Spacer(),
                    Text(
                      'ESP32',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 8),
          Text(
            'Ready for Firebase integration',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
