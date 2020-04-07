import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mentor_tracking/model/database.dart';
import 'package:mentor_tracking/model/database_model.dart';
import 'package:mentor_tracking/model/mentee_model.dart';
import 'package:mentor_tracking/route/home_route.dart';
import 'package:mentor_tracking/route/mentee_activity.dart';
import 'package:mentor_tracking/utilities/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

Future<FlutterLocalNotificationsPlugin> initializeNotifications() async {
  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  var initializationSettingsAndroid = AndroidInitializationSettings('mentor');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        // NEEDSWORK
        print(
            "Received local notification ${id}, ${title}, ${body}, ${payload}");
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await plugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    print("onSelectNotification");
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });

  return plugin;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.isNotEmpty ? cameras.first : null;

  final notificationsPlugin = await initializeNotifications();

  return runApp(MyApp(firstCamera, notificationsPlugin));
}

class MyApp extends StatefulWidget {
  final mainCamera;
  final notificationsPlugin;

  MyApp(this.mainCamera, this.notificationsPlugin);

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
              ),
              Provider<FlutterLocalNotificationsPlugin>(
                create: (context) => widget.notificationsPlugin,
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
