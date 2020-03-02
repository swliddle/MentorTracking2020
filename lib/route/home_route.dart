import 'package:flutter/material.dart';
import 'package:mentor_tracking/dialog/addMentee.dart';
import 'package:mentor_tracking/model/model.dart';
import 'package:mentor_tracking/route/menteeActivity.dart';
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
            child: ListView.builder(
              itemCount: model.mentees.length,
              itemBuilder: (BuildContext context, int index) {
                final mentee = model.mentees[index];

                return Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                        '${mentee.firstName.trim()} ${mentee.lastName.trim()}'),
                    subtitle: Text('${mentee.cellPhone}  ${mentee.email}'),
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
            ),
          )
        : Scrollbar(
            child: ListView.builder(
              itemCount: model.activityRecords.length,
              itemBuilder: (BuildContext context, int index) {
                final record = model.activityRecords[index];

                return Card(
                  child: ListTile(
                    leading: Icon(Icons.event_note),
                    title: Text('${record.minutesSpent} ${record.notes}'),
                  ),
                );
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenteeModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
          backgroundColor: Colors.lightGreen[200],
          selectedItemColor: Colors.grey[900],
          unselectedItemColor: Colors.grey[500],
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
