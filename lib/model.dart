import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Mentee {
  static const kFieldId = "id";
  static const kFieldLastName = "lastName";
  static const kFieldFirstName = "firstName";
  static const kFieldCellPhone = "cellPhone";
  static const kFieldEmail = "email";
  static const kFieldActivityLog = "activityLog";

  var id = "";
  var lastName = "";
  var firstName = "";
  var cellPhone = "";
  var email = "";
  var activityLog = List<ActivityRecord>();

  Mentee(this.id, this.lastName, this.firstName, this.cellPhone, this.email,
      this.activityLog);

  Mentee.fromJson(Map<String, dynamic> json)
      : this.id = json[kFieldId],
        this.lastName = json[kFieldLastName],
        this.firstName = json[kFieldFirstName],
        this.cellPhone = json[kFieldCellPhone],
        this.email = json[kFieldEmail] {
    json[kFieldActivityLog].forEach((activityRecord) {
      activityLog.add(ActivityRecord.fromJson(activityRecord));
    });
  }

  String getField(String fieldName) {
    switch (fieldName) {
      case kFieldLastName:
        return lastName;
      case kFieldFirstName:
        return firstName;
      case kFieldCellPhone:
        return cellPhone;
      case kFieldEmail:
        return email;
    }

    return null;
  }
}

class ActivityRecord {
  static const kFieldId = "id";
  static const kFieldMenteeId = "menteeId";
  static const kFieldDate = "date";
  static const kFieldMinutesSpent = "minutesSpent";
  static const kFieldNotes = "notes";

  String id = _nextId();
  String menteeId;
  DateTime date = DateTime.now();
  int minutesSpent = 30;
  String notes = "";

  ActivityRecord(
      this.id, this.menteeId, this.date, this.minutesSpent, this.notes);

  ActivityRecord.forMentee(String menteeId) : this.menteeId = menteeId;

  ActivityRecord.fromJson(Map<String, dynamic> json)
      : this.id = json[kFieldId],
        this.menteeId = json[kFieldMenteeId],
        this.date = DateTime.parse(json[kFieldDate]),
        this.minutesSpent = json[kFieldMinutesSpent],
        this.notes = json[kFieldNotes];
}

class MenteeModel extends ChangeNotifier {
  static const kInitialDataPath = "assets/initial_data.json";

  var _mentees = <Mentee>[];

  MenteeModel() {
    _getInitialData();
  }

  void _getInitialData() async {
    var jsonString = await rootBundle.loadString(kInitialDataPath);
    var jsonData = jsonDecode(jsonString);

    jsonData.forEach((jsonObject) {
      _mentees.add(Mentee.fromJson(jsonObject));
    });

    notifyListeners();
  }

  get mentees => _mentees;
  get activityRecords => _mentees
      .map((mentee) => mentee.activityLog)
      .reduce((value, element) => value + element);

  Mentee menteeForMenteeId(String menteeId) {
    return _mentees.firstWhere((mentee) => mentee.id == menteeId);
  }

  List<ActivityRecord> activityRecordsForMenteeId(String menteeId) {
    return _mentees.firstWhere((mentee) => mentee.id == menteeId).activityLog;
  }

  void addMentee(Mentee mentee) {
    mentee.id = _nextId();
    _mentees.add(mentee);
    notifyListeners();
  }

  void addActivityRecordForMentee(String menteeId, ActivityRecord record) {
    _mentees
        .firstWhere((mentee) => mentee.id == menteeId)
        .activityLog
        .add(record);
    notifyListeners();
  }

  void editMentee(Mentee mentee) {
    var editedMentee = _mentees.firstWhere((m) => m.id == mentee.id);

    if (editedMentee != null) {
      editedMentee.firstName = mentee.firstName;
      editedMentee.lastName = mentee.lastName;
      editedMentee.cellPhone = mentee.cellPhone;
      editedMentee.email = mentee.email;
    }

    notifyListeners();
  }

  // NEEDSWORK: implement delete
}

int _nextIdValue = 10;

String _nextId() {
  _nextIdValue += 1;

  return _nextIdValue.toString();
}
