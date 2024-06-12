import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'food_page.dart';  // Import the FoodPage class

class DrinksPage extends StatefulWidget {
  final String username;

  DrinksPage({required this.username});

  @override
  _DrinksPageState createState() => _DrinksPageState();
}

class _DrinksPageState extends State<DrinksPage> {
  int _milkCount = 0;
  int _butterMilkCount = 0;

  TextEditingController _freshJuiceController = TextEditingController();
  int _freshJuiceCount = 0;

  TextEditingController _coolDrinksController = TextEditingController();
  int _coolDrinksCount = 0;

  @override
  void dispose() {
    _freshJuiceController.dispose();
    _coolDrinksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth > 600 ? 24.0 : 16.0;
    double fontSize = screenWidth > 600 ? 18.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Drinks'),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: ListView(
          children: [
            _buildDrinkCounter('Milk (glass):', _milkCount, fontSize, (newCount) {
              setState(() {
                _milkCount = newCount;
              });
            }),
            _buildDrinkCounter('Butter Milk (glass):', _butterMilkCount, fontSize, (newCount) {
              setState(() {
                _butterMilkCount = newCount;
              });
            }),
            _buildDrinkWithTextField('Fresh Juice:', _freshJuiceController, _freshJuiceCount, fontSize, (newCount) {
              setState(() {
                _freshJuiceCount = newCount;
              });
            }),
            _buildDrinkWithTextField('Cool Drinks:', _coolDrinksController, _coolDrinksCount, fontSize, (newCount) {
              setState(() {
                _coolDrinksCount = newCount;
              });
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submit(context),
              child: Text('Submit', style: TextStyle(fontSize: fontSize)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrinkCounter(String label, int count, double fontSize, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: fontSize),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  if (count > 0) {
                    onChanged(count - 1);
                  }
                },
              ),
              Text(
                '$count',
                style: TextStyle(fontSize: fontSize),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  onChanged(count + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrinkWithTextField(String label, TextEditingController controller, int count, double fontSize, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: fontSize),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter type',
                  ),
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  if (count > 0) {
                    onChanged(count - 1);
                  }
                },
              ),
              Text(
                '$count',
                style: TextStyle(fontSize: fontSize),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  onChanged(count + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submit(BuildContext context) async {
    List<Map<String, dynamic>> drinks = [
      {'name': 'Milk', 'quantity': _milkCount},
      {'name': 'Butter Milk', 'quantity': _butterMilkCount},
      {'name': _freshJuiceController.text, 'quantity': _freshJuiceCount},
      {'name': _coolDrinksController.text, 'quantity': _coolDrinksCount},
    ];

    final response = await http.put(
      Uri.parse('http://192.168.197.83:3000/api/patients/${widget.username}/foods/Drinks'), // Replace with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'food': {'Drinks': drinks}}), // Pass drinks in the correct format
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

void main() {
  runApp(MaterialApp(
    home: DrinksPage(username: 'test_username'), // Replace with appropriate username
  ));
}
