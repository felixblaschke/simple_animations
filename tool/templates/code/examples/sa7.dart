// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      control: CustomAnimationControl.mirror,
      tween: 100.0.tweenTo(200.0),
      duration: 2.seconds,
      delay: 1.seconds,
      curve: Curves.easeInOut,
      startPosition: 0.5,
      animationStatusListener: (status) {
        print('status updated: $status');
      },
      builder: (context, child, value) {
        return Container(
            width: value, height: value, color: Colors.blue, child: child);
      },
      child: const Center(
          child: Text(
        'Hello!',
        style: TextStyle(color: Colors.white, fontSize: 24),
      )),
    );
  }
}
