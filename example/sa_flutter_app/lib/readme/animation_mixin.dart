import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

// Add AnimationMixin
class _MyWidgetState extends State<MyWidget> with AnimationMixin {
  late Animation<double> size;

  @override
  void initState() {
    // The AnimationController instance `controller` is already wired up.
    // Just connect with it with the tweens.
    size = Tween<double>(begin: 0.0, end: 200.0).animate(controller);

    controller.play(); // start the animation playback

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.value, // use animated value
      height: size.value,
      color: Colors.red,
    );
  }
}
