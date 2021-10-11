import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimation<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  curve: Curves.easeInOut, // specify curve
  builder: (context, child, value) {
    return Container(
      color: value,
      width: 100,
      height: 100,
    );
  },
);
