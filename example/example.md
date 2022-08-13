<!-- This file uses generated code. Visit https://pub.dev/packages/readme_helper for usage information. -->
<!-- This file uses generated code. Visit https://pub.dev/packages/readme_helper for usage information. -->

# Examples

This page contains several animation examples for each feature.

<!-- #toc -->
## Table of Contents

[**Animation Builder**](#animation-builder)
  - [Simple PlayAnimationBuilder widget](#simple-playanimationbuilder-widget)
  - [PlayAnimationBuilder widget with a child](#playanimationbuilder-widget-with-a-child)
  - [PlayAnimationBuilder with non-linear animation](#playanimationbuilder-with-non-linear-animation)
  - [PlayAnimationBuilder with delay](#playanimationbuilder-with-delay)
  - [LoopAnimation](#loopanimation)
  - [MirrorAnimation](#mirroranimation)
  - [CustomAnimationBuilder in stateless environment](#customanimationbuilder-in-stateless-environment)
  - [CustomAnimationBuilder in a stateful environment](#customanimationbuilder-in-a-stateful-environment)

[**Movie Tween**](#movie-tween)
  - [Animate multiple properties](#animate-multiple-properties)
  - [Chained tweens in single animation](#chained-tweens-in-single-animation)
  - [Complex example](#complex-example)

[**Animation Mixin**](#animation-mixin)
  - [Basic usage pattern](#basic-usage-pattern)
  - [Multiple AnimationController instances](#multiple-animationcontroller-instances)
<!-- // end of #toc -->

## Animation Builder

### Simple PlayAnimationBuilder widget

Animates the size of a square within a stateless widget.

![example1](https://github.com/felixblaschke/simple_animations/raw/main/example/img/s1.gif)

<!-- #code sa_flutter_app/lib/example/sa1.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // plays an animation once
    return PlayAnimationBuilder<double>(
      tween: Tween(begin: 50.0, end: 200.0), // set tween
      duration: const Duration(seconds: 5), // set duration
      builder: (context, value, _) {
        return Container(
          width: value, // apply animated value from builder function parameter
          height: value,
          color: Colors.green,
        );
      },
    );
  }
}
```
<!-- // end of #code -->

### PlayAnimationBuilder widget with a child

This example demonstrates the usage of a child widget along with `PlayAnimationBuilder`.

![example2](https://github.com/felixblaschke/simple_animations/raw/main/example/img/s2.gif)

<!-- #code sa_flutter_app/lib/example/sa2.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimationBuilder<double>(
      tween: Tween(begin: 50.0, end: 200.0),
      duration: const Duration(seconds: 5),
      child: const Center(child: Text('Hello!')), // pass in static child
      builder: (context, value, child) {
        return Container(
          width: value,
          height: value,
          color: Colors.green,
          child: child, // use child inside the animation
        );
      },
    );
  }
}
```
<!-- // end of #code -->

### PlayAnimationBuilder with non-linear animation

This example demonstrates a non-linear animation. A pink square increases it's size. The `easeOut` curve applied to the animation makes it slow down at the end.

![example3](https://github.com/felixblaschke/simple_animations/raw/main/example/img/s3.gif)

<!-- #code sa_flutter_app/lib/example/sa3.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 200.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Container(
          width: value,
          height: value,
          color: Colors.pink,
        );
      },
    );
  }
}
```
<!-- // end of #code -->

### PlayAnimationBuilder with delay

This example demonstrates an animation that waits for two seconds before it starts it's animation.

![example4](https://github.com/felixblaschke/simple_animations/raw/main/example/img/s4.gif)

<!-- #code sa_flutter_app/lib/example/sa4.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimationBuilder<double>(
      tween: Tween(begin: 100.0, end: 200.0),
      duration: const Duration(seconds: 2),
      delay: const Duration(seconds: 1),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Container(
          width: value,
          height: 50.0,
          color: Colors.orange,
        );
      },
    );
  }
}
```
<!-- // end of #code -->

### LoopAnimation

Animation that repeatly pops up a text.

![example5](https://github.com/felixblaschke/simple_animations/raw/main/example/img/s5.gif)

<!-- #code sa_flutter_app/lib/example/sa5.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoopAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 10.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: const Text('Hello!'),
    );
  }
}
```
<!-- // end of #code -->

### MirrorAnimation

This examples endlessly moves a green box from left to right.

![example6](https://github.com/felixblaschke/simple_animations/raw/main/example/img/s6.gif)

<!-- #code sa_flutter_app/lib/example/sa6.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MirrorAnimationBuilder<double>(
      tween: Tween(begin: -100.0, end: 100.0), // value for offset x-coordinate
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOutSine, // non-linear animation
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value, 0), // use animated value for x-coordinate
          child: child,
        );
      },
      child: Container(
        width: 100,
        height: 100,
        color: Colors.green,
      ),
    );
  }
}
```
<!-- // end of #code -->

### CustomAnimationBuilder in stateless environment

Example of a pulsing square created with a fully configured `CustomAnimationBuilder` widget.

![example7](https://github.com/felixblaschke/simple_animations/raw/main/example/img/s7.gif)

<!-- #code sa_flutter_app/lib/example/sa7.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<double>(
      control: Control.mirror,
      tween: Tween(begin: 100.0, end: 200.0),
      duration: const Duration(seconds: 2),
      delay: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      startPosition: 0.5,
      animationStatusListener: (status) {
        debugPrint('status updated: $status');
      },
      builder: (context, value, child) {
        return Container(
          width: value,
          height: value,
          color: Colors.blue,
          child: child,
        );
      },
      child: const Center(
          child: Text('Hello!',
              style: TextStyle(color: Colors.white, fontSize: 24))),
    );
  }
}
```
<!-- // end of #code -->

### CustomAnimationBuilder in a stateful environment

This example demonstrates the usage of `CustomAnimationBuilder` in a stateful widget.

![example8](https://github.com/felixblaschke/simple_animations/raw/main/example/img/s8.gif)

<!-- #code sa_flutter_app/lib/example/sa8.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatefulWidget {
  const Page({Key? key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  Control control = Control.play; // state variable

  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<double>(
      duration: const Duration(seconds: 1),
      control: control, // bind state variable to parameter
      tween: Tween(begin: -100.0, end: 100.0),
      builder: (context, value, child) {
        return Transform.translate(
          // animation that moves childs from left to right
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: MaterialButton(
        // there is a button
        color: Colors.yellow,
        onPressed:
            toggleDirection, // clicking button changes animation direction
        child: const Text('Swap'),
      ),
    );
  }

  void toggleDirection() {
    // toggle between control instructions
    setState(() {
      control = (control == Control.play) ? Control.playReverse : Control.play;
    });
  }
}
```
<!-- // end of #code -->

## Movie Tween

### Animate multiple properties

This example animates width, height and color of a box.

![example1](https://github.com/felixblaschke/simple_animations/raw/main/example/img/t1.gif)

<!-- #code sa_flutter_app/lib/example/movietween1.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Specify your tween
    final MovieTween tween = MovieTween()
      ..scene(
              begin: const Duration(milliseconds: 0),
              end: const Duration(milliseconds: 1000))
          .tween('width', Tween(begin: 0.0, end: 100.0))
      ..scene(
              begin: const Duration(milliseconds: 1000),
              end: const Duration(milliseconds: 1500))
          .tween('width', Tween(begin: 100.0, end: 200.0))
      ..scene(
              begin: const Duration(milliseconds: 0),
              duration: const Duration(milliseconds: 2500))
          .tween('height', Tween(begin: 0.0, end: 200.0))
      ..scene(
              begin: const Duration(milliseconds: 0),
              duration: const Duration(milliseconds: 3000))
          .tween('color', ColorTween(begin: Colors.red, end: Colors.blue));

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: PlayAnimationBuilder<Movie>(
            tween: tween, // Pass in tween
            duration: tween.duration, // Obtain duration
            builder: (context, value, child) {
              return Container(
                width: value.get('width'), // Get animated values
                height: value.get('height'),
                color: value.get('color'),
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

![example2](https://github.com/felixblaschke/simple_animations/raw/main/example/img/t2.gif)

<!-- #code sa_flutter_app/lib/example/movietween2.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Specify your tween
    final tween = MovieTween()
      ..tween('x', Tween(begin: -100.0, end: 100.0),
              duration: const Duration(seconds: 1))
          .thenTween('y', Tween(begin: -100.0, end: 100.0),
              duration: const Duration(seconds: 1))
          .thenTween('x', Tween(begin: 100.0, end: -100.0),
              duration: const Duration(seconds: 1))
          .thenTween('y', Tween(begin: 100.0, end: -100.0),
              duration: const Duration(seconds: 1));

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: LoopAnimationBuilder<Movie>(
            tween: tween, // Pass in tween
            duration: tween.duration, // Obtain duration
            builder: (context, value, child) {
              return Transform.translate(
                // Get animated offset
                offset: Offset(value.get('x'), value.get('y')),
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

![example3](https://github.com/felixblaschke/simple_animations/raw/main/example/img/t3.gif)

<!-- #code sa_flutter_app/lib/example/movietween3.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Variant with typed properties
    final x = MovieTweenProperty<double>();
    final y = MovieTweenProperty<double>();
    final color = MovieTweenProperty<Color?>();

    // Specify your tween
    final tween = MovieTween()
      ..scene(
              begin: const Duration(seconds: 0),
              duration: const Duration(seconds: 1))
          .tween(x, Tween(begin: -100.0, end: 100.0),
              curve: Curves.easeInOutSine)
          .tween(color, ColorTween(begin: Colors.red, end: Colors.yellow))
      ..scene(
              begin: const Duration(seconds: 1),
              duration: const Duration(seconds: 1))
          .tween(y, Tween(begin: -100.0, end: 100.0),
              curve: Curves.easeInOutSine)
      ..scene(
              begin: const Duration(seconds: 2),
              duration: const Duration(seconds: 1))
          .tween(x, Tween(begin: 100.0, end: -100.0),
              curve: Curves.easeInOutSine)
      ..scene(
              begin: const Duration(seconds: 1),
              end: const Duration(seconds: 3))
          .tween(color, ColorTween(begin: Colors.yellow, end: Colors.blue))
      ..scene(
              begin: const Duration(seconds: 3),
              duration: const Duration(seconds: 1))
          .tween(y, Tween(begin: 100.0, end: -100.0),
              curve: Curves.easeInOutSine)
          .tween(color, ColorTween(begin: Colors.blue, end: Colors.red));

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: LoopAnimationBuilder<Movie>(
            tween: tween, // Pass in tween
            duration: tween.duration, // Obtain duration
            builder: (context, value, child) {
              return Transform.translate(
                // Get animated offset
                offset: Offset(x.from(value), y.from(value)),
                child: Container(
                  width: 100,
                  height: 100,
                  color: color.from(value), // Get animated color
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

## Animation Mixin

### Basic usage pattern

This example shows a complete app that uses `AnimationMixin` in a simple way.

![example1](https://github.com/felixblaschke/simple_animations/raw/main/example/img/a1.gif)

<!-- #code sa_flutter_app/lib/example/am1.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MaterialApp(home: Page()));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: MyAnimatedWidget())),
    );
  }
}

class MyAnimatedWidget extends StatefulWidget {
  const MyAnimatedWidget({Key? key}) : super(key: key);

  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

// Add AnimationMixin to state class
class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {
  late Animation<double> size; // Declare animation variable

  @override
  void initState() {
    // The controller is automatically provided by the mixin.
    // Connect tween and controller and store into animation variable.
    size = Tween(begin: 0.0, end: 200.0).animate(controller);

    // Start the animation playback
    controller.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.value, // Use the value of the animation variable
      height: size.value,
      color: Colors.red,
    );
  }
}
```
<!-- // end of #code -->

### Multiple AnimationController instances

This example uses 3 unique `AnimationController` instances to animate width, height and color independently.

![example1](https://github.com/felixblaschke/simple_animations/raw/main/example/img/a2.gif)

<!-- #code sa_flutter_app/lib/example/am2.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MaterialApp(home: Page()));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: MyAnimatedWidget())),
    );
  }
}

class MyAnimatedWidget extends StatefulWidget {
  const MyAnimatedWidget({Key? key}) : super(key: key);

  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {
  // declare AnimationControllers
  late AnimationController widthController;
  late AnimationController heightController;
  late AnimationController colorController;

  // declare Animation variables
  late Animation<double> width;
  late Animation<double> height;
  late Animation<Color?> color;

  @override
  void initState() {
    // create controller instances and use mirror animation behavior
    widthController = createController()
      ..mirror(duration: const Duration(seconds: 5));
    heightController = createController()
      ..mirror(duration: const Duration(seconds: 3));
    colorController = createController()
      ..mirror(duration: const Duration(milliseconds: 1500));

    // connect tween with individual controllers
    width = Tween(begin: 100.0, end: 200.0).animate(widthController);
    height = Tween(begin: 100.0, end: 200.0).animate(heightController);
    color = ColorTween(begin: Colors.red, end: Colors.blue)
        .animate(colorController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.value, //  use animated values
      height: height.value,
      color: color.value,
    );
  }
}
```
<!-- // end of #code -->