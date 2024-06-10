import 'package:flutter/material.dart';
import 'dart:async';
import 'running exercise.dart'; // Import the running_exercise.dart file

class ImageDisplayPage extends StatefulWidget {
  @override
  _ImageDisplayPageState createState() => _ImageDisplayPageState();
}

class _ImageDisplayPageState extends State<ImageDisplayPage> {
  int _currentIndex = 0;
  int _secondsLeft = 0;
  bool _isBreak = false;
  Timer? _timer;

  final List<String> _images = [
    'images/1.jpg',
    'images/2.jpg',
    'images/3.jpg',
    'images/4.jpg',
    'images/5.jpg',
    'images/6.jpg',
    'images/7.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startExercise();
  }

  void _startExercise() {
    setState(() {
      _isBreak = false;
      _secondsLeft = 1; // Set exercise duration to 1 second
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsLeft--;
        if (_secondsLeft == 0) {
          _timer?.cancel();
          if (_currentIndex < _images.length - 1) {
            _startBreak();
          } else {
            setState(() {
              _isBreak = false;
              _timer?.cancel(); // Ensure the timer is cancelled
            });
          }
        }
      });
    });
  }

  void _startBreak() {
    setState(() {
      _isBreak = true;
      _secondsLeft = 1; // Set break duration to 1 second
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsLeft--;
        if (_secondsLeft == 0) {
          _timer?.cancel();
          setState(() {
            _currentIndex++;
            if (_currentIndex < _images.length) {
              _isBreak = false;
              _startExercise();
            } else {
              _isBreak = false;
              _timer?.cancel(); // Ensure the timer is cancelled
            }
          });
        }
      });
    });
  }

  void _goToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RunningExercisePage()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Warm Up Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back when back button is pressed
          },
        ),
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
      body: Center(
        child: _currentIndex >= _images.length
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Warm Up Complete',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goToNextPage,
              child: Text('Next'),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isBreak
                ? Text(
              'Break',
              style: TextStyle(fontSize: 24),
            )
                : Container(
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
              child: Image.asset(_images[_currentIndex]),
            ),
            SizedBox(height: 20),
            Text(
              '$_secondsLeft seconds left',
              style: TextStyle(fontSize: 18),
            ),
            if (_currentIndex == _images.length - 1 && !_isBreak)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _goToNextPage,
                    child: Text('Next'),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: screenSize.height * 0.1,
        width: screenSize.width,
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
