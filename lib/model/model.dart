import 'package:flutter/material.dart';
import 'package:mentor_tracking/model/activity_record.dart';
import 'package:mentor_tracking/model/database.dart';
import 'package:mentor_tracking/model/mentee.dart';
import 'package:mentor_tracking/model/uuid.dart';
import 'package:sqflite/sqflite.dart';

class MenteeModel extends ChangeNotifier {
  final Database database;

  MenteeModel(this.database);

  /*========================================================================
   *                        CRUD METHODS
   */
  /*------------------------------------------------------------------------
   *                        CREATE METHODS
   */
  Future<void> addMentee(Mentee mentee) async {
    mentee.id = nextId();
    await database.insert(
      tableMentee,
      mentee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    notifyListeners();
  }

  void addActivityRecordForMentee(int menteeId, ActivityRecord record) async {
    record.menteeId = menteeId;
    await database.insert(
      tableActivityRecord,
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    notifyListeners();
  }

  /*------------------------------------------------------------------------
   *                        READ METHODS
   */
  Future<List<ActivityRecord>> activityRecords() async {
    // Start by querying the table for all records, which come out as maps
    final List<Map<String, dynamic>> maps =
        await database.query(tableActivityRecord);

    // Then convert the list of maps to a list of objects
    return List.generate(maps.length, (i) {
      return ActivityRecord.fromMap(maps[i]);
    });
  }

  Future<List<ActivityRecord>> activityRecordsForMenteeId(int id) async {
    final List<Map<String, dynamic>> maps = await database.query(
      tableActivityRecord,
      where: "menteeId = ?",
      whereArgs: [id],
    );

    return List.generate(maps.length, (i) {
      return ActivityRecord.fromMap(maps[i]);
    });
  }

  Future<List<Mentee>> mentees() async {
    final List<Map<String, dynamic>> maps = await database.query(tableMentee);

    return List.generate(maps.length, (i) {
      return Mentee.fromMap(maps[i]);
    });
  }

  Future<Mentee> menteeForId(int id) async {
    final List<Map<String, dynamic>> maps = await database.query(
      tableMentee,
      where: "id = ?",
      whereArgs: [id],
    );

    return List.generate(maps.length, (i) {
      return Mentee.fromMap(maps[i]);
    }).first;
  }

  /*------------------------------------------------------------------------
   *                        UPDATE METHODS
   */
  Future<void> editActivityRecord(ActivityRecord record) async {
    await database.update(
      tableActivityRecord,
      record.toMap(),
      where: "id = ?",
      whereArgs: [record.id],
    );

    notifyListeners();
  }

  Future<void> editMentee(Mentee mentee) async {
    await database.update(
      tableMentee,
      mentee.toMap(),
      where: "id = ?",
      whereArgs: [mentee.id],
    );

    notifyListeners();
  }

  /*------------------------------------------------------------------------
   *                        DELETE METHODS
   */
  Future<void> deleteActivityRecord(int id) async {
    await database.delete(
      tableActivityRecord,
      where: "id = ?",
      whereArgs: [id],
    );

    notifyListeners();
  }

  Future<void> deleteMentee(int id) async {
    await database.delete(
      tableMentee,
      where: "id = ?",
      whereArgs: [id],
    );

    // Don't forget to delete any linked activity records too
    await database.delete(
      tableActivityRecord,
      where: "menteeId = ?",
      whereArgs: [id],
    );

    notifyListeners();
  }
}
