import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';

class Helpers {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return formatDate(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  static Color getPriorityColor(double priority) {
    if (priority >= 0.8) return AppColors.critical;
    if (priority >= 0.6) return AppColors.high;
    if (priority >= 0.4) return AppColors.medium;
    return AppColors.low;
  }

  static String getPriorityLabel(double priority) {
    if (priority >= 0.8) return 'Critical';
    if (priority >= 0.6) return 'High';
    if (priority >= 0.4) return 'Medium';
    return 'Low';
  }

  static Color getCognitiveLoadColor(double load) {
    if (load >= 0.7) return AppColors.critical;
    if (load >= 0.5) return AppColors.warning;
    return AppColors.success;
  }

  static String getCognitiveLoadLabel(double load) {
    if (load >= 0.7) return 'High Stress';
    if (load >= 0.5) return 'Moderate';
    return 'Relaxed';
  }

  static Color getDensityColor(double density) {
    if (density >= 0.8) return AppColors.critical;
    if (density >= 0.6) return AppColors.high;
    if (density >= 0.4) return AppColors.medium;
    return AppColors.low;
  }

  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Road Damage':
        return Icons.warning_rounded;
      case 'Street Light':
        return Icons.lightbulb_rounded;
      case 'Water Supply':
        return Icons.water_drop_rounded;
      case 'Garbage':
        return Icons.delete_rounded;
      case 'Drainage':
        return Icons.water_rounded;
      case 'Traffic Signal':
        return Icons.traffic_rounded;
      case 'Public Safety':
        return Icons.shield_rounded;
      case 'Noise Pollution':
        return Icons.volume_up_rounded;
      case 'Air Quality':
        return Icons.air_rounded;
      default:
        return Icons.report_rounded;
    }
  }

  static double clamp(double value, double min, double max) {
    return value.clamp(min, max);
  }

  static Gradient getBackgroundGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? AppColors.darkBackgroundGradient
        : AppColors.backgroundGradient;
  }

  static Gradient getCardGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.darkCardGradient : AppColors.cardGradient;
  }

  static Color getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.darkBackground : AppColors.background;
  }

  static Color getCardColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.darkCard : AppColors.cardBackground;
  }

  static Color getTextPrimary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  }

  static Color getTextSecondary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
  }

  static Color getTextTertiary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;
  }

  static Color getPrimaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.softTeal : AppColors.softTeal;
  }
}
