import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyAnimatedWidget extends StatefulWidget {
  const MyAnimatedWidget({Key? key}) : super(key: key);

  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

// Add AnimationMixin to state class
class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {
  late Animation<double> size;

  @override
  void initState() {
    size = Tween<double>(begin: 0.0, end: 200.0).animate(controller);
    controller.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: size.value, height: size.value, color: Colors.red);
  }
}
