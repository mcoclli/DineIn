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

  bool isWithinAvailability(DateTime dateTime) {
    // Check if the day of week matches
    if ((dateTime.weekday % 7) != (dayOfWeek ?? 0)) {
      // Adjusting for DateTime.weekday where Monday = 1, ..., Sunday = 0
      return false;
    }

    // Convert TimeOfDay to DateTime for comparison
    DateTime startDateTime = DateTime(dateTime.year, dateTime.month,
        dateTime.day, start?.hour ?? 0, start?.minute ?? 0);
    DateTime endDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
        end?.hour ?? 0, end?.minute ?? 0);

    // If the given dateTime is on the same day but before the start time or after the end time, it's not within availability
    if (dateTime.isBefore(startDateTime) || dateTime.isAfter(endDateTime)) {
      return false;
    }

    return true;
  }

  @override
  String toString() {
    return 'Availability{dayOfWeek: $dayOfWeek, start: $start, end: $end}';
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
