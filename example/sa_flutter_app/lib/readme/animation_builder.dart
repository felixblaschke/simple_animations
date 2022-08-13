import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class ResizeCubeAnimation extends StatelessWidget {
  const ResizeCubeAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PlayAnimationBuilder plays animation once
    return PlayAnimationBuilder<double>(
      tween: Tween(begin: 100.0, end: 200.0), // 100.0 to 200.0
      duration: const Duration(seconds: 1), // for 1 second
      builder: (context, value, _) {
        return Container(
          width: value, // use animated value
          height: value,
          color: Colors.blue,
        );
      },
      onCompleted: () {
        // do something ...
      },
    );
  }
}

class RotatingBox extends StatelessWidget {
  const RotatingBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // LoopAnimationBuilder plays forever: from beginning to end
    return LoopAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 2 * pi), // 0° to 360° (2π)
      duration: const Duration(seconds: 2), // for 2 seconds per iteration
      builder: (context, value, _) {
        return Transform.rotate(
          angle: value, // use value
          child: Container(color: Colors.blue, width: 100, height: 100),
        );
      },
    );
  }
}

class ColorFadeLoop extends StatelessWidget {
  const ColorFadeLoop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MirrorAnimationBuilder plays forever: alternating forward and backward
    return MirrorAnimationBuilder<Color?>(
      tween: ColorTween(begin: Colors.red, end: Colors.blue), // red to blue
      duration: const Duration(seconds: 5), // for 5 seconds per iteration
      builder: (context, value, _) {
        return Container(
          color: value, // use animated value
          width: 100,
          height: 100,
        );
      },
    );
  }
}
