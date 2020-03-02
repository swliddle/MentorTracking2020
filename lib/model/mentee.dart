import 'package:mentor_tracking/model/activity_record.dart';

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

  Map<String, dynamic> toJson() => {
        kFieldId: id,
        kFieldLastName: lastName,
        kFieldFirstName: firstName,
        kFieldCellPhone: cellPhone,
        kFieldEmail: email,
        kFieldActivityLog: activityLog,
      };
}
