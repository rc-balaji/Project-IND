import 'package:flutter/material.dart';
import 'dart:async';

class Week3Page extends StatefulWidget {
  final int duration;

  Week3Page({required this.duration});

  @override
  _Week3PageState createState() => _Week3PageState();
}

class _Week3PageState extends State<Week3Page> {
  Timer? _timer;
  int _secondsLeft = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.duration * 60;
  }

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
                Text('What is the struggle you are facing while running?'),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Struggle'),
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 50.8), // Original height + 2 inch
        child: AppBar(
          title: Text('Week 3 Exercise'),
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
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
      ),
      bottomNavigationBar: Container(
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.indigo[100]!,
              Colors.indigo[500]!,
              Colors.indigo[900]!,
            ],
          ),
        ),
      ),
    );
  }
}
