import 'package:flutter/material.dart';
import 'package:mentor_tracking/model/mentee.dart';

Future<Mentee> addOrEditMenteeDialog(BuildContext context,
    [Mentee menteeToEdit]) async {
  Mentee _mentee = Mentee(0, "", "", "", "");

  const FIELD_HINT = "hint";
  const FIELD_LABEL = "label";
  const FIELD_NAME = "fieldName";
  const FIELD_ONCHANGED = "onChanged";

  var _fieldSpecs = [
    {
      FIELD_NAME: "firstName",
      FIELD_LABEL: "First Name",
      FIELD_HINT: "Enter mentee's first name",
      FIELD_ONCHANGED: (String value) {
        _mentee.firstName = value;
      }
    },
    {
      FIELD_NAME: "lastName",
      FIELD_LABEL: "Last Name",
      FIELD_HINT: "Enter mentee's last name",
      FIELD_ONCHANGED: (String value) {
        _mentee.lastName = value;
      }
    },
    {
      FIELD_NAME: "cellPhone",
      FIELD_LABEL: "Cell Phone",
      FIELD_HINT: "Enter mentee's cell phone",
      FIELD_ONCHANGED: (String value) {
        _mentee.cellPhone = value;
      }
    },
    {
      FIELD_NAME: "email",
      FIELD_LABEL: "Email",
      FIELD_HINT: "Enter mentee's email",
      FIELD_ONCHANGED: (String value) {
        _mentee.email = value;
      }
    },
  ];

  List<Widget> _actionsForDialog(BuildContext context) {
    return <Widget>[
      FlatButton(
        child: Text('CANCEL'),
        onPressed: () {
          Navigator.of(context).pop(null);
        },
      ),
      FlatButton(
        child: Text(menteeToEdit != null ? 'EDIT' : 'ADD'),
        onPressed: () {
          Navigator.of(context).pop(_mentee);
        },
      ),
    ];
  }

  List<Widget> _fieldsForDialog(BuildContext context) {
    var fields = <Widget>[];

    _fieldSpecs.forEach((fieldSpec) {
      fields.add(Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: TextEditingController()
                ..text = _mentee.getField(fieldSpec[FIELD_NAME]),
              autofocus: true,
              decoration: InputDecoration(
                labelText: fieldSpec[FIELD_LABEL],
                hintText: fieldSpec[FIELD_HINT],
              ),
              onChanged: fieldSpec[FIELD_ONCHANGED],
            ),
          ),
        ],
      ));
    });

    return fields;
  }

  if (menteeToEdit != null) {
    _mentee.id = menteeToEdit.id;
    _mentee.firstName = menteeToEdit.firstName;
    _mentee.lastName = menteeToEdit.lastName;
    _mentee.cellPhone = menteeToEdit.cellPhone;
    _mentee.email = menteeToEdit.email;
  }

  return showDialog<Mentee>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('${menteeToEdit != null ? "Edit" : "Enter"} Mentee Info:'),
        content: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: _fieldsForDialog(context),
            ),
          ),
        ),
        actions: _actionsForDialog(context),
      );
    },
  );
}
