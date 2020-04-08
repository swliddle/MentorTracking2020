import 'package:flutter/material.dart';

class NotificationsRecord {
//  static const fieldNotifySun = "su";
//  static const fieldNotifyMon = "mo";
//  static const fieldNotifyTue = "tu";
//  static const fieldNotifyWed = "we";
//  static const fieldNotifyThu = "th";
//  static const fieldNotifyFri = "fr";
//  static const fieldNotifySat = "sa";
//  static const fieldTimeHour = "hr";
//  static const fieldTimeMinute = "mn";

  List<bool> notifyDays = [false, false, false, false, false, false, false];
  TimeOfDay timeOfDay = TimeOfDay(hour: 8, minute: 0);

//  NotificationsRecord(this.notifyDays, this.timeOfDay);
//
//  NotificationsRecord.fromMap(Map<String, dynamic> map)
//      : this.notifyDays = List<bool>(),
//        this.timeOfDay = TimeOfDay(
//            hour: int.parse(map[fieldTimeHour]),
//            minute: int.parse(map[fieldTimeMinute]));
//
//  Map<String, dynamic> toMap() => {
//        fieldNotifySun: notifyDays[0],
//        fieldNotifyMon: notifyDays[1],
//        fieldNotifyTue: notifyDays[2],
//        fieldNotifyWed: notifyDays[3],
//        fieldNotifyThu: notifyDays[4],
//        fieldNotifyFri: notifyDays[5],
//        fieldNotifySat: notifyDays[6],
//        fieldTimeHour: timeOfDay.hour,
//        fieldTimeMinute: timeOfDay.minute,
//      };
}
