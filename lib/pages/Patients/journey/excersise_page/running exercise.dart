import 'package:flutter/material.dart';
import 'Week1.dart';
import 'Week2.dart';
import 'Week3.dart';
import 'Week4.dart';
import 'AfterFourthWeek.dart';
import 'endwarmup.dart';

void main() {
  runApp(MaterialApp(
    home: RunningExercisePage(),
  ));
}

class RunningExercisePage extends StatefulWidget {
  @override
  _RunningExercisePageState createState() => _RunningExercisePageState();
}

class _RunningExercisePageState extends State<RunningExercisePage> {
  bool _isExerciseSelected = false;

  void _exerciseSelected() {
    setState(() {
      _isExerciseSelected = true;
    });
  }

  void _navigateToCoolWarmupPage() {
    if (_isExerciseSelected) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CoolWarmupPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an exercise before proceeding.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Running Exercise Page'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.indigo[900]!, Colors.indigo[100]!],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _exerciseSelected();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Week1Page(
                                message: 'You are unable to do the exercise for a week after therapy.',
                              ),
                            ),
                          );
                        },
                        child: Text('1st Week'),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _exerciseSelected();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Week2Page(
                                duration: 10,
                              ),
                            ),
                          );
                        },
                        child: Text('2nd Week'),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _exerciseSelected();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Week3Page(
                                duration: 20,
                              ),
                            ),
                          );
                        },
                        child: Text('3rd Week'),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _exerciseSelected();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Week4Page(
                                duration: 30,
                              ),
                            ),
                          );
                        },
                        child: Text('4th Week'),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _exerciseSelected();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AfterFourthWeekPage(),
                            ),
                          );
                        },
                        child: Text('After Fourth Week'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _navigateToCoolWarmupPage,
                  child: Text('Next'),
                ),
              ),
            ),
          ),
          Container(
            height: 100,
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
