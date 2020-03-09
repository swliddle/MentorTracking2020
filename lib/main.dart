import 'package:flutter/material.dart';
import 'package:mentor_tracking/model/database.dart';
import 'package:mentor_tracking/model/database_model.dart';
import 'package:mentor_tracking/model/mentee_model.dart';
import 'package:mentor_tracking/route/home_route.dart';
import 'package:mentor_tracking/utilities/theme_data.dart';
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
            create: (context) =>
                DatabaseMenteeModel(snapshot.data) as MenteeModel,
            child: MaterialApp(
              title: 'CET Mentor Tracking',
              theme: themeData,
              home: HomeRoute(title: 'CET Mentor Tracking'),
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
