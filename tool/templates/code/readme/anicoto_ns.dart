import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

// add AnimationMixin to widget's state
class _MyWidgetState extends State<MyWidget> with AnimationMixin {
  // declare animation variable
  late Animation<double> size;

  @override
  void initState() {
    // connect tween and controller and apply to animation variable
    size = Tween<double>(begin: 0.0, end: 200.0).animate(controller);

    controller.play(); // start the animation playback

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.value, // use animation variable's value
      height: size.value, // use animation variable's value
      color: Colors.red,
    );
  }
}
