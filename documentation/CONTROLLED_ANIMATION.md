# ControlledAnimation

The widget `ControlledAnimation` builds custom animations in very 
simple way.

## Use cases

The typical scenario for using `ControlledAnimation` is to create
animations based on tweens.

Because of it's widget nature, you can use it everywhere you build widgets.

## Import

Use the following import to use `ControlledAnimation`:
```dart
import 'package:simple_animations/simple_animations.dart';
```

## Simple custom animation

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




## Using non-linear tweens

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



## Delay animation execution

You can delay the start of the animation by specifying the property
`delay` to a `Duration`. `ControlledAnimation` will ignore any animation 
commands until the end of the duration.

> **Hint**
>
> Use delay for a simple way of staggering animations. You can also
> cascade multiple `ControlledAnimation` widgets into each other.
>
> [**Example** (staggered animation by using multiple ControlledAnimation)](https://github.com/felixblaschke/simple_animations/tree/master/example/lib/examples/typewriter_box.dart) 

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




## Controlling the animation

### Playback

You can control the animation with the `playback` property. 

By default it's set to `Playback.PLAY_FORWARD` that will start the animation
immediately *(considering you have no `delay` applied)* and stop at the
end of the animation duration.

You can change the `playback` property anytime to control the animation.

#### Values

playback value | description
-------------- | ------------
Playback.PAUSE | Stops the animation at the current time.
Playback.PLAY_FORWARD | Starts the animation at the current time, playing forward and stops at the end.
Playback.PLAY_REVERSE | Starts the animation from the current time, playing backward and stops at the beginning.
Playback.START_OVER_FORWARD | Starts the animation from the beginning, playing forward and stops at the end.
Playback.START_OVER_REVERSE | Starts the animation from the end, playing backward and stops at the beginning.
Playback.LOOP | Starts the animation from the current time, playing forward and repeating from beginning when reaching the end. 
Playback.MIRROR | Starts the animation from the current time, playing forward until reaching the end. Then it turns around and plays backwards until the beginning. Then again forward. And so on. 

#### Stateless example

```dart
class StatelessUseCase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ControlledAnimation(
        playback: Playback.MIRROR,
        duration: Duration(milliseconds: 1500),
        tween: ColorTween(begin: Colors.red, end: Colors.blue),
        builder: (context, color) {
          // return ...
        });
  }
}
```
This widget's animation will smoothly shift the colors from red to blue.


#### Stateful example

```dart
class StatefulUseCase extends StatefulWidget {
  @override
  _StatefulUseCaseState createState() => _StatefulUseCaseState();
}

class _StatefulUseCaseState extends State<StatefulUseCase> {
  Playback playback = Playback.PLAY_FORWARD;

  void _togglePlaybackDirection() {
    setState(() {
      playback = playback == Playback.PLAY_FORWARD
          ? Playback.PLAY_REVERSE
          : Playback.PLAY_FORWARD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlaybackDirection,
      child: ControlledAnimation(
          playback: playback,
          duration: Duration(milliseconds: 1500),
          tween: ColorTween(begin: Colors.red, end: Colors.blue),
          builder: (context, color) {
            // return ...
          }),
    );
  }
}
```
This widget can control dynamically the direction of the animation by
user interaction.

### Start position

You can specify an initial start position of the animation with the
`startPosition` property. It accepts any values between `0.0` and `1.0`.

> Note: Changing it outside the first initialization has no effect.
  




## Using pre-build childs

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



## Listen to events

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