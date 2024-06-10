import 'package:flutter/material.dart';
import 'dart:async';

class AfterFourthWeekPage extends StatefulWidget {
  @override
  _AfterFourthWeekPageState createState() => _AfterFourthWeekPageState();
}

class _AfterFourthWeekPageState extends State<AfterFourthWeekPage> {
  Timer? _timer;
  int _secondsLeft = 0;
  bool _isRunning = false;

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _timer?.cancel();
          _isRunning = false;
        }
      });
    });
  }

  void _stopTimer() {
    if (_secondsLeft > 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String feedback = '';
          return AlertDialog(
            title: Text('What happened?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('What are the struggles you are facing?'),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Feedback'),
                  onChanged: (value) {
                    feedback = value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (feedback.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in the feedback')),
                    );
                  } else {
                    Navigator.of(context).pop();
                    _timer?.cancel();
                    setState(() {
                      _isRunning = false;
                    });
                    print('Feedback: $feedback');
                  }
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
            ],
          );
        },
      );
    } else {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _setExerciseDuration(int minutes) {
    setState(() {
      _secondsLeft = minutes * 60;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + screenHeight * 0.05), // Original height + 5% of screen height
        child: AppBar(
          title: Text('After Fourth Week Exercise'),
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05), // 5% of screen width
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Set Exercise Duration (minutes):',
                    style: TextStyle(fontSize: screenWidth * 0.05), // Adjust font size based on screen width
                  ),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Minutes',
                    ),
                    onSubmitted: (value) {
                      final minutes = int.tryParse(value);
                      if (minutes != null) {
                        _setExerciseDuration(minutes);
                      }
                    },
                  ),
                  SizedBox(height: screenHeight * 0.03), // 3% of screen height
                  if (_secondsLeft > 0)
                    Column(
                      children: <Widget>[
                        Text(
                          '${(_secondsLeft ~/ 60).toString().padLeft(2, '0')}:${(_secondsLeft % 60).toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: screenWidth * 0.12), // Adjust font size based on screen width
                        ),
                        SizedBox(height: screenHeight * 0.03), // 3% of screen height
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if (!_isRunning)
                              ElevatedButton(
                                onPressed: _startTimer,
                                child: Text('Start Running'),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: screenWidth * 0.045), // Adjust button text size
                                ),
                              ),
                            if (_isRunning)
                              ElevatedButton(
                                onPressed: _stopTimer,
                                child: Text('Stop Running'),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: screenWidth * 0.045), // Adjust button text size
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03), // 3% of screen height
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Finished'),
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: screenWidth * 0.045), // Adjust button text size
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.1, // 10% of screen height
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.indigo],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
