import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CircularMeter extends StatefulWidget {
  final double value;
  final double size;
  final String label;
  final String? centerText;
  final Color? color;

  const CircularMeter({
    super.key,
    required this.value,
    this.size = 120,
    required this.label,
    this.centerText,
    this.color,
  });

  @override
  State<CircularMeter> createState() => _CircularMeterState();
}

class _CircularMeterState extends State<CircularMeter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(CircularMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(begin: _animation.value, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor(double value) {
    if (widget.color != null) return widget.color!;
    if (value >= 0.7) return AppColors.critical;
    if (value >= 0.5) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final color = _getColor(_animation.value);
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _CircularMeterPainter(
                  value: _animation.value,
                  color: color,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.centerText ?? '${(_animation.value * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: widget.size * 0.2,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: widget.size * 0.1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CircularMeterPainter extends CustomPainter {
  final double value;
  final Color color;

  _CircularMeterPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;
    const strokeWidth = 12.0;

    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * value,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularMeterPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
