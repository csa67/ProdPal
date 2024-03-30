import 'package:flutter/material.dart';
import 'package:hci/database/db.dart';
import 'package:hci/DurationPriority.dart';
import 'package:hci/model/Task.dart' as taskmodel;

GlobalKey<_TaskState> _taskKey = GlobalKey();

class NewTaskPage extends StatelessWidget{
  const NewTaskPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Task(key: _taskKey),
        persistentFooterButtons: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () async {
                if(_taskKey.currentState!=null){
                  final newTask = _taskKey.currentState!.createTaskFromInput();
                  await DatabaseHelper.instance.insertTask(newTask);
                  Navigator.pop(context);
                }

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
        ],
    );
  }
}

class Task extends StatefulWidget{
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task>{

  DateTime? selectedDate;
  DateTime? currentDate;
  bool isDateTileExpanded = false;
  int _selectedValue = 1;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  taskmodel.TaskPriority _selectedPriority = taskmodel.TaskPriority.low;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _onApplyButtonPressed() {
    setState(() {
      isDateTileExpanded = false;
      selectedDate = currentDate;
    });
  }

  taskmodel.Task createTaskFromInput() {
    // Ensure all inputs are validated before creating the Task object
    return taskmodel.Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      date: selectedDate ?? DateTime.now(),
      startTime: _startTime,
      endTime: _endTime,
      tag: 'ExampleTag', // This should ideally come from user input
      priority: _selectedPriority,
      isCompleted: false,
    );
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

  @override
  Widget build(BuildContext context) {
    return ListView(
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
        ExpansionTile(
            title: const Text('Repeat'),
            leading: const Icon(Icons.repeat),
            children: <Widget>[
              RadioListTile(
                  title: const Text('Never'),
                  value: 1,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                    });
                  }
              ),
              RadioListTile(
                  title: const Text('Daily'),
                  value: 2,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                    });
                  }
              ),
              RadioListTile(
                  title: const Text('Weekdays'),
                  value: 3,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                    });
                  }
              ),
              RadioListTile(
                  title: const Text('Weekend'),
                  value: 4,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                    });
                  }
              ),
              RadioListTile(
                  title: const Text('Weekly'),
                  value: 5,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                    });
                  }
              ),
              RadioListTile(
                  title: const Text('Monthly'),
                  value: 6,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                    });
                  }
              ),
              RadioListTile(
                  title: const Text('Custom'),
                  value: 7,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                    });
                  }
              ),
              ElevatedButton(
                onPressed: _onApplyButtonPressed,
                child: const Text('Confirm'),
              ),
            ]
        ),
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
    );
  }
}