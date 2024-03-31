import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hci/timerPage.dart';
import 'package:hci/model/Task.dart';
import 'package:hci/util.dart';

class TaskDetails extends StatelessWidget {
  final Task task;
  const TaskDetails({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Details')),
      body: WorkoutScreen(task: task,),
    );
  }
}

class WorkoutScreen extends StatelessWidget {
  final Task task;
  const WorkoutScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0),
            child: Text(
              capitalize(task.title),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            textAlign: TextAlign.right,
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Details:'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height : 15.0),
                  Text(task.description)
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TimerPage())
                );
              },
              child: const Text('Focus Mode'),
            ),
          ),
        ],
      );
  }
}
