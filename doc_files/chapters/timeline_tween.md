<!-- This file uses generated code. Visit https://pub.dev/packages/readme_helper for usage information. -->
## Timeline Tween guide

Timeline Tween is a **powerful** `Animateable` that animates multiple properties at once.

### Basic usage pattern

Create an `enum` outside your widget class. It contains all properties you want to animate. _(For example: width, height or color)_

<!-- #code ../code/timeline_tween/basic1.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// (1) create enum
enum AniProps { width, height, color }
```
<!-- // end of #code -->

Then you create a `TimelineTween` by instancing it with the `enum` you created in the first step.

<!-- #code ../code/timeline_tween/basic2.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() {
  // (2) create TimelineTween using this enum
  var tween = TimelineTween<AniProps>();

  return tween;
}
```
<!-- // end of #code -->

Use `addScene()` to add a new scene to the tween. A scene represents a span of time when certain properties will tween.

<!-- #code ../code/timeline_tween/basic3.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() {
  var tween = TimelineTween<AniProps>();

  // (3) add a scene to the tween
  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(milliseconds: 700),
  );

  return tween;
}
```
<!-- // end of #code -->

On the `scene` object you can use `animate()` to specify your tweens.

<!-- #code ../code/timeline_tween/basic4.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() {
  var tween = TimelineTween<AniProps>();

  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(milliseconds: 700),
  );

  // (4) apply tweens to properties, referenced in enum
  scene.animate(
    AniProps.width,
    tween: Tween<double>(begin: 0.0, end: 100.0),
  );

  scene.animate(
    AniProps.height,
    tween: Tween<double>(begin: 300.0, end: 200.0),
  );

  return tween;
}
```
<!-- // end of #code -->

The `animate()` method returns its parent `scene` object. You can use this to specify a scene in a builder style. Here is the same scene:

<!-- #code ../code/timeline_tween/basic_builder.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() => TimelineTween<AniProps>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(AniProps.width, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(AniProps.height, tween: Tween<double>(begin: 300.0, end: 200.0));
```
<!-- // end of #code -->

Use the created tween with your favorite animation technique. Here we use the `PlayAnimation`:

<!-- #code ../code/timeline_tween/play_animation_example.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // create tween
    var tween = createTween();

    return PlayAnimation<TimelineValue<AniProps>>(
      tween: tween, // provide tween
      duration: tween.duration, // total duration obtained from TimelineTween
      builder: (context, child, value) {
        return Container(
          width: value.get(AniProps.width), // get animated width value
          height: value.get(AniProps.height), // get animated height value
          color: Colors.yellow,
        );
      },
    );
  }
}

enum AniProps { width, height, color }

TimelineTween<AniProps> createTween() => TimelineTween<AniProps>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(AniProps.width, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(AniProps.height, tween: Tween<double>(begin: 300.0, end: 200.0));
```
<!-- // end of #code -->

`TimelineTween<PropType>` animates to `TimelineValue<PropType>` that offers you a `get()` method that can be used to obtain the single animated values.

### Scenes

A Timeline Tween can consist of multiple scenes with each scene having multiple tweened properties.

#### Absolute scenes

The most simple way to add a scene is to call `tween.addScene()`. It requires you to define two of these three parameters:

- begin (start time of the scene)
- duration (relative duration of the scene)
- end (end time of the scene)

You can freely combine begin/duration, begin/end or duration/end.

<!-- #code ../code/timeline_tween/scenes_absolute.dart -->
```dart
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  // begin + duration
  var scene1 = tween.addScene(
    begin: const Duration(milliseconds: 0),
    duration: const Duration(milliseconds: 700),
  );

  // begin + end
  var scene2 = tween.addScene(
    begin: const Duration(milliseconds: 700),
    end: const Duration(milliseconds: 1400),
  );

  // duration + end
  var scene3 = tween.addScene(
    duration: const Duration(milliseconds: 600),
    end: const Duration(milliseconds: 300),
  );

  return tween;
}
```
<!-- // end of #code -->

#### Relative scenes

While absolute scenes are easy to understand, they have one drawback. Each tuning in timings requires you to touch all `begin` durations.

To avoid this you can work with relative scenes by calling `addSubsequentScene()` on a created scene.

