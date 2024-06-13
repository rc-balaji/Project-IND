import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Determine screen size
        double screenWidth = constraints.maxWidth;

        return MaterialApp(
          title: 'Suruksha App',
          theme: _buildThemeData(screenWidth),
          // Use SplashScreen as the initial route
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => SplashScreen(),
            '/home': (context) => HomePage(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }

  ThemeData _buildThemeData(double screenWidth) {
    // Define default theme
    ThemeData baseTheme = ThemeData(
      primarySwatch: Colors.blue,
    );

    // Adjust theme based on screen width
    if (screenWidth < 600) {
      // For smaller screens, adjust theme as needed
      return baseTheme.copyWith(
          // Modify theme properties here for smaller screens
          );
    } else {
      // For larger screens, adjust theme as needed
      return baseTheme.copyWith(
          // Modify theme properties here for larger screens
          );
    }
  }
}
