import 'package:flutter/material.dart';

class NonVegPage extends StatefulWidget {
  @override
  _NonVegPageState createState() => _NonVegPageState();
}

class _NonVegPageState extends State<NonVegPage> {
  List<NonVegItem> nonVegItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Non-veg'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Selected Items:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: nonVegItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(nonVegItems[index].name),
                  trailing: nonVegItems[index].isByPiece
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (nonVegItems[index].count > 0) {
                              nonVegItems[index].count--;
                            }
                          });
                        },
                      ),
                      Text(nonVegItems[index].count.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            nonVegItems[index].count++;
                          });
                        },
                      ),
                    ],
                  )
                      : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'grams',
                          ),
                          onChanged: (value) {
                            setState(() {
                              nonVegItems[index].count = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Add Items:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                NonVegButton(
                  imagePath: 'images/egg.jpg',
                  itemName: 'Egg',
                  onPressed: () {
                    _addItem('Egg', true);
                  },
                ),
                NonVegButton(
                  imagePath: 'images/chicken.jpg',
                  itemName: 'Chicken',
                  onPressed: () {
                    _addItem('Chicken', false);
                  },
                ),
                NonVegButton(
                  imagePath: 'images/pork.jpg',
                  itemName: 'Pork',
                  onPressed: () {
                    _addItem('Pork', false);
                  },
                ),
                NonVegButton(
                  imagePath: 'images/beef.jpg',
                  itemName: 'Beef',
                  onPressed: () {
                    _addItem('Beef', false);
                  },
                ),
                NonVegButton(
                  imagePath: 'images/squid.jpg',
                  itemName: 'Squid',
                  onPressed: () {
                    _addItem('Squid', false);
                  },
                ),
                NonVegButton(
                  imagePath: 'images/fish.jpg',
                  itemName: 'Fish',
                  onPressed: () {
                    _addItem('Fish', false);
                  },
                ),
                NonVegButton(
                  imagePath: 'images/crabs.jpg',
                  itemName: 'Crabs',
                  onPressed: () {
                    _addItem('Crabs', false);
                  },
                ),
                NonVegButton(
                  imagePath: 'images/mutton.jpg',
                  itemName: 'Mutton',
                  onPressed: () {
                    _addItem('Mutton', false);
                  },
                ),
                NonVegButton(
                  imagePath: 'images/prawn.jpg',
                  itemName: 'Prawn',
                  onPressed: () {
                    _addItem('Prawn', false);
                  },
                ),
                NonVegButton(
                  imagePath: null,
                  itemName: 'Others',
                  onPressed: () {
                    _addOthers();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  _submit(context);
                },
                child: Text('Submit'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addItem(String itemName, bool isByPiece) {
    setState(() {
      var item = nonVegItems.firstWhere(
            (element) => element.name == itemName,
        orElse: () => NonVegItem(name: itemName, count: 0, isByPiece: isByPiece),
      );
      if (!nonVegItems.contains(item)) {
        nonVegItems.add(item);
      }
      if (isByPiece) {
        item.count++;
      }
    });
  }

  void _addOthers() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newItemName = '';
        return AlertDialog(
          title: Text('Add Other Item'),
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
                if (newItemName.isNotEmpty) {
                  _addItem(newItemName, false);
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _submit(BuildContext context) {
    // Implement your submit logic here.
    Navigator.pop(context); // Navigate back to the previous page (food page)
  }
}

class NonVegItem {
  final String name;
  int count;
  final bool isByPiece;

  NonVegItem({required this.name, this.count = 0, this.isByPiece = false});
}

class NonVegButton extends StatelessWidget {
  final String? imagePath;
  final String itemName;
  final VoidCallback onPressed;

  const NonVegButton({
    Key? key,
    required this.itemName,
    required this.onPressed,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black),
            ),
            child: imagePath != null
                ? ClipOval(
              child: Image.asset(
                imagePath!,
                fit: BoxFit.cover,
              ),
            )
                : Icon(Icons.add),
          ),
          SizedBox(height: 5),
          Text(
            itemName,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}