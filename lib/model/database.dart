import 'package:mentor_tracking/model/uuid.dart';
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

  var database = await db;
  print("openDatabase took ${monitor.timeElapsed().inMilliseconds}ms");

  await _updateMaxId(database);
  print("open and get max ID took ${monitor.timeElapsed().inMilliseconds}ms");

  return db;
}

void _updateMaxId(Database db) async {
  try {
    var column = "max(id)";
    var maxId = 0;

    var results = await db.query(tableMentee, columns: [column]);

    if (results.length > 0) {
      maxId = results[0][column];
    }

    results = await db.query(tableActivityRecord, columns: [column]);

    if (results.length > 0) {
      var id = results[0][column];

      if (id > maxId) {
        maxId = id;
      }
    }

    setId(maxId);
  } catch (e) {
    print("Unable to query max ID (perhaps tables don't exist?)");
  }
}