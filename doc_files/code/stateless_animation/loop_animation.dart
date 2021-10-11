import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = LoopAnimation<Color?>(
  // mandatory parameters
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100, child: child);
  },
  // optional parameters
  duration: const Duration(seconds: 5),
  curve: Curves.easeInOut,
  child: const Text('Hello World'),
);
