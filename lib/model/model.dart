import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mentor_tracking/model/activity_record.dart';
import 'package:mentor_tracking/model/mentee.dart';
import 'package:mentor_tracking/utilities/performance_monitor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MenteeModel extends ChangeNotifier {
  static const kInitialDataPath = "assets/initial_data.json";
  static const kDataPath = "data.json";

  Database _database;
  var _mentees = <Mentee>[];

  MenteeModel() {
    _getInitialData();
  }

  Future<File> get _dataFile async {
    var docsPath = await _documentsPath;

    return File('$docsPath/$kDataPath');
  }

  Future<String> get _documentsPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  void _openDatabase() async {
    var dbPath = await getDatabasesPath();

    print(dbPath);

    _database = await openDatabase(
      join(await getDatabasesPath(), 'mentoring.db'),
      onCreate: (db, version) async {
        await db.execute(
          """
          CREATE TABLE mentee(
            id INTEGER PRIMARY KEY,
            firstName TEXT,
            lastName TEXT,
            cellPhone TEXT,
            email TEXT)
          """,
        );
        return db.execute(
          """
          CREATE TABLE activityRecord(
            id INTEGER PRIMARY KEY,
            menteeId INTEGER,
            date TEXT,
            minutesSpent INTEGER,
            notes TEXT)
          """,
        );
      },
      version: 1,
    );
  }

  void _getInitialData() async {
    _openDatabase();

    var dataFile = await _dataFile;

    if (dataFile.existsSync()) {
      var jsonString = await dataFile.readAsString();
      var jsonData = jsonDecode(jsonString);

      jsonData.forEach((jsonObject) {
        _mentees.add(Mentee.fromJson(jsonObject));
      });

      notifyListeners();
    }
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
    mentee.id = nextId();
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

  @override
  void notifyListeners() {
    super.notifyListeners();

    saveMentees();
  }

  Future<void> saveMentees() async {
    var monitor = PerformanceMonitor();
    final file = await _dataFile;
    final data = jsonEncode(_mentees);

    await file.writeAsString(jsonEncode(_mentees));

    print("saveMentees took ${monitor.timeElapsed().inMicroseconds}µs");
  }

  // NEEDSWORK: implement delete
}

int _nextIdValue = 10;

String nextId() {
  _nextIdValue += 1;

  return _nextIdValue.toString();
}
