import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mentor_tracking/dialog/add_mentee.dart';
import 'package:mentor_tracking/model/activity_record.dart';
import 'package:mentor_tracking/model/mentee.dart';
import 'package:mentor_tracking/model/mentee_model.dart';
import 'package:mentor_tracking/route/mentee_activity.dart';
import 'package:mentor_tracking/utilities/theme_data.dart';
import 'package:mentor_tracking/widget/app_bar.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  HomeRoute({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  int _selectedIndex = 0;

  Widget _activityRecordList(BuildContext context, MenteeModel model) {
    return FutureBuilder(
        future: model.activityRecords(),
        builder: (context, AsyncSnapshot<List<ActivityRecord>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                final record = snapshot.data[index];

                return ListTile(
                  leading: Icon(Icons.event_note),
                  title: Text(
                    '${record.minutesSpent} ${record.notes}',
                  ),
                );
              },
            );
          } else {
            return Text('Loading...');
          }
        });
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
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
      selectedItemColor: bottomNavSelectedItemColor,
      unselectedItemColor: bottomNavUnselectedItemColor,
      onTap: _onItemTapped,
    );
  }

  Widget _conditionalFloatingActionButton(
      BuildContext context, MenteeModel model) {
    return AnimatedOpacity(
      opacity: _selectedIndex <= 0 ? 1.0 : 0.0,
      duration: Duration(milliseconds: 150),
      child: FloatingActionButton(
        onPressed: () async {
          if (_selectedIndex <= 0) {
            var mentee = await addOrEditMenteeDialog(context);

            if (mentee != null) {
              model.addMentee(mentee);
            }
          }
        },
        tooltip: 'Add Mentee',
        elevation: 0,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _menteeList(BuildContext context, MenteeModel model) {
    return FutureBuilder(
        future: model.mentees(),
        builder: (context, AsyncSnapshot<List<Mentee>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) =>
                  _menteeTile(context, model, snapshot.data[index]),
            );
          } else {
            return Text('Loading...');
          }
        });
  }

  Widget _menteeTile(BuildContext context, MenteeModel model, Mentee mentee) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text('${mentee.firstName.trim()} ${mentee.lastName.trim()}'),
      subtitle: Text('${mentee.cellPhone}  ${mentee.email}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MenteeActivityListRoute(mentee.id)),
        );
      },
      onLongPress: () async {
        var editedMentee = await addOrEditMenteeDialog(context, mentee);

        if (editedMentee != null) {
          model.editMentee(editedMentee);
        }
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _widgetForCurrentState(MenteeModel model) {
    return Scrollbar(
      child: (_selectedIndex <= 0)
          ? _menteeList(context, model)
          : _activityRecordList(context, model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraDescription>(builder: (context, camera, child) {
      return Consumer<MenteeModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: mentoringAppBar(context, widget.title, camera: camera),
          body: Center(
            child: _widgetForCurrentState(model),
          ),
          bottomNavigationBar: _bottomNavigationBar(),
          floatingActionButton:
              _conditionalFloatingActionButton(context, model),
        );
      });
    });
  }
}
