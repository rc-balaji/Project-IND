import 'package:flutter/material.dart';
import 'admin_details_entry_page.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _warning = '';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1, // 10% of screen width
              vertical: screenHeight * 0.05, // 5% of screen height
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Username TextFormField
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Username',
                    labelText: 'Username',
                  ),
                  style: TextStyle(fontSize: screenWidth * 0.04), // Adjust text size
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height

                // Password TextFormField
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  style: TextStyle(fontSize: screenWidth * 0.04), // Adjust text size
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height

                // Login Button
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: screenWidth * 0.045), // Adjust button text size
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // 1% of screen height

                // Warning Text
                Text(
                  _warning,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: screenWidth * 0.04, // Adjust warning text size
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    // Mock login logic (Replace with your actual login logic)
    if (_usernameController.text == 'admin' && _passwordController.text == 'admin') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminDetailsEntryPage()),
      );
    } else {
      setState(() {
        _warning = 'Incorrect username or password';
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}