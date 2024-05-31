import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StopWatch',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: StopWatchPage(),
    );
  }
}

class StopWatchPage extends StatefulWidget {
  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  late Timer _timer;

  var _time = 0;
  var _isRunning = false;

  List<String> _lapTimes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StopWatch'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _clickButton();
        }),
        child: _isRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody() {
    var sec = _time ~/ 100;
    var hundredth = '${_time % 100}'.padLeft(2, '0'); //1/100ch
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text( //초
                      '$sec',
                      style: TextStyle(fontSize: 50.0),
                    ),
                    Text('$hundredth'), //1/100
                  ],
                ),
                Container(
                  width: 100,
                  height: 200,
                  child: ListView(
                    children: _lapTimes.map((time) => Text(time)).toList(),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: FloatingActionButton(
                backgroundColor: Colors.deepOrangeAccent,
                onPressed: _reset,
                child: Icon(Icons.rotate_left),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _recordLapTime('$sec.$hundredth');
                  });
                },
                child: Text('Lap Time'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clickButton() {
    _isRunning = !_isRunning;
    (_isRunning ? _start() : _pause());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _start() {
    _timer = Timer.periodic(
      Duration(milliseconds: 10),
          (timer) {
        setState(() {
          _time++;
        });
      },
    );
  }

  _pause() {
    _timer?.cancel();
  }

  void _reset() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
      _lapTimes.clear();
      _time = 0;
    });
  }

  void _recordLapTime(String time) {
    _lapTimes.insert(0, '${_lapTimes.length + 1} $time');
  }
}
