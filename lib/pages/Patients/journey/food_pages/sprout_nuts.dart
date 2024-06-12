import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SproutsNutsPage extends StatefulWidget {
  final String username;

  SproutsNutsPage({required this.username});

  @override
  _SproutsNutsPageState createState() => _SproutsNutsPageState();
}

class _SproutsNutsPageState extends State<SproutsNutsPage> {
  List<ItemData> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sprouts and Nuts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddItemDialog(context);
              },
              child: Text('Add Item'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index].name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (items[index].count > 0) {
                              items[index].count--;
                            }
                          });
                        },
                      ),
                      Text(items[index].count.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            items[index].count++;
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

  void _showAddItemDialog(BuildContext context) {
    String newItemName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newItemName = value;
                },
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (newItemName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter item name'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  setState(() {
                    items.add(ItemData(name: newItemName, count: 0));
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
    List<Map<String, dynamic>> itemData = items.map((item) {
      return {'name': item.name, 'count': item.count};
    }).toList();

    final response = await http.put(
      Uri.parse('http://192.168.197.83:3000/api/patients/${widget.username}/foods/Sprouts_and_Nuts'), // Replace with your actual API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'food': {'Sprouts_and_Nuts': itemData}}),
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

class ItemData {
  String name;
  int count;

  ItemData({required this.name, required this.count});
}
