
# 📝 Examples

🛈 *Note: These examples uses **[supercharged](https://pub.dev/packages/supercharged)** for syntactic sugar.*

## Simple PlayAnimation widget

Animates the size of a square within a stateless widget.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-1.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: (50.0).tweenTo(200.0), // <-- specify tween (from 50.0 to 200.0)
      duration: 5.seconds, // <-- set a duration
      builder: (context, child, value) { // <-- use builder function
        return Container(
          width: value, // <-- apply animated value obtained from builder function parameter
          height: value, // <-- apply animated value obtained from builder function parameter
          color: Colors.green,
        );
      },
    );
  }
}
```





## PlayAnimation widget with a child

This example demonstrates the usage of a child widget along with `PlayAnimation`.

![example2](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-2.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: (50.0).tweenTo(200.0),
      duration: 5.seconds,
      child: Center(child: Text("Hello!")), // <-- specify widget called "child"
      builder: (context, child, value) { // <-- obtain child from builder function parameter
        return Container(
          width: value,
          height: value,
          child: child, // <-- place child inside your animation
          color: Colors.green,
        );
      },
    );
  }
}
```



## PlayAnimation with non-linear animation

This example demonstrates a non-linear animation. A pink square increases it's size. The `easeOut` curve applied to the animation makes it slow down at the end.

![example3](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-3.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: 0.0.tweenTo(200.0),
      duration: 2.seconds,
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


## PlayAnimation with delay

This example demonstrates an animation that waits for two seconds before it starts it's animation.

![example4](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-4.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: 100.0.tweenTo(200.0),
      duration: 2.seconds,
      delay: 1.seconds,
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


## LoopAnimation

Animation that repeatly pops up a text.

![example5](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-5.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoopAnimation<double>(
        tween: 0.0.tweenTo(10.0),
        duration: 2.seconds,
        curve: Curves.easeOut,
        builder: (context, child, value) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Text("Hello!"));
  }
}
```




## MirrorAnimation

This examples endlessly moves a green box from left to right.

![example6](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-6.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MirrorAnimation<double>(
      tween: (-100.0).tweenTo(100.0), // <-- value for offset x-coordinate
      duration: 2.seconds,
      curve: Curves.easeInOutSine, // <-- non-linear animation
      builder: (context, child, value) {
        return Transform.translate(
          offset: Offset(value, 0), // <-- use animated value for x-coordinate
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


## CustomAnimation in stateless environment

Example of a pulsing square created with a fully configured `CustomAnimation` widget.

![example7](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-7.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      control: CustomAnimationControl.MIRROR,
      tween: 100.0.tweenTo(200.0),
      duration: 2.seconds,
      delay: 1.seconds,
      curve: Curves.easeInOut,
      child: Center(
          child: Text(
        "Hello!",
        style: TextStyle(color: Colors.white, fontSize: 24),
      )),
      startPosition: 0.5,
      animationStatusListener: (status) {
        print("status updated: $status");
      },
      builder: (context, child, value) {
        return Container(
            width: value, height: value, color: Colors.blue, child: child);
      },
    );
  }
}
```

## CustomAnimation in a stateful environment

This example demonstrates the usage of `CustomAnimation` in a stateful widget.

![example8](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_stateless_animation/v1/stateless-animation-8.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Page()))));

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  CustomAnimationControl control = CustomAnimationControl.PLAY; // <-- state variable

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      control: control, // <-- bind state variable to parameter
      tween: (-100.0).tweenTo(100.0),
      builder: (context, child, value) {
        return Transform.translate( // <-- animation that moves childs from left to right
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: MaterialButton( // <-- there is a button
        color: Colors.yellow,
        child: Text("Swap"),
        onPressed: toggleDirection, // <-- clicking button changes animation direction
      ),
    );
  }

  void toggleDirection() {
    setState(() { // toggle between control instructions
      control = (control == CustomAnimationControl.PLAY)
          ? CustomAnimationControl.PLAY_REVERSE
          : CustomAnimationControl.PLAY;
    });
  }
}
```