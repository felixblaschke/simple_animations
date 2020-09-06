*This project is part of the [Simple Animations Framework](https://pub.dev/packages/simple_animations)*

# 🚀 Stateless Animation

Stateless Animation enables developers to craft custom animations with simple widgets.


## 🌞 Highlights

- Create beautiful animations **within seconds**
- **No struggeling** with stateful widgets and AnimationControllers


## ⛏ Usage

🛈 *The following code snippets use [**supercharged**](https://pub.dev/packages/supercharged) for syntactic sugar.*

### Getting started

Add **Simple Animations** to your project by following the instructions on the 
**[install page](https://pub.dev/packages/simple_animations/install)**.

To learn how to use Stateless Animation:

- Continue reading this page
- Study complete examples at
[**example page**](https://pub.dev/packages/sa_stateless_animation/example)
- Discover the
[**API documentation**](https://pub.dev/documentation/sa_stateless_animation/latest/sa_stateless_animation/sa_stateless_animation-library.html)


### PlayAnimation widget

Create your animation by adding the `PlayAnimation` widget to your app. It takes two mandatory parameters `tween` and `builder`.

#### Tween

The `tween` is the description of your animation. Mostly it will change a value from A to B. Tweens describe **what** will happen but **not how fast it will happen**.

```dart
// Animate a color from red to blue
Animatable<Color> myTween = Colors.red.tweenTo(Colors.blue);
```

#### Builder

The `builder` is a function that is called for each new rendered frame of your animation. It takes three parameters: `context`, `child` and `value`.

- `context` is your Flutter `BuildContext`, which should be familiar to you.

- `child` is a placeholder for any widget that you can additionally pass in a `PlayAnimation` widget. It's usage is described further below.

- `value` is "current value" of any animated variable. If your tween describes to interpolate from `0` to `100`, the `variable` is a value somewhere between `0` and `100`.

How often your `builder` function is called, depends on the animation duration and the framerate of the device used.

#### A simple PlayAnimation

The `PlayAnimation<?>` widget can be typed with the type of the animated variable. This enables us the code type-safe.

```dart
PlayAnimation<Color>( // <-- specify type of animated variable
  tween: Colors.red.tweenTo(Colors.blue), // <-- define tween of colors
  builder: (context, child, value) { // <-- builder function
    return Container(
        color: value, // <-- use animated value
        width: 100, 
        height: 100
    );
});
```
This snippet creates animation of a red square. It's color will fade to blue within one second.

#### Animation duration

By default the duration of the animation is one second. You set the optional parameter `duration` to refine that.

```dart
PlayAnimation<Color>(
  tween: Colors.red.tweenTo(Colors.blue),
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100);
  },
  duration: 5.seconds, // <-- specify duration
);
```

Now the red square will fade it's color for 5 seconds.

#### Delay

By default animations will play automatically. You can set the `delay` parameter to make `PlayAnimation` wait for a given amount of time.

```dart
PlayAnimation<Color>(
  tween: Colors.red.tweenTo(Colors.blue),
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100);
  },
  duration: 5.seconds,
  delay: 2.seconds, // <-- add delay
);
```

The red square will wait for 2 seconds before it starts fading it's color.

#### Non-linear animation

You can make your animation more interesting by applying a non-linear timing curve to it. By default the tween is animated constantly or **linear**. 

Scenarios where the animation is faster at beginning and slower at the ending are called **non-linear animations**.

You can enrich your animation with non-linear behavior by supplying a `Curve` to the `curve` parameter. Flutter comes with a set of predefined curves inside the `Curves` class.

```dart
PlayAnimation<Color>(
  tween: Colors.red.tweenTo(Colors.blue),
  curve: Curves.easeInOut, // <-- specify curve
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100);
  },
);
```

#### Working with child widgets

Animations are highly demanding because parts of your apps are recomputed many times per second. It's important to keep these computions as low as possible.

**Image the following scenario:** There is a `Container` with a colored background. Inside the `Container` is a `Text`. Now we want to animate the background color. There is no need to recompute the `Text` because the animation only effects the `Container` color.

In that scenario we have static `Text` widget. Only the `Container` need to be update on each frame. We can set the static widget as a `child` parameter. In our `builder` function we receive that child widget and can use it inside our animated scene. **This way the child widget is only computed once.**

```dart
PlayAnimation<Color>(
  tween: Colors.red.tweenTo(Colors.blue),
  child: Text("Hello World"), // <-- set child widget
  builder: (context, child, value) { // <-- get child passed into builder function
    return Container(
      child: child, // <-- use child
      color: value,
      width: 100,
      height: 100,
    );
  },
);
```

#### Using keys

Flutter tends to recycle used widgets. If your app swaps out a `PlayAnimation` with another different `PlayAnimation` in the same second, it may recycle the first one. This may lead to a strange behavior.

All widgets mentioned here support keys to avoid such strange behavior. If you are not familiar with keys then [watch this video](https://www.youtube.com/watch?v=kn0EOS-ZiIc).




### LoopAnimation and MirrorAnimation

Beside `PlayAnimation` there are two similar widgets `LoopAnimation` and `MirrorAnimation`. 

It's configuration is pretty the same as the `PlayAnimation`.

#### LoopAnimation

A `LoopAnimation` repeatly plays the specified `tween` from the start to the end.

```dart
LoopAnimation<Color>(
  tween: Colors.red.tweenTo(Colors.blue), // <-- mandatory
  builder: (context, child, value) { // <-- mandatory
    return Container(child: child, color: value, width: 100, height: 100);
  },
  duration: 5.seconds, // <-- optional
  curve: Curves.easeInOut, // <-- optional
  child: Text("Hello World"), // <-- optional
);
```

#### MirrorAnimation

A `MirrorAnimation` repeatly plays the specified `tween` from the start to the end, then reverse to the start, then again forward and so on.

```dart
MirrorAnimation<Color>(
  tween: Colors.red.tweenTo(Colors.blue), // <-- mandatory
  builder: (context, child, value) { // <-- mandatory
    return Container(child: child, color: value, width: 100, height: 100);
  },
  duration: 5.seconds, // <-- optional
  curve: Curves.easeInOut, // <-- optional
  child: Text("Hello World"), // <-- optional
);
```



### CustomAnimation

Use `CustomAnimation` if the animation widgets discussed above aren't sufficient for you use case. Beside all parameters mentioned for `PlayAnimation` it allows you actively control the animation.

#### Take over control

The `control` parameter can be set to the following values:

CustomAnimationControl.VALUE | Description
-------------- | ------------
STOP | Stops the animation at the current position.
PLAY | Plays the animation from the current position reverse to the start.
PLAY_REVERSE | Plays the animation from the current position reverse to the start.
PLAY_FROM_START | Reset the position of the animation to `0.0` and starts playing to the end.
PLAY_REVERSE_FROM_END | Reset the position of the animation to `1.0` and starts playing reverse to the start.
LOOP | Endlessly plays the animation from the start to the end.
MIRROR | Endlessly plays the animation from the start to the end, then it plays reverse to the start, then forward again and so on.

You can bind the `control` value to state variable and change it during the animation. The `CustomAnimation` will adapt to that.

```dart
class _PageState extends State<Page> {
  CustomAnimationControl control = CustomAnimationControl.PLAY; // <-- state variable

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      control: control, // <-- bind state variable to parameter
      tween: (-100.0).tweenTo(100.0),
      builder: (context, child, value) {
        return Transform.translate( // <-- animation that moves childs from left to right
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: MaterialButton( // <-- there is a button
        color: Colors.yellow,
        child: Text("Swap"),
        onPressed: toggleDirection, // <-- clicking button changes animation direction
      ),
    );
  }

  void toggleDirection() {
    setState(() { // toggle between control instructions
      control = (control == CustomAnimationControl.PLAY)
          ? CustomAnimationControl.PLAY_REVERSE
          : CustomAnimationControl.PLAY;
    });
  }
}
```

#### Start position

Each animation has an internal abstract position. This is a value ranging form `0.0` (start) to `1.0` end.

You can modify the initial position by setting the `startPosition` parameter.

```dart
CustomAnimation<Color>(
    control: CustomAnimationControl.PLAY, // <-- play forward
    startPosition: 0.5, // <-- set start position at 50%
    duration: 10.seconds, // <-- full duration is 10 seconds
    tween: Colors.red.tweenTo(Colors.blue),
    builder: (context, child, value) {
      return Container(color: value, width: 100, height: 100);
    });
```

This animation will start playing right in the middle of the specified animation and only will animate for 5 seconds.

#### Listen to AnimationStatus

Behind the scenes there is an `AnimationController` processing the animation. `CustomAnimation` exposes it's `AnimationStatusListener` to enable you to react to finished animations.

You can specify your own listener at the `animationStatusListener` parameter.

```dart
CustomAnimation<Color>(
  tween: Colors.red.tweenTo(Colors.blue),
  builder: (context, child, value) {
    return Container(color: value, width: 100, height: 100);
  },
  animationStatusListener: (AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      print("Animation completed!");
    }
  },
);
```