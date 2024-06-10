import 'package:flutter/material.dart';
import 'medication.dart'; // Import MedicationList from medication.dart

class Medicine extends StatelessWidget {
  // Define a global list to store medications
  static List<String> medications = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Management',
      home: MainDashboard(),
    );
  }
}

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Clear the search query when the screen is initialized
    _searchController.clear();
  }

  void navigateToMedicationList(BuildContext context) {
    String searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      // Add the new medication to the global list
      Medicine.medications.add(searchQuery);
      // Clear the search query after adding
      _searchController.clear();
      // Navigate to MedicationList
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MedicationList()),
      );
    } else {
      // Show an alert dialog if the search query is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter a medication name.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.purpleAccent, Colors.white], // Header gradient from purpleAccent to white
            ),
          ),
          child: AppBar(
            title: Text('Main Dashboard'),
            backgroundColor: Colors.transparent, // Set app bar color to transparent
            elevation: 0, // Remove app bar elevation
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white], // Middle section gradient (same color for now)
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Medication Name:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search medication...',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) {
                  navigateToMedicationList(context);
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  navigateToMedicationList(context);
                },
                child: Text('Go to Medication List'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.purpleAccent], // Footer gradient from white to purpleAccent
          ),
        ),
        height: 100.0,
        width: double.infinity,
      ),
    );
  }
}
