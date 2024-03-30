import 'package:flutter/material.dart';
import 'package:hci/timerPage.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout App',
      home: WorkoutScreen(),
    );
  }
}

class WorkoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Implement delete action
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text('Details:'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('1. 10 Pushups'),
                  Text('2. 5 min planks'),
                  Text('3. 20 min run'),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TimerPage())
                );
              },
              child: Text('Focus Mode'),
            ),
          ),
        ],
      ),
    );
  }
}
