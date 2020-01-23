import 'package:flutter/material.dart';
import 'package:video_recorder/widgets/CountDownTimer.dart';


class TimerTestPage extends StatefulWidget {
  @override
  _TimerTestPageState createState() => _TimerTestPageState();
}

class _TimerTestPageState extends State<TimerTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timer test'),),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: CountDownTimer(13),
          )
        
      ],)
    );
  }
}

