import 'package:flutter/material.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

class Week2Page extends StatefulWidget {
  final int duration;

  Week2Page({required this.duration});

  @override
  _Week2PageState createState() => _Week2PageState();
}

class _Week2PageState extends State<Week2Page> {
  late VideoPlayerController _controller;
  late Timer _timer;
  int _secondsLeft = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.duration * 60;
    _controller = VideoPlayerController.asset('images/videos/exervid.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
      });
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _controller.play();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _timer.cancel();
          _controller.pause();
          _isRunning = false;
        }
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
    _controller.pause();
    setState(() {
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 50.8), // Original height + 2 inch
        child: AppBar(
          title: Text('Week 2 Exercise'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo[900]!,
                  Colors.indigo[500]!,
                  Colors.indigo[100]!,
                  Colors.white,
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            SizedBox(height: 20),
            Text(
              '${(_secondsLeft ~/ 60).toString().padLeft(2, '0')}:${(_secondsLeft % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (!_isRunning)
                  ElevatedButton(
                    onPressed: _startTimer,
                    child: Text('Start Running'),
                  ),
                if (_isRunning)
                  ElevatedButton(
                    onPressed: _stopTimer,
                    child: Text('Stop Running'),
                  ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Finished'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.indigo],
          ),
        ),
      ),
    );
  }
}
