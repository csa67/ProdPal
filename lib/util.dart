import 'package:flutter/material.dart';

String _formatTimeOfDay(TimeOfDay? time) {
  if(time == null) return '';
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return "$hour:$minute";
}

int timeOfDayToMinutes(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);