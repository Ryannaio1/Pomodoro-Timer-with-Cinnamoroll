import 'package:flutter/material.dart';
import 'dart:async';
import 'todaylist.dart';
import 'src.dart';
import 'fontstyle.dart';
import 'PomodoroMain.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: GlobalKey<NavigatorState>(),
      home: SplashScreen(),
    ),
  );
}

enum TimerMode { work, shortBreak, longBreak }

class TodoItem {
  String title;
  bool isDone;

  TodoItem({required this.title, this.isDone = false});
}