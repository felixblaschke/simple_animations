import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<double>(
      control: Control.mirror,
      tween: Tween(begin: 100.0, end: 200.0),
      duration: const Duration(seconds: 2),
      delay: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      startPosition: 0.5,
      animationStatusListener: (status) {
        debugPrint('status updated: $status');
      },
      builder: (context, value, child) {
        return Container(
          width: value,
          height: value,
          color: Colors.blue,
          child: child,
        );
      },
      child: const Center(
          child: Text('Hello!',
              style: TextStyle(color: Colors.white, fontSize: 24))),
    );
  }
}
