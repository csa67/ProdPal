import 'package:flutter/material.dart';
import 'package:hci/DurationPicker.dart';
import 'package:intl/intl.dart';

class NewTaskPage extends StatelessWidget{
  const NewTaskPage({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(title: const Text('Task List Page'),),
        body: const Task(),
      ),
    );
  }
}

class Task extends StatefulWidget{
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task>{

  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ) ;
    if(picked != null && picked!= selectedDate ){
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd.MM.yy').format(picked);
      });
    }
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
        TextFormField(
          controller: dateController,
          decoration: InputDecoration(
            labelText: 'Select a day',
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
        ),
        ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Time'),
              Text('$selectedDate.toLocal()}'.split(' ')[0],
              )

      ]
    ),
          leading: Icon(Icons.schedule),
          children: <Widget>[
            ListTile(
              title: Text('Select Time'),
              onTap: () => _showDurationPicker(),
            ),
            ],
        ),
      ]
    );
  }

  Widget _buildTaskOption({required String title,required IconData icon, required VoidCallback onTap}){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
      leading : Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: onTap,
      ),
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