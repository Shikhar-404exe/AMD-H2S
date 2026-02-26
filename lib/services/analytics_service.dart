import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  final Logger _logger = Logger();

  FirebaseAnalyticsObserver get analyticsObserver =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> initialize() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

    FlutterError.onError = (errorDetails) {
      _crashlytics.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
      _logger.d('Analytics event logged: $name');
    } catch (e) {
      _logger.e('Error logging analytics event: $e');
    }
  }

  Future<void> logScreenView(String screenName, String screenClass) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
      _logger.d('Screen view logged: $screenName');
    } catch (e) {
      _logger.e('Error logging screen view: $e');
    }
  }

  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
      await _crashlytics.setUserIdentifier(userId);
      _logger.d('User ID set: $userId');
    } catch (e) {
      _logger.e('Error setting user ID: $e');
    }
  }

  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      _logger.d('User property set: $name = $value');
    } catch (e) {
      _logger.e('Error setting user property: $e');
    }
  }

  Future<void> logLogin(String method) async {
    await logEvent('login', parameters: {'method': method});
  }

  Future<void> logSignUp(String method) async {
    await logEvent('sign_up', parameters: {'method': method});
  }

  Future<void> logIssueReported(String category) async {
    await logEvent('issue_reported', parameters: {'category': category});
  }

  Future<void> logError(dynamic error, StackTrace? stackTrace,
      {String? reason}) async {
    try {
      await _crashlytics.recordError(error, stackTrace, reason: reason);
      _logger.e('Error logged to Crashlytics: $error');
    } catch (e) {
      _logger.e('Error logging to Crashlytics: $e');
    }
  }

  Future<void> log(String message) async {
    try {
      await _crashlytics.log(message);
    } catch (e) {
      _logger.e('Error logging message: $e');
    }
  }
}
