import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations_example_app/widgets/example_page.dart';
import 'package:supercharged/supercharged.dart';

class Box extends StatelessWidget {
  static final boxDecoration = BoxDecoration(
      color: Colors.orange,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 5,
            offset: Offset(0, 8),
            spreadRadius: 2)
      ]);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      duration: 400.milliseconds,
      tween: 0.0.tweenTo(80.0),
      builder: (context, child, height) {
        return PlayAnimation<double>(
          duration: 1200.milliseconds,
          delay: 500.milliseconds,
          tween: 2.0.tweenTo(300.0),
          builder: (context, child, width) {
            return Container(
              decoration: boxDecoration,
              width: width,
              height: height,
              child: isEnoughRoomForTypewriter(width)
                  ? TypewriterText("Hello Flutter")
                  : Container(),
            );
          },
        );
      },
    );
  }

  bool isEnoughRoomForTypewriter(double width) => width > 20;
}

class TypewriterText extends StatelessWidget {
  static const TEXT_STYLE =
      TextStyle(letterSpacing: 5, fontSize: 20, fontWeight: FontWeight.w300);

  final String text;

  TypewriterText(this.text);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<int>(
        duration: 800.milliseconds,
        delay: 800.milliseconds,
        tween: 0.tweenTo(text.length),
        builder: (context, child, textLength) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text.substring(0, textLength), style: TEXT_STYLE),
              _blinkingCursor()
            ],
          );
        });
  }

  Widget _blinkingCursor() {
    return LoopAnimation<int>(
      duration: 600.milliseconds,
      tween: 0.tweenTo(1),
      builder: (context, child, oneOrZero) {
        return Opacity(
            opacity: oneOrZero == 1 ? 1.0 : 0.0,
            child: Text("_", style: TEXT_STYLE));
      },
    );
  }
}

class TypewriterBoxDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: "Typewriter Box",
      pathToFile: "typewriter_box.dart",
      delayStartup: true,
      builder: (context) => Center(child: Box()),
    );
  }
}
