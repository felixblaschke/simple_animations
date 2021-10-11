import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // create tween
    var tween = createTween();

    return PlayAnimation<TimelineValue<AniProps>>(
      tween: tween, // provide tween
      duration: tween.duration, // total duration obtained from TimelineTween
      builder: (context, child, value) {
        return Container(
          width: value.get(AniProps.width), // get animated width value
          height: value.get(AniProps.height), // get animated height value
          color: Colors.yellow,
        );
      },
    );
  }
}

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() => TimelineTween<AniProps>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(AniProps.width, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(AniProps.height, tween: Tween<double>(begin: 300.0, end: 200.0));
