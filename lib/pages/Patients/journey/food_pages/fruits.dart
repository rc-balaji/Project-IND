import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FruitsPage extends StatefulWidget {
  final String username;

  FruitsPage({required this.username});

  @override
  _FruitsPageState createState() => _FruitsPageState();
}

class _FruitsPageState extends State<FruitsPage> {
  List<FruitData> fruits = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.02; // 2% of screen width for padding
    double fontSize = screenWidth > 600 ? 18.0 : 16.0; // Adjust font size based on screen width
    double buttonHeight = screenHeight * 0.07; // 7% of screen height for button height

    return Scaffold(
      appBar: AppBar(
        title: Text('Fruits'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(padding),
            child: ElevatedButton(
              onPressed: () {
                _showAddFruitDialog(context);
              },
              child: Text('Add Fruits'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, buttonHeight), // Full width button
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: fruits.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    fruits[index].name,
                    style: TextStyle(fontSize: fontSize),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (fruits[index].count > 0) {
                              fruits[index].count--;
                            }
                          });
                        },
                      ),
                      Text(
                        fruits[index].count.toString(),
                        style: TextStyle(fontSize: fontSize),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            fruits[index].count++;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: ElevatedButton(
              onPressed: () {
                _submit(context);
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, buttonHeight), // Full width button
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddFruitDialog(BuildContext context) {
    String newFruitName = '';
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.05; // 5% of screen width for padding

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Fruit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newFruitName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Fruit Name',
                  contentPadding: EdgeInsets.symmetric(horizontal: padding),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (newFruitName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter fruit name'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  setState(() {
                    fruits.add(FruitData(name: newFruitName, count: 0));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _submit(BuildContext context) async {
    List<Map<String, dynamic>> fruitsData = [];

    for (var fruit in fruits) {
      fruitsData.add({'name': fruit.name, 'quantity': fruit.count});
    }

    final response = await http.put(
      Uri.parse('http://192.168.197.83:3000/api/patients/${widget.username}/foods/Fruits'), // Replace with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'food': {'Fruits': fruitsData}}), // Pass fruits in the correct format
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submitted successfully!'),
        ),
      );

      // Navigate back to FoodPage
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit!'),
        ),
      );
    }
  }
}

class FruitData {
  String name;
  int count;

  FruitData({required this.name, required this.count});
}

