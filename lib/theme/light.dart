//明亮主题
//明亮主题
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/Method.dart';

class LightTheme {
  static final ThemeData theme = ThemeData(
    brightness: Brightness.light,//亮色
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),//主题色
    primaryColor: Colors.deepPurple,//主题色
    scaffoldBackgroundColor:AppMethod.hexToColor('#F1F1F1'),//背景颜色
    appBarTheme:  AppBarTheme(
      backgroundColor:AppMethod.hexToColor('#FFFFFF'),
      foregroundColor:AppMethod.hexToColor('#0A0A0A'),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor:  Colors.deepPurple,//主题色
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey[600]),
      border: OutlineInputBorder(),
    ),
  );
}
