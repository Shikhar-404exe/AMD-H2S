import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AnimatedGauge extends StatefulWidget {
  final double value;
  final double size;
  final double strokeWidth;

  const AnimatedGauge({
    super.key,
    required this.value,
    this.size = 200,
    this.strokeWidth = 20,
  });

  @override
  State<AnimatedGauge> createState() => _AnimatedGaugeState();
}

class _AnimatedGaugeState extends State<AnimatedGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(begin: _animation.value, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _GaugePainter(
              value: _animation.value,
              strokeWidth: widget.strokeWidth,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(_animation.value * 100).toInt()}',
                    style: TextStyle(
                      fontSize: widget.size * 0.25,
                      fontWeight: FontWeight.bold,
                      color: _getColor(_animation.value),
                    ),
                  ),
                  Text(
                    'CLS',
                    style: TextStyle(
                      fontSize: widget.size * 0.08,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getColor(double value) {
    if (value >= 0.7) return AppColors.critical;
    if (value >= 0.5) return AppColors.warning;
    return AppColors.success;
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final double strokeWidth;

  _GaugePainter({required this.value, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = 0.75 * pi;
    const sweepAngle = 1.5 * pi;

    final backgroundPaint = Paint()
      ..color = AppColors.textTertiary.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: [
        AppColors.success,
        AppColors.mintGreen,
        AppColors.warning,
        AppColors.high,
        AppColors.critical,
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * value,
      false,
      progressPaint,
    );

    final indicatorAngle = startAngle + sweepAngle * value;
    final indicatorX = center.dx + radius * cos(indicatorAngle);
    final indicatorY = center.dy + radius * sin(indicatorAngle);

    final indicatorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(indicatorX, indicatorY), strokeWidth / 2.5, indicatorPaint);

    final indicatorBorderPaint = Paint()
      ..color = _getColor(value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(Offset(indicatorX, indicatorY), strokeWidth / 2.5, indicatorBorderPaint);
  }

  Color _getColor(double value) {
    if (value >= 0.7) return AppColors.critical;
    if (value >= 0.5) return AppColors.warning;
    return AppColors.success;
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
