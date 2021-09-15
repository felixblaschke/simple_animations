# 🎭 Timeline Tween documentation

💡 _Note: These examples uses **[supercharged](https://pub.dev/packages/supercharged)** for syntactic sugar._

## Animate multiple properties

This example animates width, height and color of a box.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_multi_tween/v1/multitween-example-1.gif)

```dart
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
```

## Chained tweens in single animation

This example moves a box clockwise in a rectangular pattern.

![example2](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_multi_tween/v1/multitween-example-2.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(const MyApp());

// Create enum that defines the animated properties
enum AniProps { x, y }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Specify your tween
    final _tween = TimelineTween<AniProps>()
      ..addScene(begin: 0.seconds, duration: 1.seconds)
          .animate(AniProps.x, tween: (-100.0).tweenTo(100.0))
      ..addScene(begin: 1.seconds, duration: 1.seconds)
          .animate(AniProps.y, tween: (-100.0).tweenTo(100.0))
      ..addScene(begin: 2.seconds, duration: 1.seconds)
          .animate(AniProps.x, tween: (100.0).tweenTo(-100.0))
      ..addScene(begin: 3.seconds, duration: 1.seconds)
          .animate(AniProps.y, tween: (100.0).tweenTo(-100.0));

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
                  color: Colors.green,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
```

## Complex example

This example combines aspects of the examples above, including chaining and multiple properties.

![example3](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_multi_tween/v1/multitween-example-3.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(const MyApp());

// Create enum that defines the animated properties
enum AniProps { x, y, color }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Specify your tween
    final _tween = TimelineTween<AniProps>()
      ..addScene(begin: 0.seconds, duration: 1.seconds)
          .animate(
            AniProps.x,
            tween: (-100.0).tweenTo(100.0),
            curve: Curves.easeInOutSine,
          )
          .animate(AniProps.color, tween: Colors.red.tweenTo(Colors.yellow))
      ..addScene(begin: 1.seconds, duration: 1.seconds).animate(
        AniProps.y,
        tween: (-100.0).tweenTo(100.0),
        curve: Curves.easeInOutSine,
      )
      ..addScene(begin: 2.seconds, duration: 1.seconds).animate(
        AniProps.x,
        tween: (100.0).tweenTo(-100.0),
        curve: Curves.easeInOutSine,
      )
      ..addScene(begin: 1.seconds, end: 3.seconds)
          .animate(AniProps.color, tween: Colors.yellow.tweenTo(Colors.blue))
      ..addScene(begin: 3.seconds, duration: 1.seconds)
          .animate(
            AniProps.y,
            tween: (100.0).tweenTo(-100.0),
            curve: Curves.easeInOutSine,
          )
          .animate(AniProps.color, tween: Colors.blue.tweenTo(Colors.red));

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
```