import 'package:flutter/material.dart';
import 'package:mentor_tracking/dialog/addMentee.dart';
import 'package:mentor_tracking/model/activity_record.dart';
import 'package:mentor_tracking/model/mentee.dart';
import 'package:mentor_tracking/model/database_model.dart';
import 'package:mentor_tracking/model/mentee_model.dart';
import 'package:mentor_tracking/route/menteeActivity.dart';
import 'package:mentor_tracking/utilities/theme_data.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  HomeRoute({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _widgetForCurrentState(MenteeModel model) {
    return (_selectedIndex <= 0)
        ? Scrollbar(
            child: FutureBuilder(
                future: model.mentees(),
                builder: (context, AsyncSnapshot<List<Mentee>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final mentee = snapshot.data[index];

                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text(
                                '${mentee.firstName.trim()} ${mentee.lastName.trim()}'),
                            subtitle:
                                Text('${mentee.cellPhone}  ${mentee.email}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MenteeActivityListRoute(mentee.id)),
                              );
                            },
                            onLongPress: () async {
                              var editedMentee =
                                  await addOrEditMenteeDialog(context, mentee);

                              if (editedMentee != null) {
                                model.editMentee(editedMentee);
                              }
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Text('Loading...');
                  }
                }),
          )
        : Scrollbar(
            child: FutureBuilder(
                future: model.activityRecords(),
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
                          ),
                        );
                      },
                    );
                  } else {
                    return Text('Loading...');
                  }
                }),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenteeModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 4,
        ),
        body: Center(
          child: _widgetForCurrentState(model),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Mentees'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note),
              title: Text('Activity'),
            ),
          ],
          currentIndex: _selectedIndex,
          backgroundColor: bottomNavBackgroundColor,
          elevation: bottomNavElevation,
          selectedItemColor: bottomNavSelectedItemColor,
          unselectedItemColor: bottomNavUnselectedItemColor,
          onTap: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var mentee = await addOrEditMenteeDialog(context);

            if (mentee != null) {
              model.addMentee(mentee);
            }
          },
          tooltip: 'Add Mentee',
          child: Icon(Icons.add),
        ),
      );
    });
  }
}
