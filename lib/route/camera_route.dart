import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mentor_tracking/route/display_picture_route.dart';
import 'package:mentor_tracking/widget/app_bar.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraRoute extends StatefulWidget {
  final CameraDescription camera;

  const CameraRoute({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  CameraRouteState createState() => CameraRouteState();
}

class CameraRouteState extends State<CameraRoute> {
  // Add two variables to the state class to store the CameraController and
  // the Future.
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  Widget _takePhotoFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.camera_alt),
      // Provide an onPressed callback.
      onPressed: () async {
        // Take the Picture in a try / catch block. If anything goes wrong,
        // catch the error.
        try {
          // Ensure that the camera is initialized.
          await _initializeControllerFuture;

          // Construct the path where the image should be saved using the path
          // package.
          final path = join(
            // Store the picture in the temp directory.
            // Find the temp directory using the `path_provider` plugin.
            (await getTemporaryDirectory()).path,
            '${DateTime.now()}.png',
          );

          // Attempt to take a picture and log where it's been saved.
          await _controller.takePicture(path);

          // If the picture was taken, display it on a new screen.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayPictureRoute(imagePath: path),
            ),
          );
        } catch (e) {
          // If an error occurs, log the error to the console.
          // NEEDSWORK: A snackbar message would be better.
          print(e);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // To display the current output from the camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      // NEEDSWORK: You might want to let the user choose a camera.
      widget.camera,

      // Define the resolution to use.
      // NEEDSWORK: You probably want to give the user some control over this.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mentoringAppBar(context, "Take a Photo",
          hideCameraAction: true, camera: widget.camera),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: _takePhotoFloatingActionButton(context),
    );
  }
}
