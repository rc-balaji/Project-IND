import 'package:flutter/material.dart';
import '../user_details_page.dart'; // Importing the user_details_page.dart to navigate to it

class AlcoholismPage extends StatefulWidget {
  @override
  _AlcoholismPageState createState() => _AlcoholismPageState();
}

class _AlcoholismPageState extends State<AlcoholismPage> {
  String? _consumedAlcoholToday;
  String? _glassesConsumed;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Alcoholism'),
      ),
      body: ListView(
        padding: EdgeInsets.all(screenWidth * 0.04), // Adjust padding based on screen width
        children: [
          Text(
            'Have you consumed alcohol today?',
            style: TextStyle(fontSize: screenWidth * 0.05), // Adjust font size based on screen width
          ),
          SizedBox(height: screenHeight * 0.02), // Adjust spacing based on screen height
          RadioListTile(
            title: Text(
              'Yes',
              style: TextStyle(fontSize: screenWidth * 0.045), // Adjust font size
            ),
            value: 'yes',
            groupValue: _consumedAlcoholToday,
            onChanged: (value) {
              setState(() {
                _consumedAlcoholToday = value as String?;
              });
            },
          ),
          RadioListTile(
            title: Text(
              'No',
              style: TextStyle(fontSize: screenWidth * 0.045), // Adjust font size
            ),
            value: 'no',
            groupValue: _consumedAlcoholToday,
            onChanged: (value) {
              setState(() {
                _consumedAlcoholToday = value as String?;
              });
            },
          ),
          if (_consumedAlcoholToday == 'yes') ...[
            SizedBox(height: screenHeight * 0.02), // Adjust spacing based on screen height
            Text(
              'How many glasses have you consumed?',
              style: TextStyle(fontSize: screenWidth * 0.05), // Adjust font size
            ),
            SizedBox(height: screenHeight * 0.01), // Adjust spacing based on screen height
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of Glasses',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _glassesConsumed = value;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02), // Adjust spacing based on screen height
            Text(
              'Warning: Stop consuming it.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.045, // Adjust font size
              ),
            ),
          ],
          SizedBox(height: screenHeight * 0.04), // Adjust spacing based on screen height
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(
              'Submit',
              style: TextStyle(fontSize: screenWidth * 0.05), // Adjust font size
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02, // Adjust padding based on screen height
                horizontal: screenWidth * 0.1, // Adjust padding based on screen width
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    // Handle form submission
    print('Submit button pressed');
    print('Consumed Alcohol Today: $_consumedAlcoholToday');
    if (_consumedAlcoholToday == 'yes') {
      print('Glasses Consumed: $_glassesConsumed');
    }

    Navigator.pop(context); // Navigate back to the previous page
  }
}
