import 'package:flutter/material.dart';
import 'Patients_Entry_Page/PD_entry_page.dart';

class AdminDetailsEntryPage extends StatefulWidget {
  @override
  _AdminDetailsEntryPageState createState() => _AdminDetailsEntryPageState();
}

class _AdminDetailsEntryPageState extends State<AdminDetailsEntryPage> {
  final TextEditingController _patientIdController = TextEditingController();
  String _warning = '';

  void _checkPatientId(BuildContext context) {
    // Add logic to check patient ID
    String patientId = _patientIdController.text;
    // Example logic: Check if patientId is valid
    if (patientId.isNotEmpty && patientId == 'Id') {
      // Navigate to PD_EntryPage (Patient Details Entry Page)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PD_EntryPage()),
      );
    } else {
      setState(() {
        _warning = 'Invalid patient ID. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.purpleAccent, Colors.white],
            ),
          ),
          child: AppBar(
            title: Text('Admin Details Entry'),
            backgroundColor: Colors.transparent, // Set app bar color to transparent
            elevation: 0, // Remove app bar elevation
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1, // 10% of screen width
              vertical: screenHeight * 0.05, // 5% of screen height
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Image above the patient ID
                Image.asset(
                  'images/admin_img.jpg', // Path to your image asset
                  width: screenWidth * 0.6, // 60% of screen width
                  height: screenHeight * 0.3, // 30% of screen height
                ),
                SizedBox(height: screenHeight * 0.05), // 5% of screen height
                // UI for entering patient ID
                Text(
                  'Enter Patient ID',
                  style: TextStyle(fontSize: screenWidth * 0.05), // Adjust text size based on screen width
                ),
                TextField(
                  controller: _patientIdController,
                  decoration: InputDecoration(
                    hintText: 'Patient ID',
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height
                ElevatedButton(
                  onPressed: () {
                    // Call the method to check patient ID
                    _checkPatientId(context);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: screenWidth * 0.045), // Adjust button text size
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height
                Text(
                  _warning,
                  style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.04), // Adjust warning text size
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: screenHeight * 0.1, // 10% of screen height
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.purpleAccent], // Gradient from white to purpleAccent
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    super.dispose();
  }
}
