import 'package:flutter/material.dart';
import 'package:hci/MoodTrackerWidget.dart';
import 'package:intl/intl.dart';
import 'package:hci/MotivationScreen.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

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
            const ScrollableDays(),
            const SizedBox(height: 20),
            // Activity progress indicator
            const ActivityProgressIndicator(),
            MoodTrackerWidget(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuoteScreen()));
              },
              child: const Text('Motivate Me!'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollableDays extends StatelessWidget {
  const ScrollableDays({super.key});

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
          final displayDate =
          DateFormat.E().format(date)[0]; // Short weekday (e.g., Mon, Tue)
          final displayDay = DateFormat.d().format(date);

          return Container(
            width: 50,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: index == 0 ? Colors.pinkAccent : Colors.grey[800],
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$displayDate\n$displayDay',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: index == 0 ? Colors.white : Colors.grey[500],
              ),
            ),
          );
        },));
  }
}

class ActivityProgressIndicator extends StatelessWidget {
  const ActivityProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // Customizable value for progress
    double progressValue = 0.67;
    int progressPercent = (progressValue * 100).toInt(); // Convert to percentage for display

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.pink,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the row contents horizontally
      crossAxisAlignment: CrossAxisAlignment.center, // Center the row contents vertically
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
        const SizedBox(width: 20), // Spacing between the progress indicator and the text
        // Activities Text
        Expanded( // Use Expanded to take up remaining space
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start (left)
            children: [
              const Text(
                'My Activities',
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 18,
                ),
              ),
              Text(
                '4 of 6 completed',
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

