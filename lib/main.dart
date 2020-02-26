import 'package:flutter/material.dart';
import 'package:mentor_tracking/model.dart';
import 'package:mentor_tracking/route/home_route.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MenteeModel(),
      child: MaterialApp(
        title: 'CET Mentor Tracking',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: HomeRoute(title: 'CET Mentor Tracking App'),
      ),
    );
  }
}