<!-- #code ../code/timeline_tween/scenes_relative.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var firstScene = tween
      .addScene(
        begin: const Duration(seconds: 0),
        duration: const Duration(seconds: 2),
      )
      .animate(Prop.x, tween: ConstantTween<int>(0));

  // secondScene references the firstScene
  var secondScene = firstScene
      .addSubsequentScene(
        delay: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 2),
      )
      .animate(Prop.x, tween: ConstantTween<int>(1));

  return tween;
}
```
<!-- // end of #code -->

Subsequent scenes start right after their predecessor.
The relative nature of subsequent scenes require you to pass in a `duration`. Optionally you can add some `delay`.

#### Scene naming and code style

More complex animations will quickly blow up your code and get confusing. I recommend using variables with an expressive name for each scene. Use an extra function that will create your tween.

Here is my best practise:

<!-- #code ../code/timeline_tween/naming.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> _createComplexTween() {
  var tween = TimelineTween<Prop>();

  var fadeIn = tween
      .addScene(
        begin: const Duration(seconds: 0),
        duration: const Duration(milliseconds: 300),
      )
      .animate(Prop.x, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(Prop.y, tween: Tween<double>(begin: 0.0, end: 100.0));

  var grow = fadeIn
      .addSubsequentScene(duration: const Duration(milliseconds: 700))
      .animate(Prop.x, tween: Tween<double>(begin: 100.0, end: 200.0))
      .animate(Prop.y, tween: Tween<double>(begin: 100.0, end: 200.0));

  var fadeOut = grow
      .addSubsequentScene(duration: const Duration(milliseconds: 300))
      .animate(Prop.x, tween: Tween<double>(begin: 200.0, end: 0.0))
      .animate(Prop.y, tween: Tween<double>(begin: 200.0, end: 0.0));

  return tween;
}
```
<!-- // end of #code -->

### Animate properties

Use the scene's `animate()` method to specify tweens for each property.

<!-- #code ../code/timeline_tween/animate1.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(seconds: 1),
  );

  // animate properties within scene
  scene.animate(
    Prop.width,
    tween: Tween<double>(begin: 0.0, end: 100.0),
  );

  return tween;
}
```
<!-- // end of #code -->

Optionally you can specify `shiftBegin` or `shiftEnd` to further tune each property's timing.

<!-- #code ../code/timeline_tween/animate2.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(seconds: 1),
  );

  scene.animate(
    Prop.width,
    tween: Tween<double>(begin: 0.0, end: 100.0),
    shiftBegin: const Duration(milliseconds: 200), // tune begin or
    shiftEnd:
        const Duration(milliseconds: -200), // end timings by shifting them
  );

  return tween;
}
```
<!-- // end of #code -->

### Curves

Timeline Tween offers you to customize the easing curve on three levels. By default, it uses a linear timing function.

#### Property-level curves

The scene's `animate()` method allows you to specify a custom curve by setting the `curve` parameter.

<!-- #code ../code/timeline_tween/curve1.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(seconds: 1),
  );

  scene.animate(
    Prop.width,
    tween: Tween<double>(begin: 0.0, end: 100.0),
    curve: Curves.easeInOut, // apply property-level curve
  );

  return tween;
}
```
<!-- // end of #code -->

If there is no `curve` specified, it will take the curve defined by the scene.

#### Scene-level curves

The `addScene()` and `addSubsequentScene()` methods allow you to specify a custom `curve` parameter, that will be used for all properties, unless they have own property-level curve defined.

<!-- #code ../code/timeline_tween/curve2.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>();

  var scene = tween.addScene(
    begin: Duration.zero,
    end: const Duration(seconds: 1),
    curve: Curves.easeInOut, // apply scene-level curve
  );

  return tween;
}
```
<!-- // end of #code -->

If there is no `curve` specified, it will take the curve defined by the tween.

#### Tween-level curves

The constructor `TimelineTween<Prop>(...)` takes an optional parameter `curve`, that will be used for all scenes, unless they have own scene-level curves defined.

