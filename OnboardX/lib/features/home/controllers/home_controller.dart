import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../helpers/location_helper.dart';
import '../../../helpers/notification_helper.dart';
import '../models/alarm.dart';

class HomeController extends GetxController {
  final TextEditingController locationController = TextEditingController();
  final RxList<Alarm> alarms = <Alarm>[].obs;
  int _alarmIdCounter = 0;

  @override
  void onInit() {
    super.onInit();
    final initialLocation = Get.arguments as String?;
    if (initialLocation != null && initialLocation.isNotEmpty) {
      locationController.text = initialLocation;
    }
  }

  @override
  void onClose() {
    locationController.dispose();
    super.onClose();
  }

  Future<void> getCurrentLocation() async {
    final result = await LocationHelper.requestLocation();

    if (result.isSuccess && result.address != null) {
      locationController.text = result.address!;
    } else if (result.errorMessage != null) {
      _showSnackBar(result.errorMessage!);
    }
  }

  Future<void> addAlarm() async {
    if (!await _ensureNotificationPermissions()) return;

    final selectedDateTime = await _selectAlarmDateTime();

    if (selectedDateTime == null) {
      return;
    }

    final locationText = locationController.text.trim();
    final alarm = Alarm(
      id: _alarmIdCounter++,
      dateTime: selectedDateTime,
      location: locationText.isNotEmpty ? locationText : 'Current Location',
    );

    alarms.add(alarm);
    await _scheduleNotification(alarm);
  }

  Future<void> toggleAlarm(int index) async {
    final alarm = alarms[index];
    alarm.isActive = !alarm.isActive;
    alarms.refresh();

    if (alarm.isActive) {
      await _scheduleNotification(alarm);
    } else {
      await _cancelNotification(alarm.id);
    }
  }

  Future<bool> _ensureNotificationPermissions() async {
    var notificationStatus = await Permission.notification.status;

    if (!notificationStatus.isGranted) {
      notificationStatus = await Permission.notification.request();

      if (!notificationStatus.isGranted) {
        _showSnackBar(AppStrings.notificationPermissionDenied);
        return false;
      }
    }

    var exactAlarmStatus = await Permission.scheduleExactAlarm.status;

    if (!exactAlarmStatus.isGranted) {
      exactAlarmStatus = await Permission.scheduleExactAlarm.request();

      if (!exactAlarmStatus.isGranted) {
        _showSnackBar(AppStrings.exactAlarmPermissionDenied);
        return false;
      }
    }

    return true;
  }

  Future<DateTime?> _selectAlarmDateTime() async {
    final datePickerContext = Get.context;
    if (datePickerContext == null) return null;

    final pickedDate = await showDatePicker(
      context: datePickerContext,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate == null) {
      return null;
    }

    final timePickerContext = Get.context;
    if (timePickerContext == null || !timePickerContext.mounted) return null;

    final pickedTime = await showTimePicker(
      context: timePickerContext,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null || !timePickerContext.mounted) {
      return null;
    }

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  Future<void> _scheduleNotification(Alarm alarm) async {
    if (!alarm.isActive) return;

    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      alarm.dateTime.year,
      alarm.dateTime.month,
      alarm.dateTime.day,
      alarm.dateTime.hour,
      alarm.dateTime.minute,
    );

    if (scheduledTime.isBefore(now.add(const Duration(minutes: 1)))) {
      _showSnackBar(AppStrings.futureAlarmWarning);
      return;
    }

    try {
      await NotificationHelper.plugin.zonedSchedule(
        alarm.id,
        AppStrings.alarmTitle,
        'Time to wake up at ${alarm.location}!',
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'alarm_channel',
            'Alarms',
            channelDescription: 'Channel for alarm notifications',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
            fullScreenIntent: true,
            category: AndroidNotificationCategory.alarm,
            audioAttributesUsage: AudioAttributesUsage.alarm,
            autoCancel: false,
            ongoing: false,
            enableLights: true,
            ledColor: Colors.red,
            ledOnMs: 1000,
            ledOffMs: 500,
            ticker: 'Alarm notification',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      _showSnackBar(
        'Alarm scheduled for ${DateFormat('h:mm a EEE dd MMM yyyy').format(alarm.dateTime)}',
        backgroundColor: Colors.green,
      );
    } catch (error) {
      _showSnackBar('Failed to schedule notification: $error');
    }
  }

  Future<void> _cancelNotification(int id) async {
    await NotificationHelper.plugin.cancel(id);
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    Get.snackbar(
      'Alarm',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor ?? AppColors.cardBackground,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(12),
    );
  }
}
