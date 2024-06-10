import 'package:flutter/material.dart';
import 'food_page.dart';  // Import the FoodPage class

class DrinksPage extends StatefulWidget {
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
    double screenHeight = MediaQuery.of(context).size.height;
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
              onPressed: _submit,
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

  void _submit() {
    // Implement your submission logic here
    print('Milk (glass): $_milkCount');
    print('Butter Milk (glass): $_butterMilkCount');
    print('Fresh Juice: ${_freshJuiceController.text}, Glasses: $_freshJuiceCount');
    print('Cool Drinks: ${_coolDrinksController.text}, Glasses: $_coolDrinksCount');

    // For demonstration, just show a Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Submitted successfully!'),
      ),
    );

    // Navigate back to FoodPage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => FoodPage()),
          (Route<dynamic> route) => false,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DrinksPage(),
  ));
}
