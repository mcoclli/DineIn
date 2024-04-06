import 'package:flutter/material.dart';

class Availability {
  int? dayOfWeek;
  TimeOfDay? start;
  TimeOfDay? end;

  Availability({
    this.dayOfWeek,
    this.start,
    this.end,
  });

  // Using a string format for TimeOfDay (HH:mm)
  factory Availability.fromMap(Map<String, dynamic> map) {
    return Availability(
      dayOfWeek: map['dayOfWeek'],
      start: _fromMapToTimeOfDay(map['start']),
      end: _fromMapToTimeOfDay(map['end']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dayOfWeek': dayOfWeek,
      'start': _fromTimeOfDayToMap(start),
      'end': _fromTimeOfDayToMap(end),
    };
  }

  // Helper method to convert a TimeOfDay to a map format
  static String? _fromTimeOfDayToMap(TimeOfDay? time) {
    if (time == null) return null;
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  // Helper method to convert a map format to a TimeOfDay
  static TimeOfDay? _fromMapToTimeOfDay(String? timeString) {
    if (timeString == null) return null;
    final parts = timeString.split(':');
    if (parts.length != 2) return null;
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
