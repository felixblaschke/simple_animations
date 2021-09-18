# 🎥 Anicoto

💡 _Note: These examples uses **[supercharged](https://pub.dev/packages/supercharged)** for syntactic sugar._

## Basic usage pattern

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
    // Connect tween and controller and apply to animation variable
    size = Tween(begin: 0.0, end: 200.0).animate(controller);

    // Start the animation playback
    controller.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.value, // Use animation variable's value here
      height: size.value, // Use animation variable's value here
      color: Colors.red,
    );
  }
}
```

## Multiple AnimationController instances

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
    // create controller instance and let it mirror animate
    widthController = createController()
      ..mirror(duration: const Duration(seconds: 5));
    heightController = createController()
      ..mirror(duration: const Duration(seconds: 3));
    colorController = createController()
      ..mirror(duration: const Duration(milliseconds: 1500));

    // connect tween with individual controller
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