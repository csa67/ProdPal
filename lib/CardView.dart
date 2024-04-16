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
  List<DateTime> _weekDays = List.empty();
  TaskFilter _currentFilter = TaskFilter.inProgress;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _weekDays = _generateWeekDays(_selectedDate);
    futureTasks = DatabaseHelper.instance.getTasks(_selectedDate);
  }

  List<DateTime> _generateWeekDays(DateTime date) {
    int currentDay = date.weekday; //1-Monday, 7-Sunday
    int differenceToWeekStart = currentDay - DateTime.monday;
    List<DateTime> weekDays = List.generate(7, (index) {
      return date.subtract(Duration(days: differenceToWeekStart - index));
    });
    return weekDays;
  }

  Widget _buildFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: TaskFilter.values.map((filter) {
        return Expanded(
          flex: 1,
          child: TextButton(
          onPressed: () {
            setState(() {
              _currentFilter = filter;
               futureTasks = _getFilteredTasks(_selectedDate, filter);
            });
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor:
                _currentFilter == filter ? Colors.pinkAccent : Colors.grey[300],
            padding: const EdgeInsets.all(6),
          ),
          child: Text(
            filter.label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color:
                    _currentFilter == filter ? Colors.white : Colors.grey[800]),
          ),
        ),
        );
      }).toList(),
    );
  }

  Future<List<Task>> _getFilteredTasks(DateTime forDate, TaskFilter filter) async{
    if(filter == TaskFilter.inProgress){
      return await DatabaseHelper.instance.getTasks(DateTime.now(), completed: false);
    } else {
      return await DatabaseHelper.instance.getTasks(DateTime.now(), completed: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text((DateFormat('MMMM yyyy')).format(_selectedDate)),
          actions: [
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
                    _weekDays = _generateWeekDays(picked);
                    futureTasks =
                        DatabaseHelper.instance.getTasks(_selectedDate);
                  });
                }
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                  itemCount: _weekDays.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    DateTime weekDay = _weekDays[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = weekDay;
                          futureTasks =
                              DatabaseHelper.instance.getTasks(_selectedDate);
                        });
                      },
                      child: DateCard(
                        date: weekDay,
                        isSelected: _selectedDate == weekDay,
                      ),
                    );
                  }),
            ),
            _buildFilterButtons(),
            Expanded(
              child: FutureBuilder<List<Task>>(
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
                            onTaskUndo: (){
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
            ),
          ],
        ));
  }
}

class TaskCard extends StatelessWidget {
  final Task item;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final VoidCallback onTaskCompletion;
  final VoidCallback onTaskDismissal;
  final VoidCallback onTaskUndo;

  const TaskCard({
    super.key,
    required this.item,
    required this.startTime,
    required this.endTime,
    required this.onTaskCompletion,
    required this.onTaskDismissal,
    required this.onTaskUndo,
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
      direction: DismissDirection.horizontal,
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart && item.isCompleted) {
          try {
            await DatabaseHelper.instance.updateTaskCompletion(item.id, false);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Task moved to in progress!'),
              duration: Duration(seconds: 2),
            ));
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to update task! Error: $e'),
              duration: const Duration(seconds: 2),
            ));
          }
          onTaskUndo();
        } else if (direction == DismissDirection.endToStart && !item.isCompleted) {
          try {
            await DatabaseHelper.instance.updateTaskCompletion(item.id, true);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Task marked as Done!'),
              duration: Duration(seconds: 2),
            ));
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to update task! Error: $e'),
              duration: const Duration(seconds: 2),
            ));
          }
          onTaskCompletion();
        } else {
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
        color: item.isCompleted ? Colors.blue : Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(item.isCompleted ? Icons.undo : Icons.check),
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

class DateCard extends StatelessWidget {
  final DateTime date;
  final bool isSelected;

  const DateCard({
    super.key,
    required this.date,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        color: isSelected ? Colors.pinkAccent : Colors.grey,
        borderRadius: BorderRadius.circular(10),
        border: isToday(date)
            ? Border.all(
                style: BorderStyle.solid, width: 4, color: Colors.pink.shade200)
            : null,
      ),
      child: Center(
        child: Text(
          DateFormat('E\nd').format(date),
          textAlign: TextAlign.center,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
