import 'package:flutter/material.dart';
import 'package:mentor_tracking/model/database.dart';
import 'package:mentor_tracking/model/model.dart';
import 'package:mentor_tracking/route/home_route.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: openMentoringDatabase(),
      builder: (context, AsyncSnapshot<Database> snapshot) {
        if (snapshot.hasData) {
          return ChangeNotifierProvider(
            create: (context) => MenteeModel(snapshot.data),
            child: MaterialApp(
              title: 'CET Mentor Tracking',
              theme: ThemeData(
                primarySwatch: Colors.lightGreen,
              ),
              home: HomeRoute(title: 'CET Mentor Tracking App'),
            ),
          );
        } else if (snapshot.hasError) {
          // NEEDSWORK: display error message of some sort
        } else {
          return Container();
        }
      },
    );
  }
}
