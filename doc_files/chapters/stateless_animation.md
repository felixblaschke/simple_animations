<!-- This file uses generated code. Visit https://pub.dev/packages/readme_helper for usage information. -->
## Stateless Animation guide

Stateless Animation enables developers to craft custom animations with simple widgets.

### PlayAnimation widget

The `PlayAnimation()` widget plays an animation described by the properties `tween` and `builder`.

#### Tween

The `tween` is the description of your animation. Mostly it will change a value from A to B. Tweens describe **what** will happen but **not how fast it will happen**.

<!-- #code ../code/stateless_animation/pa_tween.dart -->
```dart
import 'package:flutter/material.dart';

// Animate a color from red to blue
var colorTween = ColorTween(begin: Colors.red, end: Colors.blue);

// Animate a double value from 0 to 100
var doubleTween = Tween<double>(begin: 0.0, end: 100.0);
```
<!-- // end of #code -->

#### Builder

The `builder` is a function that is called for **each new rendered frame** of your animation. It takes three parameters: `context`, `child` and `value`.

- `context` is your Flutter `BuildContext`, which should be familiar to you.

- `child` is a placeholder for any widget that you can additionally pass in a `PlayAnimation` widget. Its usage is described further below.

- `value` is "current value" of any animated variable. If your tween describes to interpolate from `0` to `100`, the `variable` is a value somewhere between `0` and `100`.

How often your `builder` function is called, depends on the animation duration, and the framerate of the device used.

#### A simple PlayAnimation

The `PlayAnimation<?>` widget can be typed with the type of the animated variable. This enables us the code type-safe.

<!-- #code ../code/stateless_animation/pa_basic.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// set Color? as type of PlayAnimation because use a ColorTween
var widget = PlayAnimation<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue), // define tween
  builder: (context, child, value) {
    return Container(
      color: value, // use animated color
      width: 100,
      height: 100,
    );
  },
);
```
<!-- // end of #code -->

This snippet creates animation of a red square. It's color will fade to blue within one second.

#### Animation duration

By default, the duration of the animation is one second. You set the optional parameter `duration` to refine that.

<!-- #code ../code/stateless_animation/pa_duration.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimation<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 5), // specify duration
  builder: (context, child, value) {
    return Container(
      color: value,
      width: 100,
      height: 100,
    );
  },
);
```
<!-- // end of #code -->

Now the red square will fade it's color for 5 seconds.

#### Delay

By default, animations will play automatically. You can set the `delay` parameter to make `PlayAnimation` wait for a given amount of time.

<!-- #code ../code/stateless_animation/pa_delay.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimation<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: const Duration(seconds: 5),
  delay: const Duration(seconds: 2), // add delay
  builder: (context, child, value) {
    return Container(
      color: value,
      width: 100,
      height: 100,
    );
  },
);
```
<!-- // end of #code -->

The red square will wait for 2 seconds before it starts fading its color.

#### Non-linear animation

You can make your animation more interesting by applying a non-linear timing curve to it. By default, the tween is animated constantly or **linear**.

Scenarios where the animation is faster at beginning and slower at the ending are called **non-linear animations**.

You can enrich your animation with non-linear behavior by supplying a `Curve` to the `curve` parameter. Flutter comes with a set of predefined curves inside the `Curves` class.

<!-- #code ../code/stateless_animation/pa_curve.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimation<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  curve: Curves.easeInOut, // specify curve
  builder: (context, child, value) {
    return Container(
      color: value,
      width: 100,
      height: 100,
    );
  },
);
```
<!-- // end of #code -->

#### Track animation status

You can track the status of the animation by setting the `onStart` and `onComplete` callbacks.

<!-- #code ../code/stateless_animation/pa_lifecycle.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimation<Color?>(
  // Track animation status
  onStart: () => print('Animation started'),
  onComplete: () => print('Animation complete'),
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  builder: (context, child, value) =>
      Container(color: value, width: 100, height: 100),
);
```
<!-- // end of #code -->

#### Working with child widgets

Animations are highly demanding because parts of your apps are recomputed many times per second. It's important to keep these computations as low as possible.

**Image the following scenario:** There is a `Container` with a colored background. Inside the `Container` is a `Text`. Now we want to animate the background color. There is no need to recompute the `Text` because the animation only effects the `Container` color.

In that scenario we have static `Text` widget. Only the `Container` need to be updated on each frame. We can set the static widget as a `child` parameter. In our `builder` function we receive that child widget and can use it inside our animated scene. **This way the child widget is only computed once.**

<!-- #code ../code/stateless_animation/pa_child.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimation<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  // child gets passed into builder function
  builder: (context, child, value) {
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

Flutter tends to recycle used widgets. If your app swaps out a `PlayAnimation` with another different `PlayAnimation` in the same second, it may recycle the first one. This may lead to a strange behavior.

All widgets mentioned here support keys to avoid such strange behavior. If you are not familiar with keys then [watch this video](https://www.youtube.com/watch?v=kn0EOS-ZiIc).

#### App example

<!-- #code ../code/stateless_animation/example_play_animation.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      // specify tween (from 50.0 to 200.0)
      tween: Tween<double>(begin: 50.0, end: 200.0),

      // set a duration
      duration: const Duration(seconds: 5),

      // set a curve
      curve: Curves.easeInOut,

      // use builder function
      builder: (context, child, value) {
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

### LoopAnimation and MirrorAnimation

Beside `PlayAnimation` there are two similar widgets `LoopAnimation` and `MirrorAnimation`.

Its configuration is pretty the same as the `PlayAnimation`.

#### LoopAnimation

A `LoopAnimation` repeatedly plays the specified `tween` from the start to the end.

<!-- #code ../code/stateless_animation/loop_animation.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = LoopAnimation<Color?>(
  // mandatory parameters
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100, child: child);
  },
  // optional parameters
  duration: const Duration(seconds: 5),
  curve: Curves.easeInOut,
  child: const Text('Hello World'),
);
```
<!-- // end of #code -->

