import 'dart:io';

import 'package:flutter/material.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureRoute extends StatelessWidget {
  final String imagePath;

  const DisplayPictureRoute({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Photo')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      // NEEDSWORK: a truly useful app would still need to do something with
      // that image file.  Add it to the library, do something else.  In our
      // case, maybe it would be to take a photo of a mentee, so we could add
      // the photo to their personal profile or something like that.
      body: Image.file(File(imagePath)),
    );
  }
}
