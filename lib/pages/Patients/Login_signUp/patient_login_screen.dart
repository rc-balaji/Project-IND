import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import '../journey/user_details_page.dart';
import 'sign_up_page.dart';

class PatientLoginScreen extends StatefulWidget {
  @override
  _PatientLoginScreenState createState() => _PatientLoginScreenState();
}

class _PatientLoginScreenState extends State<PatientLoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _showPassword = false; // State variable to toggle password visibility
  String? _recentUsername; // Variable to store recent username
  String? _recentPassword; // Variable to store recent password

  @override
  void initState() {
    super.initState();
    _loadRecentCredentials(); // Load recent username and password when the widget initializes
  }

  void _loadRecentCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentUsername = prefs.getString('recent_username');
      _recentPassword = prefs.getString('recent_password');
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + mediaQuery.size.height * 0.03125),
        child: AppBar(
          title: Text('Patient Login'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo[900]!,
                  Colors.indigo[500]!,
                  Colors.indigo[100]!,
                  Colors.white,
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(mediaQuery.size.height * 0.025),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: mediaQuery.size.width * 0.8,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(mediaQuery.size.height * 0.015625),
                    ),
                  ),
                  // Show recent username if available
                  // initialValue: _recentUsername,
                  // Use controller to set the initial value
                  // Only set the initial value if it's not null
                  // If _recentUsername is null, it will not affect the TextField
                  // If _recentUsername has a value, it will be set as the initial value
                  // Otherwise, it will remain empty
                  onChanged: (value) => _recentUsername = value.isEmpty ? null : value,
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.025),
              Container(
                width: mediaQuery.size.width * 0.8,
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(mediaQuery.size.height * 0.015625),
                    ),
                  ),
                  obscureText: !_showPassword,
                  // Show recent password if available
                  // initialValue: _recentPassword,
                  // Use controller to set the initial value
                  // Only set the initial value if it's not null
                  // If _recentPassword is null, it will not affect the TextField
                  // If _recentPassword has a value, it will be set as the initial value
                  // Otherwise, it will remain empty
                  onChanged: (value) => _recentPassword = value.isEmpty ? null : value,
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.025),
              Container(
                width: mediaQuery.size.width * 0.8,
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.0125),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: mediaQuery.size.height * 0.025),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _forgotPassword,
                    child: Text('Forgot Password?'),
                    style: TextButton.styleFrom(foregroundColor: Colors.indigo[700]),
                  ),
                  Text('|', style: TextStyle(color: Colors.black)),
                  TextButton(
                    onPressed: _signUp,
                    child: Text('Sign Up'),
                    style: TextButton.styleFrom(foregroundColor: Colors.indigo[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: mediaQuery.size.height * 0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.indigo[100]!,
              Colors.indigo[500]!,
              Colors.indigo[900]!,
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final response = await http.post(
      Uri.parse('http://192.168.197.83:3000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Store recent username and password if login is successful
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('recent_username', username);
      await prefs.setString('recent_password', password);

      final userData = jsonDecode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailsPage(
            username: userData['username'],
            name: userData['name'],
            age: userData['age'],
            gender: userData['gender'],
            maritalStatus: userData['maritalStatus'],
            alcohol: userData['alcohol'],
            smoke: userData['smoke'],
          ),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Wrong username or password.';
      });
    }
  }

  void _forgotPassword() {
    print('Forgot Password');
  }

  void _signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }
}
