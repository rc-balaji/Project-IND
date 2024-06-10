import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'food_pages/food_page.dart';
import 'excersise_page/exercise_habits.dart';
import 'smoke_page/smoking_page.dart';
import 'sleep_page/sleeping_habits.dart';
import 'alcohol_page/alcohol_page.dart';
import 'water_page/water.dart';

class JourneyPage extends StatefulWidget {
  final String username;
  final String name;
  final String age;
  final String gender;
  final String maritalStatus;
  final bool smoke;
  final bool alcohol;

  JourneyPage({
    required this.username,
    required this.name,
    required this.age,
    required this.gender,
    required this.maritalStatus,
    required this.smoke,
    required this.alcohol,
  });

  @override
  _JourneyPageState createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  late Map<String, bool> completionStatus;
  double completionPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    completionStatus = {
      'food': false,
      'exercise': false,
      'smoking': false,
      'alcohol': false,
      'sleep': false,
      'water': false,
    };
    _loadCompletionStatus();
    _resetProgressAtMidnight();
  }

  void _loadCompletionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      completionStatus['food'] = prefs.getBool('food') ?? false;
      completionStatus['exercise'] = prefs.getBool('exercise') ?? false;
      if (widget.smoke) {
        completionStatus['smoking'] = prefs.getBool('smoking') ?? false;
      }
      if (widget.alcohol) {
        completionStatus['alcohol'] = prefs.getBool('alcohol') ?? false;
      }
      completionStatus['sleep'] = prefs.getBool('sleep') ?? false;
      completionStatus['water'] = prefs.getBool('water') ?? false;
      _updateCompletionPercentage();
    });
  }

  void _updateCompletionStatus(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      completionStatus[key] = value;
      prefs.setBool(key, value);
      _updateCompletionPercentage();
    });
  }

  void _updateCompletionPercentage() {
    int completed = completionStatus.values.where((v) => v).length;
    int totalTasks = completionStatus.keys.length;
    setState(() {
      completionPercentage = (completed / totalTasks);
    });
  }

  void _resetProgressAtMidnight() {
    DateTime now = DateTime.now();
    DateTime nextMidnight = DateTime(now.year, now.month, now.day + 1);
    Duration timeToMidnight = nextMidnight.difference(now);
    Timer(timeToMidnight, () {
      setState(() {
        completionStatus.updateAll((key, value) => false);
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });
        _updateCompletionPercentage();
      });
      _resetProgressAtMidnight();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Journey'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back when back button is pressed
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.05), // Adjust padding based on screen width
        child: Column(
          children: [
            _buildProgressCircle(screenSize),
            SizedBox(height: screenSize.height * 0.03), // Adjust vertical spacing based on screen height
            _buildJourneyButton(
              text: 'Food',
              imagePath: 'images/food.jpg',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FoodPage())).then((_) {
                  _updateCompletionStatus('food', true);
                });
              },
              screenSize: screenSize,
            ),
            SizedBox(height: screenSize.height * 0.03), // Adjust vertical spacing based on screen height
            _buildJourneyButton(
              text: 'Exercise',
              imagePath: 'images/exercise.jpg',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WarmUpPage())).then((_) {
                  _updateCompletionStatus('exercise', true);
                });
              },
              screenSize: screenSize,
            ),
            if (widget.smoke) SizedBox(height: screenSize.height * 0.03), // Adjust vertical spacing based on screen height
            if (widget.smoke)
              _buildJourneyButton(
                text: 'Smoking',
                imagePath: 'images/smoke.jpg',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SmokingPage())).then((_) {
                    _updateCompletionStatus('smoking', true);
                  });
                },
                screenSize: screenSize,
              ),
            if (widget.smoke) SizedBox(height: screenSize.height * 0.03), // Adjust vertical spacing based on screen height
            if (widget.alcohol)
              _buildJourneyButton(
                text: 'Alcohol',
                imagePath: 'images/alcohol.jpg',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AlcoholismPage())).then((_) {
                    _updateCompletionStatus('alcohol', true);
                  });
                },
                screenSize: screenSize,
              ),
            if (widget.alcohol) SizedBox(height: screenSize.height * 0.03), // Adjust vertical spacing based on screen height
            _buildJourneyButton(
              text: 'Sleep Time',
              imagePath: 'images/sleep.jpg',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SleepingHabitsPage())).then((_) {
                  _updateCompletionStatus('sleep', true);
                });
              },
              screenSize: screenSize,
            ),
            SizedBox(height: screenSize.height * 0.03), // Adjust vertical spacing based on screen height
            _buildJourneyButton(
              text: 'Water',
              imagePath: 'images/water.jpg',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WaterMonitoringApp(
                      username: widget.username,
                      name: widget.name,
                      age: widget.age,
                      gender: widget.gender,
                      maritalStatus: widget.maritalStatus,
                      smoke: widget.smoke,
                      alcohol: widget.alcohol,
                    ),
                  ),
                ).then((_) {
                  _updateCompletionStatus('water', true);
                });
              },
              screenSize: screenSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyButton({
    required String text,
    required String imagePath,
    required VoidCallback onPressed,
    required Size screenSize,
  }) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade900,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenSize.width * 0.05), // Adjust border radius based on screen width
    ),
    minimumSize:
    Size(double.infinity, screenSize.height * 0.08), // Adjust button height based on screen height
        ),
      child: Container(
        height: screenSize.height * 0.08, // Adjust button height based on screen height
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04), // Adjust horizontal padding based on screen width
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(screenSize.width * 0.05), // Adjust border radius based on screen width
                    bottomRight: Radius.circular(screenSize.width * 0.05), // Adjust border radius based on screen width
                  ),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCircle(Size screenSize) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: screenSize.width * 0.4, // Adjust circle size based on screen width
            width: screenSize.width * 0.4, // Adjust circle size based on screen width
            child: CircularProgressIndicator(
              value: completionPercentage,
              strokeWidth: screenSize.width * 0.05, // Adjust stroke width based on screen width
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
          Text(
            '${(completionPercentage * 100).toInt()}%',
            style: TextStyle(fontSize: screenSize.width * 0.1, fontWeight: FontWeight.bold), // Adjust font size based on screen width
          ),
        ],
      ),
    );
  }
}

