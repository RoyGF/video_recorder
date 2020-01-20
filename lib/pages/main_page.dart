import 'package:flutter/material.dart';
import 'package:video_recorder/models/question.dart';
import 'package:video_recorder/pages/camera_page.dart';

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

  _QuestionListPageState(this.questions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
        onTap: () {
          _navigateAndFetchVideoUrl(context, question);
        },
      ),
    );
  }

  _navigateAndFetchVideoUrl(BuildContext context, Question question) async {
    final route = MaterialPageRoute(builder: (context) => CameraApp(question));
    final result = await Navigator.push(context, route) as String;

    String dataResult = result;
    print(dataResult);
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
