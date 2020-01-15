import 'package:flutter/material.dart';
import 'package:video_recorder/models/question.dart';

class MainPage extends StatelessWidget {

  var questions = [
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
          children: _videoCards(),
        ));
  }

  List<Widget> _videoCards(){
    final List<Widget> videoCards = [];
    questions.forEach((question){
      videoCards.add(_getVideoCard(question));
    });

    return videoCards;
  }

  Widget _getVideoCard(Question question) {
    return Card(
      child: ListTile(title: Text(question.getQuestion()),),
    );
  }
}
