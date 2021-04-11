# 🚀 Stateless Animation documentation

Stateless Animation enables developers to craft custom animations with simple widgets.


## PlayAnimation widget

The `PlayAnimation()` widget plays an animation described by the properties `tween` and `builder`.

### Tween

The `tween` is the description of your animation. Mostly it will change a value from A to B. Tweens describe **what** will happen but **not how fast it will happen**.

```dart
import 'package:flutter/material.dart';

// Animate a color from red to blue
var colorTween = ColorTween(begin: Colors.red, end: Colors.blue);

// Animate a double value from 0 to 100
var doubleTween = Tween<double>(begin: 0.0, end: 100.0);
```

### Builder

The `builder` is a function that is called for **each new rendered frame** of your animation. It takes three parameters: `context`, `child` and `value`.

- `context` is your Flutter `BuildContext`, which should be familiar to you.

- `child` is a placeholder for any widget that you can additionally pass in a `PlayAnimation` widget. Its usage is described further below.

- `value` is "current value" of any animated variable. If your tween describes to interpolate from `0` to `100`, the `variable` is a value somewhere between `0` and `100`.

How often your `builder` function is called, depends on the animation duration, and the framerate of the device used.

### A simple PlayAnimation

The `PlayAnimation<?>` widget can be typed with the type of the animated variable. This enables us the code type-safe.

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

This snippet creates animation of a red square. It's color will fade to blue within one second.

### Animation duration

By default, the duration of the animation is one second. You set the optional parameter `duration` to refine that.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimation<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: Duration(seconds: 5), // specify duration
  builder: (context, child, value) {
    return Container(
      color: value,
      width: 100,
      height: 100,
    );
  },
);
```

Now the red square will fade it's color for 5 seconds.

### Delay

By default, animations will play automatically. You can set the `delay` parameter to make `PlayAnimation` wait for a given amount of time.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = PlayAnimation<Color?>(
  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  duration: Duration(seconds: 5),
  delay: Duration(seconds: 2), // add delay
  builder: (context, child, value) {
    return Container(
      color: value,
      width: 100,
      height: 100,
    );
  },
);
```

The red square will wait for 2 seconds before it starts fading its color.

### Non-linear animation

You can make your animation more interesting by applying a non-linear timing curve to it. By default, the tween is animated constantly or **linear**.

Scenarios where the animation is faster at beginning and slower at the ending are called **non-linear animations**.

You can enrich your animation with non-linear behavior by supplying a `Curve` to the `curve` parameter. Flutter comes with a set of predefined curves inside the `Curves` class.

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


### Working with child widgets

Animations are highly demanding because parts of your apps are recomputed many times per second. It's important to keep these computations as low as possible.

**Image the following scenario:** There is a `Container` with a colored background. Inside the `Container` is a `Text`. Now we want to animate the background color. There is no need to recompute the `Text` because the animation only effects the `Container` color.

In that scenario we have static `Text` widget. Only the `Container` need to be updated on each frame. We can set the static widget as a `child` parameter. In our `builder` function we receive that child widget and can use it inside our animated scene. **This way the child widget is only computed once.**

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
  child: Text('Hello World'), // specify child widget
);
```

### Using keys

Flutter tends to recycle used widgets. If your app swaps out a `PlayAnimation` with another different `PlayAnimation` in the same second, it may recycle the first one. This may lead to a strange behavior.

All widgets mentioned here support keys to avoid such strange behavior. If you are not familiar with keys then [watch this video](https://www.youtube.com/watch?v=kn0EOS-ZiIc).

### App example

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      // specify tween (from 50.0 to 200.0)
      tween: (50.0).tweenTo(200.0),

      // set a duration
      duration: 5.seconds,

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
      child: Text('Hello World'),
    );
  }
}
```
> *Note: We use [supercharged extensions](https://pub.dev/packages/supercharged) here. If you don't like it, refer to this [dependency-less example](../doc/no_supercharged/stateless_animation/example_play_animation_ns.dart.md).*



## LoopAnimation and MirrorAnimation

Beside `PlayAnimation` there are two similar widgets `LoopAnimation` and `MirrorAnimation`.

Its configuration is pretty the same as the `PlayAnimation`.

### LoopAnimation

A `LoopAnimation` repeatedly plays the specified `tween` from the start to the end.

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
  duration: Duration(seconds: 5),
  curve: Curves.easeInOut,
  child: Text('Hello World'),
);
```

### MirrorAnimation

A `MirrorAnimation` repeatedly plays the specified `tween` from the start to the end, then reverse to the start, then again forward and so on.

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
  duration: Duration(seconds: 5),
  curve: Curves.easeInOut,
  child: Text('Hello World'),
);
```


## CustomAnimation

Use `CustomAnimation` if the animation widgets discussed above aren't sufficient for you use case. Beside all parameters mentioned for `PlayAnimation` it allows you actively control the animation.

### Take over control

The `control` parameter can be set to the following values:

CustomAnimationControl.*VALUE* | Description
-------------- | ------------
stop | Stops the animation at the current position.
play | Plays the animation from the current position reverse to the start.
playReverse | Plays the animation from the current position reverse to the start.
playFromStart | Reset the position of the animation to `0.0` and starts playing to the end.
playReverseFromEnd | Reset the position of the animation to `1.0` and starts playing reverse to the start.
loop | Endlessly plays the animation from the start to the end.
mirror | Endlessly plays the animation from the start to the end, then it plays reverse to the start, then forward again and so on.

You can bind the `control` value to state variable and change it during the animation. The `CustomAnimation` will adapt to that.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatefulWidget {
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
        child: Text('Swap'),
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

### Start position

Each animation has an internal abstract position. This is a value ranging form `0.0` *(start)* to `1.0` *(end)*.

You can modify the initial position by setting the `startPosition` parameter.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

var widget = CustomAnimation<Color?>(
  // play forward
  control: CustomAnimationControl.play,

  // set start position at 50%
  startPosition: 0.5,

  // full duration is 10 seconds
  duration: Duration(seconds: 5),

  tween: ColorTween(begin: Colors.red, end: Colors.blue),
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100);
  },
);
```


This animation will start playing right in the middle of the specified animation and only will animate for 5 seconds.

### Listen to AnimationStatus

Behind the scenes there is an `AnimationController` processing the animation. `CustomAnimation` exposes it's `AnimationStatusListener` to enable you to react to finished animations.

You can specify your own listener at the `animationStatusListener` parameter.

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