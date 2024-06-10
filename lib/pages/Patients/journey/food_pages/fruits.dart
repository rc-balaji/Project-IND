import 'package:flutter/material.dart';

class FruitsPage extends StatefulWidget {
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
                            fruits[index].count--;
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

  void _submit(BuildContext context) {
    // Logic to submit data
    Navigator.pop(context); // Navigate back to food_page.dart
  }
}

class FruitData {
  String name;
  int count;

  FruitData({required this.name, required this.count});
}
