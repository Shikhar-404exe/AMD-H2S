class AppConstants {
  static const String appName = 'CivicMind';
  static const String appVersion = '1.0.0';
  
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusMedium = 20.0;
  static const double borderRadiusLarge = 28.0;
  
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  static const double cardElevation = 8.0;
  static const double shadowBlur = 20.0;
  static const double shadowSpread = 0.0;
  
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 400);
  static const Duration animationSlow = Duration(milliseconds: 600);
  
  static const List<String> issueCategories = [
    'Road Damage',
    'Street Light',
    'Water Supply',
    'Garbage',
    'Drainage',
    'Traffic Signal',
    'Public Safety',
    'Noise Pollution',
    'Air Quality',
    'Other',
  ];
  
  static const List<String> zones = [
    'Zone A - Downtown',
    'Zone B - Residential North',
    'Zone C - Industrial',
    'Zone D - Commercial',
    'Zone E - Residential South',
    'Zone F - Parks & Recreation',
  ];
  
  static const Map<String, String> svgUrls = {
    'smart_city': 'https://www.svgrepo.com/show/530438/city-buildings.svg',
    'calm_zone': 'https://www.svgrepo.com/show/530440/meditation.svg',
    'infrastructure': 'https://www.svgrepo.com/show/530437/construction.svg',
    'environmental': 'https://www.svgrepo.com/show/530439/eco-friendly.svg',
    'admin': 'https://www.svgrepo.com/show/530441/dashboard.svg',
    'onboarding1': 'https://www.svgrepo.com/show/530442/smart-home.svg',
    'onboarding2': 'https://www.svgrepo.com/show/530443/analytics.svg',
    'onboarding3': 'https://www.svgrepo.com/show/530444/community.svg',
  };
}
