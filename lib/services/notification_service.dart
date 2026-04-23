import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notification service for FCM push notifications and local alerts.
class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifs =
      FlutterLocalNotificationsPlugin();

  /// Initialize notification channels and request permissions.
  Future<void> initialize() async {
    // Request permissions (iOS + Android 13+)
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true, // For emergency blood requests
    );

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifs.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create Android notification channels
    await _createNotificationChannels();

    // Handle FCM messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);
  }

  /// Get the FCM device token for this device.
  Future<String?> getToken() async {
    return _fcm.getToken();
  }

  /// Subscribe to a topic (e.g., blood group, city).
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
  }

  /// Create Android notification channels for different alert types.
  Future<void> _createNotificationChannels() async {
    final androidPlugin =
        _localNotifs.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // Emergency channel (high priority, vibrate, sound)
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'emergency_channel',
          'Emergency Requests',
          description: 'Critical blood request notifications',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );

      // Match updates channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'match_channel',
          'Match Updates',
          description: 'Donor matching and status updates',
          importance: Importance.high,
        ),
      );

      // General channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'general_channel',
          'General',
          description: 'Reminders, camps, and general updates',
          importance: Importance.defaultImportance,
        ),
      );
    }
  }

  /// Handle foreground FCM message — show local notification.
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final isEmergency = message.data['type'] == 'emergency';

    _localNotifs.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          isEmergency ? 'emergency_channel' : 'match_channel',
          isEmergency ? 'Emergency Requests' : 'Match Updates',
          importance: isEmergency ? Importance.max : Importance.high,
          priority: isEmergency ? Priority.max : Priority.high,
        ),
      ),
      payload: message.data['requestId'] as String?,
    );
  }

  /// Handle notification tap when app was in background.
  void _handleNotificationOpen(RemoteMessage message) {
    // Navigation will be handled by the app based on message data
    // This can be connected to a navigation service or stream
  }

  /// Handle local notification tap.
  void _onNotificationTap(NotificationResponse response) {
    // Navigate to request details based on payload
  }

  /// Show a local notification (for reminders, cooldown alerts, etc.).
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channel = 'general_channel',
  }) async {
    await _localNotifs.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel,
          channel == 'emergency_channel' ? 'Emergency Requests' : 'General',
        ),
      ),
      payload: payload,
    );
  }
}
