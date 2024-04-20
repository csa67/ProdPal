import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';

class ConfettiManager with ChangeNotifier {
  late ConfettiController controller;
  String message = '';

  ConfettiManager() {
    controller = ConfettiController(duration: const Duration(seconds: 5));
  }

  void playConfetti({String achievementMessage = ''}) {
    controller.play();
    message = achievementMessage; // Set the message to display
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}


