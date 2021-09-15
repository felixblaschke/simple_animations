import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      // specify tween (from 50.0 to 200.0)
      tween: (50.0).tweenTo(200.0),

      // set a duration
      duration: 5.seconds,

      // set a curve
      curve: Curves.easeInOut,

      // use builder function
      builder: (context, child, value) {
        // apply animated value obtained from builder function parameter
        return Container(
          width: value,
          height: value,
          color: Colors.green,
          child: child,
        );
      },
      child: const Text('Hello World'),
    );
  }
}
