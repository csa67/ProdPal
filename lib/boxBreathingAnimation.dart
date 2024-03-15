import 'package:flutter/material.dart';

class BoxBreathing extends StatelessWidget {
  const BoxBreathing({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal,
        body: Center(child: BreathingCircle()),
      ),
    );
  }
}

enum BreathingState { BreatheIn, HoldIn, BreatheOut, HoldOut }

extension BreathingStateExtension on BreathingState {
  String get label {
    switch (this) {
      case BreathingState.BreatheIn:
        return 'Breathe In';
      case BreathingState.HoldIn:
        return 'Hold';
      case BreathingState.BreatheOut:
        return 'Breathe Out';
      case BreathingState.HoldOut:
        return 'Hold';
    }
  }

  BreathingState get nextState {
    switch (this) {
      case BreathingState.BreatheIn:
        return BreathingState.HoldIn;
      case BreathingState.HoldIn:
        return BreathingState.BreatheOut;
      case BreathingState.BreatheOut:
        return BreathingState.HoldOut;
      case BreathingState.HoldOut:
        return BreathingState.BreatheIn;
    }
  }
}

class BreathingCircle extends StatefulWidget {
  @override
  _BreathingCircleState createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _positionAnimation;
  BreathingState state = BreathingState.BreatheIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 32), // 8 seconds per side, 4 sides
    );

    _positionAnimation = Tween(begin: 0.0, end: 4.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 1.0, curve: Curves.linear),
    ))
      ..addListener(() {
        setState(() {
          // This will trigger a rebuild with the new ball position.
        });
        final section = _positionAnimation.value;
        if (section <= 1) {
          state = BreathingState.BreatheIn;
        } else if (section <= 2) {
          state = BreathingState.HoldIn;
        } else if (section <= 3) {
          state = BreathingState.BreatheOut;
        } else {
          state = BreathingState.HoldOut;
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
    // We use modulo to wrap the value back to 0.0 after reaching 4.0
    final side = (value % 4).floor();
    final progress = value % 1;

    double top = 0, left = 0;
    switch (side) {
      case 0: // Top side
        top = 0;
        left = progress * trackLength;
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
        top = trackLength - (progress * trackLength);
        left = 0;
        break;
    }

    return Offset(left + halfBallDiameter, top + halfBallDiameter);
  }

  @override
  Widget build(BuildContext context) {
    final double squareSize = 220.0;
    final double ballDiameter = 20.0;

    Offset ballPosition = calculateBallPosition(_positionAnimation.value, squareSize, ballDiameter);

    return Container(
      width: squareSize+10,
      height: squareSize,
      alignment: Alignment.topLeft,
      child: Stack(
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
            width: squareSize - 40.0, // Consider the border width for inner circle size
            height: squareSize - 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Text(
              state.label,
              style: TextStyle(
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
              decoration: BoxDecoration(
                color: Colors.black, // Ball color is black
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
