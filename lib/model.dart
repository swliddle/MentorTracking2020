import 'package:flutter/material.dart';

class Mentee {
  var id = "";
  var lastName = "";
  var firstName = "";
  var cellPhone = "";
  var email = "";
  var activityLog = List<ActivityRecord>();

  Mentee(this.id, this.lastName, this.firstName, this.cellPhone, this.email,
      this.activityLog);

  String getField(String fieldName) {
    switch (fieldName) {
      case "lastName":
        return lastName;
      case "firstName":
        return firstName;
      case "cellPhone":
        return cellPhone;
      case "email":
        return email;
    }

    return null;
  }
}

class ActivityRecord {
  String id = _nextId();
  String menteeId;
  DateTime date = DateTime.now();
  int minutesSpent = 30;
  String notes = "";

  ActivityRecord(
      this.id, this.menteeId, this.date, this.minutesSpent, this.notes);

  ActivityRecord.forMentee(String menteeId) : this.menteeId = menteeId;
}

class MenteeModel extends ChangeNotifier {
  var _mentees = <Mentee>[
    Mentee("1", "Doe", "John", "801-555-1212",
        "email@example.com", <ActivityRecord>[
      ActivityRecord("1", "1", DateTime.parse("2020-01-02 08:18:04Z"), 30,
          "Had a great time"),
      ActivityRecord("2", "1", DateTime.parse("2020-01-03 09:19:06Z"), 15,
          "Had a great time"),
      ActivityRecord("3", "1", DateTime.parse("2020-01-04 10:20:09Z"), 30,
          "Had a great time"),
      ActivityRecord("4", "1", DateTime.parse("2020-01-05 11:21:13Z"), 15,
          "Had a great time"),
      ActivityRecord("5", "1", DateTime.parse("2020-01-06 12:22:17Z"), 30,
          "Had a great time"),
    ]),
    Mentee("2", "Roe", "Mary", "801-555-1212",
        "email@example.com", <ActivityRecord>[
      ActivityRecord("1", "1", DateTime.parse("2020-01-07 12:18:04Z"), 30,
          "Had a great time"),
      ActivityRecord("2", "1", DateTime.parse("2020-01-08 13:28:14Z"), 15,
          "Had a great time"),
      ActivityRecord("3", "1", DateTime.parse("2020-01-09 14:38:24Z"), 30,
          "Had a great time"),
      ActivityRecord("4", "1", DateTime.parse("2020-01-10 15:48:34Z"), 15,
          "Had a great time"),
      ActivityRecord("5", "1", DateTime.parse("2020-01-11 16:58:44Z"), 30,
          "Had a great time"),
    ]),
  ];

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
