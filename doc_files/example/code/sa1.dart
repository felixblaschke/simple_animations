import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: Tween(begin: 50.0, end: 200.0), // specify tween
      duration: const Duration(seconds: 5), // set a duration
      builder: (context, child, value) {
        // <-- use builder function
        return Container(
          width: value, // apply animated value from builder function parameter
          height: value,
          color: Colors.green,
        );
      },
    );
  }
}
