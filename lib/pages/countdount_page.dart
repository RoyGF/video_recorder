import 'package:flutter/material.dart';
import 'package:video_recorder/widgets/timer_widget.dart';

class RecordVideo extends StatefulWidget {
  @override
  _RecordVideoState createState() => _RecordVideoState();
}

class _RecordVideoState extends State<RecordVideo> {
  TimerController _timerController;
  AnimationController controller;

  @override
  void initState() {
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CountDownTimer(
            onTimerFinish: () {
              print('Timer has finished!');
            },
            timerDuration: 5,
            timerController: _timerController,
          ),
          getControllerButtons()
        ],
      ),
    );
  }

  Widget getControllerButtons() {
    Widget row = Row(
      children: <Widget>[
        FlatButton(
            child: Text('Start'),
            onPressed: () {
              _timerController.start();
            }),
        FlatButton(
            child: Text('Pause'),
            onPressed: () {
              _timerController.stop();
            })
      ],
    );
    return row;
  }

  void startTimer() {}

  void pauseTimer() {}
}
