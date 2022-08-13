<!-- This file uses generated code. Visit https://pub.dev/packages/readme_helper for usage information. -->

# 🎬 Simple Animations

[![Pub](https://img.shields.io/pub/v/simple_animations.svg)](https://pub.dartlang.org/packages/simple_animations)
[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue)](https://github.com/Solido/awesome-flutter)
[![Flutter gems - Top 5 Animation packages](https://img.shields.io/badge/Flutter%20gems-TOP%205%20Animation%20packages-blue)](https://fluttergems.dev/animation-transition/)

**Simple Animations** simplifies the process of creating beautiful custom animations:

- Easily create **custom animations in stateless widgets**
- Animate **multiple properties** at once
- Create **staggered animations** within seconds
- Simplified working with **AnimationController** instances
- Debug animations

<!-- #toc -->
## Table of Contents

[**Quickstart**](#quickstart)
  - [Animation Builder - Quickstart](#animation-builder---quickstart)
  - [Movie Tween - Quickstart](#movie-tween---quickstart)
  - [Animation Mixin - Quickstart](#animation-mixin---quickstart)
  - [Animation Developer Tools - Quickstart](#animation-developer-tools---quickstart)

[**Animation Builder**](#animation-builder)
  - [Essential parts of the animation](#essential-parts-of-the-animation)
  - [PlayAnimationBuilder](#playanimationbuilder)
  - [LoopAnimationBuilder](#loopanimationbuilder)
  - [MirrorAnimationBuilder](#mirroranimationbuilder)
  - [CustomAnimationBuilder](#customanimationbuilder)

[**Movie Tween**](#movie-tween)
  - [Basic usage pattern](#basic-usage-pattern)
  - [Scenes](#scenes)
  - [Animate properties](#animate-properties)
  - [Curves](#curves)
  - [Extrapolation](#extrapolation)
  - [Use developer tools](#use-developer-tools)
  - [Animation duration](#animation-duration)

[**Animation Mixin**](#animation-mixin)
  - [Basic usage pattern](#basic-usage-pattern)
  - [Create multiple AnimationController](#create-multiple-animationcontroller)

[**Shortcuts for AnimationController**](#shortcuts-for-animationcontroller)

[**Animation Developer Tools**](#animation-developer-tools)
  - [Basic usage pattern](#basic-usage-pattern)
  - [Features and tricks](#features-and-tricks)
<!-- // end of #toc -->

## Quickstart

Directly dive in and let the code speak for itself.

### Animation Builder - Quickstart

Animation Builder are powerful widgets to easily create custom animations.

<!-- #code example/sa_flutter_app/lib/readme/animation_builder.dart -->
```dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class ResizeCubeAnimation extends StatelessWidget {
  const ResizeCubeAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PlayAnimationBuilder plays animation once
    return PlayAnimationBuilder<double>(
      tween: Tween(begin: 100.0, end: 200.0), // 100.0 to 200.0
      duration: const Duration(seconds: 1), // for 1 second
      builder: (context, value, _) {
        return Container(
          width: value, // use animated value
          height: value,
          color: Colors.blue,
        );
      },
      onCompleted: () {
        // do something ...
      },
    );
  }
}

class RotatingBox extends StatelessWidget {
  const RotatingBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // LoopAnimationBuilder plays forever: from beginning to end
    return LoopAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 2 * pi), // 0° to 360° (2π)
      duration: const Duration(seconds: 2), // for 2 seconds per iteration
      builder: (context, value, _) {
        return Transform.rotate(
          angle: value, // use value
          child: Container(color: Colors.blue, width: 100, height: 100),
        );
      },
    );
  }
}

class ColorFadeLoop extends StatelessWidget {
  const ColorFadeLoop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MirrorAnimationBuilder plays forever: alternating forward and backward
    return MirrorAnimationBuilder<Color?>(
      tween: ColorTween(begin: Colors.red, end: Colors.blue), // red to blue
      duration: const Duration(seconds: 5), // for 5 seconds per iteration
      builder: (context, value, _) {
        return Container(
          color: value, // use animated value
          width: 100,
          height: 100,
        );
      },
    );
  }
}
```
<!-- // end of #code -->

[**Read guide**](#animation-builder) or [**watch examples**](example/example.md#animation-builder).

---

### Movie Tween - Quickstart

Movie Tween combines multiple tween into one, including timeline control and value extrapolation.

<!-- #code example/sa_flutter_app/lib/readme/movie_tween.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// Simple staggered tween
final tween1 = MovieTween()
  ..tween('width', Tween(begin: 0.0, end: 100),
          duration: const Duration(milliseconds: 1500), curve: Curves.easeIn)
      .thenTween('width', Tween(begin: 100, end: 200),
          duration: const Duration(milliseconds: 750), curve: Curves.easeOut);

// Design tween by composing scenes
final tween2 = MovieTween()
  ..scene(
          begin: const Duration(milliseconds: 0),
          duration: const Duration(milliseconds: 500))
      .tween('width', Tween<double>(begin: 0.0, end: 400.0))
      .tween('height', Tween<double>(begin: 500.0, end: 200.0))
      .tween('color', ColorTween(begin: Colors.red, end: Colors.blue))
  ..scene(
          begin: const Duration(milliseconds: 700),
          end: const Duration(milliseconds: 1200))
      .tween('width', Tween<double>(begin: 400.0, end: 500.0));

// Type-safe alternative
final width = MovieTweenProperty<double>();
final color = MovieTweenProperty<Color?>();

final tween3 = MovieTween()
  ..tween<double>(width, Tween(begin: 0.0, end: 100))
  ..tween<Color?>(color, ColorTween(begin: Colors.red, end: Colors.blue));
```
<!-- // end of #code -->

[**Read guide**](#movie-tween) or [**watch examples**](example/example.md#movie-tween).

---

### Animation Mixin - Quickstart

The **Animation Mixin** manages `AnimationController` instances for you.
No more boilerplate code.

<!-- #code example/sa_flutter_app/lib/readme/animation_mixin.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

// Add AnimationMixin
class _MyWidgetState extends State<MyWidget> with AnimationMixin {
  late Animation<double> size;

  @override
  void initState() {
    // The AnimationController instance `controller` is already wired up.
    // Just connect with it with the tweens.
    size = Tween<double>(begin: 0.0, end: 200.0).animate(controller);

    controller.play(); // start the animation playback

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.value, // use animated value
      height: size.value,
      color: Colors.red,
    );
  }
}
```
<!-- // end of #code -->

[**Read guide**](#animation-mixin) or [**watch examples**](example/example.md#animation-mixin).

---

### Animation Developer Tools - Quickstart

Helps you fine tuning the animation. It allows you to pause anywhere, scroll around, speed up, slow down or focus on a certain part of the animation.

![devtools](https://github.com/felixblaschke/simple_animations/raw/main/example/img/d1.gif)

[**Read guide**](#animation-developer-tools-guide)

&nbsp;

## Animation Builder

Animation Builder enables developers to craft custom animations with simple widgets.

### Essential parts of the animation

You need three things to create an animation:

- **tween**: What _value_ is changing within the animation?
- **duration**: How long does the animation take?
- **builder**: How does the UI look like regarding the changing _value_?

#### Tween

The `tween` is the description of your animation. Mostly it will change a value from A to B. Tweens describe **what** will happen but **not how fast it will happen**.

<!-- #code example/sa_flutter_app/lib/readme/animation_builder/pa_tween.dart -->
```dart
import 'package:flutter/material.dart';

// Animate a color from red to blue
var colorTween = ColorTween(begin: Colors.red, end: Colors.blue);

// Animate a double value from 0 to 100
var doubleTween = Tween<double>(begin: 0.0, end: 100.0);
```
<!-- // end of #code -->

To animate multiple properties, use a [Movie Tween](#movie-tween).

#### Duration

The `duration` is the time the animation takes.

#### Builder

The `builder` is a function that is called for **each new rendered frame** of your animation. It takes three parameters: `context`, `value` and `child`.

- `context` is your Flutter `BuildContext`

- `value` is **current value** of any animated variable, produced by the tween. If your tween is `Tween<double>(begin: 0.0, end: 100.0)`, the `value` is a `double` somewhere between `0.0` and `100.0`.

- `child` can be a widget that you might pass in a Animation Builder widget. This widget stays constant and is not affected by the animation.

How often the `builder` function is called, depends on the animation duration, and the framerate of the device used.

### PlayAnimationBuilder

The PlayAnimationBuilder is a widget that plays an animation once.

<!-- #code example/sa_flutter_app/lib/readme/animation_builder/pa_basic.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// Use type `Color?` because ColorTween produces type `Color?`
var widget = PlayAnimationBuilder<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue), // define tween
  duration: const Duration(seconds: 5), // define duration
  builder: (context, value, _) {
    return Container(
      color: value, // use animated color
      width: 100,
      height: 100,
    );
  },
);
```
<!-- // end of #code -->

#### Delay

By default, animations will play automatically. You can set a `delay` to make `PlayAnimationBuilder` wait for a given amount of time.

<!-- #code example/sa_flutter_app/lib/readme/animation_builder/pa_delay.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimationBuilder<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 5),
  delay: const Duration(seconds: 2), // add delay
  builder: (context, value, _) {
    return Container(
      color: value,
      width: 100,
      height: 100,
    );
  },
);
```
<!-- // end of #code -->

#### Non-linear motion

You can make your animation more appealing by applying non-linear motion behavior to it.
Just pass a `curve` into the widget.

Flutter comes with a set of predefined curves inside the `Curves` class.

<!-- #code example/sa_flutter_app/lib/readme/animation_builder/pa_curve.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimationBuilder<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 5),
  curve: Curves.easeInOut, // specify curve
  builder: (context, value, _) {
    return Container(
      color: value,
      width: 100,
      height: 100,
    );
  },
);
```
<!-- // end of #code -->

#### Animation lifecycle

You can react to the animation status by setting callbacks.

<!-- #code example/sa_flutter_app/lib/readme/animation_builder/pa_lifecycle.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimationBuilder<Color?>(
  // lifecycle callbacks
  onStarted: () => debugPrint('Animation started'),
  onCompleted: () => debugPrint('Animation complete'),

  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 5),
  builder: (context, value, _) =>
      Container(color: value, width: 100, height: 100),
);
```
<!-- // end of #code -->

#### Using child widgets

Parts of the UI that are not effected by the animated value can be passed as a `Widget` into the `child` property. That `Widget` is available within the `builder` function.
They will not rebuild when animated value changes and therefore has a positive performance impact.

<!-- #code example/sa_flutter_app/lib/readme/animation_builder/pa_child.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimationBuilder<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 5),
  // child gets passed into builder function
  builder: (context, value, child) {
    return Container(
      color: value,
      width: 100,
      height: 100,
      child: child, // use child
    );
  },
  child: const Text('Hello World'), // specify child widget
);
```
<!-- // end of #code -->

#### Using keys

If Flutter swaps out a `PlayAnimationBuilder` with another different `PlayAnimationBuilder` in a rebuild, it may recycle the first one.
This may lead to a undesired behavior.
In such a case use the `key` property.

You may [watch this introduction](https://www.youtube.com/watch?v=kn0EOS-ZiIc) to `Key`.

#### App example

<!-- #code example/sa_flutter_app/lib/readme/animation_builder/example_play_animation.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(
    const MaterialApp(home: Scaffold(body: Center(child: AnimatedGreenBox()))));

class AnimatedGreenBox extends StatelessWidget {
  const AnimatedGreenBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimationBuilder<double>(
      // specify tween (from 50.0 to 200.0)
      tween: Tween<double>(begin: 50.0, end: 200.0),

      // set a duration
      duration: const Duration(seconds: 5),

      // set a curve
      curve: Curves.easeInOut,

      // use builder function
      builder: (context, value, child) {
        // apply animated value obtained from builder function parameter
        return Container(
          width: value,
          height: value,
          color: Colors.green,
          child: child,
        );
      },
      child: const Text('Hello World'),
    );
  }
}
```
<!-- // end of #code -->

### LoopAnimationBuilder

A `LoopAnimationBuilder` repeatedly plays the animation from the start to the end over and over again.

<!-- #code example/sa_flutter_app/lib/readme/animation_builder/loop_animation.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = LoopAnimationBuilder<Color?>(
  // mandatory parameters
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 5),
  builder: (context, value, child) {
    return Container(color: value, width: 100, height: 100, child: child);
  },
  // optional parameters
  curve: Curves.easeInOut,
  child: const Text('Hello World'),
);
```
<!-- // end of #code -->

### MirrorAnimationBuilder

A `MirrorAnimationBuilder` repeatedly plays the animation from the start to the end, then reverse to the start, then again forward and so on.

<!-- #code example/sa_flutter_app/lib/readme/animation_builder/mirror_animation.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = MirrorAnimationBuilder<Color?>(
  // mandatory parameters
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 5),
  builder: (context, value, child) {
    return Container(color: value, width: 100, height: 100, child: child);
  },
  // optional parameters
  curve: Curves.easeInOut,
  child: const Text('Hello World'),
);
```
<!-- // end of #code -->

### CustomAnimationBuilder

Use `CustomAnimationBuilder` if the animation widgets discussed above aren't sufficient for you use case. Beside all parameters mentioned for `PlayAnimationBuilder` it allows you actively control the animation.

#### Control the animation

The `control` parameter can be set to the following values:

| Control.VALUE        | Description                                                                                                                |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `stop`               | Stops the animation at the current position.                                                                               |
| `play`               | Plays the animation from the current position to the end.                                                                  |
| `playReverse`        | Plays the animation from the current position reverse to the start.                                                        |
| `playFromStart`      | Resets the animation position to the beginning (`0.0`) and starts playing to the end.                                      |
| `playReverseFromEnd` | Resets the position of the animation to end (`1.0`) and starts playing backwards to the start.                             |
| `loop`               | Endlessly plays the animation from the start to the end.                                                                   |
| `mirror`             | Endlessly plays the animation from the start to the end, then it plays reverse to the start, then forward again and so on. |

You can bind the `control` value to state variable and change it during the animation. The `CustomAnimationBuilder` will adapt to that.

<!-- #code example/sa_flutter_app/lib/readme/animation_builder/example_control.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(
    const MaterialApp(home: Scaffold(body: Center(child: SwappingButton()))));

class SwappingButton extends StatefulWidget {
  const SwappingButton({Key? key}) : super(key: key);

  @override
  _SwappingButtonState createState() => _SwappingButtonState();
}

class _SwappingButtonState extends State<SwappingButton> {
  var control = Control.play; // define variable

  void _toggleDirection() {
    setState(() {
      // let the animation play to the opposite direction
      control = control == Control.play ? Control.playReverse : Control.play;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<double>(
      control: control, // bind variable with control instruction
      tween: Tween<double>(begin: -100.0, end: 100.0),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        // moves child from left to right
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: OutlinedButton(
        // clicking button changes animation direction
        onPressed: _toggleDirection,
        child: const Text('Swap'),
      ),
    );
  }
}
```
<!-- // end of #code -->

#### Start position

By default the animation starts from the beginning (`0.0`). You can change this by setting the `startPosition` parameter. It can be set to a value between `0.0` (beginning) and `1.0` (end).

<!-- #code example/sa_flutter_app/lib/readme/animation_builder/start_position.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = CustomAnimationBuilder<Color?>(
  control: Control.play,
  startPosition: 0.5, // set start position at 50%
  duration: const Duration(seconds: 5),
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  builder: (context, value, child) {
    return Container(color: value, width: 100, height: 100);
  },
);
```
<!-- // end of #code -->

#### Animation lifecycle

You can react to the animation status by setting callbacks.

<!-- #code example/sa_flutter_app/lib/readme/animation_builder/ca_lifecycle.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = CustomAnimationBuilder<Color?>(
  // lifecycle callbacks
  onStarted: () => debugPrint('Animation started'),
  onCompleted: () => debugPrint('Animation complete'),

  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 5),
  builder: (context, value, child) {
    return Container(color: value, width: 100, height: 100);
  },
);
```
<!-- // end of #code -->

It's also possible to directly access the `AnimationStatusListener` of the internal `AnimationController`.

<!-- #code example/sa_flutter_app/lib/readme/animation_builder/animation_status.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = CustomAnimationBuilder<Color?>(
  animationStatusListener: (AnimationStatus status) {
    // provide listener
    if (status == AnimationStatus.completed) {
      debugPrint('Animation completed!');
    }
  },
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 5),
  builder: (context, value, child) {
    return Container(color: value, width: 100, height: 100);
  },
);
```
<!-- // end of #code -->

&nbsp;

## Movie Tween

Movie Tween combines multiple tween into one, including timeline control and value extrapolation.

### Basic usage pattern

Create a new `MovieTween` and use the `tween()` to tween multiples values:

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/basic1.dart -->
```dart
final tween = MovieTween();

tween.tween('width', Tween(begin: 0.0, end: 100.0),
    duration: const Duration(milliseconds: 700));

tween.tween('height', Tween(begin: 100.0, end: 200.0),
    duration: const Duration(milliseconds: 700));
```
<!-- // end of #code -->

You can use `..` to get a nice builder style syntax:

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/basic1_builder.dart -->
```dart
final tween = MovieTween()
  ..tween('width', Tween(begin: 0.0, end: 100.0),
      duration: const Duration(milliseconds: 700))
  ..tween('height', Tween(begin: 100.0, end: 200.0),
      duration: const Duration(milliseconds: 700));
```
<!-- // end of #code -->

In order to not repeat yourself, you can use `scene()` to create an explicit scene and apply both tween to it:

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/basic2.dart -->
```dart
final tween = MovieTween();

tween.scene(duration: const Duration(milliseconds: 700))
  ..tween('width', Tween(begin: 0.0, end: 100.0))
  ..tween('height', Tween(begin: 100.0, end: 200.0));
```
<!-- // end of #code -->

Calling `tween()` creates a scene as well. Therefore you can just call `thenTween()` to create staggered animations.

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/basic3.dart -->
```dart
final tween = MovieTween();

tween
    .tween('width', Tween(begin: 0.0, end: 100.0),
        duration: const Duration(milliseconds: 700))
    .thenTween('width', Tween(begin: 100.0, end: 200.0),
        duration: const Duration(milliseconds: 500));
```
<!-- // end of #code -->

You can use e.g. a `PlayAnimationBuilder` to bring the `MovieTween` alive:

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/play_animation_example.dart -->
```dart
@override
Widget build(BuildContext context) {
  // create tween
  var tween = MovieTween()
    ..scene(duration: const Duration(milliseconds: 700))
        .tween('width', Tween<double>(begin: 0.0, end: 100.0))
        .tween('height', Tween<double>(begin: 300.0, end: 200.0));

  return PlayAnimationBuilder<Movie>(
    tween: tween, // provide tween
    duration: tween.duration, // total duration obtained from MovieTween
    builder: (context, value, _) {
      return Container(
        width: value.get('width'), // get animated width value
        height: value.get('height'), // get animated height value
        color: Colors.yellow,
      );
    },
  );
}
```
<!-- // end of #code -->

`MovieTween` animates to `Movie` that offers you a `get()` method to obtain a single animated value.

### Scenes

A `MovieTween` can consist of multiple scenes with each scene having multiple tweened properties. Those scenes can be created

- implicitly using `tween()` or `thenTween()`,
- explicitly using `scene()` or `thenFor()`.

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/scenes.dart -->
```dart
final tween = MovieTween();

// implicit scenes
final sceneA1 = tween.tween('x', Tween(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 700));

final sceneA2 = sceneA1.thenTween('x', Tween(begin: 1.0, end: 2.0),
    duration: const Duration(milliseconds: 500));

// explicit scenes
final sceneB1 = tween
    .scene(duration: const Duration(milliseconds: 700))
    .tween('x', Tween(begin: 0.0, end: 1.0));

final sceneB2 = sceneA1
    .thenFor(duration: const Duration(milliseconds: 500))
    .tween('x', Tween(begin: 1.0, end: 2.0));
```
<!-- // end of #code -->

#### Absolute scenes

You can add scenes anywhere in the timeline of your tween by using `tween.scene()`. You just need to provide two of these parameters:

- `begin` (start time of the scene)
- `duration` (duration of the scene)
- `end` (end time of the scene)

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/scenes_absolute.dart -->
```dart
final tween = MovieTween();

// start at 0ms and end at 1500ms
final scene1 = tween.scene(
  duration: const Duration(milliseconds: 1500),
);

// start at 200ms and end at 900ms
final scene2 = tween.scene(
  begin: const Duration(milliseconds: 200),
  duration: const Duration(milliseconds: 700),
);

// start at 700ms and end at 1400ms
final scene3 = tween.scene(
  begin: const Duration(milliseconds: 700),
  end: const Duration(milliseconds: 1400),
);

// start at 1000ms and end at 1600ms
final scene4 = tween.scene(
  duration: const Duration(milliseconds: 600),
  end: const Duration(milliseconds: 1600),
);
```
<!-- // end of #code -->

#### Relative scenes

You can also make scenes depend on each other by using `thenFor()`.

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/scenes_relative.dart -->
```dart
final tween = MovieTween();

final firstScene = tween
    .scene(
      begin: const Duration(seconds: 0),
      duration: const Duration(seconds: 2),
    )
    .tween('x', ConstantTween<int>(0));

// secondScene references the firstScene
final secondScene = firstScene
    .thenFor(
      delay: const Duration(milliseconds: 200),
      duration: const Duration(seconds: 2),
    )
    .tween('x', ConstantTween<int>(1));
```
<!-- // end of #code -->

It also possible to add an optional `delay` to add further time between the scenes.

#### Hint on code style

By using builder style Dart syntax and comments you can easily create a well-readable animation.

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/tween.dart -->
```dart
MovieTween()

    /// fade in
    .scene(
      begin: const Duration(seconds: 0),
      duration: const Duration(milliseconds: 300),
    )
    .tween('x', Tween<double>(begin: 0.0, end: 100.0))
    .tween('y', Tween<double>(begin: 0.0, end: 200.0))

    /// grow
    .thenFor(duration: const Duration(milliseconds: 700))
    .tween('x', Tween<double>(begin: 100.0, end: 200.0))
    .tween('y', Tween<double>(begin: 200.0, end: 400.0))

    /// fade out
    .thenFor(duration: const Duration(milliseconds: 300))
    .tween('x', Tween<double>(begin: 200.0, end: 0.0))
    .tween('y', Tween<double>(begin: 400.0, end: 0.0));
```
<!-- // end of #code -->

### Animate properties

You can use `tween()` to specify a tween for single property.

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/animate1.dart -->
```dart
final tween = MovieTween();
final scene = tween.scene(end: const Duration(seconds: 1));

scene.tween('width', Tween(begin: 0.0, end: 100.0));
scene.tween('color', ColorTween(begin: Colors.red, end: Colors.blue));
```
<!-- // end of #code -->

You can fine tune the timing with `shiftBegin` or `shiftEnd` for each property.

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/animate2.dart -->
```dart
scene.tween('width', Tween(begin: 0.0, end: 100.0),
    shiftBegin: const Duration(milliseconds: 200), // start later
    shiftEnd: const Duration(milliseconds: -200) // end earlier
    );
```
<!-- // end of #code -->

### Curves

You can customize the default easing curve at MovieTween, scene or property tween level.

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/curve.dart -->
```dart
final tween = MovieTween(curve: Curves.easeIn);

// scene1 will use Curves.easeIn defined by the MovieTween
final scene1 = tween.scene(duration: const Duration(seconds: 1));

// scene2 will use Curves.easeOut
final scene2 =
    tween.scene(duration: const Duration(seconds: 1), curve: Curves.easeOut);

// will use Curves.easeIn defined by the MovieTween
scene1.tween('value1', Tween(begin: 0.0, end: 100.0));

// will use Curves.easeOut defined by scene2
scene2.tween('value2', Tween(begin: 0.0, end: 100.0));

// will use Curves.easeInOut defined by property tween
scene2.tween('value3', Tween(begin: 0.0, end: 100.0),
    curve: Curves.easeInOut);
```
<!-- // end of #code -->

### Extrapolation

All values that are not explicitly set in the timeline will be extrapolated.

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/extrapolation.dart -->
```dart
final tween = MovieTween()

  // implicitly use 100.0 for width values from 0.0s - 1.0s

  // 1.0s - 2.0s
  ..scene(
    begin: const Duration(seconds: 1),
    duration: const Duration(seconds: 1),
  ).tween('width', Tween<double>(begin: 100.0, end: 200.0))

  // implicitly use 200.0 for width values from 2.0s - 3.0s

  // 3.0s - 4.0s
  ..scene(
    begin: const Duration(seconds: 3),
    end: const Duration(seconds: 4),
  ).tween('height', Tween<double>(begin: 400.0, end: 500.0));
```
<!-- // end of #code -->

### Use developer tools

Creating complex tweens with multiple or staggered properties can be time consuming to create and maintain. I recommend using the [**Animation Developer Tools**](#animation-developer-tools) to streamline this process.

![devtools](https://github.com/felixblaschke/simple_animations/raw/main/example/img/d1.gif)

### Animation duration

Normally an `Animatable` or `Tween` doesn't contain a duration information. But `MovieTween` class contains a `duration` property that contains the total duration of the animation.

<!-- #code example/sa_flutter_app/lib/readme/movie_tween/duration.dart -->
```dart
@override
Widget build(BuildContext context) {
  final tween = MovieTween()
    ..tween('width', Tween<double>(begin: 0.0, end: 100.0),
        duration: const Duration(milliseconds: 700))
    ..tween('height', Tween<double>(begin: 300.0, end: 200.0),
        duration: const Duration(milliseconds: 700));

  return PlayAnimationBuilder<Movie>(
    tween: tween,
    duration: tween.duration, // use duration from MovieTween
    builder: (context, value, _) {
      return Container(
        width: value.get('width'),
        height: value.get('height'),
        color: Colors.yellow,
      );
    },
  );
}
```
<!-- // end of #code -->

_Hint: You can also multiply the `duration` value with a numeric factor in order to speed up or slow down an animation._

Of cause you can also use an own `Duration` for the animation.

&nbsp;

## Animation Mixin

It reduces boilerplate code when using `AnimationController` instances.

### Basic usage pattern

Create an `AnimationController` just by adding `AnimationMixin` to your stateful widget:

<!-- #code example/sa_flutter_app/lib/readme/animation_mixin/basic.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyAnimatedWidget extends StatefulWidget {
  const MyAnimatedWidget({Key? key}) : super(key: key);

  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

// Add AnimationMixin to state class
class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {
  late Animation<double> size;

  @override
  void initState() {
    size = Tween<double>(begin: 0.0, end: 200.0).animate(controller);
    controller.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: size.value, height: size.value, color: Colors.red);
  }
}
```
<!-- // end of #code -->

💪 The `AnimationMixin` generates a preconfigured AnimationController as `controller`. You can just use it. No need to worry about initialization or disposing.

### Create multiple AnimationController

With multiple AnimationController you can have many parallel animations at the same time.

Anicoto's `AnimationMixin` enhances your **state class** with a method `createController()` to create multiple **managed\*** AnimationController. _("Managed" means that you don't need to care about initialization and disposing.)_

#### Create a managed AnimationController

First create a class variable of type `AnimationController`. Then inside the `initState() {...}` method call `createController()`. That's all.

<!-- #code example/sa_flutter_app/lib/readme/animation_mixin/managed1.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyAnimatedWidget extends StatefulWidget {
  const MyAnimatedWidget({Key? key}) : super(key: key);

  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

// use AnimationMixin
class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {
  late AnimationController sizeController; // declare custom AnimationController
  late Animation<double> size;

  @override
  void initState() {
    sizeController = createController(); // create custom AnimationController
    size = Tween<double>(begin: 0.0, end: 200.0).animate(sizeController);
    sizeController.play(duration: const Duration(seconds: 5));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: size.value, height: size.value, color: Colors.red);
  }
}
```
<!-- // end of #code -->

#### Create many managed AnimationController

Anicoto allows you to have as many AnimationController you want. Behind the scenes it keeps track of them.

<!-- #code example/sa_flutter_app/lib/readme/animation_mixin/managed2.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyAnimatedWidget extends StatefulWidget {
  const MyAnimatedWidget({Key? key}) : super(key: key);

  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {
  late AnimationController widthController;
  late AnimationController heightController;
  late AnimationController colorController;

  late Animation<double> width;
  late Animation<double> height;
  late Animation<Color?> color;

  @override
  void initState() {
    widthController = createController()
      ..mirror(duration: const Duration(seconds: 5));
    heightController = createController()
      ..mirror(duration: const Duration(seconds: 3));
    colorController = createController()
      ..mirror(duration: const Duration(milliseconds: 1500));

    width = Tween<double>(begin: 100.0, end: 200.0).animate(widthController);
    height = Tween<double>(begin: 100.0, end: 200.0).animate(heightController);
    color = ColorTween(begin: Colors.red, end: Colors.blue)
        .animate(colorController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width.value, height: height.value, color: color.value);
  }
}
```
<!-- // end of #code -->

&nbsp;

## Shortcuts for AnimationController

The extension for `AnimationController` adds four convenience functions:

- `controller.play()` plays animation and stops at the end.

- `controller.playReverse()` plays animation reversed and stops at the start.

- `controller.loop()` repetitively plays the animation from start to the end.

- `controller.mirror()` repetitively plays the animation forward, then backwards, then forward and so on.

Each of these methods take an optional `duration` named parameter to configure your animation action within one line of code.

<!-- #code example/sa_flutter_app/lib/readme/animation_controller_extension/shortcuts.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void someFunction(AnimationController controller) {
  controller.play(duration: const Duration(milliseconds: 1500));
  controller.playReverse(duration: const Duration(milliseconds: 1500));
  controller.loop(duration: const Duration(milliseconds: 1500));
  controller.mirror(duration: const Duration(milliseconds: 1500));
}
```
<!-- // end of #code -->

You can use these methods nicely along the already existing `controller.stop()` and `controller.reset()` methods.

&nbsp;

## Animation Developer Tools

The Animation Developer Tools allow you to create or review your animation step by step.

### Basic usage pattern

Wrap your UI with the `AnimationDeveloperTools` widget.

<!-- #code example/sa_flutter_app/lib/readme/animation_developer_tools/intro.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // put DevTools very high in the widget hierarchy
      body: AnimationDeveloperTools(
        child: Container(), // your UI
      ),
    );
  }
}
```
<!-- // end of #code -->

Enable developer mode on the animation you want to debug.

#### Using Animation Builder widgets

The Animation Builder widgets

- `PlayAnimationBuilder`
- `LoopAnimationBuilder`
- `MirrorAnimationBuilder`
- `CustomAnimationBuilder`

have a constructor parameter `developerMode` that can be set to `true`. It will connect to the closest `AnimationDeveloperTools` widget.

**Example**

<!-- #code example/sa_flutter_app/lib/readme/animation_developer_tools/animation_builder.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: MyPage())));

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // put DevTools very high in the widget hierarchy
      child: AnimationDeveloperTools(
        child: Center(
          child: PlayAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 100.0),
            duration: const Duration(seconds: 1),
            developerMode: true, // enable developer mode
            builder: (context, value, child) {
              return Container(
                width: value,
                height: value,
                color: Colors.blue,
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

![devtools](https://github.com/felixblaschke/simple_animations/raw/main/example/img/d1.gif)

#### Using Animation Mixin

If your stateful widget uses `AnimationMixin` to manage your instances of `AnimationController` you can call `enableDeveloperMode()` to connect to the clostest `AnimationDeveloperMode` widget.

**Example**

<!-- #code example/sa_flutter_app/lib/readme/animation_developer_tools/animation_mixin.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          // put DevTools very high in the widget hierarchy
          child: AnimationDeveloperTools(
            child: Center(
              child: MyAnimation(),
            ),
          ),
        ),
      ),
    );
  }
}

class MyAnimation extends StatefulWidget {
  const MyAnimation({Key? key}) : super(key: key);

  @override
  _MyAnimationState createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation> with AnimationMixin {
  late Animation<double> size;

  @override
  void initState() {
    size = Tween<double>(begin: 0.0, end: 100.0).animate(controller);
    enableDeveloperMode(controller); // enable developer mode
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: size.value, height: size.value, color: Colors.blue);
  }
}
```
<!-- // end of #code -->

### Features and tricks

The Animation Developer Tools come with several features that simplify your developer life:

- Regardless of the real animation, with developer mode activated the animation will always loop.
- You can use Flutter hot reloading for editing and debugging if your tween is created stateless.
- Use the slider to edit the animated scene while pausing.
- You can slow down the animation to look out for certain details.
- Use the interval buttons to focus on a time span of the animation.