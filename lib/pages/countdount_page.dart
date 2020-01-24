import 'package:flutter/material.dart';
import 'package:video_recorder/widgets/timer_widget.dart';

class TimerTestPage extends StatefulWidget {
  @override
  _TimerTestPageState createState() => _TimerTestPageState();
}

class _TimerTestPageState extends State<TimerTestPage> {

  TimerController _timerController;
  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timerController = new TimerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Timer test'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(child: CountDownTimer(13, _timerController)),
            getControllerButtons()
          ],
        ));
  }

  Widget getControllerButtons() {
    Widget row = Row(
      children: <Widget>[
        FlatButton(child: Text('Start'), onPressed: (){
          _timerController.start();
        }),
        FlatButton(child: Text('Pause'), onPressed: (){
          _timerController.stop();
        })
        ],
    );
    return row;
  }

  void startTimer(){

  }

  void pauseTimer(){

  }
}
