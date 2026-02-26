import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utilities/helpers.dart';
import '../models/recommendation_model.dart';

class RecommendationCard extends StatelessWidget {
  final RecommendationModel recommendation;
  final VoidCallback? onTap;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Helpers.getCardColor(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _getColor().withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _getColor().withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _getIcon(),
                color: _getColor(),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recommendation.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recommendation.description,
                    style: TextStyle(
                      color: Helpers.getTextSecondary(context),
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: _getColor(),
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (recommendation.type) {
      case RecommendationType.breathing:
        return Icons.air_rounded;
      case RecommendationType.calmZone:
        return Icons.spa_rounded;
      case RecommendationType.hydration:
        return Icons.water_drop_rounded;
      case RecommendationType.music:
        return Icons.music_note_rounded;
      case RecommendationType.rest:
        return Icons.bedtime_rounded;
      case RecommendationType.activity:
        return Icons.directions_walk_rounded;
    }
  }

  Color _getColor() {
    switch (recommendation.type) {
      case RecommendationType.breathing:
        return AppColors.powderBlue;
      case RecommendationType.calmZone:
        return AppColors.mintGreen;
      case RecommendationType.hydration:
        return AppColors.softTeal;
      case RecommendationType.music:
        return AppColors.mutedLavender;
      case RecommendationType.rest:
        return AppColors.warmPeach;
      case RecommendationType.activity:
        return AppColors.success;
    }
  }
}
