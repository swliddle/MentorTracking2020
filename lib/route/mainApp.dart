import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mentor_tracking/dialog/addMentee.dart';
import 'package:mentor_tracking/model.dart';
import 'package:mentor_tracking/route/menteeActivity.dart';

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
  var _mentees = <Mentee>[
    Mentee("1", "Doe", "John", "801-555-1212",
        "email@example.com", <ActivityRecord>[
      ActivityRecord("1", "1", DateTime.parse("2020-01-02 08:18:04Z"), 30,
          "Had a great time"),
      ActivityRecord("2", "1", DateTime.parse("2020-01-03 09:19:06Z"), 15,
          "Had a great time"),
      ActivityRecord("3", "1", DateTime.parse("2020-01-04 10:20:09Z"), 30,
          "Had a great time"),
      ActivityRecord("4", "1", DateTime.parse("2020-01-05 11:21:13Z"), 15,
          "Had a great time"),
      ActivityRecord("5", "1", DateTime.parse("2020-01-06 12:22:17Z"), 30,
          "Had a great time"),
    ]),
    Mentee("2", "Roe", "Mary", "801-555-1212",
        "email@example.com", <ActivityRecord>[
      ActivityRecord("1", "1", DateTime.parse("2020-01-07 12:18:04Z"), 30,
          "Had a great time"),
      ActivityRecord("2", "1", DateTime.parse("2020-01-08 13:28:14Z"), 15,
          "Had a great time"),
      ActivityRecord("3", "1", DateTime.parse("2020-01-09 14:38:24Z"), 30,
          "Had a great time"),
      ActivityRecord("4", "1", DateTime.parse("2020-01-10 15:48:34Z"), 15,
          "Had a great time"),
      ActivityRecord("5", "1", DateTime.parse("2020-01-11 16:58:44Z"), 30,
          "Had a great time"),
    ]),
  ];
//  var _activities = List<ActivityRecord>();

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

  Widget _widgetForCurrentState() {
    return (_selectedIndex <= 0)
        ? Scrollbar(
            child: ListView.builder(
                itemCount: _mentees.length,
                itemBuilder: (BuildContext context, int index) {
                  final mentee = _mentees[index];

                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('${mentee.firstName} ${mentee.lastName}'),
                      subtitle: Text('${mentee.cellPhone} ${mentee.email}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenteeActivityListRoute(
                                  mentee.id, mentee.activityLog)),
                        );
                      },
                    ),
                  );
                }),
          )
        : Text("Activities tab");
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _widgetForCurrentState(),
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
          var mentee = await addMenteeDialog(context);

          if (mentee != null) {
            var maxId = _mentees
                .map((mentee) => int.tryParse(mentee.id) ?? 0)
                .reduce(max);

            mentee.id = "${maxId + 1}";

            setState(() {
              _mentees.add(mentee);
            });
          }
        },
        tooltip: 'Add Mentee',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
