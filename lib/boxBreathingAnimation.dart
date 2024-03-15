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
    final double outerSquareSize = 230.0;
    final double squareSize = 220.0;
    final innerCircleSize = 180.0;
    final double ballDiameter = 20.0;

    Offset ballPosition = calculateBallPosition(_positionAnimation.value, squareSize, ballDiameter);

    return Container(
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

// import 'package:flutter/material.dart';
// import 'dart:math' as math;
//
// class BoxBreathing extends StatelessWidget {
//   const BoxBreathing({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.teal,
//         body: Center(child: BreathingCircle()),
//       ),
//     );
//   }
// }
//
// enum BreathingState { BreatheIn, HoldIn, BreatheOut, HoldOut }
//
// extension BreathingStateExtension on BreathingState {
//   String get label {
//     switch (this) {
//       case BreathingState.BreatheIn:
//         return 'Breathe In';
//       case BreathingState.HoldIn:
//         return 'Hold';
//       case BreathingState.BreatheOut:
//         return 'Breathe Out';
//       case BreathingState.HoldOut:
//         return 'Hold';
//     }
//   }
//
//   BreathingState get nextState {
//     switch (this) {
//       case BreathingState.BreatheIn:
//         return BreathingState.HoldIn;
//       case BreathingState.HoldIn:
//         return BreathingState.BreatheOut;
//       case BreathingState.BreatheOut:
//         return BreathingState.HoldOut;
//       case BreathingState.HoldOut:
//         return BreathingState.BreatheIn;
//     }
//   }
// }
//
// class BreathingCircle extends StatefulWidget {
//   @override
//   _BreathingCircleState createState() => _BreathingCircleState();
// }
//
// class _BreathingCircleState extends State<BreathingCircle> with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _positionAnimation;
//   BreathingState state = BreathingState.BreatheIn;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 32), // 8 seconds per side, 4 sides
//     );
//
//     _positionAnimation = Tween(begin: 0.0, end: 4.0).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Interval(0.0, 1.0, curve: Curves.linear),
//     ))
//       ..addListener(() {
//         setState(() {
//           // This will trigger a rebuild with the new ball position.
//         });
//         final section = _positionAnimation.value;
//         if (section <= 1) {
//           state = BreathingState.BreatheIn;
//         } else if (section <= 2) {
//           state = BreathingState.HoldIn;
//         } else if (section <= 3) {
//           state = BreathingState.BreatheOut;
//         } else {
//           state = BreathingState.HoldOut;
//         }
//       });
//
//     _controller.repeat();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Offset calculateBallPosition(double value, double squareSize, double ballDiameter) {
//     final double borderOffset = ballDiameter / 2; // Offset to position ball correctly on the path
//     final double trackLength = squareSize - ballDiameter; // Total path length for ball movement
//
//     // The value ranges from 0.0 to 4.0, each full number representing a corner of the square
//     final progress = value % 4; // Progress around the square
//     final side = progress.floor(); // Current side of the square
//     final sideProgress = progress - side; // Progress along the current side
//
//     double top, left;
//     switch (side) {
//       case 0: // Moving right (top side)
//         top = 0;
//         left = trackLength * sideProgress;
//         break;
//       case 1: // Moving down (right side)
//         top = trackLength * sideProgress;
//         left = trackLength;
//         break;
//       case 2: // Moving left (bottom side)
//         top = trackLength;
//         left = trackLength - (trackLength * sideProgress);
//         break;
//       case 3: // Moving up (left side)
//         top = trackLength - (trackLength * sideProgress);
//         left = 0;
//         break;
//       default:
//         throw Exception('Invalid side for square animation');
//     }
//
//     // Adjust the ball position to account for the border width
//     return Offset(left + borderOffset, top + borderOffset);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final outerBorderSize = 220.0;
//     final innerCircleSize = 180.0;
//     final ballSize = 20.0;
//
//     Offset ballPosition = calculateBallPosition(_controller.value, outerBorderSize, ballSize);
//
//     return SizedBox(
//       width: outerBorderSize,
//       height: outerBorderSize,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Container(
//             width: outerBorderSize,
//             height: outerBorderSize,
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//               border: Border.all(color: Colors.white, width: 6),
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//           Container(
//             width: innerCircleSize,
//             height: innerCircleSize,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               state.label,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontSize: 24,
//               ),
//             ),
//           ),
//           Positioned(
//             top: ballPosition.dy,
//             left: ballPosition.dx,
//             child: Container(
//               width: ballSize,
//               height: ballSize,
//               decoration: const BoxDecoration(
//                 color: Colors.black,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
