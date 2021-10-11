// ignore_for_file: avoid_print
// #begin
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = CustomAnimation<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100);
  },
  animationStatusListener: (AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      print('Animation completed!');
    }
  },
);
// #end
