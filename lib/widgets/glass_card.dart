import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/utilities/helpers.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(borderRadius ?? AppConstants.borderRadiusLarge),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? Helpers.getCardColor(context).withOpacity(0.85)
                : Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.borderRadiusLarge),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
