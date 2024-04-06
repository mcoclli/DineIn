import 'package:flutter/material.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/feature/profile_page/model/availability.dart';

class AvailabilityEditor extends StatefulWidget {
  final Map<int, Availability> availability;

  const AvailabilityEditor(
      {super.key, required this.availability, this.updateFunction});

  final void Function()? updateFunction;

  @override
  State<AvailabilityEditor> createState() => _AvailabilityEditorState();
}

class _AvailabilityEditorState extends State<AvailabilityEditor> {
  @override
  Widget build(BuildContext context) {
    List<String> daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    return Padding(
      padding: context.pagePadding,
      child: Column(
        children: daysOfWeek.asMap().entries.map((entry) {
          int index = entry.key;
          String day = entry.value;
          Availability? timeRange = widget.availability[index];
          return ListTile(
            title: Text(day),
            subtitle: Text(
                'Start: ${timeRange?.start?.format(context)} - End: ${timeRange?.end?.format(context)}'),
            onTap: () async {
              await _pickTime(context, index, true).then((value) async {
                await _pickTime(context, index, false).then((value) {
                  if (widget.updateFunction != null) {
                    widget.updateFunction!();
                  }
                });
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, int day, bool isStart) async {
    const startTimeDef = TimeOfDay(hour: 0, minute: 0);
    const endTimeDef = TimeOfDay(hour: 23, minute: 59);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? widget.availability[day]?.start ?? startTimeDef
          : widget.availability[day]?.end ?? endTimeDef,
    );
    if (picked != null) {
      setState(() {
        if (widget.availability.containsKey(day)) {
          widget.availability[day]!.dayOfWeek = day;
          if (isStart) {
            widget.availability[day]!.start = picked;
          } else {
            widget.availability[day]!.end = picked;
          }
        } else {
          widget.availability[day] = Availability(
              start: isStart ? picked : startTimeDef,
              end: isStart ? startTimeDef : picked,
              dayOfWeek: day);
        }
      });
    }
  }
}
