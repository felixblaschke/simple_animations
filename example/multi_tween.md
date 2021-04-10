

# 🎭 Multi Tween (predecessor of Timeline Tween)

💡 *Note: These examples uses **[supercharged](https://pub.dev/packages/supercharged)** for syntactic sugar.*

## Animate multiple properties

This example animates width, height and color of a box.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_multi_tween/v1/multitween-example-1.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MyApp());

// Create enum that defines the animated properties
enum AniProps { width, height, color }

class MyApp extends StatelessWidget {

  // Specify your tween
  final _tween = MultiTween<AniProps>()
    ..add(AniProps.width, 0.0.tweenTo(100.0), 1000.milliseconds)
    ..add(AniProps.width, 100.0.tweenTo(200.0), 500.milliseconds)
    ..add(AniProps.height, 0.0.tweenTo(200.0), 2500.milliseconds)
    ..add(AniProps.color, Colors.red.tweenTo(Colors.blue), 3.seconds);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: PlayAnimation<MultiTweenValues<AniProps>>(
            tween: _tween, // Pass in tween
            duration: _tween.duration, // Obtain duration from MultiTween
            builder: (context, child, value) {
              return Container(
                width: value.get(AniProps.width), // Get animated value for width
                height: value.get(AniProps.height), // Get animated value for height
                color: value.get(AniProps.color), // Get animated value for color
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

void main() => runApp(MyApp());

// Create enum that defines the animated properties
enum AniProps { offset }

class MyApp extends StatelessWidget {
  // Specify your tween
  final _tween = MultiTween<AniProps>()
    ..add( // top left => top right
        AniProps.offset,
        Tween(begin: Offset(-100, -100), end: Offset(100, -100)),
        1000.milliseconds)
    ..add( // top right => bottom right
        AniProps.offset,
        Tween(begin: Offset(100, -100), end: Offset(100, 100)),
        1000.milliseconds)
    ..add( // bottom right => bottom left
        AniProps.offset,
        Tween(begin: Offset(100, 100), end: Offset(-100, 100)),
        1000.milliseconds)
    ..add( // bottom left => top left
        AniProps.offset,
        Tween(begin: Offset(-100, 100), end: Offset(-100, -100)),
        1000.milliseconds);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: LoopAnimation<MultiTweenValues<AniProps>>(
            tween: _tween, // Pass in tween
            duration: _tween.duration, // Obtain duration from MultiTween
            builder: (context, child, value) {
              return Transform.translate(
                offset: value.get(AniProps.offset), // Get animated offset
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

void main() => runApp(MyApp());

// Create enum that defines the animated properties
enum AniProps { offset, color }

class MyApp extends StatelessWidget {
  // Specify your tween
  final _tween = MultiTween<AniProps>()
    ..add(
      // top left => top right
        AniProps.offset,
        Tween(begin: Offset(-100, -100), end: Offset(100, -100)),
        1000.milliseconds, Curves.easeInOutSine)
    ..add(
      // top right => bottom right
        AniProps.offset,
        Tween(begin: Offset(100, -100), end: Offset(100, 100)),
        1000.milliseconds, Curves.easeInOutSine)
    ..add(
      // bottom right => bottom left
        AniProps.offset,
        Tween(begin: Offset(100, 100), end: Offset(-100, 100)),
        1000.milliseconds, Curves.easeInOutSine)
    ..add(
      // bottom left => top left
        AniProps.offset,
        Tween(begin: Offset(-100, 100), end: Offset(-100, -100)),
        1000.milliseconds, Curves.easeInOutSine)
    ..add(AniProps.color, Colors.red.tweenTo(Colors.yellow), 1.seconds)
    ..add(AniProps.color, Colors.yellow.tweenTo(Colors.blue), 2.seconds)
    ..add(AniProps.color, Colors.blue.tweenTo(Colors.red), 1.seconds);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: LoopAnimation<MultiTweenValues<AniProps>>(
            tween: _tween, // Pass in tween
            duration: _tween.duration, // Obtain duration from MultiTween
            builder: (context, child, value) {
              return Transform.translate(
                offset: value.get(AniProps.offset), // Get animated offset
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
