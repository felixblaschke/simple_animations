import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';
import 'package:supercharged/supercharged.dart';

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
    return MirrorAnimation<MultiTweenValues<DefaultAnimationProperties>>(
      duration: Duration(seconds: 10),
      tween: rainbowTween(),
      child: CircleText(),
      builder: (context, child, value) {
        return Container(
          child: child,
          width: circleRadius * 2,
          height: circleRadius * 2,
          decoration: BoxDecoration(
              color: value.get(DefaultAnimationProperties.color),
              borderRadius: BorderRadius.all(Radius.circular(circleRadius))),
        );
      },
    );
  }

  MultiTween<DefaultAnimationProperties> rainbowTween() {
    final tween = MultiTween<DefaultAnimationProperties>();
    0.until(rainbowColors.length - 1).forEach((index) {
      tween.add(
        DefaultAnimationProperties.color,
        rainbowColors[index].tweenTo(rainbowColors[index + 1]),
      );
    });
    return tween;
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
