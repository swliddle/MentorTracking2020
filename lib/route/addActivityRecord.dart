import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentor_tracking/model/activity_record.dart';
import 'package:mentor_tracking/model/mentee.dart';
import 'package:mentor_tracking/model/model.dart';
import 'package:provider/provider.dart';

class AddActivityRecordRoute extends StatefulWidget {
  final menteeId;

  AddActivityRecordRoute(this.menteeId);

  @override
  _AddActivityRecordRouteState createState() =>
      _AddActivityRecordRouteState(menteeId);
}

class _AddActivityRecordRouteState extends State<AddActivityRecordRoute> {
  ActivityRecord _record;

  _AddActivityRecordRouteState(menteeId)
      : this._record = ActivityRecord.forMentee(menteeId);

  void _callDatePicker(BuildContext context) async {
    var chosenDate = await showDatePicker(
      context: context,
      initialDate: _record.date,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );

    if (chosenDate != null) {
      setState(() {
        _record.date = DateTime(chosenDate.year, chosenDate.month,
            chosenDate.day, _record.date.hour, _record.date.minute);
      });
    }
  }

  void _callTimePicker(BuildContext context) async {
    var chosenTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_record.date),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );

    if (chosenTime != null) {
      setState(() {
        _record.date = DateTime(_record.date.year, _record.date.month,
            _record.date.day, chosenTime.hour, chosenTime.minute);
      });
    }
  }

  Widget _editForm(String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(DateFormat.yMd().format(_record.date)),
            onTap: () {
              _callDatePicker(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text(DateFormat().add_jm().format(_record.date)),
            onTap: () {
              _callTimePicker(context);
            },
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 16.0,
                  ),
                  child: TextField(
                      controller: TextEditingController()
                        ..text = _record.minutesSpent.toString(),
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: "Minutes Spent",
                        hintText: "Enter minutes spent with mentee",
                      ),
                      onChanged: (value) {
                        _record.minutesSpent = int.tryParse(value) ?? 30;
                      }),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: TextField(
                      controller: TextEditingController()..text = _record.notes,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: "Notes",
                        hintText: "Enter notes about this interaction",
                      ),
                      onChanged: (value) {
                        _record.notes = value;
                      }),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                child: Text("CANCEL"),
                textColor: Colors.black,
                color: Colors.pinkAccent.shade100,
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  child: Text("ADD"),
                  textColor: Colors.black,
                  color: Colors.teal.shade200,
                  onPressed: () {
                    Navigator.of(context).pop(_record);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenteeModel>(
      builder: (context, model, child) {
        return FutureBuilder(
          future: model.menteeForId(widget.menteeId),
          builder: (context, AsyncSnapshot<Mentee> snapshot) {
            String title = "Log Activity";

            if (snapshot.hasData) {
              title =
                  "Log Activity with ${snapshot.data.firstName.trim()} ${snapshot.data.lastName.trim()}";
            }

            return _editForm(title);
          },
        );
      },
    );
  }
}
