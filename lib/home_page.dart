import 'package:flutter/material.dart';
import 'pages/Admin/admin_details_entry_page.dart';
import 'pages/Patients/Login_signUp/patient_login_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = screenHeight * 0.12;
    double buttonHeight = screenHeight * 0.07; // 7% of screen height for button height
    double buttonFontSize = screenWidth > 600 ? 18.0 : 16.0; // Adjust font size based on screen width
    double spacing = screenHeight * 0.02; // 2% of screen height for spacing

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          title: Text('Suruksha App'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blueAccent,
                  Colors.blueAccent.withOpacity(0.5),
                  Colors.white,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Suruksha',
              style: TextStyle(
                fontSize: screenWidth > 600 ? 28 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing * 3),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminDetailsEntryPage()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person),
                  SizedBox(width: spacing),
                  Text(
                    'Admin Login',
                    style: TextStyle(fontSize: buttonFontSize),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenWidth * 0.5, buttonHeight), // 50% of screen width and calculated button height
              ),
            ),
            SizedBox(height: spacing),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientLoginScreen()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_circle),
                  SizedBox(width: spacing),
                  Text(
                    'Patient Login',
                    style: TextStyle(fontSize: buttonFontSize),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenWidth * 0.5, buttonHeight), // 50% of screen width and calculated button height
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: appBarHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blueAccent.withOpacity(0.5),
              Colors.blueAccent,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}

class AdminLoginScreen {}
