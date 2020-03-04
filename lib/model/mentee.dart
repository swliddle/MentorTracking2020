class Mentee {
  static const kFieldId = "id";
  static const kFieldLastName = "lastName";
  static const kFieldFirstName = "firstName";
  static const kFieldCellPhone = "cellPhone";
  static const kFieldEmail = "email";
  static const kFieldActivityLog = "activityLog";

  int id = 0;
  var lastName = "";
  var firstName = "";
  var cellPhone = "";
  var email = "";

  Mentee(this.id, this.lastName, this.firstName, this.cellPhone, this.email);

  Mentee.fromMap(Map<String, dynamic> map)
      : this.id = map[kFieldId],
        this.lastName = map[kFieldLastName],
        this.firstName = map[kFieldFirstName],
        this.cellPhone = map[kFieldCellPhone],
        this.email = map[kFieldEmail];

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

  Map<String, dynamic> toMap() => {
        kFieldId: id,
        kFieldLastName: lastName,
        kFieldFirstName: firstName,
        kFieldCellPhone: cellPhone,
        kFieldEmail: email,
      };
}
