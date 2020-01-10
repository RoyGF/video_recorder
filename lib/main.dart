import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_recorder/test.dart';

class CameraExampleHome extends StatefulWidget {
  @override
  _CameraExampleHomeState createState() {
    return _CameraExampleHomeState();
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraExampleHomeState extends State<CameraExampleHome>
    with WidgetsBindingObserver {
  CameraController controller;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed && controller != null) {
      onNewCameraSelected(controller.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Camera example'),
      ),
      body: Column(
        children: <Widget>[
          _surfaceCameraView(),
          _captureControlRowWidget(),
          _toggleAudioWidget(),
          _unknownWidgetView()
        ],
      ),
    );
  }

  Widget _unknownWidgetView() {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_cameraTogglesRowWidget(), Text("Hola Mundo 2")],
        ));
  }

  Widget _surfaceCameraView() {
    return Expanded(
        child: Container(
      child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Center(child: _cameraPreviewWidget())),
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
              width: 3.0,
              color: controller != null && controller.value.isRecordingVideo
                  ? Colors.redAccent
                  : Colors.grey)),
    ));
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text('Tap a camera',
          style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.w900));
    } else {
      return AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller));
    }
  }

  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
            icon: const Icon(Icons.camera_alt),
            color: Colors.blue,
            onPressed: controller != null &&
                    controller.value.isInitialized &&
                    !controller.value.isRecordingVideo
                ? onTakePictureButtonPressed
                : null),
        IconButton(
            icon: Icon(Icons.videocam),
            color: Colors.blue,
            onPressed: controller != null &&
                    controller.value.isInitialized &&
                    !controller.value.isRecordingVideo
                ? onVideoRecordButtonPressed
                : null),
        IconButton(
          icon: controller != null && controller.value.isRecordingPaused
              ? Icon(Icons.play_arrow)
              : Icon(Icons.pause),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
              ? (controller != null && controller.value.isRecordingVideo
                  ? onResumeButtonPressed
                  : onPauseButtonPressed)
              : null,
        ),
        IconButton(
            icon: const Icon(Icons.stop),
            color: Colors.red,
            onPressed: controller != null &&
                    controller.value.isInitialized &&
                    controller.value.isRecordingVideo
                ? onStopButtonPressed
                : null)
      ],
    );
  }

  Widget _toggleAudioWidget() {
    return Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Row(
          children: <Widget>[
            Text('Enable Audio:'),
            Switch(
              value: enableAudio,
              onChanged: (bool value) {
                enableAudio = value;
                if (controller != null) {
                  onNewCameraSelected(controller.description);
                }
              },
            )
          ],
        ));
  }

  /// Selector of front Camera and main Camera
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    if (cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      for (CameraDescription cameraDescription in cameras) {
        toggles.add(SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
                title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
                groupValue: cameraDescription,
                onChanged:
                    controller != null && controller.value.isRecordingVideo
                        ? null
                        : onNewCameraSelected)));
      }
    }
    return Row(children: toggles);
  }

  /// Display the thumbnail of the captured image or video
  Widget _thumbnailWidget() {
    return null;
  }

  void onTakePictureButtonPressed() {}

  void onVideoRecordButtonPressed() {}

  void onResumeButtonPressed() {}

  void onPauseButtonPressed() {}

  void onStopButtonPressed() {}

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) await controller.dispose();

    controller = CameraController(cameraDescription, ResolutionPreset.medium,
        enableAudio: enableAudio);

    // If the controller is updated then update the UI
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/video_recorder';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '${dirPath}/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

List<CameraDescription> cameras = [];

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CameraExampleHome());
  }
}

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(CameraApp());
}
