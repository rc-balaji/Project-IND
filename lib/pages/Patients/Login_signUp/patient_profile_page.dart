import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Add this import
import 'dart:convert';

import 'package:untitled2/pages/Patients/Login_signUp/patient_login_screen.dart';

class PatientProfilePage extends StatefulWidget {
  final String username;
  final String password;

  PatientProfilePage({required this.username, required this.password});

  @override
  _PatientProfilePageState createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _ageFocusNode = FocusNode();
  FocusNode _occupationFocusNode = FocusNode();
  String _selectedGender = '';
  String _selectedMaritalStatus = '';
  bool _smokes = false;
  bool _drinksAlcohol = false;
  bool _showError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    _nameFocusNode.dispose();
    _ageFocusNode.dispose();
    _occupationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Patient Profile'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigo,
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient Name:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_ageFocusNode);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter patient name',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Age:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _ageController,
                    focusNode: _ageFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_occupationFocusNode);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter age',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Occupation:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _occupationController,
                    focusNode: _occupationFocusNode,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter occupation',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Gender:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      _genderButton('Male'),
                      _genderButton('Female'),
                      _genderButton('Neither'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Marital Status:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      _maritalStatusButton('Single'),
                      _maritalStatusButton('Married'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Smoke:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      _smokeButton('Yes', true),
                      _smokeButton('No', false),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Alcohol:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      _alcoholButton('Yes', true),
                      _alcoholButton('No', false),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _validateAndSaveProfile,
                    child: Text('Save Profile'),
                  ),
                  if (_showError)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Please fill all the fields!',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverFooter(),
        ],
      ),
    );
  }

  Widget _genderButton(String gender) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Text(gender),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedGender == gender ? Colors.lightGreen : null,
      ),
    );
  }

  Widget _maritalStatusButton(String status) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedMaritalStatus = status;
        });
      },
      child: Text(status),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedMaritalStatus == status ? Colors.lightGreen : null,
      ),
    );
  }

  Widget _smokeButton(String label, bool value) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _smokes = value;
        });
      },
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: _smokes == value ? Colors.lightGreen : null,
      ),
    );
  }

  Widget _alcoholButton(String label, bool value) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _drinksAlcohol = value;
        });
      },
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: _drinksAlcohol == value ? Colors.lightGreen : null,
      ),
    );
  }

  void _validateAndSaveProfile() {
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _occupationController.text.isEmpty ||
        _selectedGender.isEmpty ||
        _selectedMaritalStatus.isEmpty) {
      setState(() {
        _showError = true;
      });
    } else {
      setState(() {
        _showError = false;
      });
      _saveProfile();
    }
  }

  void _saveProfile() async {
    String name = _nameController.text;
    String age = _ageController.text;
    String occupation = _occupationController.text;
    String registeredDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    final response = await http.put(
      Uri.parse('http://192.168.1.10:3000/api/patients/${widget.username}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'password': widget.password,
        'name': name,
        'age': age,
        'gender': _selectedGender,
        'maritalStatus': _selectedMaritalStatus,
        'occupation': occupation,
        'alcohol': _drinksAlcohol,
        'smoke': _smokes,
        'journey': {
          'registered_Date': registeredDate
        }
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PatientLoginScreen(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save profile.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

class SliverFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.indigo[300]!,
              Colors.indigo[900]!,
            ],
          ),
        ),
      ),
    );
  }
}
