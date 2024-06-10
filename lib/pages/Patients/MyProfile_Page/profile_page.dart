import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String age;
  final String gender;
  final String maritalStatus;
  final bool smoke;
  final bool alcohol;

  ProfilePage({
    required this.name,
    required this.age,
    required this.gender,
    required this.maritalStatus,
    required this.smoke,
    required this.alcohol,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.indigo[900]!,
                Colors.white,
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Age: $age',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Gender: $gender',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Marital Status: $maritalStatus',
              style: TextStyle(fontSize: 18),
            ),
            if (smoke) SizedBox(height: 8),
            if (smoke)
              Text(
                'Smoke: Yes',
                style: TextStyle(fontSize: 18),
              ),
            if (alcohol) SizedBox(height: 8),
            if (alcohol)
              Text(
                'Alcohol: Yes',
                style: TextStyle(fontSize: 18),
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
            colors: [
              Colors.white,
              Colors.indigo,
            ],
          ),
        ),
      ),
    );
  }
}
