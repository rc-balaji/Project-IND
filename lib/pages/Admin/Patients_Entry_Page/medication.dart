import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/pages/Admin/Patients_Entry_Page/medicine_reminder_page.dart';
import '../../../home_page.dart';

class MedicationList extends StatefulWidget {
  @override
  _MedicationListState createState() => _MedicationListState();
  final String patientId;
  MedicationList({required this.patientId});
}

class _MedicationListState extends State<MedicationList> {
  final Map<String, List<MedicationReminder>> medicationReminders = {};

  Future<void> _sendMedicationReminders() async {
    final url = Uri.parse('http://192.168.183.83:3000/api/add-medication-list');
    final List<Map<String, dynamic>> medicationList = medicationReminders.entries.map((entry) {
      return {
        'name': entry.key,
        'start_date': entry.value.first.date.toIso8601String(),
        'end_date': entry.value.last.date.toIso8601String(),
        'times': entry.value.map((reminder) => reminder.time.format(context)).toList(),
      };
    }).toList();

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patient_id': widget.patientId,
        'medication_list': medicationList,
      }),
    );

    if (response.statusCode == 200) {
      print('Medication reminder list sent successfully');
    } else {
      print('Failed to send medication reminder list');
    }
  }

  void _addReminder(String medicationName) async {
    final reminders = await showDialog<List<MedicationReminder>>(
      context: context,
      builder: (BuildContext context) {
        return DateTimePickerDialog(medicationName: medicationName);
      },
    );

    if (reminders != null && reminders.isNotEmpty) {
      setState(() {
        if (!medicationReminders.containsKey(medicationName)) {
          medicationReminders[medicationName] = [];
        }
        medicationReminders[medicationName]!.addAll(reminders);
        _sendMedicationReminders();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication List'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.purpleAccent, Colors.white], // Header gradient from purpleAccent to white
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Calendar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white], // Middle section gradient (same color for now)
              ),
            ),
            child: CalendarWidget(reminders: medicationReminders), // Calendar widget
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Medicine.medications.length,
              itemBuilder: (context, index) {
                final medicationName = Medicine.medications[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _addReminder(medicationName),
                    child: Text(medicationName),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _sendMedicationReminders();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
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

class CalendarWidget extends StatefulWidget {
  final Map<String, List<MedicationReminder>> reminders;

  CalendarWidget({required this.reminders});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white], // Middle section gradient (same color for now)
        ),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarFormat: _calendarFormat,
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableGestures: AvailableGestures.horizontalSwipe,
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          selectedTextStyle: TextStyle(color: Colors.white),
          todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(color: Colors.blue, width: 2),
          ),
          todayTextStyle: TextStyle(color: Colors.black),
        ),
        headerStyle: HeaderStyle(
          formatButtonTextStyle: TextStyle().copyWith(color: Colors.blue, fontSize: 15.0),
          formatButtonDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            return Center(
              child: Text(
                DateFormat.E().format(day).substring(0, 1),
                style: TextStyle(color: Colors.black),
              ),
            );
          },
          markerBuilder: (context, day, events) {
            final reminders = widget.reminders.values.expand((reminderList) => reminderList).toList();
            final todayReminders = reminders.where((reminder) => isSameDay(reminder.date, day)).toList();

            if (todayReminders.isNotEmpty) {
              return Positioned(
                right: 1,
                bottom: 1,
                child: _buildMarkers(todayReminders),
              );
            }

            return Container();
          },
        ),
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
        },
      ),
    );
  }

  Widget _buildMarkers(List<MedicationReminder> reminders) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      width: 16,
      height: 16,
      child: Center(
        child: Text(
          reminders.length.toString(),
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

class MedicationReminder {
  final DateTime date;
  final TimeOfDay time;
  final String medicationName;

  MedicationReminder({
    required this.date,
    required this.time,
    required this.medicationName,
  });
}

class DateTimePickerDialog extends StatefulWidget {
  final String medicationName;

  DateTimePickerDialog({required this.medicationName});

  @override
  _DateTimePickerDialogState createState() => _DateTimePickerDialogState();
}

class _DateTimePickerDialogState extends State<DateTimePickerDialog> {
  late DateTime _startDate;
  late DateTime _endDate;
  List<TimeOfDay> _times = [];
  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, int? index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (index == null) {
          _times.add(picked);
        } else {
          _times[index] = picked;
        }
      });
    }
  }

  void _addTime() {
    _selectTime(context, null);
  }

  void _removeTime(int index) {
    setState(() {
      _times.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Dates and Times'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            ListTile(
              title: Text("Start Date: ${_dateFormat.format(_startDate)}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text("End Date: ${_dateFormat.format(_endDate)}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            ..._times.asMap().entries.map((entry) {
              int index = entry.key;
              TimeOfDay time = entry.value;
              return ListTile(
                title: Text("Time ${index + 1}: ${time.format(context)}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _selectTime(context, index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeTime(index),
                    ),
                  ],
                ),
              );
            }).toList(),
            ElevatedButton(
              onPressed: _addTime,
              child: Text("Add Time"),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final List<MedicationReminder> reminders = [];
            for (DateTime date = _startDate;
            date.isBefore(_endDate) || date.isAtSameMomentAs(_endDate);
            date = date.add(Duration(days: 1))) {
              for (TimeOfDay time in _times) {
                reminders.add(
                  MedicationReminder(
                    date: date,
                    time: time,
                    medicationName: widget.medicationName, // Set medication name here
                  ),
                );
              }
            }
            Navigator.of(context).pop(reminders);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
