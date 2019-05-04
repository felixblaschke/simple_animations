# AnimationProgress

`AnimationProgress` is a utility class that helps you with `Duration`-based
Animations like [Rendering](RENDERING.md).

## Import

Use the following import to use `AnimationProgress`:
```dart
import 'package:simple_animations/simple_animations.dart';
```

## Usage

You can simply create an instance of `AnimationProgress` by supplying
a `startTime` and a `duration`.

```dart
final animationProgress = AnimationProgress(
      startTime: Duration(seconds: 2), duration: Duration(seconds: 2));
```

The instance has now the ability to query the progression value (a `double`
value between `0.0` and `1.0`) by calling `progress(...)`.

In this case the animation will start at 2 seconds, reaches it's half at
3 seconds and will end at 4 seconds.

```dart
animationProgress.progress(Duration(seconds: 2)); // = 0.0
animationProgress.progress(Duration(seconds: 3)); // = 0.5
animationProgress.progress(Duration(seconds: 4)); // = 1.0
```

It automatically clamps values that are our outside the duration, in order
to display start- and end-states of the animation:

```dart
animationProgress.progress(Duration(seconds: 1)); // = 0.0
animationProgress.progress(Duration(seconds: 5)); // = 1.0
```


## Example

This examples covers using `AnimationProgress` with `Rendering` and
Flutter's build-in tweens:

```dart
class ExampleWidget extends StatelessWidget {
  final tween = Tween(begin: 0.0, end: 100.0);
  final animationProgress = AnimationProgress(
      startTime: Duration.zero, duration: Duration(seconds: 3));

  @override
  Widget build(BuildContext context) {
    return Rendering(
      builder: (context, timeElapsed) {
        final progress = animationProgress.progress(timeElapsed);
        return Container(
          width: tween.transform(progress),
          height: 100,
          color: Colors.red,
        );
      },
    );
  }
}
``` 