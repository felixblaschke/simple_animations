import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tween = createTween();

    return PlayAnimation<TimelineValue<Prop>>(
      tween: tween,
      duration: tween.duration, // use absolute duration
      builder: (context, child, value) {
        return Container(
          width: value.get(Prop.width),
          height: value.get(Prop.height),
          color: Colors.yellow,
        );
      },
    );
  }
}

TimelineTween<Prop> createTween() => TimelineTween<Prop>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(Prop.width, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(Prop.height, tween: Tween<double>(begin: 300.0, end: 200.0));
