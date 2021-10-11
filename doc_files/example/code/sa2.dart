import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: Tween(begin: 50.0, end: 200.0),
      duration: const Duration(seconds: 5),
      child: // specify child widget
          const Center(child: Text('Hello!')),
      builder: (context, child, value) {
        // obtain child via function parameter
        return Container(
          width: value,
          height: value,
          color: Colors.green,
          child: child, // place child inside the animation
        );
      },
    );
  }
}
