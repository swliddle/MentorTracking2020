import 'package:flutter/material.dart';
import 'package:mentor_tracking/model/notifications_record.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const keyNotifyDays = 'notifyDays';
  static const keyNotifyTimeOfDay = 'timeOfDay';

  Future<void> clearNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyNotifyDays);
    await prefs.remove(keyNotifyTimeOfDay);
  }

  Future<NotificationsRecord> notificationsRecord() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final daysToNotify = sharedPrefs.getStringList(keyNotifyDays);
    final timeOfDay = sharedPrefs.getString(keyNotifyTimeOfDay);
    NotificationsRecord record = NotificationsRecord();

    if (timeOfDay != null) {
      var timeParts = timeOfDay.split(":");

      if (timeParts.length == 2) {
        record.timeOfDay = TimeOfDay(
            hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      }
    }

    if (daysToNotify != null) {
      record.notifyDays = daysToNotify.map((day) => day != 'n');
    }

    return record;
  }

  Future<void> saveNotificationSettings(NotificationsRecord record) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
        keyNotifyDays, record.notifyDays.map((day) => day ? 'y' : 'n'));
    await prefs.setString(keyNotifyTimeOfDay,
        '${record.timeOfDay.hour}:${record.timeOfDay.minute}');
  }

  static Preferences get(BuildContext context, {bool listen = false}) {
    return Provider.of(context, listen: listen);
  }
}
