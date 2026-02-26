import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/crowd_data_model.dart';

class HeatMapWidget extends StatelessWidget {
  final List<CrowdDataModel> data;

  const HeatMapWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
        ),
        child: Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: _HeatMapPainter(data: data),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: _buildLegend(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Density',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _buildLegendItem('Very High', AppColors.critical),
          _buildLegendItem('High', AppColors.high),
          _buildLegendItem('Medium', AppColors.warning),
          _buildLegendItem('Low', AppColors.mintGreen),
          _buildLegendItem('Very Low', AppColors.success),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeatMapPainter extends CustomPainter {
  final List<CrowdDataModel> data;

  _HeatMapPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    canvas.drawLine(
      Offset(0, size.height * 0.25),
      Offset(size.width, size.height * 0.25),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.75),
      Offset(size.width, size.height * 0.75),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, 0),
      Offset(size.width * 0.25, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.5, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.75, 0),
      Offset(size.width * 0.75, size.height),
      roadPaint,
    );

    for (final crowdData in data) {
      final random = Random(crowdData.zoneId.hashCode);
      final centerX = 50.0 + random.nextDouble() * (size.width - 100);
      final centerY = 50.0 + random.nextDouble() * (size.height - 100);
      final center = Offset(centerX, centerY);
      final radius = 40.0 + crowdData.estimatedCount / 100 * 40;

      final color = _getHeatColor(crowdData.density);

      final gradient = RadialGradient(
        colors: [
          color.withOpacity(0.7),
          color.withOpacity(0.3),
          color.withOpacity(0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: center, radius: radius),
        );

      canvas.drawCircle(center, radius, paint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: crowdData.zoneName.length > 8 
            ? crowdData.zoneName.substring(0, 8) 
            : crowdData.zoneName,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
      );
    }
  }

  Color _getHeatColor(double density) {
    if (density >= 0.8) return AppColors.critical;
    if (density >= 0.6) return AppColors.high;
    if (density >= 0.4) return AppColors.warning;
    if (density >= 0.2) return AppColors.mintGreen;
    return AppColors.success;
  }

  @override
  bool shouldRepaint(covariant _HeatMapPainter oldDelegate) {
    return true;
  }
}
