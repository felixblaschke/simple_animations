import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';

class ExampleRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

class RectangleDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: "Rectangle",
      pathToFile: "rectangle.dart",
      delayStartup: false,
      builder: (context) => Center(child: ExampleRectangle()),
    );
  }
}
