import 'package:flutter/material.dart';
import 'package:hci/ConfettiDisplay.dart';
import 'package:hci/ConfettiManager.dart';
import 'package:hci/model/Mood.dart';
import 'package:provider/provider.dart';

class MoodTrackerWidget extends StatefulWidget {
  const MoodTrackerWidget({super.key});

  @override
  MoodTrackerWidgetState createState() => MoodTrackerWidgetState();
}

class MoodTrackerWidgetState extends State<MoodTrackerWidget> {
  int? _selectedMoodIndex; // Index of the selected mood
  bool _isFirstTap = true;

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'How are you today?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(moods.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMoodIndex = index;
                    if(_isFirstTap){
                      Provider.of<ConfettiManager>(context, listen: false).playConfetti(
                        achievementMessage: "Wohoo! You unlocked a new achievement!",
                      );
                      _isFirstTap = false;
                    }
                  });
                },
                child: Column(
                  children: [
                    Image.asset(
                      _selectedMoodIndex == index
                          ? moods[index].emojiColorPath
                          : moods[index].emojiGreyPath,
                      width: 40,
                    ),
                    Text(moods[index].label),
                  ],
                ),
              );
            }),
          ),
      const ConfettiMessageDisplay(),
        ],
      ),
    );
  }
}
