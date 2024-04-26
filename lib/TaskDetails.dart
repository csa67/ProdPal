import 'package:flutter/material.dart';
import 'package:hci/NewTaskPage.dart' as newTask;
import 'package:hci/model/Task.dart';
import 'package:hci/timerPage.dart';
import 'package:hci/util.dart';
import 'package:intl/intl.dart';


class TaskDetails extends StatelessWidget {
  final Task task;

  const TaskDetails({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: steelBlue,
        title: const Text('Task Details',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to the NewTaskPage and pass the current task to it
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => newTask.NewTaskPage(
                      taskToEdit:
                          task), // Modify NewTaskPage to accept a Task parameter
                ),
              );
            },
          ),
        ],
      ),
      body: WorkoutScreen(
        task: task,
      ),
    );
  }
}

class WorkoutScreen extends StatelessWidget {
  final Task task;

  const WorkoutScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Text(
            capitalize(task.title),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22, // Increased font size
              color: steelBlue, // Changed font color
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 300,
          child: Card(
            color: Colors.lightBlue[100],
            child: ListTile(
              title: const Text('Details:',
    style: TextStyle(// Changed title color in ListTile
    fontWeight: FontWeight.bold, // Increased title font weight
    ),
    ),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 15.0),
                    Text(task.description)
                  ]),
            ),
          ),
        ),
      ],
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: Padding(
      padding: const EdgeInsets.all(16.0),
      // Add some padding around the button
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cornflowerBlue,
          minimumSize: const Size.fromHeight(50), // Set the button's height
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(40), // If you want rounded corners
          ),
        ),
        onPressed: () {
          // Handle the button tap
          Duration duration = calculateDuration(
            DateFormat('yyyy-MM-dd').format(task.date),
            task.startTime,
            task.endTime,
          );

          // Push the TimerPage onto the navigation stack and pass the duration
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TimerPage(time: duration)),
          );
        },
        child: const Text(
          'Focus Mode',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white), // Optional: Set your TextStyle
        ),
      ),
    ),);
  }
}
