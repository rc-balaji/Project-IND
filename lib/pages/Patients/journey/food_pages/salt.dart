import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'food_page.dart';  // Import the FoodPage class

class SaltPage extends StatefulWidget {
  final String username;

  SaltPage({required this.username});

  @override
  _SaltPageState createState() => _SaltPageState();
}

class _SaltPageState extends State<SaltPage> {
  final TextEditingController _saltController = TextEditingController();
  final TextEditingController _dryFishController = TextEditingController();
  final TextEditingController _picklesController = TextEditingController();
  final TextEditingController _saltedNutsController = TextEditingController();
  final TextEditingController _preservedFoodsController = TextEditingController();
  final TextEditingController _saltedButterController = TextEditingController();
  final TextEditingController _cheeseController = TextEditingController();

  int _papadamCount = 0;

  @override
  void dispose() {
    _saltController.dispose();
    _dryFishController.dispose();
    _picklesController.dispose();
    _saltedNutsController.dispose();
    _preservedFoodsController.dispose();
    _saltedButterController.dispose();
    _cheeseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salt and Related Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField('Amount of salt added (grams):', _saltController),
            _buildTextField('Dry fish (grams):', _dryFishController),
            _buildPapadamCounter(),
            _buildTextField('Pickles (grams):', _picklesController),
            _buildTextField('Salted nuts (grams):', _saltedNutsController),
            _buildTextField('Preserved foods:', _preservedFoodsController),
            _buildTextField('Salted butter (glass):', _saltedButterController),
            _buildTextField('Cheese (grams):', _cheeseController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  Widget _buildPapadamCounter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Papadam count:',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (_papadamCount > 0) {
                      _papadamCount--;
                    }
                  });
                },
              ),
              Text(
                '$_papadamCount',
                style: TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _papadamCount++;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submit() async {
    List<Map<String, dynamic>> saltData = [
      {'name': 'Amount of salt added', 'value': _saltController.text},
      {'name': 'Dry fish', 'value': _dryFishController.text},
      {'name': 'Papadam count', 'value': _papadamCount.toString()},
      {'name': 'Pickles', 'value': _picklesController.text},
      {'name': 'Salted nuts', 'value': _saltedNutsController.text},
      {'name': 'Preserved foods', 'value': _preservedFoodsController.text},
      {'name': 'Salted butter', 'value': _saltedButterController.text},
      {'name': 'Cheese', 'value': _cheeseController.text},
    ];

    final response = await http.put(
      Uri.parse('http://192.168.197.83:3000/api/patients/${widget.username}/foods/Salt'), // Replace with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'food': {'Salt': saltData}}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submitted successfully!'),
        ),
      );

      // Navigate back to FoodPage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => FoodPage(username: widget.username)),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit!'),
        ),
      );
    }
  }
}

class ItemData {
  String name;
  int count;

  ItemData({required this.name, required this.count});
}
