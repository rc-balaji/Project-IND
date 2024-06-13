import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
  Timer? resetTimer;

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
    _loadCompletionData();
    _resetProgressAtMidnight();
  }

  @override
  void dispose() {
    resetTimer?.cancel();
    super.dispose();
  }

  void _loadCompletionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      completionPercentage = (prefs.getDouble('completionPercentage') ?? 0.0);
      completionStatus = {
        'food': (prefs.getBool('foodCompleted') ?? false),
        'exercise': (prefs.getBool('exerciseCompleted') ?? false),
        'smoking': (prefs.getBool('smokingCompleted') ?? false),
        'alcohol': (prefs.getBool('alcoholCompleted') ?? false),
        'sleep': (prefs.getBool('sleepCompleted') ?? false),
        'water': (prefs.getBool('waterCompleted') ?? false),
      };
    });
  }

  void _saveCompletionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('completionPercentage', completionPercentage);
    await prefs.setBool('foodCompleted', completionStatus['food']!);
    await prefs.setBool('exerciseCompleted', completionStatus['exercise']!);
    await prefs.setBool('smokingCompleted', completionStatus['smoking']!);
    await prefs.setBool('alcoholCompleted', completionStatus['alcohol']!);
    await prefs.setBool('sleepCompleted', completionStatus['sleep']!);
    await prefs.setBool('waterCompleted', completionStatus['water']!);
  }

  void _updateCompletionStatus(String key, bool value) {
    setState(() {
      completionStatus[key] = value;
      _calculateAndUpdateCompletionPercentage();
    });
  }

  void _calculateAndUpdateCompletionPercentage() {
    int completed = completionStatus.values.where((v) => v).length;
    int totalTasks = completionStatus.keys.length;
    double newPercentage = completed / totalTasks;
    setState(() {
      completionPercentage = newPercentage;
    });
    _saveCompletionData();
  }

  void _resetProgressAtMidnight() {
    DateTime now = DateTime.now();
    DateTime nextMidnight = DateTime(now.year, now.month, now.day + 1);
    Duration timeToMidnight = nextMidnight.difference(now);

    resetTimer = Timer(timeToMidnight, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      setState(() {
        completionStatus.updateAll((key, value) => false);
        completionPercentage = 0.0;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05), // Adjust padding based on screen width
          child: Column(
            children: [
              _buildProgressCircle(screenSize),
              SizedBox(height: screenSize.height * 0.03), // Adjust vertical spacing based on screen height
              _buildJourneyButton(
                text: 'Food',
                imagePath: 'images/food.jpg',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FoodPage(username: widget.username))).then((_) {
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SmokingPage(username : widget.username))).then((_) {
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AlcoholismPage(username : widget.username))).then((_) {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SleepingHabitsPage(username : widget.username))).then((_) {
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
          borderRadius: BorderRadius.circular(screenSize.width * 0.03),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.blue.shade900,
          borderRadius: BorderRadius.circular(screenSize.width * 0.03),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.03,
            horizontal: screenSize.width * 0.05,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: screenSize.width * 0.06, // Adjust font size based on screen width
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: screenSize.width * 0.06, // Adjust icon size based on screen width
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCircle(Size screenSize) {
    return Center(
      child: Container(
        width: screenSize.width * 0.4, // Adjust circle size based on screen width
        height: screenSize.width * 0.4, // Adjust circle size based on screen width
        child: Stack(
          children: [
            Center(
              child: Container(
                width: screenSize.width * 0.35, // Adjust inner circle size based on screen width
                height: screenSize.width * 0.35, // Adjust inner circle size based on screen width
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Text(
                    '${(completionPercentage * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.08, // Adjust font size based on screen width
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: screenSize.width * 0.4, // Adjust progress circle size based on screen width
                height: screenSize.width * 0.4, // Adjust progress circle size based on screen width
                child: CircularProgressIndicator(
                  value: completionPercentage,
                  strokeWidth: screenSize.width * 0.04, // Adjust stroke width based on screen width
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
