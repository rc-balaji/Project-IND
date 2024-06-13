import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Patients_Entry_Page/PD_entry_page.dart';

class AdminDetailsEntryPage extends StatefulWidget {
  @override
  _AdminDetailsEntryPageState createState() => _AdminDetailsEntryPageState();
}

class _AdminDetailsEntryPageState extends State<AdminDetailsEntryPage> {
  final TextEditingController _patientIdController = TextEditingController();
  String _warning = '';

  Future<bool> _checkPatientId(String patientId) async {
    final response = await http.get(Uri.parse('http://192.168.183.83:3000/api/checkPatientId?patientId=$patientId'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['exists'];
    } else {
      throw Exception('Failed to check patient ID');
    }
  }

  void _onSubmit(BuildContext context) async {
    String patientId = _patientIdController.text;
    
    try {
      bool isValid = await _checkPatientId(patientId);
      if (isValid) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PD_EntryPage(patientId: patientId)),
        );
      } else {
        setState(() {
          _warning = 'Invalid patient ID. Please try again.';
        });
      }
    } catch (error) {
      setState(() {
        _warning = 'Error fetching data. Please try again later.';
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
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1,
              vertical: screenHeight * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/admin_img.jpg',
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.3,
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Enter Patient ID',
                  style: TextStyle(fontSize: screenWidth * 0.05),
                ),
                TextField(
                  controller: _patientIdController,
                  decoration: InputDecoration(
                    hintText: 'Patient ID',
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                ElevatedButton(
                  onPressed: () {
                    _onSubmit(context);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: screenWidth * 0.045),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  _warning,
                  style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.04),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: screenHeight * 0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.purpleAccent],
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
