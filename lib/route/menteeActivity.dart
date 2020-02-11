import 'package:flutter/material.dart';
import 'package:mentor_tracking/model.dart';
import 'package:mentor_tracking/route/addActivityRecord.dart';

class MenteeActivityListRoute extends StatelessWidget {
  final String id;
  // NEEDSWORK: we should get this from the app state, not pass it in
  final List<ActivityRecord> activities;

  MenteeActivityListRoute(this.id, this.activities);

  void _addActivity(ActivityRecord record) {
    if (record != null) {
      // NEEDSWORK: this needs to go into the app state and trigger a rebuild
      activities.add(record);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CET Mentor Tracking App"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: activities.length,
          itemBuilder: (BuildContext context, int index) {
            final record = activities[index];

            return Card(
              child: ListTile(
                leading: Icon(Icons.event_note),
                title: Text('${record.minutesSpent} ${record.notes}'),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _addActivity(await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddActivityRecordRoute(id)),
          ));
        },
        tooltip: 'Add Activity Record',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
