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
      tween: (50.0).tweenTo(200.0), // specify tween (from 50.0 to 200.0)
      duration: 5.seconds, // set a duration
      builder: (context, child, value) {
        // <-- use builder function
        return Container(
          width: value, // apply animated value from builder function parameter
          height: value,
          color: Colors.green,
        );
      },
    );
  }
}
