import 'package:flutter/material.dart';

class Week1Page extends StatelessWidget {
  final String message;

  Week1Page({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 50.8), // Original height + 2 inch
        child: AppBar(
          title: Text('Week 1 Exercise'),
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
      body: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 24, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
      bottomNavigationBar: Container(
        height: 100.0,
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
