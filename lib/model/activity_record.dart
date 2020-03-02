import 'package:mentor_tracking/model/model.dart';

class ActivityRecord {
  static const kFieldId = "id";
  static const kFieldMenteeId = "menteeId";
  static const kFieldDate = "date";
  static const kFieldMinutesSpent = "minutesSpent";
  static const kFieldNotes = "notes";

  String id = nextId();
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

  Map<String, dynamic> toJson() => {
        kFieldId: id,
        kFieldMenteeId: menteeId,
        kFieldDate: date.toIso8601String(),
        kFieldMinutesSpent: minutesSpent,
        kFieldNotes: notes,
      };
}
