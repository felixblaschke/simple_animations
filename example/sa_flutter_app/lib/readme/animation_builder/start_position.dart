import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = CustomAnimationBuilder<Color?>(
  control: Control.play,
  startPosition: 0.5, // set start position at 50%
  duration: const Duration(seconds: 5),
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  builder: (context, value, child) {
    return Container(color: value, width: 100, height: 100);
  },
);
