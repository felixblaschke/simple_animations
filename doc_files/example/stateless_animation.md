<!-- This file uses generated code. Visit https://pub.dev/packages/readme_helper for usage information. -->
## Stateless Animation

### Simple PlayAnimation widget

Animates the size of a square within a stateless widget.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-1.gif)

<!-- #code code/sa1.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: Tween(begin: 50.0, end: 200.0), // specify tween
      duration: const Duration(seconds: 5), // set a duration
      builder: (context, child, value) {
        // <-- use builder function
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

### PlayAnimation widget with a child

This example demonstrates the usage of a child widget along with `PlayAnimation`.

![example2](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-2.gif)

<!-- #code code/sa2.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: Tween(begin: 50.0, end: 200.0),
      duration: const Duration(seconds: 5),
      child: // specify child widget
          const Center(child: Text('Hello!')),
      builder: (context, child, value) {
        // obtain child via function parameter
        return Container(
          width: value,
          height: value,
          color: Colors.green,
          child: child, // place child inside the animation
        );
      },
    );
  }
}
```
<!-- // end of #code -->

### PlayAnimation with non-linear animation

This example demonstrates a non-linear animation. A pink square increases it's size. The `easeOut` curve applied to the animation makes it slow down at the end.

![example3](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-3.gif)

<!-- #code code/sa3.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: Tween(begin: 0.0, end: 200.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
      builder: (context, child, value) {
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

### PlayAnimation with delay

This example demonstrates an animation that waits for two seconds before it starts it's animation.

![example4](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-4.gif)

<!-- #code code/sa4.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: Tween(begin: 100.0, end: 200.0),
      duration: const Duration(seconds: 2),
      delay: const Duration(seconds: 1),
      curve: Curves.easeOut,
      builder: (context, child, value) {
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

![example5](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-5.gif)

<!-- #code code/sa5.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoopAnimation<double>(
      tween: Tween(begin: 0.0, end: 10.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
      builder: (context, child, value) {
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

![example6](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-6.gif)

<!-- #code code/sa6.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MirrorAnimation<double>(
      tween: Tween(begin: -100.0, end: 100.0), // value for offset x-coordinate
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOutSine, // non-linear animation
      builder: (context, child, value) {
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

### CustomAnimation in stateless environment

Example of a pulsing square created with a fully configured `CustomAnimation` widget.

![example7](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-7.gif)

<!-- #code code/sa7.dart -->
```dart
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() =>
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      control: CustomAnimationControl.mirror,
      tween: Tween(begin: 100.0, end: 200.0),
      duration: const Duration(seconds: 2),
      delay: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      startPosition: 0.5,
      animationStatusListener: (status) {
        print('status updated: $status');
      },
      builder: (context, child, value) {
        return Container(
            width: value, height: value, color: Colors.blue, child: child);
      },
      child: const Center(
          child: Text(
        'Hello!',
        style: TextStyle(color: Colors.white, fontSize: 24),
      )),
    );
  }
}
```
<!-- // end of #code -->

### CustomAnimation in a stateful environment

This example demonstrates the usage of `CustomAnimation` in a stateful widget.

![example8](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-8.gif)

<!-- #code code/sa8.dart -->
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
  CustomAnimationControl control =
      CustomAnimationControl.play; // state variable

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      control: control, // bind state variable to parameter
      tween: Tween(begin: -100.0, end: 100.0),
      builder: (context, child, value) {
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
      control = (control == CustomAnimationControl.play)
          ? CustomAnimationControl.playReverse
          : CustomAnimationControl.play;
    });
  }
}
```
<!-- // end of #code -->
