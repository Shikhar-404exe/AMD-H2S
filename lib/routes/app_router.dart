import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/report_issue_screen.dart';
import '../screens/smart_map_screen.dart';
import '../screens/calm_zone_screen.dart';
import '../screens/cognitive_load_screen.dart';
import '../screens/crowd_density_screen.dart';
import '../screens/environmental_screen.dart';
import '../screens/admin_dashboard_screen.dart';
import '../screens/settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String reportIssue = '/report-issue';
  static const String smartMap = '/smart-map';
  static const String calmZone = '/calm-zone';
  static const String cognitiveLoad = '/cognitive-load';
  static const String crowdDensity = '/crowd-density';
  static const String environmental = '/environmental';
  static const String adminDashboard = '/admin-dashboard';
  static const String settings = '/settings';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _createRoute(const SplashScreen());
      case onboarding:
        return _createRoute(const OnboardingScreen());
      case login:
        return _createRoute(const LoginScreen());
      case home:
        return _createRoute(const HomeScreen());
      case reportIssue:
        return _createRoute(const ReportIssueScreen());
      case smartMap:
        return _createRoute(const SmartMapScreen());
      case calmZone:
        return _createRoute(const CalmZoneScreen());
      case cognitiveLoad:
        return _createRoute(const CognitiveLoadScreen());
      case crowdDensity:
        return _createRoute(const CrowdDensityScreen());
      case environmental:
        return _createRoute(const EnvironmentalScreen());
      case adminDashboard:
        return _createRoute(const AdminDashboardScreen());
      case AppRouter.settings:
        return _createRoute(const SettingsScreen());
      default:
        return _createRoute(const HomeScreen());
    }
  }
  
  static PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
