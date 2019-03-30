import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: animatedContainer()),
      ),
    );
  }

  Widget animatedContainer() {
    return InstantAnimation(
      duration: Duration(milliseconds: 1500),
      tween: Tween(begin: 100.0, end: 300.0),
      builder: (context, animatedValue) {
        return Container(width: animatedValue, height: animatedValue, color: Colors.red);
      },
    );
  }
}
