class Mentee {
  var id = "";
  var lastName = "";
  var firstName = "";
  var cellPhone = "";
  var email = "";
  var activityLog = List<ActivityRecord>();

  Mentee(this.id, this.lastName, this.firstName, this.cellPhone, this.email,
      this.activityLog);
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

// NEEDSWORK: This information (mentees and their associated activity records)
// should be managed by a ChangeNotifier so our app can monitor updates to the
// data structure and reflect updates properly in the UI.
var activityRecords = List<ActivityRecord>();
var mentees = List<Mentee>();

// NEEDSWORK: We're a bit dissatisfied with this approach to IDs.  Could it be
// included in a class or something?  At a minimum, when we have a more robust
// model we'll need to update this whenever the model updates.
int _nextIdValue = 1;

String _nextId() {
  _nextIdValue += 1;

  return _nextIdValue.toString();
}
