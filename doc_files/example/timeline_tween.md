<!-- This file uses generated code. Visit https://pub.dev/packages/readme_helper for usage information. -->
## Timeline Tween

### Animate multiple properties

This example animates width, height and color of a box.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_multi_tween/v1/multitween-example-1.gif)

<!-- #code code/timelinetween1.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MyApp());

// Create enum that defines the animated properties
enum AniProps { width, height, color }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Specify your tween
    final TimelineTween<AniProps> _tween = TimelineTween<AniProps>()
      ..addScene(
              begin: const Duration(milliseconds: 0),
              end: const Duration(milliseconds: 1000))
          .animate(AniProps.width, tween: Tween(begin: 0.0, end: 100.0))
      ..addScene(
              begin: const Duration(milliseconds: 1000),
              end: const Duration(milliseconds: 1500))
          .animate(AniProps.width, tween: Tween(begin: 100.0, end: 200.0))
      ..addScene(
              begin: Duration.zero,
              duration: const Duration(milliseconds: 2500))
          .animate(AniProps.height, tween: Tween(begin: 0.0, end: 200.0))
      ..addScene(
              begin: Duration.zero,
              duration: const Duration(milliseconds: 3000))
          .animate(AniProps.color,
              tween: ColorTween(begin: Colors.red, end: Colors.blue));

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
<!-- // end of #code -->

### Chained tweens in single animation

This example moves a box clockwise in a rectangular pattern.

![example2](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_multi_tween/v1/multitween-example-2.gif)

<!-- #code code/timelinetween2.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MyApp());

// Create enum that defines the animated properties
enum AniProps { x, y }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Specify your tween
    final _tween = TimelineTween<AniProps>()
      ..addScene(begin: Duration.zero, duration: const Duration(seconds: 1))
          .animate(AniProps.x, tween: Tween(begin: -100.0, end: 100.0))
      ..addScene(
              begin: const Duration(seconds: 1),
              duration: const Duration(seconds: 1))
          .animate(AniProps.y, tween: Tween(begin: -100.0, end: 100.0))
      ..addScene(
              begin: const Duration(seconds: 2),
              duration: const Duration(seconds: 1))
          .animate(AniProps.x, tween: Tween(begin: 100.0, end: -100.0))
      ..addScene(
              begin: const Duration(seconds: 3),
              duration: const Duration(seconds: 1))
          .animate(AniProps.y, tween: Tween(begin: 100.0, end: -100.0));

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
<!-- // end of #code -->

### Complex example

This example combines aspects of the examples above, including chaining and multiple properties.

![example3](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_multi_tween/v1/multitween-example-3.gif)

<!-- #code code/timelinetween3.dart -->
```dart
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
```
<!-- // end of #code -->
