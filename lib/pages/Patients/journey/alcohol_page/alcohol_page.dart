import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode
import '../user_details_page.dart'; // Importing the user_details_page.dart to navigate to it

class AlcoholismPage extends StatefulWidget {
  final String username;

  AlcoholismPage({required this.username});

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
            onPressed: canSubmit ? _submitForm : null,
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

  bool get canSubmit {
    if (_consumedAlcoholToday == 'no') {
      return true;
    } else if (_consumedAlcoholToday == 'yes' && _glassesConsumed != null && _glassesConsumed!.isNotEmpty) {
      return true;
    }
    return false;
  }

  void _submitForm() async {
    // API endpoint URL
    String apiUrl = 'http://192.168.197.83:3000/api/patients/${widget.username}/updateAlcoholItems'; // Replace with your API URL
    print("Submitting............");
    // Prepare data to be sent
    Map<String, dynamic> alcoholData = {
      'consumedAlcoholToday': _consumedAlcoholToday,
      'glassesConsumed': _glassesConsumed,
    };

    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(alcoholData),
      );

      if (response.statusCode == 200) {
        print('Data submitted successfully');
        Navigator.pop(context); // Navigate back to the previous page
      } else {
        print('Failed to submit data: ${response.statusCode}');
        // Handle the error appropriately
      }
    } catch (error) {
      print('Error submitting data: $error');
      // Handle the error appropriately
    }
  }
}
