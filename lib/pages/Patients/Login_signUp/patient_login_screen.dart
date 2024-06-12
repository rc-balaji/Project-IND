import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(mediaQuery.size.height * 0.015625),
                    ),
                  ),
                  obscureText: true,
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
