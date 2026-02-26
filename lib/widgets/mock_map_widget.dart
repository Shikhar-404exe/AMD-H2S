import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utilities/helpers.dart';
import '../models/issue_model.dart';
import '../models/calm_zone_model.dart';

class MockMapWidget extends StatefulWidget {
  final List<IssueModel> issues;
  final List<CalmZoneModel> calmZones;
  final Function(dynamic)? onMarkerTap;
  final bool showIssues;
  final bool showCalmZones;

  const MockMapWidget({
    super.key,
    this.issues = const [],
    this.calmZones = const [],
    this.onMarkerTap,
    this.showIssues = true,
    this.showCalmZones = true,
  });

  @override
  State<MockMapWidget> createState() => _MockMapWidgetState();
}

class _MockMapWidgetState extends State<MockMapWidget> {
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
              painter: _MapBackgroundPainter(),
            ),
            if (widget.showIssues)
              ...widget.issues.map((issue) => _buildIssueMarker(issue)),
            if (widget.showCalmZones)
              ...widget.calmZones.map((zone) => _buildCalmZoneMarker(zone)),
            Positioned(
              right: 16,
              bottom: 16,
              child: Column(
                children: [
                  _buildMapControl(Icons.add, () {}),
                  const SizedBox(height: 8),
                  _buildMapControl(Icons.remove, () {}),
                  const SizedBox(height: 8),
                  _buildMapControl(Icons.my_location, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueMarker(IssueModel issue) {
    final random = Random(issue.id.hashCode);
    final left = 50.0 + random.nextDouble() * 200;
    final top = 50.0 + random.nextDouble() * 250;

    Color markerColor;
    if (issue.priorityScore >= 0.7) {
      markerColor = AppColors.critical;
    } else if (issue.priorityScore >= 0.5) {
      markerColor = AppColors.high;
    } else if (issue.priorityScore >= 0.3) {
      markerColor = AppColors.warning;
    } else {
      markerColor = AppColors.success;
    }

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () {
          widget.onMarkerTap?.call(issue);
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
            border: Border.all(color: Helpers.getCardColor(context), width: 3),
            boxShadow: [
              BoxShadow(
                color: markerColor.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            _getCategoryIcon(issue.category),
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildCalmZoneMarker(CalmZoneModel zone) {
    final random = Random(zone.id.hashCode);
    final left = 80.0 + random.nextDouble() * 180;
    final top = 80.0 + random.nextDouble() * 200;

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () {
          widget.onMarkerTap?.call(zone);
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.mintGreen,
            shape: BoxShape.circle,
            border: Border.all(color: Helpers.getCardColor(context), width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.mintGreen.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.spa_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildMapControl(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Helpers.getCardColor(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'pothole':
        return Icons.warning_rounded;
      case 'streetlight':
        return Icons.lightbulb_rounded;
      case 'garbage':
        return Icons.delete_rounded;
      case 'water leak':
        return Icons.water_drop_rounded;
      case 'noise':
        return Icons.volume_up_rounded;
      case 'traffic':
        return Icons.traffic_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }
}

class _MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.7),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      roadPaint,
    );

    final blockPaint = Paint()
      ..color = AppColors.softTeal.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.05, size.height * 0.05, size.width * 0.2,
            size.height * 0.2),
        const Radius.circular(8),
      ),
      blockPaint,
    );

    blockPaint.color = AppColors.mutedLavender.withOpacity(0.1);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.35, size.height * 0.05, size.width * 0.3,
            size.height * 0.2),
        const Radius.circular(8),
      ),
      blockPaint,
    );

    blockPaint.color = AppColors.warmPeach.withOpacity(0.1);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.75, size.height * 0.35, size.width * 0.2,
            size.height * 0.3),
        const Radius.circular(8),
      ),
      blockPaint,
    );

    blockPaint.color = AppColors.mintGreen.withOpacity(0.15);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.05, size.height * 0.75, size.width * 0.2,
            size.height * 0.2),
        const Radius.circular(8),
      ),
      blockPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
