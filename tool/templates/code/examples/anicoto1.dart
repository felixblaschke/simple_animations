import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(const MaterialApp(home: Page()));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: MyAnimatedWidget())),
    );
  }
}

class MyAnimatedWidget extends StatefulWidget {
  const MyAnimatedWidget({Key? key}) : super(key: key);

  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

// Add AnimationMixin to state class
class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {
  late Animation<double> size; // Declare animation variable

  @override
  void initState() {
    // Connect tween and controller and apply to animation variable
    size = 0.0.tweenTo(200.0).animatedBy(controller);

    // Start the animation playback
    controller.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size.value, // Use animation variable's value here
        height: size.value, // Use animation variable's value here
        color: Colors.red);
  }
}
