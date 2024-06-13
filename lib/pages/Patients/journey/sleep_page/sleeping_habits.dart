import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SleepingHabitsPage extends StatefulWidget {
  final String username;

  SleepingHabitsPage({required this.username}); // Accept username as a parameter

  @override
  _SleepingHabitsPageState createState() => _SleepingHabitsPageState();
}

class _SleepingHabitsPageState extends State<SleepingHabitsPage> {
  String? _sleepQuality;
  String? _undisturbedSleepHours;
  String? _napDuration;

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('images/videos/sleep.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true); // Set looping to true
        _controller.play(); // Start playing the video
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool _canSubmit() {
    return _sleepQuality != null &&
        _undisturbedSleepHours != null &&
        _napDuration != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleeping Habits'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Video and text overlay
          Stack(
            alignment: Alignment.center,
            children: [
              // Video widget
              _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : Container(),
              // Text overlay

            ],
          ),

          SizedBox(height: 16.0),

          Text('How do you describe your usual sleep?'),
          _buildRadioTile('Disturbed sleep', 'disturbed'),
          _buildRadioTile('Undisturbed sleep', 'undisturbed'),

          SizedBox(height: 16.0),

          Text('How many hours of undisturbed sleep do you have?'),
          _buildRadioTile('2-4 hrs', '2-4 hrs'),
          _buildRadioTile('4-6 hrs', '4-6 hrs'),

          SizedBox(height: 16.0),

          Text('How long do you nap?'),
          _buildRadioTile('More than one hour', '>1 hr'),
          _buildRadioTile('Less than one hour', '<1 hr'),

          SizedBox(height: 32.0),

          Center(
            child: ElevatedButton(
              onPressed: _canSubmit() ? () => _submitForm(widget.username) : null,
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioTile(String title, String value) {
    return RadioListTile(
      title: Text(title),
      value: value,
      groupValue: _getGroupValue(title),
      onChanged: (selectedValue) {
        setState(() {
          _updateGroupValue(title, selectedValue);
        });
      },
    );
  }

  dynamic _getGroupValue(String title) {
    switch (title) {
      case 'Disturbed sleep':
      case 'Undisturbed sleep':
        return _sleepQuality;
      case '2-4 hrs':
      case '4-6 hrs':
        return _undisturbedSleepHours;
      case 'More than one hour':
      case 'Less than one hour':
        return _napDuration;
      default:
        return null;
    }
  }

  void _updateGroupValue(String title, dynamic selectedValue) {
    switch (title) {
      case 'Disturbed sleep':
      case 'Undisturbed sleep':
        _sleepQuality = selectedValue as String?;
        break;
      case '2-4 hrs':
      case '4-6 hrs':
        _undisturbedSleepHours = selectedValue as String?;
        break;
      case 'More than one hour':
      case 'Less than one hour':
        _napDuration = selectedValue as String?;
        break;
    }
  }

  void _submitForm(String username) async {
    // API endpoint URL
    String apiUrl = 'http://192.168.197.83:3000/api/patients/${username}/updateSleepingHabits'; // Replace with your API URL

    // Prepare data to be sent
    Map<String, dynamic> sleepingHabitsData = {
      'status': true, // Assuming you want to send the status as true
      'sleep_quality': _sleepQuality,
      'undisturbed_sleep_hours': _undisturbedSleepHours,
      'nap_duration': _napDuration,
    };

    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse(apiUrl), // Use the username from the widget
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(sleepingHabitsData),
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
