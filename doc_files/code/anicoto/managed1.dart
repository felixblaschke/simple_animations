import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyAnimatedWidget extends StatefulWidget {
  const MyAnimatedWidget({Key? key}) : super(key: key);

  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

// use AnimationMixin
class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {
  late AnimationController sizeController; // declare custom AnimationController
  late Animation<double> size;

  @override
  void initState() {
    sizeController = createController(); // create custom AnimationController
    size = Tween<double>(begin: 0.0, end: 200.0).animate(sizeController);
    sizeController.play(duration: const Duration(seconds: 5));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: size.value, height: size.value, color: Colors.red);
  }
}
