import 'package:flutter/material.dart';

class VegetablesPage extends StatefulWidget {
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
                            vegetables[index].count--;
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

  void _submit(BuildContext context) {
    // Logic to submit data
    Navigator.pop(context); // Navigate back to food_page.dart
  }
}

class VegetableData {
  String name;
  int count;

  VegetableData({required this.name, required this.count});
}