import 'package:flutter/material.dart';
import 'package:hci/database/db.dart';
import 'package:hci/model/Task.dart';
import 'package:hci/util.dart';
import 'package:hci/TaskDetails.dart';
import 'package:intl/intl.dart';

class CardView extends StatelessWidget{
  const CardView({super.key});

  @override
  Widget build(BuildContext context){
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
  void initState(){
    super.initState();
    _selectedDate = DateTime.now();
    futureTasks = DatabaseHelper.instance.getTasks();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Task>>(
      future: futureTasks,
      builder: (context, snapshot)
      {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data != null) {
          final items = snapshot.data!;

          // Assuming 'tasks' is your List<Task>
          items.sort((Task a, Task b) {
            return timeOfDayToMinutes(a.startTime).compareTo(
                timeOfDayToMinutes(b.startTime));
          });

          return Scaffold(
              appBar: AppBar(
                title: Text((DateFormat('MMMM yyyy')).format(_selectedDate)),
                actions: [
                  IconButton(icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2011),
                        lastDate: DateTime(2100),
                      );
                      if(picked!=null && picked!= _selectedDate){
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              body: ListView.builder(
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
                    }, startTime: items[index].startTime,);
                },));
        } else {
          return const Center(child: Text("No tasks found"));
        }
      },
    );
  }

}

class TaskCard extends StatelessWidget {
  final Task item;
  final TimeOfDay startTime;
  final VoidCallback onTaskCompletion;
  final VoidCallback onTaskDismissal;

  const TaskCard({
    super.key,
    required this.item,
    required this.startTime,
    required this.onTaskCompletion,
    required this.onTaskDismissal,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.title),
      direction: DismissDirection.horizontal,
      secondaryBackground: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.done_outlined),
      ),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        child: const Icon(Icons.archive_outlined),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          item.isCompleted = true;
          onTaskCompletion();
        } else if (direction == DismissDirection.endToStart) {
          onTaskDismissal();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 4.0,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskDetails(task: item,)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(item.title),
            ),
          ),
        ),
      ),
    );
  }
}