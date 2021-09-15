import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimation<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 5),
  delay: const Duration(seconds: 2), // add delay
  builder: (context, child, value) {
    return Container(
      color: value,
      width: 100,
      height: 100,
    );
  },
);
