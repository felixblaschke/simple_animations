import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = CustomAnimation<Color?>(
  // play forward
  control: CustomAnimationControl.play,

  // set start position at 50%
  startPosition: 0.5,

  // full duration is 5 seconds
  duration: const Duration(seconds: 5),

  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100);
  },
);
