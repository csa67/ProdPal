import 'package:flutter/material.dart';
import 'package:hci/database/db.dart';
import 'package:hci/model/Task.dart';
import 'package:hci/util.dart';
import 'package:hci/TaskDetails.dart';
import 'package:intl/intl.dart';

class CardView extends StatelessWidget {
  const CardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TasksList(),
    );
  }
}

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  late Future<List<Task>> futureTasks;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    futureTasks = DatabaseHelper.instance.getTasks(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((DateFormat('MMMM yyyy')).format(_selectedDate)),
        actions: [
          IconButton(
            icon: const Icon(Icons.pending_actions_sharp),
            onPressed: () {
              //
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2011),
                lastDate: DateTime(2100),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                  futureTasks = DatabaseHelper.instance.getTasks(_selectedDate);
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data != null) {
            final items = snapshot.data!;

            if (items.isNotEmpty) {
              // Assuming 'tasks' is your List<Task>
              items.sort((Task a, Task b) {
                return timeOfDayToMinutes(a.startTime)
                    .compareTo(timeOfDayToMinutes(b.startTime));
              });

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    item: items[index],
                    onTaskCompletion: () {
                      setState(() {
                        items.removeAt(index);
                      });
                    },
                    onTaskDismissal: () {
                      setState(() {
                        items.removeAt(index);
                      });
                    },
                    startTime: items[index].startTime,
                    endTime: items[index].endTime,
                  );
                },
              );
            } else {
              return const Center(child: Text("No tasks found"));
            }
          } else {
            return const Center(child: Text("No tasks found"));
          }
        },
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task item;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final VoidCallback onTaskCompletion;
  final VoidCallback onTaskDismissal;

  const TaskCard({
    super.key,
    required this.item,
    required this.startTime,
    required this.endTime,
    required this.onTaskCompletion,
    required this.onTaskDismissal,
  });

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); // Use the format that suits your needs
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      // Make sure to use a unique key like item's id
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          item.isCompleted = true;
          onTaskCompletion();
        } else if (direction == DismissDirection.endToStart) {
          onTaskDismissal();
        }
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        child: const Icon(Icons.delete_outline),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.check),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _formatTimeOfDay(startTime),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4.0,
                child: InkWell(
                  onTap: () {
                    // Navigator.push to your task details page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskDetails(task: item)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            "${_formatTimeOfDay(startTime)} - ${_formatTimeOfDay(endTime)}"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
