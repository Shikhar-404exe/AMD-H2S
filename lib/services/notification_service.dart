import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final Logger _logger = Logger();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  Future<void> initialize() async {
    await requestPermission();

    _fcmToken = await _messaging.getToken();
    _logger.i('FCM Token: $_fcmToken');

    _messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      _logger.i('FCM Token refreshed: $newToken');
    });

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  Future<bool> requestPermission() async {
    PermissionStatus status = await Permission.notification.request();

    if (status.isDenied) {
      status = await Permission.notification.request();
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _logger.i('Foreground message: ${message.notification?.title}');
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    _logger.i('Message opened app: ${message.notification?.title}');
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      _logger.i('Subscribed to topic: $topic');
    } catch (e) {
      _logger.e('Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      _logger.i('Unsubscribed from topic: $topic');
    } catch (e) {
      _logger.e('Error unsubscribing from topic: $e');
    }
  }
}
