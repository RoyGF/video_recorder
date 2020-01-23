import 'dart:math' as math;

import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  final int _timerDuration;
  CountDownTimer(this._timerDuration);

  @override
  _CountDownTimerState createState() => _CountDownTimerState(_timerDuration);
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;
  int _timerDuration;

  _CountDownTimerState(this._timerDuration);

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds + 1 % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _timerDuration),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: 50.0, height: 50.0, child: getStack());
  }

  Widget getStack() {
    var stack = Stack(
      children: <Widget>[
        Positioned(
          height: 50.0,
          width: 50.0,
          child: CustomPaint(
              painter: CustomTimerPainter(
            animation: controller,
            backgroundColor: Colors.white,
            color: Colors.blue,
          )),
        ),
        Positioned(
          left: 12,
          top: 16,
          child: Text(
            timerString,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
    return stack;
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
