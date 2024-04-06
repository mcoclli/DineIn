import 'package:flutter/material.dart';

class SelectDayAndTime extends StatefulWidget {
  @override
  _SelectDayAndTimeState createState() => _SelectDayAndTimeState();
}

class _SelectDayAndTimeState extends State<SelectDayAndTime> {
  String? _selectedDay;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final List<String> _daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  void _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showSelectDayAndTimeSheet(context),
      child: Text('Select Day & Time'),
    );
  }

  void _showSelectDayAndTimeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _daysOfWeek.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(_daysOfWeek[index]),
                      onTap: () => setState(() {
                        _selectedDay = _daysOfWeek[index];
                        Navigator.pop(context);
                      }),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context, true),
                child: Text('Select Start Time'),
              ),
              if (_startTime != null)
                Text('Start Time: ${_startTime!.format(context)}'),
              ElevatedButton(
                onPressed: () => _selectTime(context, false),
                child: Text('Select End Time'),
              ),
              if (_endTime != null)
                Text('End Time: ${_endTime!.format(context)}'),
            ],
          ),
        );
      },
    ).then((value) {
      // Optionally do something after the bottom sheet is closed
      // For example, you could show a summary or confirmation dialog
      if (_selectedDay != null && _startTime != null && _endTime != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Selection Summary'),
              content: Text('Day: $_selectedDay\nStart Time: ${_startTime!.format(context)}\nEnd Time: ${_endTime!.format(context)}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }
}