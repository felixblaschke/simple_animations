import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(const MyApp());

// Create enum that defines the animated properties
enum AniProps { width, height, color }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Specify your tween
    final TimelineTween<AniProps> _tween = TimelineTween<AniProps>()
      ..addScene(begin: 0.milliseconds, end: 1000.milliseconds)
          .animate(AniProps.width, tween: 0.0.tweenTo(100.0))
      ..addScene(begin: 1000.milliseconds, end: 1500.milliseconds)
          .animate(AniProps.width, tween: 100.0.tweenTo(200.0))
      ..addScene(begin: 0.milliseconds, duration: 2500.milliseconds)
          .animate(AniProps.height, tween: 0.0.tweenTo(200.0))
      ..addScene(begin: 0.milliseconds, duration: 3.seconds)
          .animate(AniProps.color, tween: Colors.red.tweenTo(Colors.blue));

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: PlayAnimation<TimelineValue<AniProps>>(
            tween: _tween, // Pass in tween
            duration: _tween.duration, // Obtain duration
            builder: (context, child, value) {
              return Container(
                width: value.get(AniProps.width), // Get animated value
                height: value.get(AniProps.height),
                color: value.get(AniProps.color),
              );
            },
          ),
        ),
      ),
    );
  }
}
