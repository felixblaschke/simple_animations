import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimationBuilder<double>(
      tween: Tween(begin: 50.0, end: 200.0),
      duration: const Duration(seconds: 5),
      child: const Center(child: Text('Hello!')), // pass in static child
      builder: (context, value, child) {
        return Container(
          width: value,
          height: value,
          color: Colors.green,
          child: child, // use child inside the animation
        );
      },
    );
  }
}
