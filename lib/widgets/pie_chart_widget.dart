import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme/app_colors.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, int> data;

  const PieChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final colors = [
      AppColors.softTeal,
      AppColors.mutedLavender,
      AppColors.warmPeach,
      AppColors.mintGreen,
      AppColors.powderBlue,
      AppColors.critical,
      AppColors.warning,
      AppColors.success,
    ];

    final total = data.values.fold(0, (sum, val) => sum + val);
    final entries = data.entries.toList();

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: entries.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final percentage = (item.value / total * 100);
                return PieChartSectionData(
                  color: colors[index % colors.length],
                  value: item.value.toDouble(),
                  title: percentage > 5 ? '${percentage.toStringAsFixed(0)}%' : '',
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entries.asMap().entries.take(5).map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.key.length > 10 ? '${item.key.substring(0, 10)}...' : item.key,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