<!-- #code ../code/timeline_tween/curve3.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() {
  var tween = TimelineTween<Prop>(
    curve: Curves.easeInOut, // apply tween-level curve
  );

  return tween;
}
```
<!-- // end of #code -->

If there is no `curve` specified, it will use `Curves.linear`.

### Extrapolation

Timeline Tween extrapolates all values that are defined in scenes but get used outside those time spans.

Look at this example:

<!-- #code ../code/timeline_tween/extrapolation.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() => TimelineTween<Prop>()
  ..addScene(
    begin: const Duration(seconds: 1),
    duration: const Duration(seconds: 1),
  ).animate(Prop.width, tween: Tween<double>(begin: 100.0, end: 200.0))
  ..addScene(begin: const Duration(seconds: 3), end: const Duration(seconds: 4))
      .animate(Prop.height, tween: Tween<double>(begin: 400.0, end: 500.0));
```
<!-- // end of #code -->

This tween specifies two scenes tweening `width` from 1 - 2 seconds and `height` from 3 - 4 seconds. The tween ends after 4 seconds.

If we use this tween inside an animation, starting with 0 seconds, both `width` and `height` gets extrapolated to the values `100.0` for `width` and `400.0` for `height`. At 1.5 seconds the `width` is in the middle of the tweening, while `height` stays at `400.0`.

This behavior feels natural and will help you to define complex custom animations.

### Use developer tools

Defining complex tweens can be time-consuming when watching the same animation over and over again.

Simple Animations offers the [Animation Developer Tools](animation_developer_tools.md) to simplify that process.

### Using the predefined enum for animation properties

It's always good to create your own `enum` that contain the precise animation properties the animation uses.
But we developers are sometimes lazy.

If you feel lazy can also use the `Prop` enum that contains a variety of common used animation properties:

<!-- #code ../code/timeline_tween/predefined_enum.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

TimelineTween<Prop> createTween() => TimelineTween<Prop>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(Prop.x, tween: ConstantTween<double>(0.0))
      .animate(Prop.y, tween: ConstantTween<double>(0.0))
      .animate(Prop.width, tween: ConstantTween<double>(0.0))
      .animate(Prop.height, tween: ConstantTween<double>(0.0))
      .animate(Prop.color, tween: ConstantTween<Color?>(Colors.red))
      .animate(Prop.translateX, tween: ConstantTween<double>(0.0))
      .animate(Prop.translateY, tween: ConstantTween<double>(0.0))
      .animate(Prop.rotateZ,
          tween: ConstantTween<double>(0.0)); // and many more...
```
<!-- // end of #code -->

### Animation duration

#### Duration tracking

The `TimelineTween` is technically an `Animateable`. `Animateable`s only contain changes over a relative time span ranging from `0.0` to `1.0`.

In addition to that `TimelineTween` tracks the absolute time specified via scenes. Use the `duration` property to access the absolute duration.

<!-- #code ../code/timeline_tween/duration1.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tween = createTween();

    return PlayAnimation<TimelineValue<Prop>>(
      tween: tween,
      duration: tween.duration, // use absolute duration
      builder: (context, child, value) {
        return Container(
          width: value.get(Prop.width),
          height: value.get(Prop.height),
          color: Colors.yellow,
        );
      },
    );
  }
}

TimelineTween<Prop> createTween() => TimelineTween<Prop>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(Prop.width, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(Prop.height, tween: Tween<double>(begin: 300.0, end: 200.0));
```
<!-- // end of #code -->

_Hint: You can also multiply the tracked duration with a numeric factor in order to speed up or slow down an animation._

#### Use own durations

You also use your own `Duration`. Timeline Tween will automatically lengthen or shorten the tween animation.

<!-- #code ../code/timeline_tween/duration2.dart -->
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tween = createTween();

    return PlayAnimation<TimelineValue<Prop>>(
      tween: tween,
      duration: const Duration(seconds: 3), // use own duration
      builder: (context, child, value) {
        return Container(
          width: value.get(Prop.width),
          height: value.get(Prop.height),
          color: Colors.yellow,
        );
      },
    );
  }
}

TimelineTween<Prop> createTween() => TimelineTween<Prop>()
  ..addScene(begin: Duration.zero, end: const Duration(milliseconds: 700))
      .animate(Prop.width, tween: Tween<double>(begin: 0.0, end: 100.0))
      .animate(Prop.height, tween: Tween<double>(begin: 300.0, end: 200.0));
```
<!-- // end of #code -->
