import 'package:flutter/material.dart';

class BoxBreathing extends StatelessWidget {
  const BoxBreathing({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal,
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
          // This will trigger a rebuild with the new ball position.
        });
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

    _controller.repeat();
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
        top = trackLength - (progress * trackLength); // Adjust to align with the border
        left = -ballDiameter / 2; // Adjust to align with the border
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

    Offset ballPosition = calculateBallPosition(_positionAnimation.value, squareSize, ballDiameter);

    return SizedBox(
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
              border: Border.all(color: Colors.white, width: 6),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Container(
            width: innerCircleSize, // Consider the border width for inner circle size
            height: innerCircleSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Text(
              state.label,
              style: const TextStyle(
                color: Colors.black,
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
                color: Colors.white, // Ball color is black
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
