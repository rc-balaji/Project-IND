import 'package:flutter/material.dart';
import 'nonveg.dart';
import 'veg.dart';
import 'fruits.dart';
import 'spinach.dart';
import 'sprout_nuts.dart';
import 'salt.dart';
import 'baked_items.dart';
import 'drinks.dart';

class FoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double imageSize = screenWidth > 600 ? 150.0 : 100.0; // Adjust image size based on screen width
    double fontSize = screenWidth > 600 ? 18.0 : 16.0; // Adjust font size based on screen width

    return Scaffold(
      appBar: AppBar(
        title: Text('Food Categories'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.grey, Colors.white, Colors.grey],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          GridView.extent(
            maxCrossAxisExtent: screenWidth / 2,
            padding: EdgeInsets.all(0),
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            children: [
              FoodCategoryButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FruitsPage()),
                  );
                },
                imagePath: 'images/fruit.jpg',
                text: 'Fruits',
                imageSize: imageSize,
                fontSize: fontSize,
              ),
              FoodCategoryButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VegetablesPage()),
                  );
                },
                imagePath: 'images/veg.jpg',
                text: 'Vegetables',
                imageSize: imageSize,
                fontSize: fontSize,
              ),
              FoodCategoryButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SproutsNutsPage()),
                  );
                },
                imagePath: 'images/sprouts.jpg',
                text: 'Sprouts & Nuts',
                imageSize: imageSize,
                fontSize: fontSize,
              ),
              FoodCategoryButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpinachPage()),
                  );
                },
                imagePath: 'images/spinach.jpg',
                text: 'Spinach',
                imageSize: imageSize,
                fontSize: fontSize,
              ),
              FoodCategoryButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BakedItemsPage()),
                  );
                },
                imagePath: 'images/baked.jpg',
                text: 'Baked Items',
                imageSize: imageSize,
                fontSize: fontSize,
              ),
              FoodCategoryButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NonVegPage()),
                  );
                },
                imagePath: 'images/nonveg.jpg',
                text: 'Non-Veg',
                imageSize: imageSize,
                fontSize: fontSize,
              ),
              FoodCategoryButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaltPage()),
                  );
                },
                imagePath: 'images/salt.jpg',
                text: 'Salt',
                imageSize: imageSize,
                fontSize: fontSize,
              ),
              FoodCategoryButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DrinksPage()),
                  );
                },
                imagePath: 'images/drinks.jpg',
                text: 'Drinks',
                imageSize: imageSize,
                fontSize: fontSize,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FoodCategoryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagePath;
  final String text;
  final double imageSize;
  final double fontSize;

  const FoodCategoryButton({
    Key? key,
    required this.onPressed,
    required this.imagePath,
    required this.text,
    required this.imageSize,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: imageSize,
              height: imageSize,
            ),
          ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
