import 'package:flutter/foundation.dart';
import 'package:mentor_tracking/model/activity_record.dart';
import 'package:mentor_tracking/model/mentee.dart';

abstract class MenteeModel extends ChangeNotifier {
  /// Be sure to call super.addMentee(mentee) AFTER adding it in the subclass.
  Future<void> addMentee(Mentee mentee) async {
    notifyListeners();
  }

  void addActivityRecordForMentee(int menteeId, ActivityRecord record) async {
    notifyListeners();
  }

  Future<List<ActivityRecord>> activityRecords();
  Future<List<ActivityRecord>> activityRecordsForMenteeId(int id);
  Future<List<Mentee>> mentees();
  Future<Mentee> menteeForId(int id);

  Future<void> editActivityRecord(ActivityRecord record) async {
    notifyListeners();
  }

  Future<void> editMentee(Mentee mentee) async {
    notifyListeners();
  }

  Future<void> deleteActivityRecord(int id) async {
    notifyListeners();
  }

  Future<void> deleteMentee(int id) async {
    notifyListeners();
  }
}
