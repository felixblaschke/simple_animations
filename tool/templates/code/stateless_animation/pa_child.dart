import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimation<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  // child gets passed into builder function
  builder: (context, child, value) {
    return Container(
      color: value,
      width: 100,
      height: 100,
      child: child, // use child
    );
  },
  child: const Text('Hello World'), // specify child widget
);
