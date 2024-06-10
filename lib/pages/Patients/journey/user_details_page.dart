import 'package:flutter/material.dart';
import 'journey_page.dart';
import '../MyProfile_Page/profile_page.dart'; // Ensure you have this import for ProfilePage
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsPage extends StatefulWidget {
  final String username;
  final String name;
  final String age;
  final String gender;
  final String maritalStatus;
  final bool smoke;
  final bool alcohol;

  UserDetailsPage({
    required this.username,
    required this.name,
    required this.age,
    required this.gender,
    required this.maritalStatus,
    required this.smoke,
    required this.alcohol,
  });

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  Map<String, bool> completionStatus = {
    'food': false,
    'exercise': false,
    'smoking': false,
    'alcohol': false,
    'sleep': false,
    'water': false,
  };

  double completionPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCompletionStatus();
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

  void _updateCompletionPercentage() {
    int completed = completionStatus.values.where((v) => v).length;
    int totalTasks = completionStatus.keys.length;
    setState(() {
      completionPercentage = (completed / totalTasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo,
              Colors.white,
              Colors.white,
              Colors.indigo,
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildContent()),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200.0,
      alignment: Alignment.center,
      child: Text(
        'User Details',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${widget.username}!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildProgressCircle(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavigationButton(
            text: 'Journey',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JourneyPage(
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
                _loadCompletionStatus();
              });
            },
          ),
          _buildNavigationButton(
            text: 'My Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    name: widget.name,
                    age: widget.age,
                    gender: widget.gender,
                    maritalStatus: widget.maritalStatus,
                    smoke: widget.smoke,
                    alcohol: widget.alcohol,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Colors.white60, padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildProgressCircle() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              value: completionPercentage,
              strokeWidth: 10,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
          Text(
            '${(completionPercentage * 100).toInt()}%',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
