import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          // put DevTools very high in the widget hierarchy
          child: AnimationDeveloperTools(
            child: Center(
              child: MyAnimation(),
            ),
          ),
        ),
      ),
    );
  }
}

class MyAnimation extends StatefulWidget {
  const MyAnimation({super.key});

  @override
  _MyAnimationState createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation> with AnimationMixin {
  late Animation<double> size;

  @override
  void initState() {
    size = Tween<double>(begin: 0.0, end: 100.0).animate(controller);
    enableDeveloperMode(controller); // enable developer mode
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: size.value, height: size.value, color: Colors.blue);
  }
}
