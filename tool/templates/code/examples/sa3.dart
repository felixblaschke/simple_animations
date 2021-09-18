import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: Tween(begin: 0.0, end: 200.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
      builder: (context, child, value) {
        return Container(
          width: value,
          height: value,
          color: Colors.pink,
        );
      },
    );
  }
}
