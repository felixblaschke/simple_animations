# 🎬 Simple Animations

[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter)
[![Pub](https://img.shields.io/pub/v/simple_animations.svg)](https://pub.dartlang.org/packages/simple_animations)

**Simple Animations** is a powerful package to create beautiful custom animations in no time.

- 💪 **fully tested**
- 📝 **well documented**
- 💼 **enterprise-ready**

**Highlights**

- Easily create **custom animations in stateless widgets**
- Animate **multiple properties** at once
- Create **staggered animations** within seconds
- Simplified working with **AnimationController** instances
- Debug animations

## Table of contents

[**Overview**](#overview)
  - [Stateless Animation](#stateless-animation)
  - [Timeline Tween](#timeline-tween)
  - [Anicoto](#anicoto)
  - [Animation Developer Tools](#animation-developer-tools)

[**Stateless Animation guide**](#stateless-animation-guide)
  - [PlayAnimation widget](#playanimation-widget)
  - [LoopAnimation and MirrorAnimation](#loopanimation-and-mirroranimation)
  - [CustomAnimation](#customanimation)

[**Timeline Tween guide**](#timeline-tween-guide)
  - [Basic usage pattern](#basic-usage-pattern)
  - [Scenes](#scenes)
  - [Animate properties](#animate-properties)
  - [Curves](#curves)
  - [Extrapolation](#extrapolation)
  - [Use developer tools](#use-developer-tools)
  - [Using the predefined enum for animation properties](#using-the-predefined-enum-for-animation-properties)
  - [Animation duration](#animation-duration)

[**Anicoto guide**](#anicoto-guide)
  - [Basic usage pattern](#basic-usage-pattern)
  - [Shortcuts for AnimationController](#shortcuts-for-animationcontroller)
  - [Create multiple AnimationController](#create-multiple-animationcontroller)

[**Animation Developer Tools guide**](#animation-developer-tools-guide)
  - [Basic usage pattern](#basic-usage-pattern)
  - [Features and tricks](#features-and-tricks)

## Overview

Simple Animation consists of severals feature, that work alone or in synergy.

### Stateless Animation

Stateless Animation provides a powerful set of Flutter widgets that hide the most complex part of creating animations.

**Example**: Square with an animated background color.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // create animation widget with type of animated variable
    return PlayAnimation<Color?>(
        tween: ColorTween(begin: Colors.red, end: Colors.blue), // define tween
        duration: const Duration(seconds: 2), // define duration
        builder: (context, child, value) {
          return Container(
            color: value, // use animated value
            width: 100,
            height: 100,
          );
        });
  }
}
```

[**Read guide**](#stateless-animation-guide) or [**watch examples**](example/example.md#stateless-animation).

---

### Timeline Tween

Timeline Tween is a mighty tool that enables you to tween multiple
properties _or_ designing staggered animations in a single `Animatable`.

**Example**: Custom tween with multiple properties.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// define animated properties
enum AniProps { width, height, color }

// design tween by composing scenes
final tween = TimelineTween<AniProps>()
  ..addScene(
          begin: const Duration(milliseconds: 0),
          duration: const Duration(milliseconds: 500))
      .animate(AniProps.width, tween: Tween<double>(begin: 0.0, end: 400.0))
      .animate(AniProps.height, tween: Tween<double>(begin: 500.0, end: 200.0))
      .animate(AniProps.color,
          tween: ColorTween(begin: Colors.red, end: Colors.yellow))
  ..addScene(
          begin: const Duration(milliseconds: 700),
          end: const Duration(milliseconds: 1200))
      .animate(AniProps.width, tween: Tween<double>(begin: 400.0, end: 500.0));
```

[**Read guide**](#timeline-tween-guide) or [**watch examples**](example/example.md#timeline-tween).

---

### Anicoto

Anicoto fully manages your AnimationController instances and handles initialization, configuration and disposing. No
more boilerplate code.

**Example**: Animated stateful widget with full-fledged AnimationController instance.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

// add AnimationMixin to widget's state
class _MyWidgetState extends State<MyWidget> with AnimationMixin {
  // declare animation variable
  late Animation<double> size;

  @override
  void initState() {
    // connect tween and controller and apply to animation variable
    size = Tween<double>(begin: 0.0, end: 200.0).animate(controller);

    controller.play(); // start the animation playback

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.value, // use animation variable's value
      height: size.value, // use animation variable's value
      color: Colors.red,
    );
  }
}
```

[**Read guide**](#anicoto-guide) or [**watch examples**](example/example.md#anicoto).

---

### Animation Developer Tools

Tired of watching the same animation over and over again, in order to fine tune it?

![devtools](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/v2/devtools.gif)

The Animation Developer Tools allows you pause anywhere, scroll around, speed up, slow down or focus on a certain
interval of the animation.

[**Read guide**](#animation-developer-tools-guide)

---

## Stateless Animation guide

Stateless Animation enables developers to craft custom animations with simple widgets.

### PlayAnimation widget

The `PlayAnimation()` widget plays an animation described by the properties `tween` and `builder`.

#### Tween

The `tween` is the description of your animation. Mostly it will change a value from A to B. Tweens describe **what** will happen but **not how fast it will happen**.

```dart
import 'package:flutter/material.dart';

// Animate a color from red to blue
var colorTween = ColorTween(begin: Colors.red, end: Colors.blue);

// Animate a double value from 0 to 100
var doubleTween = Tween<double>(begin: 0.0, end: 100.0);
```

#### Builder

The `builder` is a function that is called for **each new rendered frame** of your animation. It takes three parameters: `context`, `child` and `value`.

- `context` is your Flutter `BuildContext`, which should be familiar to you.

- `child` is a placeholder for any widget that you can additionally pass in a `PlayAnimation` widget. Its usage is described further below.

- `value` is "current value" of any animated variable. If your tween describes to interpolate from `0` to `100`, the `variable` is a value somewhere between `0` and `100`.

How often your `builder` function is called, depends on the animation duration, and the framerate of the device used.

#### A simple PlayAnimation

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

#### Animation duration

By default, the duration of the animation is one second. You set the optional parameter `duration` to refine that.

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

Now the red square will fade it's color for 5 seconds.

#### Delay

By default, animations will play automatically. You can set the `delay` parameter to make `PlayAnimation` wait for a given amount of time.

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

The red square will wait for 2 seconds before it starts fading its color.

#### Non-linear animation

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

#### Track animation status

You can track the status of the animation by setting the `onStart` and `onComplete` callbacks.

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

#### Working with child widgets

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
  child: const Text('Hello World'), // specify child widget
);
```

#### Using keys

Flutter tends to recycle used widgets. If your app swaps out a `PlayAnimation` with another different `PlayAnimation` in the same second, it may recycle the first one. This may lead to a strange behavior.

All widgets mentioned here support keys to avoid such strange behavior. If you are not familiar with keys then [watch this video](https://www.youtube.com/watch?v=kn0EOS-ZiIc).

#### App example

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

### LoopAnimation and MirrorAnimation

Beside `PlayAnimation` there are two similar widgets `LoopAnimation` and `MirrorAnimation`.

Its configuration is pretty the same as the `PlayAnimation`.

#### LoopAnimation

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
  duration: const Duration(seconds: 5),
  curve: Curves.easeInOut,
  child: const Text('Hello World'),
);
```

#### MirrorAnimation

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
  duration: const Duration(seconds: 5),
  curve: Curves.easeInOut,
  child: const Text('Hello World'),
);
```

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

#### Start position

Each animation has an internal abstract position. This is a value ranging form `0.0` _(start)_ to `1.0` _(end)_.

You can modify the initial position by setting the `startPosition` parameter.

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

This animation will start playing right in the middle of the specified animation and only will animate for 2.5 seconds.

#### Track animation status

You can track the status of the animation by setting the `onStart` and `onComplete` callbacks.

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

Or you can access the [`AnimationStatusListener`](https://api.flutter.dev/flutter/animation/AnimationStatusListener.html) within the internal [`AnimationController`](https://api.flutter.dev/flutter/animation/AnimationController-class.html).

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
## Timeline Tween guide

Timeline Tween is a **powerful** `Animateable` that animates multiple properties at once.

### Basic usage pattern

Create an `enum` outside your widget class. It contains all properties you want to animate. _(For example: width, height or color)_

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// (1) create enum
enum AniProps { width, height, color }
```

Then you create a `TimelineTween` by instancing it with the `enum` you created in the first step.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() {
  // (2) create TimelineTween using this enum
  var tween = TimelineTween<AniProps>();

  return tween;
}
```

Use `addScene()` to add a new scene to the tween. A scene represents a span of time when certain properties will tween.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() {
  var tween = TimelineTween<AniProps>();

  // (3) add a scene to the tween
  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(milliseconds: 700),
  );

  return tween;
}
```

On the `scene` object you can use `animate()` to specify your tweens.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() {
  var tween = TimelineTween<AniProps>();

  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(milliseconds: 700),
  );

  // (4) apply tweens to properties, referenced in enum
  scene.animate(
    AniProps.width,
    tween: Tween<double>(begin: 0.0, end: 100.0),
  );

  scene.animate(
    AniProps.height,
    tween: Tween<double>(begin: 300.0, end: 200.0),
  );

  return tween;
}
```

The `animate()` method returns its parent `scene` object. You can use this to specify a scene in a builder style. Here is the same scene:

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() => TimelineTween<AniProps>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(AniProps.width, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(AniProps.height, tween: Tween<double>(begin: 300.0, end: 200.0));
```

Use the created tween with your favorite animation technique. Here we use the `PlayAnimation`:

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // create tween
    var tween = createTween();

    return PlayAnimation<TimelineValue<AniProps>>(
      tween: tween, // provide tween
      duration: tween.duration, // total duration obtained from TimelineTween
      builder: (context, child, value) {
        return Container(
          width: value.get(AniProps.width), // get animated width value
          height: value.get(AniProps.height), // get animated height value
          color: Colors.yellow,
        );
      },
    );
  }
}

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() => TimelineTween<AniProps>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(AniProps.width, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(AniProps.height, tween: Tween<double>(begin: 300.0, end: 200.0));
```

`TimelineTween<PropType>` animates to `TimelineValue<PropType>` that offers you a `get()` method that can be used to obtain the single animated values.

### Scenes

A Timeline Tween can consist of multiple scenes with each scene having multiple tweened properties.

#### Absolute scenes

The most simple way to add a scene is to call `tween.addScene()`. It requires you to define two of these three parameters:

- begin (start time of the scene)
- duration (relative duration of the scene)
- end (end time of the scene)

You can freely combine begin/duration, begin/end or duration/end.

```dart
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  // begin + duration
  var scene1 = tween.addScene(
    begin: const Duration(milliseconds: 0),
    duration: const Duration(milliseconds: 700),
  );

  // begin + end
  var scene2 = tween.addScene(
    begin: const Duration(milliseconds: 700),
    end: const Duration(milliseconds: 1400),
  );

  // duration + end
  var scene3 = tween.addScene(
    duration: const Duration(milliseconds: 600),
    end: const Duration(milliseconds: 300),
  );

  return tween;
}
```

#### Relative scenes

While absolute scenes are easy to understand, they have one drawback. Each tuning in timings requires you to touch all `begin` durations.

To avoid this you can work with relative scenes by calling `addSubsequentScene()` on a created scene.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var firstScene = tween
      .addScene(
        begin: const Duration(seconds: 0),
        duration: const Duration(seconds: 2),
      )
      .animate(Prop.x, tween: ConstantTween<int>(0));

  // secondScene references the firstScene
  var secondScene = firstScene
      .addSubsequentScene(
        delay: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 2),
      )
      .animate(Prop.x, tween: ConstantTween<int>(1));

  return tween;
}
```

Subsequent scenes start right after their predecessor.
The relative nature of subsequent scenes require you to pass in a `duration`. Optionally you can add some `delay`.

#### Scene naming and code style

More complex animations will quickly blow up your code and get confusing. I recommend using variables with an expressive name for each scene. Use an extra function that will create your tween.

Here is my best practise:

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> _createComplexTween() {
  var tween = TimelineTween<Prop>();

  var fadeIn = tween
      .addScene(
        begin: const Duration(seconds: 0),
        duration: const Duration(milliseconds: 300),
      )
      .animate(Prop.x, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(Prop.y, tween: Tween<double>(begin: 0.0, end: 100.0));

  var grow = fadeIn
      .addSubsequentScene(duration: const Duration(milliseconds: 700))
      .animate(Prop.x, tween: Tween<double>(begin: 100.0, end: 200.0))
      .animate(Prop.y, tween: Tween<double>(begin: 100.0, end: 200.0));

  var fadeOut = grow
      .addSubsequentScene(duration: const Duration(milliseconds: 300))
      .animate(Prop.x, tween: Tween<double>(begin: 200.0, end: 0.0))
      .animate(Prop.y, tween: Tween<double>(begin: 200.0, end: 0.0));

  return tween;
}
```

### Animate properties

Use the scene's `animate()` method to specify tweens for each property.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(seconds: 1),
  );

  // animate properties within scene
  scene.animate(
    Prop.width,
    tween: Tween<double>(begin: 0.0, end: 100.0),
  );

  return tween;
}
```

Optionally you can specify `shiftBegin` or `shiftEnd` to further tune each property's timing.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(seconds: 1),
  );

  scene.animate(
    Prop.width,
    tween: Tween<double>(begin: 0.0, end: 100.0),
    shiftBegin: const Duration(milliseconds: 200), // tune begin or
    shiftEnd:
        const Duration(milliseconds: -200), // end timings by shifting them
  );

  return tween;
}
```

### Curves

Timeline Tween offers you to customize the easing curve on three levels. By default, it uses a linear timing function.

#### Property-level curves

The scene's `animate()` method allows you to specify a custom curve by setting the `curve` parameter.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(seconds: 1),
  );

  scene.animate(
    Prop.width,
    tween: Tween<double>(begin: 0.0, end: 100.0),
    curve: Curves.easeInOut, // apply property-level curve
  );

  return tween;
}
```

If there is no `curve` specified, it will take the curve defined by the scene.

#### Scene-level curves

The `addScene()` and `addSubsequentScene()` methods allow you to specify a custom `curve` parameter, that will be used for all properties, unless they have own property-level curve defined.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(seconds: 1),
    curve: Curves.easeInOut, // apply scene-level curve
  );

  return tween;
}
```

If there is no `curve` specified, it will take the curve defined by the tween.

#### Tween-level curves

The constructor `TimelineTween<Prop>(...)` takes an optional parameter `curve`, that will be used for all scenes, unless they have own scene-level curves defined.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>(
    curve: Curves.easeInOut, // apply tween-level curve
  );

  return tween;
}
```

If there is no `curve` specified, it will use `Curves.linear`.

### Extrapolation

Timeline Tween extrapolates all values that are defined in scenes but get used outside those time spans.

Look at this example:

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() => TimelineTween<Prop>()
  ..addScene(
    begin: const Duration(seconds: 1),
    duration: const Duration(seconds: 1),
  ).animate(Prop.width, tween: Tween<double>(begin: 100.0, end: 200.0))
  ..addScene(begin: const Duration(seconds: 3), end: const Duration(seconds: 4))
      .animate(Prop.height, tween: Tween<double>(begin: 400.0, end: 500.0));
```

This tween specifies two scenes tweening `width` from 1 - 2 seconds and `height` from 3 - 4 seconds. The tween ends after 4 seconds.

If we use this tween inside an animation, starting with 0 seconds, both `width` and `height` gets extrapolated to the values `100.0` for `width` and `400.0` for `height`. At 1.5 seconds the `width` is in the middle of the tweening, while `height` stays at `400.0`.

This behavior feels natural and will help you to define complex custom animations.

### Use developer tools

Defining complex tweens can be time-consuming when watching the same animation over and over again.

Simple Animations offers the [Animation Developer Tools](animation_developer_tools.md) to simplify that process.

### Using the predefined enum for animation properties

It's always good to create your own `enum` that contain the precise animation properties the animation uses.
But we developers are sometimes lazy.

If you feel lazy can also use the `Prop` enum that contains a variety of common used animation properties:

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() => TimelineTween<Prop>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(Prop.x, tween: ConstantTween<double>(0.0))
      .animate(Prop.y, tween: ConstantTween<double>(0.0))
      .animate(Prop.width, tween: ConstantTween<double>(0.0))
      .animate(Prop.height, tween: ConstantTween<double>(0.0))
      .animate(Prop.color, tween: ConstantTween<Color?>(Colors.red))
      .animate(Prop.translateX, tween: ConstantTween<double>(0.0))
      .animate(Prop.translateY, tween: ConstantTween<double>(0.0))
      .animate(Prop.rotateZ,
          tween: ConstantTween<double>(0.0)); // and many more...
```

### Animation duration

#### Duration tracking

The `TimelineTween` is technically an `Animateable`. `Animateable`s only contain changes over a relative time span ranging from `0.0` to `1.0`.

In addition to that `TimelineTween` tracks the absolute time specified via scenes. Use the `duration` property to access the absolute duration.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tween = createTween();

    return PlayAnimation<TimelineValue<Prop>>(
      tween: tween,
      duration: tween.duration, // use absolute duration
      builder: (context, child, value) {
        return Container(
          width: value.get(Prop.width),
          height: value.get(Prop.height),
          color: Colors.yellow,
        );
      },
    );
  }
}

TimelineTween<Prop> createTween() => TimelineTween<Prop>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(Prop.width, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(Prop.height, tween: Tween<double>(begin: 300.0, end: 200.0));
```

_Hint: You can also multiply the tracked duration with a numeric factor in order to speed up or slow down an animation._

#### Use own durations

You also use your own `Duration`. Timeline Tween will automatically lengthen or shorten the tween animation.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tween = createTween();

    return PlayAnimation<TimelineValue<Prop>>(
      tween: tween,
      duration: const Duration(seconds: 3), // use own duration
      builder: (context, child, value) {
        return Container(
          width: value.get(Prop.width),
          height: value.get(Prop.height),
          color: Colors.yellow,
        );
      },
    );
  }
}

TimelineTween<Prop> createTween() => TimelineTween<Prop>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(Prop.width, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(Prop.height, tween: Tween<double>(begin: 300.0, end: 200.0));
```
## Anicoto guide

Anicoto (**Ani**mation**Con**troller **to**olkit) enriches your developing expierience with Flutter's AnimationController.

### Basic usage pattern

With Anicoto you can simply add an `AnimationController` just by adding `AnimationMixin` to your stateful widget.

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

💪 The `AnimationMixin` generates a preconfigured AnimationController as `controller`. You can just use it. No need to worry about initialization or disposing.

### Shortcuts for AnimationController

Anicoto enriches the `AnimationController` with four convenience functions:

- `controller.play()` plays animation and stops at the end.

- `controller.playReverse()` plays animation reversed and stops at the start.

- `controller.loop()` repeatly plays the animation from start to the end.

- `controller.mirror()` repeatly plays the animation forward, then backwards, then forward and so on.

Each of these methods take an optional `duration` named parameter to configure your animation action within one line of code.

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

You can use these methods nicely along the already existing `controller.stop()` and `controller.reset()` methods.

### Create multiple AnimationController

With multiple AnimationController you can have many parallel animations at the same time.

Anicoto's `AnimationMixin` enhances your **state class** with a method `createController()` to create multiple **managed\*** AnimationController. _("Managed" means that you don't need to care about initialization and disposing.)_

#### Create a managed AnimationController

First create a class variable of type `AnimationController`. Then inside the `initState() {...}` method call `createController()`. That's all.

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

#### Create many managed AnimationController

Anicoto allows you to have as many AnimationController you want. Behind the scenes it keeps track of them.

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
## Animation Developer Tools guide

The Animation Developer Tools allow you to create or review your animation step by step.

### Basic usage pattern

Wrap your UI with the `AnimationDeveloperTools` widget.

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

Enable developer mode on the animation you want to debug.

#### Using stateless animation widgets

Stateless animation widgets like

- `PlayAnimation`
- `LoopAnimation`
- `MirrorAnimation`
- `CustomAnimation`

have a constructor parameter `developerMode` that can be set to `true`. It will connect to the closest `AnimationDeveloperTools` widget.

**Example**
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
          child: PlayAnimation<double>(
            tween: Tween<double>(begin: 0.0, end: 100.0),
            duration: const Duration(seconds: 1),
            developerMode: true, // enable developer mode
            builder: (context, child, value) {
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

![devtools](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/v2/devtools.gif)

#### Using Anicoto AnimationMixin

If your stateful widget uses `AnimationMixin` to manage your instances of `AnimationController` you can call `enableDeveloperMode()` to connect to the clostest `AnimationDeveloperMode` widget.

**Example**
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

### Features and tricks

The Animation Developer Tools come with several features that simplify your developer life:

- Regardless of the real animation, with developer mode activated the animation will always loop.
- You can use Flutter hot reloading for editing and debugging if your tween is created stateless.
- Use the slider to edit the animated scene while pausing.
- You can slow down the animation to look out for certain details.
- Use the interval buttons to focus on a time span of the animation.