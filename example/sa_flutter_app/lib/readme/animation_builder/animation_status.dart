// #begin
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = CustomAnimationBuilder<Color?>(
  animationStatusListener: (AnimationStatus status) {
    // provide listener
    if (status == AnimationStatus.completed) {
      debugPrint('Animation completed!');
    }
  },
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 5),
  builder: (context, value, child) {
    return Container(color: value, width: 100, height: 100);
  },
);
// #end
