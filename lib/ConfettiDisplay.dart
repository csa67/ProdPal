
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hci/ConfettiManager.dart';
import 'package:provider/provider.dart';

class ConfettiMessageDisplay extends StatelessWidget {
  const ConfettiMessageDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Consumer<ConfettiManager>(
          builder: (context, manager, child) {
            return ConfettiWidget(
              confettiController: manager.controller,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            );
          },
        ),
        Consumer<ConfettiManager>(
          builder: (context, manager, child) {
            if (manager.message.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (manager.message.isNotEmpty) {
                  final snackBar = SnackBar(
                    content: Text(manager.message),
                    backgroundColor: Colors.black,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  manager.message = ''; // Reset message to prevent repetitive snacking
                }
              });
              return SizedBox.shrink(); // Avoids returning a new widget that might conflict with snackbar
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
