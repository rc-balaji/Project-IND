import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SleepingHabitsPage extends StatefulWidget {
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
              onPressed: _canSubmit() ? () => _submitForm(context) : null,
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

  bool _canSubmit() {
    return _sleepQuality != null &&
        _undisturbedSleepHours != null &&
        _napDuration != null;
  }

  void _submitForm(BuildContext context) {
    // Handle form submission
    print('Sleep quality: $_sleepQuality');
    print('Undisturbed sleep hours: $_undisturbedSleepHours');
    print('Nap duration: $_napDuration');
    // Add your logic here for handling the form submission

    // Navigate back to UserDetailsPage
    Navigator.pop(context);
  }
}