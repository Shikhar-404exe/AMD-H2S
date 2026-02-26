import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'services/issue_service.dart';
import 'services/iot_service.dart';
import 'services/health_service.dart';
import 'services/calm_zone_service.dart';
import 'services/crowd_service.dart';
import 'services/environmental_service.dart';
import 'services/admin_service.dart';
import 'services/user_service.dart';
import 'services/storage_service.dart';
import 'services/connectivity_service.dart';
import 'services/theme_service.dart';
import 'engines/priority_engine.dart';
import 'engines/cognitive_load_engine.dart';
import 'engines/crowd_density_engine.dart';
import 'engines/calm_recommendation_engine.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env').catchError((_) {});

  await StorageService().init();
  await ThemeService().init();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const CivicMindApp());
}

class CivicMindApp extends StatelessWidget {
  const CivicMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => IssueService()),
        ChangeNotifierProvider(create: (_) => IoTService()),
        ChangeNotifierProvider(create: (_) => HealthService()),
        ChangeNotifierProvider(create: (_) => CalmZoneService()),
        ChangeNotifierProvider(create: (_) => CrowdService()),
        ChangeNotifierProvider(create: (_) => EnvironmentalService()),
        ChangeNotifierProvider(create: (_) => AdminService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        Provider(create: (_) => PriorityEngine()),
        Provider(create: (_) => CognitiveLoadEngine()),
        Provider(create: (_) => CrowdDensityEngine()),
        Provider(create: (_) => CalmRecommendationEngine()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, _) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  themeService.isDarkMode ? Brightness.light : Brightness.dark,
            ),
          );

          return MaterialApp(
            title: 'CivicMind',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: AppRouter.splash,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
