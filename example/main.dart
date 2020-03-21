// "This is just one possibility what
//     you can do with simple_animations!"
//
// Documentation:
//   https://github.com/felixblaschke/simple_animations/tree/master/documentation
//
// Example App:
//   https://github.com/felixblaschke/simple_animations/tree/master/example
//

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(Example());

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(child: Center(child: buildAnimation())),
      ),
    );
  }

  final tween = MultiTrackTween([
    Track("size").add(Duration(seconds: 4), Tween(begin: 0.0, end: 150.0)),
    Track("color")
        .add(Duration(seconds: 2),
            ColorTween(begin: Colors.red, end: Colors.blue),
            curve: Curves.easeIn)
        .add(Duration(seconds: 2),
            ColorTween(begin: Colors.blue, end: Colors.green),
            curve: Curves.easeOut),
    Track("rotation").add(Duration(seconds: 1), ConstantTween(0.0)).add(
        Duration(seconds: 3), Tween(begin: 0.0, end: pi / 2),
        curve: Curves.easeOutSine)
  ]);

  Widget buildAnimation() {
    return ControlledAnimation(
      playback: Playback.MIRROR,
      duration: tween.duration,
      tween: tween,
      builder: (context, animation) {
        return Transform.rotate(
          angle: animation["rotation"],
          child: Container(
            width: animation["size"],
            height: animation["size"],
            color: animation["color"],
          ),
        );
      },
    );
  }
}
