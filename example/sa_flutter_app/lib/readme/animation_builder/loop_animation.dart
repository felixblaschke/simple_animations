import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = LoopAnimationBuilder<Color?>(
  // mandatory parameters
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 5),
  builder: (context, value, child) {
    return Container(color: value, width: 100, height: 100, child: child);
  },
  // optional parameters
  curve: Curves.easeInOut,
  child: const Text('Hello World'),
);
