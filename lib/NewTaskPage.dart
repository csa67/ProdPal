import 'package:flutter/material.dart';
import 'package:hci/database/db.dart';
import 'package:hci/DurationPriority.dart';
import 'package:hci/model/Task.dart' as taskmodel;
import 'package:hci/util.dart';

class NewTaskPage extends StatelessWidget{
  final taskmodel.Task? taskToEdit;
  final VoidCallback? onTaskCreated;

  const NewTaskPage({super.key, this.taskToEdit, this.onTaskCreated});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Task(taskToEdit: taskToEdit, onTaskCreated: onTaskCreated),
    );
  }
}

class Task extends StatefulWidget{
  final taskmodel.Task? taskToEdit;
  final VoidCallback? onTaskCreated;

  const Task({super.key, this.taskToEdit, this.onTaskCreated});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task>{

  DateTime? selectedDate = DateTime.now();
  DateTime? currentDate;
  bool isDateTileExpanded = false;
  late TimeOfDay _startTime = TimeOfDay.now();
  late TimeOfDay _endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
  taskmodel.TaskPriority _selectedPriority = taskmodel.TaskPriority.low;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState(){
    super.initState();
    if(widget.taskToEdit != null){
      _titleController.text = widget.taskToEdit!.title;
      _descriptionController.text = widget.taskToEdit!.description;
      _selectedPriority = widget.taskToEdit!.priority;
      selectedDate = widget.taskToEdit!.date;
      currentDate = widget.taskToEdit!.date;
      _startTime = timeFromTask(formatTimeOfDay(widget.taskToEdit!.startTime));
      _endTime = timeFromTask(formatTimeOfDay(widget.taskToEdit!.endTime));
    }
  }

  void _onApplyButtonPressed() {
    setState(() {
      isDateTileExpanded = false;
      selectedDate = currentDate;
    });
  }

  taskmodel.Task createTaskFromInput() {
    // Ensure all inputs are validated before creating the Task object
    if(widget.taskToEdit!=null){
      return taskmodel.Task(
        id: widget.taskToEdit!.id, // Keep the original task id
        title: _titleController.text,
        description: _descriptionController.text,
        date: selectedDate ?? DateTime.now(),
        startTime: _startTime,
        endTime: _endTime,
        tag: widget.taskToEdit!.tag, // Keep the original tag or update as needed
        priority: _selectedPriority,
        isCompleted: widget.taskToEdit!.isCompleted,
      );
    }else {
      return taskmodel.Task(
        id: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        date: selectedDate ?? DateTime.now(),
        startTime: _startTime,
        endTime: _endTime,
        tag: 'ExampleTag',
        // This should ideally come from user input
        priority: _selectedPriority,
        isCompleted: false,
      );
    }
  }

Widget _buildDatePicker() {
    return Column(
      children: [
       CalendarDatePicker(
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        onDateChanged: (DateTime value) {
          setState(() {
            currentDate = value;
          });
        },
      ),
        ElevatedButton(
          onPressed: _onApplyButtonPressed,
          child: const Text('Apply'),
        ),
      ],
    );
  }

  void clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    selectedDate = null;
    _startTime = TimeOfDay.now();
    _endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
    _selectedPriority = taskmodel.TaskPriority.low;
    isDateTileExpanded = false;
    setState(() {});
  }

  void saveTaskAndNavigateBack(BuildContext context) async {
    try {
      final newTask = createTaskFromInput();
      await DatabaseHelper.instance.insertTask(newTask);
      clearForm();

      if (widget.onTaskCreated != null) {
        widget.onTaskCreated!();
      }

      if (Navigator.canPop(context)) {
          int count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 2;
          });
        }

