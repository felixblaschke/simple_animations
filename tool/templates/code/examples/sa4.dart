import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: 100.0.tweenTo(200.0),
      duration: 2.seconds,
      delay: 1.seconds,
      curve: Curves.easeOut,
      builder: (context, child, value) {
        return Container(
          width: value,
          height: 50.0,
          color: Colors.orange,
        );
      },
    );
  }
}
