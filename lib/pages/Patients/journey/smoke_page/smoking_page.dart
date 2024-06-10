import 'package:flutter/material.dart';
import '../user_details_page.dart'; // Importing the user_details_page.dart to navigate to it
import 'package:video_player/video_player.dart';

class SmokingPage extends StatefulWidget {
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
            onPressed: canSubmit ? _submitForm : null,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    // Handle form submission
    print('Submit button pressed');
    print('Smoked Today: $_smokedToday');
    if (_smokedToday == 'yes') {
      print('Cigarettes Smoked: $_cigarettesSmoked');
    }

    Navigator.pop(context); // Navigate back to the previous page
  }
}
