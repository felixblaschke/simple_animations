import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';
import 'package:supercharged/supercharged.dart';

enum _SquareProps { size, color, rotation }

class ExampleRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MirrorAnimation<MultiTweenValues<_SquareProps>>(
      duration: tween.duration,
      tween: tween,
      builder: (context, child, value) {
        return Transform.rotate(
          angle: value.get(_SquareProps.rotation),
          child: Container(
            width: value.get(_SquareProps.size),
            height: value.get(_SquareProps.size),
            color: value.get(_SquareProps.color),
          ),
        );
      },
    );
  }

  final tween = MultiTween<_SquareProps>()
    ..add(_SquareProps.size, 0.0.tweenTo(150.0), 4.seconds)
    ..add(_SquareProps.color, Colors.red.tweenTo(Colors.blue), 2.seconds)
    ..add(_SquareProps.color, Colors.blue.tweenTo(Colors.green), 2.seconds)
    ..add(_SquareProps.rotation, ConstantTween(0.0), 1.seconds)
    ..add(_SquareProps.rotation, 0.0.tweenTo(pi / 2.0), 3.seconds,
        Curves.easeOutSine);
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
