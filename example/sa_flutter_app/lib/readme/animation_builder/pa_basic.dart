import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// Use type `Color?` because ColorTween produces type `Color?`
var widget = PlayAnimationBuilder<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue), // define tween
  duration: const Duration(seconds: 5), // define duration
  builder: (context, value, _) {
    return Container(
      color: value, // use animated color
      width: 100,
      height: 100,
    );
  },
);
