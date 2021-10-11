<!-- This file uses generated code. Visit https://pub.dev/packages/readme_helper for usage information. -->
## Animation Developer Tools guide

The Animation Developer Tools allow you to create or review your animation step by step.

### Basic usage pattern

Wrap your UI with the `AnimationDeveloperTools` widget.

<!-- #code ../code/animation_developer_tools/intro.dart -->
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

#### Using stateless animation widgets

Stateless animation widgets like

- `PlayAnimation`
- `LoopAnimation`
- `MirrorAnimation`
- `CustomAnimation`

have a constructor parameter `developerMode` that can be set to `true`. It will connect to the closest `AnimationDeveloperTools` widget.

**Example**
<!-- #code ../code/animation_developer_tools/stateless_animation.dart -->
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
<!-- // end of #code -->

![devtools](https://raw.githubusercontent.com/felixblaschke/simple_animations_documentation_assets/master/v2/devtools.gif)

#### Using Anicoto AnimationMixin

If your stateful widget uses `AnimationMixin` to manage your instances of `AnimationController` you can call `enableDeveloperMode()` to connect to the clostest `AnimationDeveloperMode` widget.

**Example**
<!-- #code ../code/animation_developer_tools/anicoto.dart -->
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
