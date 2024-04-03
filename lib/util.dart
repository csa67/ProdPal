import 'package:flutter/material.dart';

int timeOfDayToMinutes(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

TimeOfDay timeFromTask(String time) {
  final timeParts = time.split(':').map(int.parse).toList();
  return TimeOfDay(hour: timeParts[0], minute: timeParts[1]);
}

String formatTimeOfDay(TimeOfDay? time) {
  if(time == null) return '';
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return "$hour:$minute";
}