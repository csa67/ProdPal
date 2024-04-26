import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hci/util.dart';

class AchievementsScreen extends StatelessWidget {
  final List<Achievement> achievements = [
    Achievement(
      title: 'First Step',
      icon: 'assets/mental-health.png',
      description: 'Record your first mood.',
      isUnlocked: true,
    ),
    Achievement(
      title: 'Task Titan',
      icon: 'assets/trophy.png',
      description: 'Complete 10 tasks.',
      isUnlocked: false,
    ),
    Achievement(
      title: 'Wellness Warrior',
      icon: 'assets/mood.png',
      description: 'Consistent mood tracking for more than a week.',
      isUnlocked: false,
    ),
    Achievement(
      title: 'Silver Lining Scout',
      icon: 'assets/sunflower.png',
      description: 'Maintaining ',
      isUnlocked: false,
    ),
    Achievement(
      title: 'Hot Auction',
      icon: 'assets/trophy.png',
      description: 'Participate in your first auction',
      isUnlocked: false,
    ),
    Achievement(
      title: 'Hot Auction',
      icon: 'assets/sunflower.png',
      description: 'Participate in your first auction',
      isUnlocked: false,
    ),
    Achievement(
      title: 'Hot Auction',
      icon: 'assets/trophy.png',
      description: 'Participate in your first auction',
      isUnlocked: false,
    ),
    Achievement(
      title: 'Hot Auction',
      icon: 'assets/trophy.png',
      description: 'Participate in your first auction',
      isUnlocked: false,
    ),
    //Add more achievements as needed
  ];

  AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements', style: TextStyle(color: Colors.white),),
        backgroundColor: steelBlue,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: (4 / 4),
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          return AchievementCard(achievement: achievements[index]);
        },
      ),
    );
  }
}

class Achievement {
  final String title;
  final String icon;
  final String description;
  final bool isUnlocked;

  Achievement({
    required this.title,
    required this.icon,
    required this.description,
    this.isUnlocked = false,
  });
}

class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  AchievementCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: achievement.isUnlocked ? paleGreen: lightGray,
      elevation: 4.0,
      child: Container(
        padding: const EdgeInsets.all(10.0), // Fixed minimum height for the card
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              achievement.icon,
              width: 100.0, // Adjust the size as needed
              color: achievement.isUnlocked ? null : darkGray,
            ),
            const SizedBox(height: 8),
            Text(
              achievement.title,
              style: const TextStyle(
                fontSize: 18, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView( // Allows the text to be scrollable if it exceeds the space
                child: Text(achievement.description,
                  style: TextStyle(
                    color: achievement.isUnlocked ? Colors.black : Colors.grey,
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

