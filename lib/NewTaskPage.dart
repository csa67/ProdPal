import 'package:flutter/material.dart';
import 'package:hci/DurationPicker.dart';
import 'package:hci/timerPage.dart';

class NewTaskPage extends StatelessWidget{
  const NewTaskPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: const Task(),
        persistentFooterButtons: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                // Define the action when the button is pressed
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TimerPage()),);
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

  void _onApplyButtonPressed() {
    setState(() {
      isDateTileExpanded = false;
      selectedDate = currentDate;
    });
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
  Widget build(BuildContext context){
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        const TextField(
          decoration: InputDecoration(
            labelText: 'Title',
            contentPadding: EdgeInsets.all(8),
            border: OutlineInputBorder(),
          ),
            style: TextStyle(fontSize: 24),
            minLines: 2,
            maxLines: 3,
        ),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Description',
            hintStyle: TextStyle(fontSize:16,fontWeight:FontWeight.bold),
            contentPadding: EdgeInsets.all(8),
            border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 16),
            minLines: 4,
            maxLines: 6,
          ),
        ListTile(
          title: Text(selectedDate == null ? 'Date' : 'Date:  ${'${selectedDate!.toLocal()}'.split(' ')[0]}'),
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
        ExpansionTile(
          title: const Text('Repeat'),
          leading: const Icon(Icons.repeat),
          children: <Widget>[
              RadioListTile(
                  title: const Text('Never'),
                  value: 1,
                  groupValue: _selectedValue,
                  onChanged: (value){
                    setState(() {
                      _selectedValue = value!;
                    });
                  }
              ),
            RadioListTile(
                title: const Text('Daily'),
                value: 2,
                groupValue: _selectedValue,
                onChanged: (value){
                  setState(() {
                    _selectedValue = value!;
                  });
                }
            ),
            RadioListTile(
                title: const Text('Weekdays'),
                value: 3,
                groupValue: _selectedValue,
                onChanged: (value){
                  setState(() {
                    _selectedValue = value!;
                  });
                }
            ),
            RadioListTile(
                title: const Text('Weekend'),
                value: 4,
                groupValue: _selectedValue,
                onChanged: (value){
                  setState(() {
                    _selectedValue = value!;
                  });
                }
            ),
            RadioListTile(
                title: const Text('Weekly'),
                value: 5,
                groupValue: _selectedValue,
                onChanged: (value){
                  setState(() {
                    _selectedValue = value!;
                  });
                }
            ),
            RadioListTile(
                title: const Text('Monthly'),
                value: 6,
                groupValue: _selectedValue,
                onChanged: (value){
                  setState(() {
                    _selectedValue = value!;
                  });
                }
            ),
            RadioListTile(
                title: const Text('Custom'),
                value: 7,
                groupValue: _selectedValue,
                onChanged: (value){
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
      ],
    );
  }

  void _showDurationPicker() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick a duration"),
          content: SizedBox(
            height: 400, // Adjust as needed
            child: DurationPicker(
              onDurationSelected: (int hour, int minute) {
                // Update the state of your parent widget here
                Navigator.pop(context); // Close the dialog
              },
            ),
          ),
        );
      },
    );
  }
}