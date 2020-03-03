import 'package:mentor_tracking/model/uuid.dart';

class ActivityRecord {
  static const kFieldId = "id";
  static const kFieldMenteeId = "menteeId";
  static const kFieldDate = "date";
  static const kFieldMinutesSpent = "minutesSpent";
  static const kFieldNotes = "notes";

  int id = nextId();
  int menteeId;
  DateTime date = DateTime.now();
  int minutesSpent = 30;
  String notes = "";

  ActivityRecord(
      this.id, this.menteeId, this.date, this.minutesSpent, this.notes);

  ActivityRecord.forMentee(int menteeId) : this.menteeId = menteeId;

  ActivityRecord.fromMap(Map<String, dynamic> map)
      : this.id = map[kFieldId],
        this.menteeId = map[kFieldMenteeId],
        this.date = DateTime.parse(map[kFieldDate]),
        this.minutesSpent = map[kFieldMinutesSpent],
        this.notes = map[kFieldNotes];

  Map<String, dynamic> toMap() => {
        kFieldId: id,
        kFieldMenteeId: menteeId,
        kFieldDate: date.toIso8601String(),
        kFieldMinutesSpent: minutesSpent,
        kFieldNotes: notes,
      };
}
