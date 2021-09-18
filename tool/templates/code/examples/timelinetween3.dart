import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MyApp());

// Create enum that defines the animated properties
enum AniProps { x, y, color }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Specify your tween
    final _tween = TimelineTween<AniProps>()
      ..addScene(
              begin: const Duration(seconds: 0),
              duration: const Duration(seconds: 1))
          .animate(
            AniProps.x,
            tween: Tween(begin: -100.0, end: 100.0),
            curve: Curves.easeInOutSine,
          )
          .animate(
            AniProps.color,
            tween: ColorTween(begin: Colors.red, end: Colors.yellow),
          )
      ..addScene(
              begin: const Duration(seconds: 1),
              duration: const Duration(seconds: 1))
          .animate(
        AniProps.y,
        tween: Tween(begin: -100.0, end: 100.0),
        curve: Curves.easeInOutSine,
      )
      ..addScene(
              begin: const Duration(seconds: 2),
              duration: const Duration(seconds: 1))
          .animate(
        AniProps.x,
        tween: Tween(begin: 100.0, end: -100.0),
        curve: Curves.easeInOutSine,
      )
      ..addScene(
              begin: const Duration(seconds: 1),
              end: const Duration(seconds: 3))
          .animate(AniProps.color,
              tween: ColorTween(begin: Colors.yellow, end: Colors.blue))
      ..addScene(
              begin: const Duration(seconds: 3),
              duration: const Duration(seconds: 1))
          .animate(
            AniProps.y,
            tween: Tween(begin: 100.0, end: -100.0),
            curve: Curves.easeInOutSine,
          )
          .animate(AniProps.color,
              tween: ColorTween(begin: Colors.blue, end: Colors.red));

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: LoopAnimation<TimelineValue<AniProps>>(
            tween: _tween, // Pass in tween
            duration: _tween.duration, // Obtain duration
            builder: (context, child, value) {
              return Transform.translate(
                // Get animated offset
                offset: Offset(value.get(AniProps.x), value.get(AniProps.y)),
                child: Container(
                  width: 100,
                  height: 100,
                  color: value.get(AniProps.color), // Get animated color
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
