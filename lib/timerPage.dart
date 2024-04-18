import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hci/boxBreathingAnimation.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Center(
                child: TimerCircle(
                    duration: 30), // Duration is set here, change as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerCircle extends StatefulWidget {
  final int duration; // in seconds

  const TimerCircle({Key? key, required this.duration}) : super(key: key);

  @override
  _TimerCircleState createState() => _TimerCircleState();
}

class _TimerCircleState extends State<TimerCircle> {
  Timer? _timer;
  double _progress = 0;
  late int _remainingSeconds;
  bool _isRunning = false; // Timer is not running initially

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration;
  }

  void startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _progress = 1 - (_remainingSeconds / widget.duration);
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isRunning = false; // Stop the timer automatically when time is up
        });
      }
    });
  }

  void pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void resumeTimer() {
    setState(() {
      _isRunning = true;
    });
    startTimer();
  }

  void resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = widget.duration;
      _progress = 0;
      _isRunning = false; // Timer stops and needs to be started again
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey,
                  color: Colors.pinkAccent,
                ),
              ),
              Text(
                formatTime(_remainingSeconds),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.pinkAccent,
                ),
              ),
            ],
          ),
          Visibility(
            visible: !_isRunning && _remainingSeconds == widget.duration,
            child: IconButton(
              icon: Icon(Icons.play_arrow),
              color: Colors.pinkAccent,
              onPressed: startTimer,
              iconSize: 30,
            ),
          ),
          Visibility(
              visible: _isRunning || _remainingSeconds != widget.duration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: _remainingSeconds != 0,
                    child: IconButton(
                      icon: _isRunning
                          ? Icon(Icons.pause)
                          : Icon(Icons.play_arrow),
                      color: Colors.pinkAccent,
                      onPressed: _isRunning ? pauseTimer : resumeTimer,
                      iconSize: 30,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.replay),
                    color: Colors.pinkAccent,
                    onPressed: resetTimer,
                    iconSize: 30,
                  ),
                ],
              )),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const BoxBreathing()),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  40), // Ensures the button is square-edged
            ),
            minimumSize: const Size.fromHeight(50), // Set the button's height
          ),
          child: const Text('I need a break!'),
        ),
      ),
    );
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
