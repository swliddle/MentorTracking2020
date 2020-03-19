import 'package:flutter/material.dart';
import 'package:mentor_tracking/model/activity_record.dart';
import 'package:mentor_tracking/model/mentee_model.dart';
import 'package:mentor_tracking/route/add_activity_record.dart';
import 'package:mentor_tracking/widget/app_bar.dart';
import 'package:provider/provider.dart';

class MenteeActivityListRoute extends StatelessWidget {
  final int menteeId;

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
          appBar: mentoringAppBar(context, "CET Mentor Tracking App"),
          body: Center(
            child: FutureBuilder(
                future: model.activityRecordsForMenteeId(menteeId),
                builder:
                    (context, AsyncSnapshot<List<ActivityRecord>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final record = snapshot.data[index];

                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.event_note),
                            title:
                                Text('${record.minutesSpent} ${record.notes}'),
                            onLongPress: () {
                              // NEEDSWORK: display context menu with delete option
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Text('Loading...');
                  }
                }),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              _addActivity(
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddActivityRecordRoute(menteeId),
                  ),
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
