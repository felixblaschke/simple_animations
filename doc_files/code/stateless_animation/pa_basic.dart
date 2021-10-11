import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// set Color? as type of PlayAnimation because use a ColorTween
var widget = PlayAnimation<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue), // define tween
  builder: (context, child, value) {
    return Container(
      color: value, // use animated color
      width: 100,
      height: 100,
    );
  },
);
