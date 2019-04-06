# ControlledAnimation

The widget `ControlledAnimation` builds custom animations in very 
simple way.

## Usage

You can use `ControlledAnimation` everywhere you build widgets.

Use the following imports:
```dart
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
```



### Simple custom animation

The most simple form uses

- **duration**: `Duration` of the animation sequence

- **tween**: the `Animatable` that maps **"time"** to 
**animation-dependant values**

- **builder**: a modified `WidgetBuilder` that passes the 
**current animation-dependant value** into the `WidgetBuilder` as a second parameter

#### Example
```dart
ControlledAnimation(
    duration: Duration(milliseconds: 1500),
    tween: Tween(begin: 100, end: 300),
    builder: (context, value) {
      return Container(width: value, height: 100, color: Colors.red);
    });
```

This will immediately start an animation. You will see red rectangle 
with a height of 100 and a **width of 100**. Over a time of **1.5 seconds**
the rectangle will increase it's width until it reaches a **width of 300**.




### Using non-linear tweens

If you want your animation to appear accelerated / easing you can set
the property `curve` to any `Curve` you like. You can find common curves
in Flutter's `Curves` class.

#### Example
```dart
ControlledAnimation(
    duration: Duration(milliseconds: 1500),
    tween: Tween(begin: 100, end: 300),
    curve: Curves.easeIn,
    builder: (context, value) {
      // return ...
    });
```



### Delay animation execution

You can delay the start of the animation by specifying the property
`delay` to a `Duration`. `ControlledAnimation` will ignore any animation 
commands until the end of the duration.

> **Hint**
>
> Use delay for a simple way of staggering animations. You can also
> cascade multiple `ControlledAnimation` widgets into each other.
>
> [**Example** (staggered animation by using multiple ControlledAnimation)](https://github.com/felixblaschke/simple_animations_example_app/blob/master/lib/examples/typewriter_box.dart) 

#### Example
```dart
ControlledAnimation(
    delay: Duration(milliseconds: 500),
    duration: Duration(milliseconds: 1500),
    tween: Tween(begin: 100, end: 300),
    builder: (context, value) {
      // return ...
    });
```
This animation will wait for **0.5 seconds** until it animates for 1.5 seconds.




### Controlling the animation

You can control the animation with the `playback` property. 

By default it's set to `Playback.PLAY_FORWARD` that will start the animation
immediately *(considering you have no `delay` applied)* and stop at the
end of the animation duration.

You can change the `playback` property anytime to control the animation.

[**⇨ Learn more about `Playback`**](CONTROLLED_ANIMATION_PLAYBACK.md)

### Using pre-build childs

If the animated scene is quite large you can use a **pre-build child**
to **reduce widget-rebuilds** that are not really effected by animation
to increase the overall performance.

Imagine we have a box that animates it's size. Inside this box is a
centered text "Hello Flutter" that is not effect by the animation:
 
 ```dart
ControlledAnimation(
    duration: Duration(milliseconds: 1500),
    tween: Tween(begin: 100, end: 300),
    builder: (context, value) {
      return Container(
        width: value,
        height: value,
        child: Center(child: Text("Hello Flutter")),
      );
    });
```

During the animation, the context would rebuild very often. Alternatively
you can use the property `builderWithChild` along with `child`, instead of
`builder`.

#### Example
 ```dart
final complexScene = Center(child: Text("Hello Flutter"));

ControlledAnimation(
    duration: Duration(milliseconds: 1500),
    tween: Tween(begin: 100, end: 300),
    child: complexScene,
    builderWithChild: (context, child, value) {
      return Container(
        width: value,
        height: value,
        child: child,
      );
    });
```



### Listen to events

`ControlledAnimation` routes all events of it's internal `AnimationController`
to a specified `AnimationStatusListener` for the property `animationControllerStatusListener`.

For example you can use it listen to the `AnimationStatus.completed` event 
(*The animation is stopped at the beginning*) or the `AnimationStatus.dismissed`
event (*The animation is stopped at the end*).

#### Example
```dart
  ControlledAnimation(
      duration: Duration(milliseconds: 1500),
      tween: Tween(begin: 100, end: 300),
      animationControllerStatusListener: (status) {
        if (status == AnimationStatus.completed) {
          // do something
        }
      },
      builder: (context, value) {
        // return ...
      });
```