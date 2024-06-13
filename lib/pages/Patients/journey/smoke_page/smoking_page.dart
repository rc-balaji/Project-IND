import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode
import '../user_details_page.dart'; // Importing the user_details_page.dart to navigate to it
import 'package:video_player/video_player.dart';

class SmokingPage extends StatefulWidget {
  final String username;

  SmokingPage({required this.username}); // Accept username as a parameter

  @override
  _SmokingPageState createState() => _SmokingPageState();
}

class _SmokingPageState extends State<SmokingPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  String? _smokedToday;
  String? _cigarettesSmoked;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('images/videos/smoke.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get canSubmit {
    if (_smokedToday == 'no') {
      return true;
    } else if (_smokedToday == 'yes' && _cigarettesSmoked != null && _cigarettesSmoked!.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smoking'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          SizedBox(height: 16.0),
          Text('Have you smoked today?'),
          RadioListTile(
            title: Text('Yes'),
            value: 'yes',
            groupValue: _smokedToday,
            onChanged: (value) {
              setState(() {
                _smokedToday = value as String?;
              });
            },
          ),
          RadioListTile(
            title: Text('No'),
            value: 'no',
            groupValue: _smokedToday,
            onChanged: (value) {
              setState(() {
                _smokedToday = value as String?;
                _cigarettesSmoked = null; // Reset cigarettes smoked
              });
            },
          ),
          if (_smokedToday == 'yes') ...[
            SizedBox(height: 16.0),
            Text('How many cigarettes have you smoked?'),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of Cigarettes',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _cigarettesSmoked = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Warning: Avoid smoking.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
          SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: canSubmit ?()=> _submitForm(widget.username) : null,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _submitForm(String username) async {
    // API endpoint URL
     String apiUrl = 'http://192.168.197.83:3000/api/patients/${username}/updateSmokeItems'; // Replace with your API URL

    // Prepare data to be sent
    Map<String, dynamic> smokeData = {
      'consumed_smoke_today': _smokedToday,
      'cigarettes_consumed': _cigarettesSmoked,
    };

    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse(apiUrl), // Use the username from the widget
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(smokeData),
      );

      if (response.statusCode == 200) {
        print('Data submitted successfully');
        Navigator.pop(context); // Navigate back to the previous page
      } else {
        print('Failed to submit data: ${response.statusCode}');
        // Handle the error appropriately
      }
    } catch (error) {
      print('Error submitting data: $error');
      // Handle the error appropriately
    }
  }
}
