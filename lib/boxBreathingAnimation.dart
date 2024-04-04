import 'package:flutter/material.dart';

class BoxBreathing extends StatelessWidget {
  const BoxBreathing({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: BreathingCircle()),
      ),
    );
  }
}

enum BreathingState { breatheIn, holdIn, breatheOut, holdOut }

extension BreathingStateExtension on BreathingState {
  String get label {
    switch (this) {
      case BreathingState.breatheIn:
        return 'Breathe In';
      case BreathingState.holdIn:
        return 'Hold';
      case BreathingState.breatheOut:
        return 'Breathe Out';
      case BreathingState.holdOut:
        return 'Hold';
    }
  }

  BreathingState get nextState {
    switch (this) {
      case BreathingState.breatheIn:
        return BreathingState.holdIn;
      case BreathingState.holdIn:
        return BreathingState.breatheOut;
      case BreathingState.breatheOut:
        return BreathingState.holdOut;
      case BreathingState.holdOut:
        return BreathingState.breatheIn;
    }
  }
}

class BreathingCircle extends StatefulWidget {
  const BreathingCircle({super.key});

  @override
  _BreathingCircleState createState() => _BreathingCircleState();
}


class _BreathingCircleState extends State<BreathingCircle> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _positionAnimation;
  BreathingState state = BreathingState.breatheIn;
  bool isStarted = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 32), // 8 seconds per side, 4 sides
    );

    _positionAnimation = Tween(begin: 0.0, end: 4.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.linear),
    ))
      ..addListener(() {
        setState(() {
          final section = _positionAnimation.value;
          if (section <= 1) {
            state = BreathingState.breatheIn;
          } else if (section <= 2) {
            state = BreathingState.holdIn;
          } else if (section <= 3) {
            state = BreathingState.breatheOut;
          } else {
            state = BreathingState.holdOut;
          }
        });
      });

    // Do not start the animation immediately
    //_controller.repeat();
  }

  void _toggleStart() {
    if (!isStarted) {
      _controller.repeat();
      isPaused = false;
    } else if(!isPaused) {
      _controller.stop();
      isPaused = true;
    }else{
      _controller.forward();
      isPaused = false;
    }

    setState(() {
      isStarted = !isStarted || isPaused;
    });
  }

  void _pauseOrResume(){
    setState(() {
      if(_controller.isAnimating){
        _controller.stop();
        isPaused = true;
      } else {
        _controller.forward();
        isPaused = false;
      }
    });
  }
  void _resetAnimation() {
    _controller.reset();
    setState(() {
      isStarted = false;
      isPaused = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset calculateBallPosition(double value, double squareSize, double ballDiameter) {
    final halfBallDiameter = ballDiameter / 2;
    final trackLength = squareSize - ballDiameter;

    // The value ranges from 0.0 to 4.0, each integer representing a side
    final side = (value % 4).floor();
    final progress = value % 1;

    double top = 0, left = 0;
    switch (side) {
      case 0: // Top side
        top = -ballDiameter/2; // Adjust to align with the border
        left = progress * trackLength; // Adjust to align with the border
        break;
      case 1: // Right side
        top = progress * trackLength;
        left = trackLength;
        break;
      case 2: // Bottom side
        top = trackLength;
        left = trackLength - (progress * trackLength);
        break;
      case 3: // Left side
        top = trackLength - (progress * trackLength); // Move up
        left = -halfBallDiameter; // Stay at the left edge
        break;
    }

    return Offset(left + halfBallDiameter, top + halfBallDiameter);
  }


  @override
  Widget build(BuildContext context) {
    const double outerSquareSize = 230.0;
    const double squareSize = 220.0;
    const innerCircleSize = 180.0;
    const double ballDiameter = 20.0;
    String btnText = 'Pause';

    Offset ballPosition = calculateBallPosition(_positionAnimation.value, squareSize, ballDiameter);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: outerSquareSize,
          height: outerSquareSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: squareSize,
                height: squareSize,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey, width: 6),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                width: innerCircleSize, // Consider the border width for inner circle size
                height: innerCircleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 3),
                    ),
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(0, 3),
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: Offset(0, 3),
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: Offset(0, 3),
                    ),
                    // Add more shadows with increasing blurRadius and lighter colors as needed
                  ],
                ),

              // Container(
              //   width: innerCircleSize, // Consider the border width for inner circle size
              //   height: innerCircleSize,
              //   decoration: const BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Colors.white,
              //     boxShadow: BoxShadow(spreadRadius: 5.0)
              //
              //   ),
                alignment: Alignment.center,
                child: Text(
                  state.label,
                  style: const TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 24,
                  ),
                ),
              ),
              Positioned(
                top: ballPosition.dy,
                left: ballPosition.dx,
                child: Container(
                  width: ballDiameter,
                  height: ballDiameter,
                  decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: isStarted
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _pauseOrResume,
                child: Text(isPaused ? 'Resume' : 'Pause'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _resetAnimation,
                child: const Text('Reset'),
              ),
            ],
          )
              : ElevatedButton(
            onPressed: _toggleStart,
            child: const Text('Start'),
          ),
        ),
      ],
    );
  }
}
