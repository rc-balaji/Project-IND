import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VegetablesPage extends StatefulWidget {
  final String username;

  VegetablesPage({required this.username});

  @override
  _VegetablesPageState createState() => _VegetablesPageState();
}

class _VegetablesPageState extends State<VegetablesPage> {
  List<VegetableData> vegetables = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vegetables'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddVegetableDialog(context);
              },
              child: Text('Add Vegetables'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vegetables.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(vegetables[index].name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (vegetables[index].count > 0) {
                              vegetables[index].count--;
                            }
                          });
                        },
                      ),
                      Text(vegetables[index].count.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            vegetables[index].count++;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _submit(context);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showAddVegetableDialog(BuildContext context) {
    String newVegetableName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Vegetable'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newVegetableName = value;
                },
                decoration: InputDecoration(labelText: 'Vegetable Name'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (newVegetableName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter vegetable name'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  setState(() {
                    vegetables.add(VegetableData(name: newVegetableName, count: 0));
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
    List<Map<String, dynamic>> vegetableData = vegetables.map((vegetable) {
      return {'name': vegetable.name, 'count': vegetable.count};
    }).toList();

    final response = await http.put(
      Uri.parse('http://192.168.197.83:3000/api/patients/${widget.username}/foods/Vegetables'), // Replace with your actual API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'food': {'Vegetables': vegetableData}}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submitted successfully!'),
        ),
      );
      Navigator.pop(context); // Navigate back to the previous page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit!'),
        ),
      );
    }
  }
}

class VegetableData {
  String name;
  int count;

  VegetableData({required this.name, required this.count});
}
