import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: AppColors.softTeal.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size * 0.6, size * 0.6),
            painter: _LogoPainter(),
          ),
        ],
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    canvas.drawCircle(center, radius, paint);

    final buildingPath = Path();
    buildingPath.moveTo(size.width * 0.3, size.height * 0.7);
    buildingPath.lineTo(size.width * 0.3, size.height * 0.4);
    buildingPath.lineTo(size.width * 0.5, size.height * 0.25);
    buildingPath.lineTo(size.width * 0.7, size.height * 0.4);
    buildingPath.lineTo(size.width * 0.7, size.height * 0.7);

    canvas.drawPath(buildingPath, paint);

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.45),
      Offset(size.width * 0.5, size.height * 0.7),
      paint,
    );

    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.15),
      size.width * 0.06,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
