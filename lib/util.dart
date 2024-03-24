import 'package:flutter/material.dart';

String _formatTimeOfDay(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return "$hour:$minute";
}

int timeOfDayToMinutes(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}