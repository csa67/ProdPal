import 'dart:ui';
import 'package:hci/AchievementsScreen.dart';
import 'package:flutter/material.dart';
import 'package:hci/MoodTrackerWidget.dart';
import 'package:intl/intl.dart';
import 'package:hci/MotivationScreen.dart';
import 'package:hci/database/db.dart';
import 'package:hci/model/Task.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  DateTime selectedDate = DateTime.now();

  final GlobalKey<_ActivityProgressIndicatorState>
      _activityProgressIndicatorKey = GlobalKey();

  void _updateSelectedDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      _activityProgressIndicatorKey.currentState?._updateProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            // Provide some spacing from the top of the screen.
            const Text(
              'Hello,\nSophie!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            //Scrollable list of days
            ScrollableDays(
              onDateSelected: _updateSelectedDate,
            ),
            const SizedBox(height: 20),
            // Activity progress indicator
            ActivityProgressIndicator(
                key: _activityProgressIndicatorKey, date: selectedDate),
            const SizedBox(height: 10),
            MoodTrackerWidget(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const QuoteScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.pinkAccent,
                      // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            18.0), // Rounded corners - adjust the radius to match your MoodTrackerWidget
                      ),
                      padding: const EdgeInsets.all(12),
                      elevation: 5,
                      minimumSize: const Size(180,
                          150) // Elevation - adjust to your preference or match your MoodTrackerWidget
                      ),
                  child: const Text(
                    'Motivate Me!',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AchievementsScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.pinkAccent,
                      // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            18.0), // Rounded corners - adjust the radius to match your MoodTrackerWidget
                      ),
                      padding: const EdgeInsets.all(12),
                      elevation: 5,
                      minimumSize: const Size(180, 150)
                      ),
                  child: const Text(
                    'Achievements',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollableDays extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const ScrollableDays({super.key, required this.onDateSelected});

  @override
  State<StatefulWidget> createState() => _ScrollableDaysState();
}

class _ScrollableDaysState extends State<ScrollableDays> {
  DateTime? selectedDate;
  final DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedDate = today; // Initialize the selected date to today
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 30, // Number of days to display (e.g., a year)
          itemBuilder: (context, index) {
            // Calculate the date to display
            final date = DateTime.now().add(Duration(days: index));
            final displayDate = DateFormat.E()
                .format(date)[0]; // Short weekday (e.g., Mon, Tue)
            final displayDay = DateFormat.d().format(date);

            bool isSelected = selectedDate?.year == date.year &&
                selectedDate?.month == date.month &&
                selectedDate?.day == date.day;
            bool isToday = today.year == date.year &&
                today.month == date.month &&
                today.day == date.day;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = date;
                  widget.onDateSelected(date);
                });
              },
              child: Container(
                width: 50,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.pinkAccent : Colors.grey[800],
                  border: isToday
                      ? Border.all(color: Colors.pinkAccent, width: 2)
                      : null,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$displayDate\n$displayDay',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        isSelected || isToday ? Colors.white : Colors.grey[500],
                  ),
                ),
              ),
            );
          },
        ));
  }
}

class ActivityProgressIndicator extends StatefulWidget {
  final DateTime date;

  const ActivityProgressIndicator({super.key, required this.date});

  @override
  State<StatefulWidget> createState() => _ActivityProgressIndicatorState();
}

class _ActivityProgressIndicatorState extends State<ActivityProgressIndicator> {
  int totaltasks = 0;
  int completedtasks = 0;
  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _updateProgress();
  }

  @override
  void didUpdateWidget(ActivityProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date != widget.date) {
      _updateProgress(); // Call the progress update when the widget date changes
    }
  }

  Future<void> _updateProgress() async {
    List<Task> tasksonTheDay =
        await DatabaseHelper.instance.getTasks(widget.date);
    int Total = tasksonTheDay.length;
    int completedTasks = tasksonTheDay.where((task) => task.isCompleted).length;
    setState(() {
      totaltasks = Total;
      completedtasks = completedTasks;
      progressValue = totaltasks > 0 ? completedtasks / totaltasks : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    int progressPercent =
        (progressValue * 100).toInt(); // Convert to percentage for display

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // Center the row contents horizontally
        crossAxisAlignment: CrossAxisAlignment.center,
        // Center the row contents vertically
        children: [
          // Circular Progress Indicator with Percentage in the Center
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 100, // Smaller size for the circular progress indicator
                width: 100,
                child: CircularProgressIndicator(
                  value: progressValue, // Current progress
                  backgroundColor: Colors.grey[800],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
                  strokeWidth: 6, // Thinner stroke width
                ),
              ),
              Text(
                '$progressPercent%', // Display the percentage
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Smaller font size for the percentage text
                  color: Colors.pink,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          // Spacing between the progress indicator and the text
          // Activities Text
          Expanded(
            // Use Expanded to take up remaining space
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              // Align text to the start (left)
              children: [
                const Text(
                  'My Activities',
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '$completedtasks of $totaltasks completed',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
