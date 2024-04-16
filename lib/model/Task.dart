import 'package:flutter/material.dart';

enum TaskPriority { low, medium, high }

enum TaskFilter {
  inProgress("In Progress"),
  completed("Completed");

  final String label;

  const TaskFilter(this.label);
}

class Task {
  String id;
  String title;
  String description;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String tag;
  TaskPriority priority;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.tag,
    this.priority = TaskPriority.low, // Default priority is set to low
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    // Helper functions to format TimeOfDay to a string.
    String formatTimeOfDay(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(), // Convert DateTime to String
      'startTime': formatTimeOfDay(startTime), // Format TimeOfDay to String
      'endTime': formatTimeOfDay(endTime), // Format TimeOfDay to String
      'tag': tag,
      'priority': priority.index, // Convert enum to int
      'isCompleted': isCompleted ? 1 : 0, // Convert bool to int for storage
    };
  }

  // Convert a Map to a Task object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      startTime: _parseTime(map['startTime']),
      endTime: _parseTime(map['endTime']),
      tag: map['tag'],
      priority: TaskPriority.values[map['priority']],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  // Helper method to convert a time string to a TimeOfDay object
  static TimeOfDay _parseTime(String time) {
    final hours = int.parse(time.split(":")[0]);
    final minutes = int.parse(time.split(":")[1]);
    return TimeOfDay(hour: hours, minute: minutes);
  }
}




