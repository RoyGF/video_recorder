import 'package:flutter/material.dart';
import 'package:video_recorder/models/question.dart';
import 'package:video_recorder/pages/camera_page.dart';

class MainPage extends StatelessWidget {
  final List<Question> questions = [
    Question('Pregunta 1', 10),
    Question('Pregunta 2', 15),
    Question('Pregunta 3', 5)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  /// create a video card using a Question object
  Widget _getVideoCard(BuildContext context, Question question) {
    return Card(
      child: ListTile(
        title: Text(question.getQuestion()),
        leading: Icon(Icons.videocam, color: Colors.red),
        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red),
        onTap: (){
          final route = MaterialPageRoute(builder: (context) => CameraApp(question));
          Navigator.push(context, route);
        },
      ),
    );
  }
}
