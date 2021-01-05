# ⏯ Animation Developer Tools documentation

The Animation Developer Tools allow you to create or review your animation step by step.

💡 *Note: These code examples uses **[supercharged](https://pub.dev/packages/supercharged)** for syntactic sugar.*

## Basic usage pattern

Wrap your UI with the `AnimationDeveloperTools` widget.

```dart
@override
Widget build(BuildContext context) {
  return AnimationDeveloperTools(
    child: // your UI
  );
}
```

Enable developer mode on the animation you want to debug.

### Stateless animation widgets

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
import 'package:supercharged/supercharged.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: AnimationDeveloperTools( // place widget
            child: Center(
              child: LoopAnimation<double>(
                tween: 0.0.tweenTo(100.0),
                duration: 1.seconds,
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
        ),
      ),
    );
  }
}

```

## Features and tricks

The Animation Developer Tools come with several features that simplify your developer life:

- Regardless of the real animation, with developer mode activated the animation will always loop.
- You can use Flutter hot reloading for editing and debugging if your tween is created stateless.
- Use the slider to edit the animated scene while pausing.
- You can slow down the animation to look out for certain details.
- Use the interval buttons to focus on a time span of the animation.
