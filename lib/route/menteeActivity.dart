import 'package:flutter/material.dart';
import 'package:mentor_tracking/model.dart';
import 'package:mentor_tracking/route/addActivityRecord.dart';
import 'package:provider/provider.dart';

class MenteeActivityListRoute extends StatelessWidget {
  final String menteeId;

  MenteeActivityListRoute(this.menteeId);

  void _addActivity(ActivityRecord record, MenteeModel model) {
    if (record != null) {
      model.addActivityRecordForMentee(menteeId, record);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenteeModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("CET Mentor Tracking App"),
          ),
          body: Center(
            child: ListView.builder(
              itemCount: model.activityRecordsForMenteeId(menteeId).length,
              itemBuilder: (BuildContext context, int index) {
                final record =
                    model.activityRecordsForMenteeId(menteeId)[index];

                return Card(
                  child: ListTile(
                    leading: Icon(Icons.event_note),
                    title: Text('${record.minutesSpent} ${record.notes}'),
                    onLongPress: () {
                      // NEEDSWORK: display context menu with delete option
                    },
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              _addActivity(
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddActivityRecordRoute(
                          model.menteeForMenteeId(menteeId))),
                ),
                model,
              );
            },
            tooltip: 'Add Activity Record',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
