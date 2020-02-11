import 'package:flutter/material.dart';
import 'package:mentor_tracking/model.dart';

Future<Mentee> addMenteeDialog(BuildContext context) async {
  Mentee _mentee = Mentee("", "", "", "", "", <ActivityRecord>[]);

  const FIELD_HINT = "hint";
  const FIELD_LABEL = "label";
  const FIELD_ONCHANGED = "onChanged";

  var _fieldSpecs = [
    {
      FIELD_LABEL: "First Name",
      FIELD_HINT: "Enter mentee's first name",
      FIELD_ONCHANGED: (String value) {
        _mentee.firstName = value;
      }
    },
    {
      FIELD_LABEL: "Last Name",
      FIELD_HINT: "Enter mentee's last name",
      FIELD_ONCHANGED: (String value) {
        _mentee.lastName = value;
      }
    },
    {
      FIELD_LABEL: "Cell Phone",
      FIELD_HINT: "Enter mentee's cell phone",
      FIELD_ONCHANGED: (String value) {
        _mentee.cellPhone = value;
      }
    },
    {
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
        child: Text('ADD'),
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

  return showDialog<Mentee>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter Mentee Info:'),
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
