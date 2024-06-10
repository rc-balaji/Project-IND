import 'package:flutter/material.dart';
import 'image_display_page.dart'; // Import the image_display_page.dart file

class WarmUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth > 600 ? 24.0 : 16.0;
    double fontSize = screenWidth > 600 ? 28.0 : 24.0;
    double buttonFontSize = screenWidth > 600 ? 20.0 : 16.0;
    double bottomNavHeight = screenWidth > 600 ? 120.0 : 100.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Warm Up Page'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.indigo,
                Colors.white,
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.indigo,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Exercise is a celebration of what your body can do, not a punishment for what you ate.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImageDisplayPage()),
                  );
                },
                child: Text('Start Warm Up', style: TextStyle(fontSize: buttonFontSize)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: bottomNavHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.indigo,
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WarmUpPage(),
  ));
}
