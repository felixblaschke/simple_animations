
# 🎥 Anicoto documentation

Anicoto (**Ani**mation**Con**troller **to**olkit) enriches your developing expierience with Flutter's AnimationController.

## Basic usage pattern

With Anicoto you can simply add an `AnimationController` just by adding `AnimationMixin` to your stateful widget.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyAnimatedWidget extends StatefulWidget {
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

💪 The `AnimationMixin` generates a preconfigured AnimationController as  `controller`. You can just use it. No need to worry about initialization or disposing.


## Shortcuts for AnimationController

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
  controller.play(duration: Duration(milliseconds: 1500));
  controller.playReverse(duration: Duration(milliseconds: 1500));
  controller.loop(duration: Duration(milliseconds: 1500));
  controller.mirror(duration: Duration(milliseconds: 1500));
}
```

You can use these methods nicely along the already existing `controller.stop()` and `controller.reset()` methods.


## Create multiple AnimationController

With multiple AnimationController you can have many parallel animations at the same time.

Anicoto's `AnimationMixin` enhances your **state class** with a method `createController()` to create multiple **managed\*** AnimationController. *("Managed" means that you don't need to care about initialization and disposing.)*

### Create a managed AnimationController

First create a class variable of type `AnimationController`. Then inside the `initState() {...}` method call `createController()`. That's all.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyAnimatedWidget extends StatefulWidget {
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
    sizeController.play(duration: Duration(seconds: 5));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: size.value, height: size.value, color: Colors.red);
  }
}
```

### Create many managed AnimationController

Anicoto allows you to have as many AnimationController you want. Behind the scenes it keeps track of them.

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class MyAnimatedWidget extends StatefulWidget {
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
    widthController = createController()..mirror(duration: 5.seconds);
    heightController = createController()..mirror(duration: 3.seconds);
    colorController = createController()..mirror(duration: 1500.milliseconds);

    width = 100.0.tweenTo(200.0).animatedBy(widthController);
    height = 100.0.tweenTo(200.0).animatedBy(heightController);
    color = Colors.red.tweenTo(Colors.blue).animatedBy(colorController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width.value, height: height.value, color: color.value);
  }
}
```
> *Note: We use [supercharged extensions](https://pub.dev/packages/supercharged) here. If you don't like it, refer to this [dependency-less example](../doc/no_supercharged/anicoto/managed2_ns.dart.md).*