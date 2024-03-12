import 'package:flutter/material.dart';

class DurationPicker extends StatefulWidget {
  final Function(int hour, int minute) onDurationSelected;

  const DurationPicker({Key? key, required this.onDurationSelected}) : super(key: key);

  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  int selectedHour = 0;
  int selectedMinute = 0;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        height: 200,
        width: 100,
        child: ListView.builder(
          itemCount: 24, //24 hours
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                '$index',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: selectedHour == index ? Colors.blue : Colors.black,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedHour = index;
                });
                widget.onDurationSelected(selectedHour, selectedMinute);
              },
            );
          },
        ),
      ),

      const Text(':',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      //Minutes
      Container(
        height: 200,
        width: 100,
        child: ListView.builder(
          itemCount: 60, //60 hours
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                '$index'.padLeft(2,'0'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: selectedHour == index ? Colors.blue : Colors.black,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedMinute = index;
                });
                widget.onDurationSelected(selectedHour, selectedMinute);
              },
            );
          },
        ),
      ),
    ]);
  }
}
