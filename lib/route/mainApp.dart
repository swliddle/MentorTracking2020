import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mentor_tracking/dialog/addMentee.dart';
import 'package:mentor_tracking/model.dart';
import 'package:mentor_tracking/route/menteeActivity.dart';
import 'package:provider/provider.dart';

class MainAppRoute extends StatefulWidget {
  MainAppRoute({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MainAppRouteState createState() => _MainAppRouteState();
}

class _MainAppRouteState extends State<MainAppRoute> {
  int _selectedIndex = 0;

  void _addMentee() {
//    var mentee = Mentee();
//
//    mentee.id = mentee.firstName = "John";
//    mentee.lastName = "Doe";
//    mentee.cellPhone = "801-555-1212";
//    mentee.email = "email@example.com";
//
//    setState(() {
//      _mentees.add(mentee);
//    });
  }

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
                    title: Text('${mentee.firstName} ${mentee.lastName}'),
                    subtitle: Text('${mentee.cellPhone} ${mentee.email}'),
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
          ));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Consumer<MenteeModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
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
          backgroundColor: Colors.amber[300],
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
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }
}
