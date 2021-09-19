## Stateless Animation guide

Stateless Animation enables developers to craft custom animations with simple widgets.

### PlayAnimation widget

The `PlayAnimation()` widget plays an animation described by the properties `tween` and `builder`.

#### Tween

The `tween` is the description of your animation. Mostly it will change a value from A to B. Tweens describe **what** will happen but **not how fast it will happen**.

@code tool/templates/code/stateless_animation/pa_tween.dart

#### Builder

The `builder` is a function that is called for **each new rendered frame** of your animation. It takes three parameters: `context`, `child` and `value`.

- `context` is your Flutter `BuildContext`, which should be familiar to you.

- `child` is a placeholder for any widget that you can additionally pass in a `PlayAnimation` widget. Its usage is described further below.

- `value` is "current value" of any animated variable. If your tween describes to interpolate from `0` to `100`, the `variable` is a value somewhere between `0` and `100`.

How often your `builder` function is called, depends on the animation duration, and the framerate of the device used.

#### A simple PlayAnimation

The `PlayAnimation<?>` widget can be typed with the type of the animated variable. This enables us the code type-safe.

@code tool/templates/code/stateless_animation/pa_basic.dart

This snippet creates animation of a red square. It's color will fade to blue within one second.

#### Animation duration

By default, the duration of the animation is one second. You set the optional parameter `duration` to refine that.

@code tool/templates/code/stateless_animation/pa_duration.dart

Now the red square will fade it's color for 5 seconds.

#### Delay

By default, animations will play automatically. You can set the `delay` parameter to make `PlayAnimation` wait for a given amount of time.

@code tool/templates/code/stateless_animation/pa_delay.dart

The red square will wait for 2 seconds before it starts fading its color.

#### Non-linear animation

You can make your animation more interesting by applying a non-linear timing curve to it. By default, the tween is animated constantly or **linear**.

Scenarios where the animation is faster at beginning and slower at the ending are called **non-linear animations**.

You can enrich your animation with non-linear behavior by supplying a `Curve` to the `curve` parameter. Flutter comes with a set of predefined curves inside the `Curves` class.

@code tool/templates/code/stateless_animation/pa_curve.dart

#### Track animation status

You can track the status of the animation by setting the `onStart` and `onComplete` callbacks.

@code tool/templates/code/stateless_animation/pa_lifecycle.dart

#### Working with child widgets

Animations are highly demanding because parts of your apps are recomputed many times per second. It's important to keep these computations as low as possible.

**Image the following scenario:** There is a `Container` with a colored background. Inside the `Container` is a `Text`. Now we want to animate the background color. There is no need to recompute the `Text` because the animation only effects the `Container` color.

In that scenario we have static `Text` widget. Only the `Container` need to be updated on each frame. We can set the static widget as a `child` parameter. In our `builder` function we receive that child widget and can use it inside our animated scene. **This way the child widget is only computed once.**

@code tool/templates/code/stateless_animation/pa_child.dart

#### Using keys

Flutter tends to recycle used widgets. If your app swaps out a `PlayAnimation` with another different `PlayAnimation` in the same second, it may recycle the first one. This may lead to a strange behavior.

All widgets mentioned here support keys to avoid such strange behavior. If you are not familiar with keys then [watch this video](https://www.youtube.com/watch?v=kn0EOS-ZiIc).

#### App example

@code tool/templates/code/stateless_animation/example_play_animation.dart

### LoopAnimation and MirrorAnimation

Beside `PlayAnimation` there are two similar widgets `LoopAnimation` and `MirrorAnimation`.

Its configuration is pretty the same as the `PlayAnimation`.

#### LoopAnimation

A `LoopAnimation` repeatedly plays the specified `tween` from the start to the end.

@code tool/templates/code/stateless_animation/loop_animation.dart

#### MirrorAnimation

A `MirrorAnimation` repeatedly plays the specified `tween` from the start to the end, then reverse to the start, then again forward and so on.

@code tool/templates/code/stateless_animation/mirror_animation.dart

### CustomAnimation

Use `CustomAnimation` if the animation widgets discussed above aren't sufficient for you use case. Beside all parameters mentioned for `PlayAnimation` it allows you actively control the animation.

#### Control the animation

The `control` parameter can be set to the following values:

| CustomAnimationControl._VALUE_ | Description                                                                                                                |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| `stop`                         | Stops the animation at the current position.                                                                               |
| `play`                         | Plays the animation from the current position reverse to the start.                                                        |
| `playReverse`                  | Plays the animation from the current position reverse to the start.                                                        |
| `playFromStart`                | Reset the position of the animation to `0.0` and starts playing to the end.                                                |
| `playReverseFromEnd`           | Reset the position of the animation to `1.0` and starts playing reverse to the start.                                      |
| `loop`                         | Endlessly plays the animation from the start to the end.                                                                   |
| `mirror`                       | Endlessly plays the animation from the start to the end, then it plays reverse to the start, then forward again and so on. |

You can bind the `control` value to state variable and change it during the animation. The `CustomAnimation` will adapt to that.

@code tool/templates/code/stateless_animation/example_control.dart

#### Start position

Each animation has an internal abstract position. This is a value ranging form `0.0` _(start)_ to `1.0` _(end)_.

You can modify the initial position by setting the `startPosition` parameter.

@code tool/templates/code/stateless_animation/start_position.dart

This animation will start playing right in the middle of the specified animation and only will animate for 2.5 seconds.

#### Track animation status

You can track the status of the animation by setting the `onStart` and `onComplete` callbacks.

@code tool/templates/code/stateless_animation/ca_lifecycle.dart

Or you can access the [`AnimationStatusListener`](https://api.flutter.dev/flutter/animation/AnimationStatusListener.html) within the internal [`AnimationController`](https://api.flutter.dev/flutter/animation/AnimationController-class.html).

@code tool/templates/code/stateless_animation/animation_status.dart
