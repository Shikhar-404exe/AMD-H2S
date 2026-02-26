import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/utilities/helpers.dart';

class ElevatedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const ElevatedCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient ?? Helpers.getCardGradient(context),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
