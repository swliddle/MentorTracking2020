import 'package:mentor_tracking/utilities/performance_monitor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const databaseFilename = "mentoring.db";
const tableActivityRecord = "activity_record";
const tableMentee = "mentee";

Future<Database> openMentoringDatabase() async {
  var monitor = PerformanceMonitor();

  var db = openDatabase(
    join(await getDatabasesPath(), databaseFilename),
    onCreate: (db, version) async {
      await db.execute(
        """
          CREATE TABLE $tableMentee(
            id INTEGER PRIMARY KEY,
            firstName TEXT,
            lastName TEXT,
            cellPhone TEXT,
            email TEXT)
          """,
      );

      return db.execute(
        """
          CREATE TABLE $tableActivityRecord(
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

  await db;
  print("openDatabase took ${monitor.timeElapsed().inMilliseconds}ms");

  return db;
}
