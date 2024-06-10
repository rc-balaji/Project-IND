import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../user_details_page.dart'; // Import UserDetailsPage

class WaterMonitoringApp extends StatelessWidget {
  final String username;
  final String name;
  final String age;
  final String gender;
  final String maritalStatus;
  final bool smoke;
  final bool alcohol;

  WaterMonitoringApp({
    required this.username,
    required this.name,
    required this.age,
    required this.gender,
    required this.maritalStatus,
    required this.smoke,
    required this.alcohol,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Monitoring App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WaterMonitoringScreen(
        username: username,
        name: name,
        age: age,
        gender: gender,
        maritalStatus: maritalStatus,
        smoke: smoke,
        alcohol: alcohol,
      ),
    );
  }
}

class WaterMonitoringScreen extends StatefulWidget {
  final String username;
  final String name;
  final String age;
  final String gender;
  final String maritalStatus;
  final bool smoke;
  final bool alcohol;

  WaterMonitoringScreen({
    required this.username,
    required this.name,
    required this.age,
    required this.gender,
    required this.maritalStatus,
    required this.smoke,
    required this.alcohol,
  });

  @override
  _WaterMonitoringScreenState createState() => _WaterMonitoringScreenState();
}

class _WaterMonitoringScreenState extends State<WaterMonitoringScreen> {
  int currentIntake = 0;
  int dailyGoal = 4000; // Daily water intake goal
  List<int> intakeRecords = [];
  bool goalReached = false;

  void logWaterIntake(int amount) {
    setState(() {
      currentIntake += amount;
      intakeRecords.add(amount);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged $amount ml of water intake.'),
          duration: Duration(seconds: 1),
        ),
      );
      // Check if the goal is completed
      if (currentIntake >= dailyGoal) {
        setState(() {
          goalReached = true;
        });
        showGoalCompletedDialog();
      }
    });
  }

  void showGoalCompletedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have completed your daily goal of $dailyGoal ml.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void navigateToSubmitScreen() {
    // Navigate to the submit screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitScreen(
          username: widget.username,
          name: widget.name,
          age: widget.age,
          gender: widget.gender,
          maritalStatus: widget.maritalStatus,
          smoke: widget.smoke,
          alcohol: widget.alcohol,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double appBarHeight = kToolbarHeight + statusBarHeight;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: appBarHeight + 3.54 * 16, // 1 inch converted to pixels
            color: Colors.blueAccent, // Blue accent background for header
            child: Column(
              children: [
                SizedBox(height: statusBarHeight), // To accommodate status bar
                Container(
                  color: Colors.blueAccent, // Blue accent background for header
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0), // Adjusted padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Water Monitoring',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${DateFormat('HH:mm').format(DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30)))}',
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[300], // Grey background for middle page
              child: Center(
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                      painter: WaterDropletsAnimation(),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Today\'s Water Intake',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 20.0),
                          TweenAnimationBuilder(
                            duration: Duration(seconds: 1),
                            tween: Tween<double>(begin: 0, end: currentIntake / dailyGoal),
                            builder: (_, double value, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 200,
                                    height: 200,
                                    child: CircularProgressIndicator(
                                      value: value,
                                      strokeWidth: 10.0,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                    ),
                                  ),
                                  Text(
                                    '${(value * 100).toInt()}% of goal',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton.icon(
                            onPressed: goalReached ? null : () => logWaterIntake(200),
                            icon: Icon(Icons.local_drink),
                            label: Text('Log Water Intake (200 ML)'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Daily Goal: $dailyGoal ml',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: navigateToSubmitScreen,
        child: Container(
          color: Colors.blueAccent, // Blue accent color for footer
          height: 50.0,
          child: Center(
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class WaterDropletsAnimation extends CustomPainter {
  final List<WaterDrop> drops = [];

  WaterDropletsAnimation() {
    // Create initial water drops
    for (int i = 0; i < 20; i++) {
      drops.add(WaterDrop());
    }
    // Start animation loop
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      for (var drop in drops) {
        drop.fall();
      }
      // Add new drop
      if (drops.length < 50 && Random().nextDouble() > 0.8) {
        drops.add(WaterDrop());
      }
      // Remove drops that reach the bottom
      drops.removeWhere((drop) => drop.y > 700);
      // Trigger repaint
      if (drops.isNotEmpty) {
        this..markNeedsRepaint();
      }
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue.withOpacity(0.5);
    for (var drop in drops) {
      canvas.drawCircle(Offset(drop.x, drop.y), drop.radius, paint);
    }
  }

  @override
  bool shouldRepaint(WaterDropletsAnimation oldDelegate) {
    return true;
  }

  markNeedsRepaint() {}
}

class WaterDrop {
  double x = 0;
  double y = 0;
  double radius = 0;
  double speed = 0;

  WaterDrop() {
    x = Random().nextDouble() * 400; // Random horizontal position
    y = Random().nextDouble() * 200 - 100; // Random vertical position (start above screen)
    radius = Random().nextDouble() * 5 + 2; // Random radius
    speed = Random().nextDouble() * 4 + 2; // Random speed
  }

  void fall() {
    y += speed;
  }
}

class SubmitScreen extends StatelessWidget {
  final String username;
  final String name;
  final String age;
  final String gender;
  final String maritalStatus;
  final bool smoke;
  final bool alcohol;

  SubmitScreen({
    required this.username,
    required this.name,
    required this.age,
    required this.gender,
    required this.maritalStatus,
    required this.smoke,
    required this.alcohol,
  });

  void navigateBackToUserDetails(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(
          username: username,
          name: name,
          age: age,
          gender: gender,
          maritalStatus: maritalStatus,
          smoke: smoke,
          alcohol: alcohol,
        ),
      ),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => navigateBackToUserDetails(context),
          child: Text(
            'Submit your data here.',
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}