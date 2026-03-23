import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as timezone;

class NotificationHelper {
  const NotificationHelper._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static FlutterLocalNotificationsPlugin get plugin => _plugin;

  static Future<void> initialize() async {
    await _initializeTimezone();
    await _initializeNotifications();
    await _createNotificationChannel();
  }

  static Future<void> _initializeTimezone() async {
    try {
      tz.initializeTimeZones();

      try {
        timezone.setLocalLocation(
          timezone.getLocation(DateTime.now().timeZoneName),
        );
      } catch (error, stackTrace) {
        _reportInitializationError(
          'Failed to set local timezone. Falling back to UTC.',
          error,
          stackTrace,
        );
        timezone.setLocalLocation(timezone.UTC);
      }
    } catch (error, stackTrace) {
      _reportInitializationError(
        'Failed to initialize timezone data.',
        error,
        stackTrace,
      );
    }
  }

  static Future<void> _initializeNotifications() async {
    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initSettings = InitializationSettings(android: androidSettings);

      await _plugin.initialize(initSettings);
    } catch (error, stackTrace) {
      _reportInitializationError(
        'Failed to initialize local notifications.',
        error,
        stackTrace,
      );
    }
  }

  static Future<void> _createNotificationChannel() async {
    try {
      const channel = AndroidNotificationChannel(
        'alarm_channel',
        'Alarms',
        description: 'Channel for alarm notifications',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound('notification'),
      );

      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    } catch (error, stackTrace) {
      _reportInitializationError(
        'Failed to create notification channel.',
        error,
        stackTrace,
      );
    }
  }

  static void _reportInitializationError(
    String message,
    Object error,
    StackTrace stackTrace,
  ) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'notification_helper',
        context: ErrorDescription(message),
      ),
    );
  }
}
