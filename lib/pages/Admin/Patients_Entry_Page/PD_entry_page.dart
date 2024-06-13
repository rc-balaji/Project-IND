import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'medicine_reminder_page.dart';

class PD_EntryPage extends StatefulWidget {
  @override
  _PD_EntryPageState createState() => _PD_EntryPageState();
  final String patientId;
  PD_EntryPage({required this.patientId});
}

class _PD_EntryPageState extends State<PD_EntryPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bpController = TextEditingController();
  final TextEditingController _waistCircumferenceController = TextEditingController();
  final TextEditingController _fastingBloodSugarController = TextEditingController();
  final TextEditingController _ldlCholesterolController = TextEditingController();
  final TextEditingController _hdlCholesterolController = TextEditingController();
  final TextEditingController _triglycerideController = TextEditingController();

  final FocusNode _heightFocusNode = FocusNode();
  final FocusNode _weightFocusNode = FocusNode();
  final FocusNode _bpFocusNode = FocusNode();
  final FocusNode _waistCircumferenceFocusNode = FocusNode();
  final FocusNode _fastingBloodSugarFocusNode = FocusNode();
  final FocusNode _ldlCholesterolFocusNode = FocusNode();
  final FocusNode _hdlCholesterolFocusNode = FocusNode();
  final FocusNode _triglycerideFocusNode = FocusNode();

  String _warningMessage = '';

  Future<void> _sendPatientDetails() async {
    final url = Uri.parse('http://192.168.183.83:3000/api/updatePatientDetails');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patientId': widget.patientId,
        'patient_details': {
          'height': _heightController.text,
          'weight': _weightController.text,
          'bp': _bpController.text,
          'waist_circumference': _waistCircumferenceController.text,
          'fasting_blood_sugar': _fastingBloodSugarController.text,
          'ldl_cholesterol': _ldlCholesterolController.text,
          'hdl_cholesterol': _hdlCholesterolController.text,
          'triglyceride': _triglycerideController.text,
        }
      }),
    );
    if (response.statusCode == 200) {
      print('Patient details sent successfully');
    } else {
      print('Failed to send patient details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purpleAccent, Colors.white],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Patient Details Entry',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.purpleAccent],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              onPressed: _handleSubmitted,
              child: Text('Next'),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Enter Patient Details:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            _buildFeatureButton(
              labelText: 'Height (cms)',
              controller: _heightController,
              focusNode: _heightFocusNode,
              nextFocusNode: _weightFocusNode,
              imagePath: 'images/height_img.jpg',
            ),
            _buildFeatureButton(
              labelText: 'Weight (kg)',
              controller: _weightController,
              focusNode: _weightFocusNode,
              nextFocusNode: _bpFocusNode,
              imagePath: 'images/weight_img.jpg',
            ),
            _buildFeatureButton(
              labelText: 'BP (mm of Hg)',
              controller: _bpController,
              focusNode: _bpFocusNode,
              nextFocusNode: _waistCircumferenceFocusNode,
              imagePath: 'images/bp_img.jpg',
            ),
            _buildFeatureButton(
              labelText: 'Waist Circumference (cms)',
              controller: _waistCircumferenceController,
              focusNode: _waistCircumferenceFocusNode,
              nextFocusNode: _fastingBloodSugarFocusNode,
              imagePath: 'images/waist_circumference_img.jpg',
            ),
            _buildFeatureButton(
              labelText: 'Fasting Blood Sugar (mg/dL)',
              controller: _fastingBloodSugarController,
              focusNode: _fastingBloodSugarFocusNode,
              nextFocusNode: _ldlCholesterolFocusNode,
              imagePath: 'images/fasting_blood_sugar_img.jpg',
            ),
            _buildFeatureButton(
              labelText: 'LDL Cholesterol (mg/dL)',
              controller: _ldlCholesterolController,
              focusNode: _ldlCholesterolFocusNode,
              nextFocusNode: _hdlCholesterolFocusNode,
              imagePath: 'images/LDL_cholesterol_img.jpg',
            ),
            _buildFeatureButton(
              labelText: 'HDL Cholesterol (mg/dL)',
              controller: _hdlCholesterolController,
              focusNode: _hdlCholesterolFocusNode,
              nextFocusNode: _triglycerideFocusNode,
              imagePath: 'images/HDL_cholesterol_img.jpg',
            ),
            _buildFeatureButton(
              labelText: 'Triglyceride (mg/dL)',
              controller: _triglycerideController,
              focusNode: _triglycerideFocusNode,
              nextFocusNode: null,
              isLast: true,
              imagePath: 'images/triglyceride_img.jpg',
            ),
            SizedBox(height: 20.0),
            if (_warningMessage.isNotEmpty)
              Text(
                _warningMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton({
    required String labelText,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    bool isLast = false,
    required String imagePath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 50, // Adjust width as needed
          height: 50, // Adjust height as needed
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover, // or use BoxFit.fill to stretch the image
          ),        ),
        SizedBox(height: 10),
        Text(
          labelText,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Enter value',
          ),
          keyboardType: TextInputType.number,
          textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
          onFieldSubmitted: (_) {
            focusNode.unfocus();
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              _handleSubmitted();
            }
          },
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  void _handleSubmitted() async {
    if (_validateForm()) {
      await _sendPatientDetails();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Medicine(patientId: widget.patientId),
        ),
      );
    }
  }

  bool _validateForm() {
    if (_heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _bpController.text.isEmpty ||
        _waistCircumferenceController.text.isEmpty ||
        _fastingBloodSugarController.text.isEmpty ||
        _ldlCholesterolController.text.isEmpty ||
        _hdlCholesterolController.text.isEmpty ||
        _triglycerideController.text.isEmpty) {
      setState(() {
        _warningMessage = 'Please fill in all fields.';
      });
      return false;
    }
    setState(() {
      _warningMessage = '';
    });
    return true;
  }
}

       