        // Pops current page off the navigation stack if possible
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Task"),),
      body: ListView(
      padding: const EdgeInsets.all(10),
      children: <Widget>[
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            contentPadding: EdgeInsets.all(8),
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          style: const TextStyle(fontSize: 24),
          minLines: 2,
          maxLines: 3,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            contentPadding: EdgeInsets.all(8),
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          style: const TextStyle(fontSize: 16),
          minLines: 4,
          maxLines: 10,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 20),
        ListTile(
          title: Text(selectedDate == null ? 'Date' : 'Date:  ${'${selectedDate!
              .toLocal()}'.split(' ')[0]}'),
          leading: const Icon(Icons.calendar_today),
          trailing: Icon(
            isDateTileExpanded ? Icons.expand_less : Icons.expand_more,
          ),
          onTap: () {
            setState(() {
              isDateTileExpanded = !isDateTileExpanded;
            });
          },
        ),
        if (isDateTileExpanded) _buildDatePicker(),
        const SizedBox(height: 10),
        TimeSelectionTile(
          onSettingDuration: (startTime, endTime){
            setState(() {
              _startTime = startTime;
              _endTime = endTime;
            });
          }
        ),
        // ExpansionTile(
        //     title: const Text('Repeat'),
        //     leading: const Icon(Icons.repeat),
        //     children: <Widget>[
        //       RadioListTile(
        //           title: const Text('Never'),
        //           value: 1,
        //           groupValue: _selectedValue,
        //           onChanged: (value) {
        //             setState(() {
        //               _selectedValue = value!;
        //             });
        //           }
        //       ),
        //       RadioListTile(
        //           title: const Text('Daily'),
        //           value: 2,
        //           groupValue: _selectedValue,
        //           onChanged: (value) {
        //             setState(() {
        //               _selectedValue = value!;
        //             });
        //           }
        //       ),
        //       RadioListTile(
        //           title: const Text('Weekdays'),
        //           value: 3,
        //           groupValue: _selectedValue,
        //           onChanged: (value) {
        //             setState(() {
        //               _selectedValue = value!;
        //             });
        //           }
        //       ),
        //       RadioListTile(
        //           title: const Text('Weekend'),
        //           value: 4,
        //           groupValue: _selectedValue,
        //           onChanged: (value) {
        //             setState(() {
        //               _selectedValue = value!;
        //             });
        //           }
        //       ),
        //       RadioListTile(
        //           title: const Text('Weekly'),
        //           value: 5,
        //           groupValue: _selectedValue,
        //           onChanged: (value) {
        //             setState(() {
        //               _selectedValue = value!;
        //             });
        //           }
        //       ),
        //       RadioListTile(
        //           title: const Text('Monthly'),
        //           value: 6,
        //           groupValue: _selectedValue,
        //           onChanged: (value) {
        //             setState(() {
        //               _selectedValue = value!;
        //             });
        //           }
        //       ),
        //       RadioListTile(
        //           title: const Text('Custom'),
        //           value: 7,
        //           groupValue: _selectedValue,
        //           onChanged: (value) {
        //             setState(() {
        //               _selectedValue = value!;
        //             });
        //           }
        //       ),
        //       ElevatedButton(
        //         onPressed: _onApplyButtonPressed,
        //         child: const Text('Confirm'),
        //       ),
        //     ]
        // ),
        ExpansionTile(
          title: const Text('Priority'),
          leading: const Icon(Icons.priority_high),
          children: [
            PrioritySelectionTile(
              onPriorityChanged: (priority){
                setState(() {
                  _selectedPriority = priority;
                });
              }
            )
          ],
        ),
      ],
    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:  SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async {
            _addTaskIfNoOverlap();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40), // Ensures the button is square-edged
            ),
            minimumSize: const Size.fromHeight(50), // Set the button's height
          ),
          child: const Text('Add Task'),
        ),
      ),
    );
  }

  DateTime _convertTimeOfDayToDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<taskmodel.Task?> findConflictingTask(TimeOfDay newStartTime, TimeOfDay newEndTime, DateTime newTaskDate) async {
    List<taskmodel.Task> tasksForTheDay = await DatabaseHelper.instance.getTasks(newTaskDate);

    for (var task in tasksForTheDay) {
      final newStart = _convertTimeOfDayToDateTime(newTaskDate, newStartTime);
      final newEnd = _convertTimeOfDayToDateTime(newTaskDate, newEndTime);
      final existingStart = _convertTimeOfDayToDateTime(task.date, task.startTime);
      final existingEnd = _convertTimeOfDayToDateTime(task.date, task.endTime);

      if ((newStart.isAfter(existingStart) && newStart.isBefore(existingEnd)) ||
          (newEnd.isAfter(existingStart) && newEnd.isBefore(existingEnd)) ||
          (newStart.isAtSameMomentAs(existingStart) || newEnd.isAtSameMomentAs(existingEnd))) {
        return task; // Return the conflicting task
      }
    }

    return null; // No conflict found
  }

  Future<void> _addTaskIfNoOverlap() async {
    taskmodel.Task? conflictingTask = await findConflictingTask(_startTime, _endTime, selectedDate!);

    if (conflictingTask != null) {
      // There is a conflicting task, so let's ask the user to confirm
      bool? userChoice = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alert'),
            content: Text('This task conflicts with "${conflictingTask.title}". Are you sure you want to add it?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Continue'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      if (userChoice ?? false) {
        _actuallyAddTask(); // User confirmed they want to add the task
      }
    } else {
      _actuallyAddTask(); // No conflict, proceed to add the task
    }
  }

  void _actuallyAddTask() async {
    saveTaskAndNavigateBack(context);
    if (widget.onTaskCreated != null) {
      widget.onTaskCreated!();
    }
  }
}