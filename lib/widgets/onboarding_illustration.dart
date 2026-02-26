import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class OnboardingIllustration extends StatelessWidget {
  final int pageIndex;
  final double size;

  const OnboardingIllustration({
    super.key,
    required this.pageIndex,
    this.size = 280,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _IllustrationPainter(pageIndex: pageIndex),
      ),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  final int pageIndex;

  _IllustrationPainter({required this.pageIndex});

  @override
  void paint(Canvas canvas, Size size) {
    switch (pageIndex) {
      case 0:
        _drawSmartCityIllustration(canvas, size);
        break;
      case 1:
        _drawCommunityIllustration(canvas, size);
        break;
      case 2:
        _drawWellnessIllustration(canvas, size);
        break;
      default:
        _drawSmartCityIllustration(canvas, size);
    }
  }

  void _drawSmartCityIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final circlePaint = Paint()
      ..color = AppColors.softTeal.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.45, circlePaint);

    final buildingPaint = Paint()
      ..color = AppColors.softTeal
      ..style = PaintingStyle.fill;

    final building1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.4, size.width * 0.15, size.height * 0.35),
      const Radius.circular(8),
    );
    canvas.drawRRect(building1, buildingPaint);

    buildingPaint.color = AppColors.mutedLavender;
    final building2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.4, size.height * 0.3, size.width * 0.18, size.height * 0.45),
      const Radius.circular(8),
    );
    canvas.drawRRect(building2, buildingPaint);

    buildingPaint.color = AppColors.warmPeach;
    final building3 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.62, size.height * 0.45, size.width * 0.15, size.height * 0.3),
      const Radius.circular(8),
    );
    canvas.drawRRect(building3, buildingPaint);

    final windowPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 2; j++) {
        canvas.drawRect(
          Rect.fromLTWH(
            size.width * 0.23 + j * size.width * 0.05,
            size.height * 0.45 + i * size.height * 0.1,
            size.width * 0.03,
            size.height * 0.05,
          ),
          windowPaint,
        );
      }
    }

    final signalPaint = Paint()
      ..color = AppColors.mintGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final signalCenter = Offset(size.width * 0.49, size.height * 0.2);
    for (var i = 1; i <= 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: signalCenter, radius: size.width * 0.04 * i),
        -2.5,
        1.8,
        false,
        signalPaint..color = AppColors.mintGreen.withOpacity(1 - i * 0.25),
      );
    }

    final dotPaint = Paint()
      ..color = AppColors.mintGreen
      ..style = PaintingStyle.fill;
    canvas.drawCircle(signalCenter, 4, dotPaint);
  }

  void _drawCommunityIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final circlePaint = Paint()
      ..color = AppColors.mutedLavender.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.45, circlePaint);

    _drawPerson(canvas, Offset(size.width * 0.3, size.height * 0.5), size, AppColors.softTeal);
    _drawPerson(canvas, Offset(size.width * 0.5, size.height * 0.45), size, AppColors.mutedLavender);
    _drawPerson(canvas, Offset(size.width * 0.7, size.height * 0.5), size, AppColors.warmPeach);

    final connectionPaint = Paint()
      ..color = AppColors.mintGreen.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.42),
      Offset(size.width * 0.45, size.height * 0.38),
      connectionPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.55, size.height * 0.38),
      Offset(size.width * 0.65, size.height * 0.42),
      connectionPaint,
    );

    final heartPaint = Paint()
      ..color = AppColors.critical.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final heartPath = Path();
    final heartCenter = Offset(size.width * 0.5, size.height * 0.28);
    heartPath.moveTo(heartCenter.dx, heartCenter.dy + 8);
    heartPath.cubicTo(
      heartCenter.dx - 15, heartCenter.dy,
      heartCenter.dx - 15, heartCenter.dy - 15,
      heartCenter.dx, heartCenter.dy - 8,
    );
    heartPath.cubicTo(
      heartCenter.dx + 15, heartCenter.dy - 15,
      heartCenter.dx + 15, heartCenter.dy,
      heartCenter.dx, heartCenter.dy + 8,
    );
    canvas.drawPath(heartPath, heartPaint);
  }

  void _drawPerson(Canvas canvas, Offset position, Size size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(position.dx, position.dy - size.height * 0.08), size.width * 0.06, paint);

    final bodyPath = Path();
    bodyPath.moveTo(position.dx - size.width * 0.06, position.dy + size.height * 0.12);
    bodyPath.quadraticBezierTo(
      position.dx, position.dy - size.height * 0.02,
      position.dx + size.width * 0.06, position.dy + size.height * 0.12,
    );
    canvas.drawPath(bodyPath, paint);
  }

  void _drawWellnessIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final circlePaint = Paint()
      ..color = AppColors.mintGreen.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.45, circlePaint);

    final brainPaint = Paint()
      ..color = AppColors.softTeal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final brainPath = Path();
    brainPath.moveTo(size.width * 0.35, size.height * 0.5);
    brainPath.quadraticBezierTo(
      size.width * 0.3, size.height * 0.35,
      size.width * 0.45, size.height * 0.32,
    );
    brainPath.quadraticBezierTo(
      size.width * 0.5, size.height * 0.28,
      size.width * 0.55, size.height * 0.32,
    );
    brainPath.quadraticBezierTo(
      size.width * 0.7, size.height * 0.35,
      size.width * 0.65, size.height * 0.5,
    );
    brainPath.quadraticBezierTo(
      size.width * 0.68, size.height * 0.6,
      size.width * 0.5, size.height * 0.65,
    );
    brainPath.quadraticBezierTo(
      size.width * 0.32, size.height * 0.6,
      size.width * 0.35, size.height * 0.5,
    );
    canvas.drawPath(brainPath, brainPaint);

    final detailPaint = Paint()
      ..color = AppColors.mutedLavender
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(size.width * 0.43, size.height * 0.4),
      Offset(size.width * 0.43, size.height * 0.55),
      detailPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.57, size.height * 0.4),
      Offset(size.width * 0.57, size.height * 0.55),
      detailPaint,
    );

    final leafPaint = Paint()
      ..color = AppColors.mintGreen
      ..style = PaintingStyle.fill;

    final leafPath = Path();
    leafPath.moveTo(size.width * 0.72, size.height * 0.35);
    leafPath.quadraticBezierTo(
      size.width * 0.8, size.height * 0.3,
      size.width * 0.78, size.height * 0.22,
    );
    leafPath.quadraticBezierTo(
      size.width * 0.7, size.height * 0.25,
      size.width * 0.72, size.height * 0.35,
    );
    canvas.drawPath(leafPath, leafPaint);
  }

  @override
  bool shouldRepaint(covariant _IllustrationPainter oldDelegate) {
    return oldDelegate.pageIndex != pageIndex;
  }
}
