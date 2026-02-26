import 'package:flutter/material.dart';

class AppColors {
  static const Color softTeal = Color(0xFF7EC8C8);
  static const Color mutedLavender = Color(0xFFB8A9C9);
  static const Color warmPeach = Color(0xFFFAD4C0);
  static const Color mintGreen = Color(0xFFA8E6CF);
  static const Color powderBlue = Color(0xFFB5D8EB);

  static const Color background = Color(0xFFF8F9FC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color glassMorphism = Color(0x40FFFFFF);

  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF5C6378);
  static const Color textTertiary = Color(0xFF9BA3B5);

  static const Color critical = Color(0xFFE57373);
  static const Color high = Color(0xFFFFB74D);
  static const Color medium = Color(0xFFFFD54F);
  static const Color low = Color(0xFF81C784);
  static const Color resolved = Color(0xFF4DB6AC);

  static const Color error = Color(0xFFE57373);
  static const Color success = Color(0xFF81C784);
  static const Color warning = Color(0xFFFFB74D);
  static const Color info = Color(0xFF64B5F6);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [softTeal, powderBlue],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mutedLavender, warmPeach],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF8F9FC), Color(0xFFEEF1F8)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FC)],
  );

  static const Color amdRed = Color(0xFFED1C24);
  static const Color amdRedDark = Color(0xFFD81B21);
  static const Color amdRedLight = Color(0xFFFF4D4D);

  static const Color darkBackground = Color(0xFF0D0D0D);
  static const Color darkCard = Color(0xFF1A1A1A);
  static const Color darkCardElevated = Color(0xFF242424);
  static const Color darkGlassMorphism = Color(0x20FFFFFF);

  static const Color darkTextPrimary = Color(0xFFE8E8E8);
  static const Color darkTextSecondary = Color(0xFFB4B4B4);
  static const Color darkTextTertiary = Color(0xFF808080);

  static const Color darkCritical = Color(0xFFFF4D4D);
  static const Color darkHigh = Color(0xFFFFAA00);
  static const Color darkMedium = Color(0xFFFFC947);
  static const Color darkLow = Color(0xFF4CAF50);
  static const Color darkResolved = Color(0xFF00BFA5);

  static const Color darkSuccess = Color(0xFF4CAF50);
  static const Color darkWarning = Color(0xFFFFAA00);
  static const Color darkError = Color(0xFFFF4D4D);
  static const Color darkInfo = Color(0xFF42A5F5);

  static const LinearGradient darkPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [softTeal, powderBlue],
  );

  static const LinearGradient darkSecondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF121212), Color(0xFF0D0D0D)],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1E1E), Color(0xFF1A1A1A)],
  );
}
