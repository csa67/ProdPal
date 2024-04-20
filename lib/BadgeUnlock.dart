import 'package:flutter/material.dart';

class BadgeUnlockPage extends StatefulWidget {
  @override
  _BadgeUnlockPageState createState() => _BadgeUnlockPageState();
}

class _BadgeUnlockPageState extends State<BadgeUnlockPage> {
  bool badgeUnlocked = false;

  void unlockBadge() {
    setState(() {
      badgeUnlocked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unlock Badge Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: badgeUnlocked,
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.elasticOut,
                width: badgeUnlocked ? 200 : 0,
                height: badgeUnlocked ? 200 : 0,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.star, color: Colors.white, size: 100),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                unlockBadge();
              },
              child: const Text("Unlock Badge"),
            ),
          ],
        ),
      ),
    );
  }
}
