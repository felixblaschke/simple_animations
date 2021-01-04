
# 🎭 Timeline Tween documentation

Timeline Tween is a **powerful** `Animateable` that animates multiple properties at once.

💡 *Note: These code examples uses **[supercharged](https://pub.dev/packages/supercharged)** for syntactic sugar.*

## Basic usage pattern

Create an `enum` outside your widget class. It contains all properties you want to animate. *(For example: width, height or color)*
```dart
enum AniProps { width, height, color }
```

Then you create a `TimelineTween` by instancing it with the `enum` you created in the first step.

```dart
var _tween = TimelineTween<AniProps>();
```

Use `addScene()` to add a new scene to the tween. A scene represents a span of time where certain properties will tween.

```dart
var scene = _tween.addScene(begin: 0.milliseconds, end: 700.milliseconds);
```

On the `scene` object you can use `animate()` to specify your tweens.

```dart
scene.animate(AniProps.width, tween: 0.0.tweenTo(100.0));
scene.animate(AniProps.height, tween: 300.0.tweenTo(200.0));
```



The `animate()` method returns it's parent `scene` object. You can use this to specify a scene in a builder style. Here is the same scene:

```dart
_tween.addScene(begin: 0.milliseconds, end: 700.milliseconds)
  .animate(AniProps.width, tween: 0.0.tweenTo(100.0))
  .animate(AniProps.height, tween: 300.0.tweenTo(200.0));
```

Use the created `_tween` with your favorite animation technique. Here we use the `PlayAnimation` widget provided by **Simple Animations**:

```dart
PlayAnimation<TimelineValue<AniProps>>(
  tween: _tween, // Pass in tween
  duration: _tween.duration, // Pass in total duration obtained from TimelineTween
  builder: (context, child, value) {
    return Container(
      width: value.get(AniProps.width), // Get animated width value
      height: value.get(AniProps.height), // Get animated height value
      color: Colors.yellow,
    );
  },
);
```

`TimelineTween<PropType>` animates to `TimelineValue<PropType>` that offers you a `get()` method that can be used to obtain the single animated values.


## Scenes

A Timeline Tween can consist of multiple scenes with each scene having multiple tweened properties.

### Absolute scenes

The most simple way to add a scene is to call `tween.addScene()`. It requires you to define two of these three parameters:

- begin (start time of the scene)
- duration (relative duration of the scnee)
- end (end time of the scene)

You can freely combine begin/duration, begin/end or duration/end.

```dart
var scene1 = tween.addScene(
  begin: 0.milliseconds,
  duration: 700.milliseconds,
);

var scene2 = tween.addScene(
  begin: 700.milliseconds,
  end: 1400.milliseconds,
);

var scene3 = tween.addScene(
  duration: 600.milliseconds,
  end: 3000.milliseconds,
);
```


### Relative scenes

While absolute scenes are easy to understand they have one drawback. Each tuning in timings requires you to touch all `begin` durations.

To avoid this you can work with relative scenes by calling `addSubsequentScene()` on a created scene.

```dart
var firstScene = tween.addScene(...)
  .animate(...);

var secondScene = firstScene.addSubsequentScene(...)
  .animate(...);
```

Subsequent scenes start right after their predecessor. 

The relative nature of subsequent scenes require you to pass in a `duration`. Optionally you can add some `delay`.

```dart
var nextScene = previousScene.addSubsequentScene(
  delay: 300.milliseconds, // will start 300ms after previousScene
  duration 2.seconds,
).animate(...)
```

### Scene naming and code style

More complex animations will quickly blow up your code and get confusing. I recommend using variables with an expressive name for each scene. Use an extra function that will create your tween.

Here is my best practise:

```dart
TimelineTween<Prop> _createComplexTween() {
  var tween = TimelineTween<Prop>();

  var fadeIn = tween.addScene(...)
    .animate(Prop.x, ...)
    .animate(Prop.y, ...);

  var grow = fadeIn.addSubsequentScene(...)
    .animate(Prop.x, ...)
    .animate(Prop.y, ...);

  var fadeOut = tween.addScene(...)
    .animate(Prop.x, ...)
    .animate(Prop.y, ...);

  return tween;
}
```

## Animate properties

Use the scene's `animate()` method to specify tweens for each property.

```dart
scene.animate(Prop.width, tween: 100.0.tweenTo(200.0));
```

Optionally you can specify `shiftBegin` or `shiftEnd` to further tune each property's timing.

```dart
scene.animate(
  Prop.width,
  tween: 100.0.tweenTo(200.0),
  shiftBegin: 200.milliseconds,
  shiftEnd: -200.milliseconds,
);
```

## Curves

Timeline Tween offers you to customize the easing curve on three levels. By default it uses a linear timing function.

### Property-level curves

The scene's `animate()` method allows you to specify a custom curve by setting the `curve` parameter.

```dart
scene.animate(
  Prop.width,
  tween: 100.0.tweenTo(200.0),
  curve: Curves.easeInOut,
);
```

If there is no `curve` specified, it will take the curve defined by the scene.


### Scene-level curves

The `addScene()` and `addSubsequentScene()` methods allow you to specify a custom `curve` parameter, that will be used for all properties, unless they have own property-level curve defined.

```dart
tween.addScene(
  begin: 0.seconds,
  end: 1.seconds, 
  curve: Curves.easeInOut,
);
```

If there is no `curve` specified, it will take the curve defined by the tween.


### Tween-level curves

The constructor `TimelineTween<Prop>(...)` takes an optional parameter `curve`, that will be used for all scenes, unless they have own scene-level curves defined.

```dart
var tween = TimelineTween<Prop>(curve: Curves.easeInOut);
```

If there is no `curve` specified, it will use `Curves.linear`.

## Extrapolation

Timeline Tween extrapolates all values that are defined in scenes but get used outside those time spans.

Look at this example:

```dart
final _tween = TimelineTween<Prop>()
    ..addScene(begin: 1.seconds, duration: 1.seconds)
        .animate(Prop.width, tween: 100.0.tweenTo(200.0))
    ..addScene(begin: 3.seconds, end: 4.seconds)
        .animate(Prop.height, tween: 400.0.tweenTo(500.0));
```

This tween specifies two scenes tweening `width` from 1 - 2 seconds and `height` from 3 - 4 seconds. The tween ends after 4 seconds.

If we use this tween inside an animation, starting with 0 seconds, both `width` and `height` gets extrapolated to the values `100.0` for `width` and `400.0` for `height`. At 1.5 seconds the `width` is in the middle of the tweening, while `height` stays at `400.0`.

This behavior feels natural and will help you defining complex custom animations.

## Use developer tools

Defining complex tweens can be time consuming when watching the same animation over and over again.

Simple Animations offers the [Animation Developer Tools](animation_developer_tools.md) to simplify that process.


## Using the predefined enum for animation properties

It's always good to create your own `enum` that contain the precise animation properties the animation uses.
But we developers are sometimes lazy.

If you feel lazy can also use the `Prop` enum that contains a varity of common used animation properties.

```dart
final tween = TimelineTween<Prop>()
  ..addScene(begin: 0.milliseconds, duration: 500.milliseconds)
    .animate(Prop.width, tween: 0.0.tweenTo(400.0))
    .animate(Prop.height, tween: 500.0.tweenTo(200.0));
```

## Animation duration

### Duration tracking

The `TimelineTween` is technically an `Animateable`. `Animateable`s only contain changes over a relative time span ranging from `0.0` to `1.0`. 

In addition to that `TimelineTween` tracks the absolute time specified via scenes. Use the `duration` property to access the absolute duration.

```dart
PlayAnimation<TimelineValue<Prop>>(
  tween: _tween,
  duration: _tween.duration, // Use absolute duration
  builder: (context, child, value) {
    return ...;
  },
);
```

*Hint: You can also multiply the tracked duration with a numeric factor in order to speed up or slow down an animation.*

### Use own durations

You also also use your own `Duration`. Timeline Tween will automatically lengthen or shorten the tween animation.

```dart
PlayAnimation<TimelineValue<Prop>>(
  tween: _tween,
  duration: 3.seconds, // Use own duration
  builder: (context, child, value) {
    return ...;
  },
);
```
