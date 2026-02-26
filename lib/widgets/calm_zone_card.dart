import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utilities/helpers.dart';
import '../models/calm_zone_model.dart';

class CalmZoneCard extends StatelessWidget {
  final CalmZoneModel zone;
  final VoidCallback? onTap;

  const CalmZoneCard({
    super.key,
    required this.zone,
    this.onTap,
  });

  String _getCrowdLevelText(double density) {
    if (density < 0.3) return 'Low';
    if (density < 0.6) return 'Medium';
    return 'High';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Helpers.getCardColor(context),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.mintGreen.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.mintGreen.withOpacity(0.3),
                    AppColors.softTeal.withOpacity(0.2),
                  ],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.spa_rounded,
                      size: 48,
                      color: AppColors.softTeal.withOpacity(0.5),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Helpers.getCardColor(context),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            zone.calmScore.toStringAsFixed(1),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          zone.description,
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildAttribute(
                        Icons.volume_off_rounded,
                        'Noise: ${zone.noiseLevel.toStringAsFixed(0)}dB',
                        zone.noiseLevel < 50
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                      const SizedBox(width: 16),
                      _buildAttribute(
                        Icons.grass_rounded,
                        '${(zone.greeneryIndex * 100).toStringAsFixed(0)}%',
                        AppColors.mintGreen,
                      ),
                      const SizedBox(width: 16),
                      _buildAttribute(
                        Icons.people_rounded,
                        _getCrowdLevelText(zone.crowdDensity),
                        _getCrowdColor(_getCrowdLevelText(zone.crowdDensity)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: zone.amenities.take(3).map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.mintGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          amenity,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.softTeal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttribute(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getCrowdColor(String crowdLevel) {
    switch (crowdLevel.toLowerCase()) {
      case 'low':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'high':
        return AppColors.critical;
      default:
        return AppColors.textTertiary;
    }
  }
}
