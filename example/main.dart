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
        body: Center(
            child: ControlledAnimation(
                duration: Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 100.0),
                builder: (context, width) {
                  return Container(
                      width: width, height: 50.0, color: Colors.red);
                })),
      ),
    );
  }
}
