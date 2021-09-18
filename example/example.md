# Examples

This page contains several animation examples for each feature.

## Table of contents

[**Stateless Animation**](#stateless-animation)
  - [Simple PlayAnimation widget](#simple-playanimation-widget)
  - [PlayAnimation widget with a child](#playanimation-widget-with-a-child)
  - [PlayAnimation with non-linear animation](#playanimation-with-non-linear-animation)
  - [PlayAnimation with delay](#playanimation-with-delay)
  - [LoopAnimation](#loopanimation)
  - [MirrorAnimation](#mirroranimation)
  - [CustomAnimation in stateless environment](#customanimation-in-stateless-environment)
  - [CustomAnimation in a stateful environment](#customanimation-in-a-stateful-environment)

[**Timeline Tween**](#timeline-tween)
  - [Animate multiple properties](#animate-multiple-properties)
  - [Chained tweens in single animation](#chained-tweens-in-single-animation)
  - [Complex example](#complex-example)

[**Anicoto**](#anicoto)
  - [Basic usage pattern](#basic-usage-pattern)
  - [Multiple AnimationController instances](#multiple-animationcontroller-instances)

## Stateless Animation

### Simple PlayAnimation widget

Animates the size of a square within a stateless widget.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-1.gif)

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

### PlayAnimation widget with a child

This example demonstrates the usage of a child widget along with `PlayAnimation`.

![example2](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-2.gif)

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

### PlayAnimation with non-linear animation

This example demonstrates a non-linear animation. A pink square increases it's size. The `easeOut` curve applied to the animation makes it slow down at the end.

![example3](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-3.gif)

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

### PlayAnimation with delay

This example demonstrates an animation that waits for two seconds before it starts it's animation.

![example4](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-4.gif)

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

### LoopAnimation

Animation that repeatly pops up a text.

![example5](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-5.gif)

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

### MirrorAnimation

This examples endlessly moves a green box from left to right.

![example6](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-6.gif)

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

### CustomAnimation in stateless environment

Example of a pulsing square created with a fully configured `CustomAnimation` widget.

![example7](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-7.gif)

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

### CustomAnimation in a stateful environment

This example demonstrates the usage of `CustomAnimation` in a stateful widget.

![example8](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-8.gif)

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
## Timeline Tween

### Animate multiple properties

This example animates width, height and color of a box.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_multi_tween/v1/multitween-example-1.gif)

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

### Chained tweens in single animation

This example moves a box clockwise in a rectangular pattern.

![example2](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_multi_tween/v1/multitween-example-2.gif)

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

### Complex example

This example combines aspects of the examples above, including chaining and multiple properties.

![example3](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_multi_tween/v1/multitween-example-3.gif)

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
## Anicoto

### Basic usage pattern

This example shows a complete app that uses `AnimationMixin` in a simple way.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_anicoto/v1/anicoto-1.gif)

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

### Multiple AnimationController instances

This example uses 3 unique `AnimationController` instances to animate width, height and color independently.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_anicoto/v1/anicoto-2.gif)

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