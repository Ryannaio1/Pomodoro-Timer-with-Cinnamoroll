import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/Item.dart';
import 'package:my_first_flutter_app/finished%20task.dart';
import 'dart:async';
import 'todaylist.dart';
import 'src.dart';
import 'fontstyle.dart';
import 'main.dart';
import 'finished task.dart';
import 'Item.dart';

class PomodoroTimer extends StatefulWidget {
  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> with SingleTickerProviderStateMixin {
  TimerMode _currentMode = TimerMode.work;
  final int _workDuration = 25 * 60;
  final int _shortBreakDuration = 5 * 60;
  final int _longBreakDuration = 15 * 60;
  static const int pomodoroDuration = 25 * 60;
  int _time = pomodoroDuration;
  Timer? _timer;
  bool _isRunning = false;
  late AnimationController _gifController;
  late Animation<double> _animation;
  String _backgroundImage = 'assets/p1.jpg';
  void _showThemeChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('選擇你想要更改的主題！', style: TextStyle(fontFamily: 'Font', color: Colors.blue)),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    title: Text('大耳狗主題一', style: TextStyle(fontFamily: 'Font', color: Colors.blue)),
                    onTap: () {
                      _changeBackground('assets/p1.jpg');
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: Text('大耳狗主題二', style: TextStyle(fontFamily: 'Font', color: Colors.blue)),
                    onTap: () {
                      _changeBackground('assets/p6.jpg');
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: Text('大耳狗主題三', style: TextStyle(fontFamily: 'Font', color: Colors.blue)),
                    onTap: () {
                      _changeBackground('assets/p7.jpg');
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ).toList(),
            ),
          ),
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    _gifController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);


    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      _animation = Tween<double>(
        begin: -screenWidth,
        end: screenWidth,
      ).animate(_gifController)
        ..addListener(() {
          setState(() {});
        });
    });

    _startTimer();
  }
  @override
  void dispose() {
    _timer?.cancel();
    _gifController.dispose();
    super.dispose();
  }
  void _startTimer() {
    _isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_time > 0) {
          _time--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }
  void _pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }
  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
      if (_currentMode == TimerMode.work) {
        _time = _workDuration;
      } else if (_currentMode == TimerMode.shortBreak) {
        _time = _shortBreakDuration;
      } else if (_currentMode == TimerMode.longBreak) {
        _time = _longBreakDuration;
      }
    });
  }
  void _toggleMode() {
    setState(() {
      if (_currentMode == TimerMode.work) {
        _currentMode = TimerMode.shortBreak;
        _time = _shortBreakDuration;
      } else if (_currentMode == TimerMode.shortBreak) {
        _currentMode = TimerMode.longBreak;
        _time = _longBreakDuration;
      } else {
        _currentMode = TimerMode.work;
        _time = _workDuration;
      }
      _resetTimer();
      _startTimer();
    });
  }

  void _changeBackground(String newBackground) {
    setState(() {
      _backgroundImage = newBackground;
    });
  }


  String get timerString {
    Duration duration = Duration(seconds: _time);
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('大耳狗測試版番茄鐘', style: TextStyle(fontFamily: 'Font', color: Colors.blue)),
          actions: <Widget>[
            IconButton(
              icon: CircleAvatar(
                backgroundImage: AssetImage('assets/p3.png'),
              ),
              onPressed: () {
                _showThemeChangeDialog(context);
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            // 側邊欄內容
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/p4.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Text(
                      'Cinnamoroll Clock List',
                      style: TextStyle(
                        fontFamily: 'Font',
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                    ),
                    //在這邊+更多東西
                  ],
                ),
              ),

              ListTile(
                leading: Image.asset('assets/p3.png',width: 50.0, height: 50.0),
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('行事曆',style: TextStyle(fontFamily: 'Font',color: Colors.blue)),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CalendarScreen(),
                  ));
                },
              ),
              ListTile(
                leading: Image.asset('assets/p3.png',width: 50.0, height: 50.0),
                title: Text('待辦項目',style: TextStyle(fontFamily: 'Font',color: Colors.blue)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TodoPage(),
                  ));
                },
              ),
              // 在這+
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: (_time / pomodoroDuration),
                        strokeWidth: 6,
                        backgroundColor: Colors.grey[800],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                      ),
                    ),
                    Text(
                      timerString,
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Font',
                        fontSize: 50,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _toggleMode,
                  child: Text('切換模式',style: customTextStyle),

                ),
                SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_animation.value, 0),
                      child: child,
                    );
                  },
                  child: Image.asset('assets/p5.gif', width: 150,gaplessPlayback: true,),
                ),
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton.icon(
                      onPressed: _startTimer,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.blue,
                        shadowColor: Colors.transparent,
                      ),
                      icon: Image.asset('assets/p9.png', width: 12),
                      label: Text('開始', style: customTextStyle),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton.icon(
                      onPressed: _pauseTimer,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.blue,
                        shadowColor: Colors.transparent,
                      ),
                      icon: Image.asset('assets/p9.png', width: 12),
                      label: Text('暫停', style: customTextStyle),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton.icon(
                      onPressed: _resetTimer,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.blue,
                        shadowColor: Colors.transparent,
                      ),
                      icon: Image.asset('assets/p9.png', width: 12),
                      label: Text('重置', style: customTextStyle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}