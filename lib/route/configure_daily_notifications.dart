import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentor_tracking/model/notifications_record.dart';
import 'package:mentor_tracking/model/preferences.dart';
import 'package:mentor_tracking/widget/app_bar.dart';

class ConfigureNotificationsRoute extends StatefulWidget {
  @override
  _ConfigureNotificationsRouteState createState() =>
      _ConfigureNotificationsRouteState();
}

class _ConfigureNotificationsRouteState
    extends State<ConfigureNotificationsRoute> {
  NotificationsRecord _record;

  _ConfigureNotificationsRouteState() : this._record = NotificationsRecord();

  void _callTimePicker(BuildContext context) async {
    var chosenTime = await showTimePicker(
      context: context,
      initialTime: _record.timeOfDay,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );

    if (chosenTime != null) {
      setState(() {
        _record.timeOfDay = chosenTime;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();

    return format.format(dt);
  }

  Widget _editForm(String title) {
    return Scaffold(
      appBar: mentoringAppBar(context, title),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text("Remind me to check on my mentees at this time:"),
          ),
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text(
              _formatTimeOfDay(_record.timeOfDay),
            ),
            onTap: () {
              _callTimePicker(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("On these days:"),
          ),
          Center(
            child: ToggleButtons(
              children: <Widget>[
                Text("S"),
                Text("M"),
                Text("T"),
                Text("W"),
                Text("T"),
                Text("F"),
                Text("S"),
              ],
              onPressed: (int index) {
                setState(() {
                  _record.notifyDays[index] = !_record.notifyDays[index];
                });
              },
              isSelected: _record.notifyDays,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  child: Text("CANCEL"),
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RaisedButton(
                    child: Text("SAVE"),
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop(_record);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Preferences prefs = Preferences.get(context);
    var notificationsRecord = prefs.notificationsRecord();

    return FutureBuilder(
      future: notificationsRecord,
      builder: (context, AsyncSnapshot<NotificationsRecord> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _editForm("Remind Me");
        }

        return Container();
      },
    );
  }
}
