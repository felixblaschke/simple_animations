// ignore_for_file: avoid_print
//@start
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = CustomAnimation<Color?>(
  onStart: () => print('Animation started'),
  onComplete: () => print('Animation complete'),
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100);
  },
);
//@end