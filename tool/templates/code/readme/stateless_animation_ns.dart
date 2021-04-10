import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // create animation widget with type of animated variable
    return PlayAnimation<Color?>(
        tween: ColorTween(begin: Colors.red, end: Colors.blue), // define tween
        builder: (context, child, value) {
          // use animated value
          return Container(color: value, width: 100, height: 100);
        });
  }
}
