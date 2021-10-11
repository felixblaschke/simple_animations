import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // create animation widget with type of animated variable
    return PlayAnimation<Color?>(
        tween: ColorTween(begin: Colors.red, end: Colors.blue), // define tween
        duration: const Duration(seconds: 2), // define duration
        builder: (context, child, value) {
          return Container(
            color: value, // use animated value
            width: 100,
            height: 100,
          );
        });
  }
}
