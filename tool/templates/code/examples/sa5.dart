import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoopAnimation<double>(
        tween: 0.0.tweenTo(10.0),
        duration: 2.seconds,
        curve: Curves.easeOut,
        builder: (context, child, value) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: const Text('Hello!'));
  }
}
