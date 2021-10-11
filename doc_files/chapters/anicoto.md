<!-- This file uses generated code. Visit https://pub.dev/packages/readme_helper for usage information. -->
## Anicoto guide

Anicoto (**Ani**mation**Con**troller **to**olkit) enriches your developing expierience with Flutter's AnimationController.

### Basic usage pattern

With Anicoto you can simply add an `AnimationController` just by adding `AnimationMixin` to your stateful widget.

<!-- #code ../code/anicoto/basic.dart -->
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

### Shortcuts for AnimationController

Anicoto enriches the `AnimationController` with four convenience functions:

- `controller.play()` plays animation and stops at the end.

- `controller.playReverse()` plays animation reversed and stops at the start.

- `controller.loop()` repeatly plays the animation from start to the end.

- `controller.mirror()` repeatly plays the animation forward, then backwards, then forward and so on.

Each of these methods take an optional `duration` named parameter to configure your animation action within one line of code.

<!-- #code ../code/anicoto/shortcuts.dart -->
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

### Create multiple AnimationController

With multiple AnimationController you can have many parallel animations at the same time.

Anicoto's `AnimationMixin` enhances your **state class** with a method `createController()` to create multiple **managed\*** AnimationController. _("Managed" means that you don't need to care about initialization and disposing.)_

#### Create a managed AnimationController

First create a class variable of type `AnimationController`. Then inside the `initState() {...}` method call `createController()`. That's all.

<!-- #code ../code/anicoto/managed1.dart -->
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

<!-- #code ../code/anicoto/managed2.dart -->
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
