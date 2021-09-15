import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: (50.0).tweenTo(200.0),
      duration: 5.seconds,
      child: const Center(child: Text('Hello!')), // specify widget called "child"
      builder: (context, child, value) {
        // obtain child via function parameter
        return Container(
          width: value,
          height: value,
          color: Colors.green,
          child: child, // place child inside your animation
        );
      },
    );
  }
}
