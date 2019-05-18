# Rendering

The widget `Rendering` allows easy building of continuous animations.

## Use cases

The typical scenario for using `Rendering` is to create
animations are running continuously and have no explicit start and end.

Because of it's widget nature, you can use it everywhere you build widgets.

## Import

Use the following import to use `Rendering`:
```dart
import 'package:simple_animations/simple_animations.dart';
```

## Simple rendering

The most simple form of using `Rendering` is to supply a `builder`
function:

```dart
Rendering(
  builder: (BuildContext context, Duration timeElapsed) {
    return Text("Time elapsed: $timeElapsed");
  },
);
```

The `builder` function has a second parameter `timeElapsed`. It contains
the amount of time (as a `Duration`) that passed from the creation of
the `Rendering` widget. It useful for creating animations.

The `builder` function is called for each frame that is generated.

## Use AnimationProgress to animate

You can utilize `AnimationProgress` to easily create
animations. 

Simply create an instance of `AnimationProgress` by supplying
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


#### Example

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



## Using onTick and fast-forward

You can specify a `onTick` function that is called before the `builder`
function. It's recommended to put frame-based modifications that apply
to your rendered scene into that `onTick` function:

```dart
Rendering(
  startTime: Duration(seconds: 5),
  onTick: (Duration timeElapsed)  {
    simulateModel(sceneModel);
  },
  builder: (BuildContext context, Duration timeElapsed) {
    return ScenePainter(sceneModel);
  },
);
```

Also you can specify an alternative `startTime`. The `Rendering` widget
will automatically interpolate all `onTick` steps from zero to the 
specified startTime.

It's useful if your animation needs some kind of ramp up time to look
beautiful.