import 'package:flutter/material.dart';
import 'dart:async';
import '../user_details_page.dart';

void main() {
  runApp(MaterialApp(
    home: CoolWarmupPage(),
  ));
}

class CoolWarmupPage extends StatefulWidget {
  @override
  _CoolWarmupPageState createState() => _CoolWarmupPageState();
}

class _CoolWarmupPageState extends State<CoolWarmupPage> {
  int _currentImageIndex = -1; // Start with -1 indicating no image is displayed
  bool _isBreak = false; // To indicate if it's currently a break
  bool _showCongrats = false; // To indicate if congrats animation should be shown
  bool _showButton = false; // To indicate if the button should be shown

  List<String> _imagePaths = [
    'images/1.-Forward-fold-1.jpg',
    'images/2.-Seated-one-legged-bend-forward-1.jpg',
    'images/3.-Cat-cow-1.jpg',
    'images/4.-Seated-twist-1.jpg',
    'images/5.-Upward-facing-dog-1.jpg',
    'images/6.-Childs-pose-1.jpg',
    'images/7.-Tricep-stretch-1.jpg',
    'images/8.-Sumo-squat-stretch-1.jpg',
    'images/9.-Pigeon-pose-1.jpg',
  ];

  void _startCool() {
    setState(() {
      _currentImageIndex = 0;
      _isBreak = false;
      _showCongrats = false;
      _showButton = false;
    });
    _showNextImage();
  }

  void _showNextImage() {
    if (_currentImageIndex < _imagePaths.length) {
      Timer(Duration(seconds: 1), () {
        setState(() {
          _isBreak = !_isBreak;
          if (!_isBreak) {
            _currentImageIndex++;
          }
          if (_currentImageIndex >= _imagePaths.length) {
            _showCongrats = true;
          }
        });
        if (_currentImageIndex < _imagePaths.length) {
          _showNextImage();
        }
      });
    }
  }

  void _onAnimationStart() {
    setState(() {
      _showButton = true;
    });
  }

  void _resetState() {
    setState(() {
      _currentImageIndex = -1;
      _isBreak = false;
      _showCongrats = false;
      _showButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth > 600 ? 24.0 : 16.0;
    double fontSize = screenWidth > 600 ? 28.0 : 24.0;
    double buttonFontSize = screenWidth > 600 ? 20.0 : 16.0;
    double bottomNavHeight = screenWidth > 600 ? 120.0 : 100.0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 50.8), // Original height + 2 inches
        child: AppBar(
          title: Text('Cool Warmup Page'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo[900]!,
                  Colors.indigo[500]!,
                  Colors.indigo[100]!,
                  Colors.white
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _currentImageIndex == -1
                    ? ElevatedButton(
                  onPressed: _startCool,
                  child: Text('Start Cool', style: TextStyle(fontSize: buttonFontSize)),
                )
                    : _currentImageIndex < _imagePaths.length
                    ? _isBreak
                    ? BreakScreen(fontSize: fontSize)
                    : Image.asset(_imagePaths[_currentImageIndex])
                    : _showCongrats
                    ? CongratsAnimation(onAnimationStart: _onAnimationStart, fontSize: fontSize)
                    : Container(),
              ),
            ),
            if (_showButton)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsPage(
                          username: 'johndoe', // Replace with actual value
                          name: 'John Doe', // Replace with actual value
                          age: '25', // Replace with actual value
                          gender: 'Male', // Replace with actual value
                          maritalStatus: 'Single', // Replace with actual value
                          smoke: true, // Replace with actual value
                          alcohol: true, // Replace with actual value
                        ),
                      ),
                    );
                    _resetState(); // Reset the state when returning from UserDetailsPage
                  },
                  child: Text('Next', style: TextStyle(fontSize: buttonFontSize)),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: bottomNavHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.indigo],
          ),
        ),
      ),
    );
  }
}

class BreakScreen extends StatelessWidget {
  final double fontSize;

  BreakScreen({required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Take a short break...',
      style: TextStyle(fontSize: fontSize),
    );
  }
}

class CongratsAnimation extends StatefulWidget {
  final VoidCallback onAnimationStart;
  final double fontSize;

  CongratsAnimation({required this.onAnimationStart, required this.fontSize});

  @override
  _CongratsAnimationState createState() => _CongratsAnimationState();
}

class _CongratsAnimationState extends State<CongratsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeOutAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationStart();
      }
    });

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5),
      ),
    );

    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: Text(
              'Congratulations!',
              style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 20),
        FadeTransition(
          opacity: _fadeOutAnimation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconAnimation(),
            ],
          ),
        ),
      ],
    );
  }
}

class IconAnimation extends StatefulWidget {
  @override
  _IconAnimationState createState() => _IconAnimationState();
}

class _IconAnimationState extends State<IconAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Icon(
        Icons.star,
        color: Colors.amber,
        size: 50,
      ),
    );
  }
}
