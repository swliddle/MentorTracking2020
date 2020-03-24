import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mentor_tracking/route/camera_route.dart';
import 'package:mentor_tracking/route/web_route.dart';

AppBar mentoringAppBar(BuildContext context, String title,
    {hideWebAction = false,
    hideCameraAction = false,
    CameraDescription camera}) {
  final actions = <Widget>[];

  if (!hideWebAction) {
    actions.add(
      IconButton(
        icon: Icon(Icons.web),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebRoute()),
          );
        },
      ),
    );
  }

  if (!hideCameraAction) {
    actions.add(
      IconButton(
        icon: Icon(Icons.camera),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraRoute(
                camera: camera,
              ),
            ),
          );
        },
      ),
    );
  }

  return AppBar(
    title: Text(title),
    elevation: 0,
    actions: actions,
  );
}
