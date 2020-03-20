import 'package:flutter/material.dart';
import 'package:mentor_tracking/route/web_route.dart';

AppBar mentoringAppBar(BuildContext context, String title,
    {hideWebAction = false}) {
  final actions = <Widget>[];

  if (!hideWebAction) {
    actions.add(IconButton(
      icon: Icon(Icons.web),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WebRoute()),
        );
      },
    ));
  }

  return AppBar(
    title: Text(title),
    elevation: 0,
    actions: actions,
  );
}
