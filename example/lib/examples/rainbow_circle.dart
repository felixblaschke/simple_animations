import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:sa_v1_migration/sa_v1_migration.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';

class Circle extends StatelessWidget {
  static final rainbowColors = <MaterialColor>[
    Colors.pink,
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.red,
    Colors.pink
  ];

  static final circleRadius = 100.0;

  @override
  Widget build(BuildContext context) {
    return ControlledAnimation(
      playback: Playback.MIRROR,
      duration: Duration(seconds: 10),
      tween: rainbowTween(),
      child: CircleText(),
      builderWithChild: (context, child, color) {
        return Container(
          child: child,
          width: circleRadius * 2,
          height: circleRadius * 2,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(circleRadius))),
        );
      },
    );
  }

  TweenSequence rainbowTween() {
    final items = <TweenSequenceItem>[];
    for (int i = 0; i < rainbowColors.length - 1; i++) {
      items.add(TweenSequenceItem(
          tween: ColorTween(begin: rainbowColors[i], end: rainbowColors[i + 1]),
          weight: 1));
    }
    return TweenSequence(items);
  }
}

class CircleText extends StatelessWidget {
  static final thinkText =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 19);
  static final boldText = thinkText.copyWith(fontWeight: FontWeight.bold);

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Animations.", style: boldText),
        Text("Made simple.", style: thinkText),
      ],
    );
  }
}

class RainbowCircleDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: "Rainbow Circle",
      pathToFile: "rainbow_circle.dart",
      delayStartup: false,
      builder: (context) => Center(child: Circle()),
    );
  }
}
