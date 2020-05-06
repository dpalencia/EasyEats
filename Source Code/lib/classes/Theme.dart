

import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xff8a0027), 
    accentColor: Color(0xfff9bf3b),
    buttonColor: Color(0xfff9bf3b),
    backgroundColor: Color(0xff1e252b),
    scaffoldBackgroundColor: Color(0xff1e252b),
    textTheme: TextTheme(
      body1: TextStyle(
        color: Color(0xffffffff)
      )
    )
  );
}