import 'package:flutter/material.dart';
import 'package:video_recorder/pages/main_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder> {
    '/'   : (BuildContext context) => MainPage()
  };
}