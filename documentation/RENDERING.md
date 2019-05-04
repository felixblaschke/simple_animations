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

You can utilize [AnimationProgress](ANIMATION_PROGRESS.md) to easily create
animations.



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