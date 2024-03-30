import 'package:flutter/material.dart';

class TimeSelectionTile extends StatefulWidget {
  @override
  _TimeSelectionTileState createState() => _TimeSelectionTileState();
}

class _TimeSelectionTileState extends State<TimeSelectionTile> {
  TimeOfDay? _fromTime;
  TimeOfDay? _tillTime;

  Future<void> _selectFromTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _fromTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _fromTime)
      setState(() {
        _fromTime = picked;
      });
  }

  Future<void> _selectTillTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _tillTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _tillTime)
      setState(() {
        _tillTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          ExpansionTile(
            title: Text('Time'),
            leading: const Icon(Icons.alarm),
            children: [
              ListTile(
                title: Text(_fromTime != null
                    ? 'From: ${_fromTime!.format(context)}'
                    : 'Choose From Time'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _selectFromTime(context),
                ),
              ),
              if (_fromTime != null)
                ListTile(
                  title: Text(_tillTime != null
                      ? 'Till: ${_tillTime!.format(context)}'
                      : 'Choose Till Time'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _selectTillTime(context),
                  ),
                ),
            ],
          ),
        ],
      );
  }
}

class PrioritySelectionTile extends StatefulWidget {
  const PrioritySelectionTile({super.key});

  @override
  _PrioritySelectionTileState createState() => _PrioritySelectionTileState();
}

class _PrioritySelectionTileState extends State<PrioritySelectionTile> {
  List<bool> _selections = [true, false, false];
  bool vertical = false;
  static const List<Widget> priorityLevels = <Widget>[
    Text('Low'),
    Text('Medium'),
    Text('High')
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(10),
      child: ToggleButtons(
        direction: vertical ? Axis.vertical : Axis.horizontal,
        onPressed: (int index){
          setState(() {
            for(int i=0; i<_selections.length;i++){
              _selections[i] = i == index;
            }
          });
        },
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        selectedBorderColor: Colors.pink,
        selectedColor: Colors.white,
        fillColor: Colors.pinkAccent,
        color: Colors.pink[10],
        constraints: const BoxConstraints(minHeight: 40.0, minWidth: 100.0),
        isSelected: _selections,
        children: priorityLevels,
      ),
    );
  } // Initial selection for Low

}