#### MirrorAnimation

A `MirrorAnimation` repeatedly plays the specified `tween` from the start to the end, then reverse to the start, then again forward and so on.

<!-- #code ../code/stateless_animation/mirror_animation.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = MirrorAnimation<Color?>(
  // mandatory parameters
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100, child: child);
  },
  // optional parameters
  duration: const Duration(seconds: 5),
  curve: Curves.easeInOut,
  child: const Text('Hello World'),
);
```
<!-- // end of #code -->

### CustomAnimation

Use `CustomAnimation` if the animation widgets discussed above aren't sufficient for you use case. Beside all parameters mentioned for `PlayAnimation` it allows you actively control the animation.

#### Control the animation

The `control` parameter can be set to the following values:

| CustomAnimationControl._VALUE_ | Description                                                                                                                |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| `stop`                         | Stops the animation at the current position.                                                                               |
| `play`                         | Plays the animation from the current position reverse to the start.                                                        |
| `playReverse`                  | Plays the animation from the current position reverse to the start.                                                        |
| `playFromStart`                | Reset the position of the animation to `0.0` and starts playing to the end.                                                |
| `playReverseFromEnd`           | Reset the position of the animation to `1.0` and starts playing reverse to the start.                                      |
| `loop`                         | Endlessly plays the animation from the start to the end.                                                                   |
| `mirror`                       | Endlessly plays the animation from the start to the end, then it plays reverse to the start, then forward again and so on. |

You can bind the `control` value to state variable and change it during the animation. The `CustomAnimation` will adapt to that.

<!-- #code ../code/stateless_animation/example_control.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatefulWidget {
  const Page({Key? key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  var control = CustomAnimationControl.play; // state variable

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      // bind state variable to parameter
      control: control,
      tween: Tween<double>(begin: -100.0, end: 100.0),
      builder: (context, child, value) {
        // animation that moves child from left to right
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },
      // there is a button
      child: MaterialButton(
        color: Colors.yellow,
        // clicking button changes animation direction
        onPressed: toggleDirection,
        child: const Text('Swap'),
      ),
    );
  }

  void toggleDirection() {
    setState(() {
      // toggle between control instructions
      control = control == CustomAnimationControl.play
          ? CustomAnimationControl.playReverse
          : CustomAnimationControl.play;
    });
  }
}
```
<!-- // end of #code -->

#### Start position

Each animation has an internal abstract position. This is a value ranging form `0.0` _(start)_ to `1.0` _(end)_.

You can modify the initial position by setting the `startPosition` parameter.

<!-- #code ../code/stateless_animation/start_position.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = CustomAnimation<Color?>(
  // play forward
  control: CustomAnimationControl.play,

  // set start position at 50%
  startPosition: 0.5,

  // full duration is 5 seconds
  duration: const Duration(seconds: 5),

  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100);
  },
);
```
<!-- // end of #code -->

This animation will start playing right in the middle of the specified animation and only will animate for 2.5 seconds.

#### Track animation status

You can track the status of the animation by setting the `onStart` and `onComplete` callbacks.

<!-- #code ../code/stateless_animation/ca_lifecycle.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = CustomAnimation<Color?>(
  onStart: () => print('Animation started'),
  onComplete: () => print('Animation complete'),
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100);
  },
);
```
<!-- // end of #code -->

Or you can access the [`AnimationStatusListener`](https://api.flutter.dev/flutter/animation/AnimationStatusListener.html) within the internal [`AnimationController`](https://api.flutter.dev/flutter/animation/AnimationController-class.html).

<!-- #code ../code/stateless_animation/animation_status.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = CustomAnimation<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100);
  },
  animationStatusListener: (AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      print('Animation completed!');
    }
  },
);
```
<!-- // end of #code -->
