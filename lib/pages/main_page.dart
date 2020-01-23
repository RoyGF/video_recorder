import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';
import 'package:video_recorder/models/question.dart';
import 'package:video_recorder/pages/camera_page.dart';
import 'dart:io';

import 'package:video_recorder/pages/countdount_page.dart';

class QuestionListPage extends StatefulWidget {
  final List<Question> questions;

  QuestionListPage(this.questions);

  @override
  State<StatefulWidget> createState() {
    return _QuestionListPageState(questions);
  }
}

class _QuestionListPageState extends State<QuestionListPage> {
  final List<Question> questions;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  VideoPlayerController _videoController;
  VoidCallback videoPlayerListener;
  _QuestionListPageState(this.questions);
  String videoPath;

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          child: Text('Timer test', textAlign: TextAlign.center,),
          onPressed: (){
                final route = MaterialPageRoute(builder: (context) => TimerTestPage());
                Navigator.push(context, route);
          },
          ),
        appBar: AppBar(
            title: Text('Pantalla inicial'), backgroundColor: Colors.red),
        body: ListView(
          children: _videoCards(context),
        ));
  }

  /// Creates Video Cards using questions list
  List<Widget> _videoCards(BuildContext context) {
    final List<Widget> videoCards = [];
    questions.forEach((question) {
      videoCards.add(_getVideoCard(context, question));
    });
    return videoCards;
  }

  /// Creates a video card using a Question object
  Widget _getVideoCard(BuildContext context, Question question) {
    return Card(
      child: ListTile(
        title: Text(question.getQuestion()),
        subtitle: question.hasVideo()
            ? _thumbnailWidget(question.getVideoPath())
            : null,
        leading: Icon(Icons.videocam, color: Colors.red),
        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red),
        onTap: () {
          _navigateAndFetchVideoUrl(context, question);
        },
      ),
    );
  }

  /// Video Player Thumbnail
  Widget _thumbnailWidget(String inVideoPath) {
    return Center(
      child: _videoController.value.initialized ? AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: VideoPlayer(_videoController)
      ) : Container(),
    );
  }

  initVideoController(String inVideoPath) {
    _videoController = VideoPlayerController.file(File(videoPath));
    _videoController.initialize().then((_){
      setState((){});
    });
  }

  /// Opens Camera Page and waits for video path string callback
  _navigateAndFetchVideoUrl(BuildContext context, Question question) async {
    final route = MaterialPageRoute(builder: (context) => CameraApp(question));
    final result = await Navigator.push(context, route) as String;

    String dataResult = result;
    videoPath = dataResult;
    if (dataResult != null) {
      question.setVideoPath(videoPath);
      initVideoController(videoPath);
      setState(() {});
    }
  }

  _startVideoPlayer(String videoPath)  {
    if (videoPath == null)
      return;
    if (_videoController.value.initialized){
      setState(() {
        _videoController.value.isPlaying ? _videoController.pause() : _videoController.play();
      });
    }
  }
}

class MainPage extends StatelessWidget {
  final List<Question> questions = [
    Question('Pregunta 1', 10),
    Question('Pregunta 2', 15),
    Question('Pregunta 3', 5),
    Question('Pregunta 4', 10),
    Question('Pregunta 7', 19)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: QuestionListPage(questions));
  }
}
