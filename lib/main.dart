import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mentor_tracking/model/database.dart';
import 'package:mentor_tracking/model/database_model.dart';
import 'package:mentor_tracking/model/mentee_model.dart';
import 'package:mentor_tracking/route/home_route.dart';
import 'package:mentor_tracking/route/mentee_activity.dart';
import 'package:mentor_tracking/utilities/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.isNotEmpty ? cameras.first : null;

  return runApp(MyApp(firstCamera));
}

class MyApp extends StatefulWidget {
  final mainCamera;

  MyApp(this.mainCamera);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: openMentoringDatabase(),
      builder: (context, AsyncSnapshot<Database> snapshot) {
        if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) =>
                    DatabaseMenteeModel(snapshot.data) as MenteeModel,
              ),
              Provider<CameraDescription>(
                create: (context) => widget.mainCamera,
              )
            ],
            child: MaterialApp(
              title: 'CET Mentor Tracking',
              theme: themeData,
              initialRoute: '/',
              routes: {
                '/': (context) => HomeRoute(title: 'CET Mentor Tracking'),
                '/mentee_activity': (context) => MenteeActivityListRoute(1),
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            child: Center(
              child: Text('Unable to open database.'),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
