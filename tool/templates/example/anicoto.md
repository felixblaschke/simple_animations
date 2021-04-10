

# 🎥 Anicoto

💡 *Note: These examples uses **[supercharged](https://pub.dev/packages/supercharged)** for syntactic sugar.*

## Basic usage pattern

This example shows a complete app that uses `AnimationMixin` in a simple way.

![example1](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/sa_anicoto/v1/anicoto-1.gif)

```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Page()));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: MyAnimatedWidget())),
    );
  }
}

class MyAnimatedWidget extends StatefulWidget {
  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {  // Add AnimationMixin to state class

  Animation<double> size; // Declare animation variable

  @override
  void initState() {
    size = 0.0.tweenTo(200.0).animatedBy(controller); // Connect tween and controller and apply to animation variable
    controller.play(); // Start the animation playback
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.value, // Use animation variable's value here 
      height: size.value, // Use animation variable's value here
      color: Colors.red
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
import 'package:supercharged/supercharged.dart';

void main() => runApp(MaterialApp(home: Page()));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: MyAnimatedWidget())),
    );
  }
}

class MyAnimatedWidget extends StatefulWidget {
  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {
  AnimationController widthController; // <-- declare AnimationController
  AnimationController heightController; // <-- declare AnimationController
  AnimationController colorController; // <-- declare AnimationController

  Animation<double> width; // <-- declare Animation variable
  Animation<double> height; // <-- declare Animation variable
  Animation<Color> color; // <-- declare Animation variable

  @override
  void initState() {
    widthController = createController()..mirror(duration: 5.seconds); // <-- create controller instance and let it mirror animate
    heightController = createController()..mirror(duration: 3.seconds); // <-- create controller instance and let it mirror animate
    colorController = createController()..mirror(duration: 1500.milliseconds); // <-- create controller instance and let it mirror animate

    width = 100.0.tweenTo(200.0).animatedBy(widthController); // <-- connect tween with individual controller
    height = 100.0.tweenTo(200.0).animatedBy(heightController); // <-- connect tween with individual controller
    color = Colors.red.tweenTo(Colors.blue).animatedBy(colorController); // <-- connect tween with individual controller

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width.value, height: height.value, color: color.value); // <-- use animated values
  }
}
```




