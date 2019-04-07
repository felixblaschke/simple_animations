# MultiTrackTween

`MultiTrackTween` is an `Animatable` that can tween multiple properties at once.

## Use cases

Typical scenarios for using `MultiTrackTween` are

- staggered animations by combining multiple tweens
- multiple properties (i.e. color and width) are animated simultaneously

The idea behind `MultiTrackTween` is to pass multiple (so called) "Tracks"
into the constructor of `MultiTrackTween`. Each `Track` represents one
property to animate.

## Import

Use the following import to use `MultiTrackTween`:
```dart
import 'package:simple_animations/simple_animations.dart';
```




## Single track tween

Each `Track` has a **name** and consists of one or multiple **sequence parts**:

- First create a Track via by passing the **name** in the constructor:
    ```dart
    final track = Track("width");
    ```
- Then use `add` to append a **sequence part**:
    ```dart
    track.add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 100.0));
    ```
    Specify the `Duration` as first parameter, and an `Animatable` as the
    second parameter. *Optionally you can pass in a `curve` (named parameter)
    to apply easing to your tween.*
    
    > **Hint**
    >
    > The `add` method returns the `Track`, so you can use like a builder:
    >
    > ```dart
    > Track("width")
    >    .add(...)
    >    .add(...)
    >    .add(...);
    > ``` 

- Pass the `Track` into `MultiTrackTween`:
    ```dart
    final tween = MultiTrackTween(track);
    ```

- When using the tween it will return a `Map` where the **track name**
corresponds the the **map key**.
    ```dart
    final widthStart = tween.transform(0.0)["width"];
    final widthMiddle = tween.transform(0.5)["width"];
    final widthEnd = tween.transform(1.0)["width"];
    ```


#### Example

```dart
final tween = MultiTrackTween([
  Track("width")
      .add(Duration(milliseconds: 500), ConstantTween(0.0))
      .add(Duration(milliseconds: 1000), Tween(begin: 0.0, end: 100.0))
      .add(Duration(milliseconds: 700), Tween(begin: 100.0, end: 200.0),
          curve: Curves.easeOut)
]);
```
This tween will compute `{"width": 0.0}` for the first **25%**, then smoothly
interpolates `width` from `0` to `100` for the next **50%**, and from `100` 
to `200` with an `easeOut` effect for the last **25%**. 

You can read more about handling the "real designed duration" below in 
the **Using duration** section.



## Multiple tracks

Advancing from using **one track** to **multiple tracks** is really simple:

- Just specify multiple `Track` with unique names:
    ```dart
    final tween = MultiTrackTween([
      Track("width").add(...).add(...).add(...),
      Track("height").add(...).add(...).add(...),
      Track("color").add(...).add(...).add(...),
      Track("radius").add(...).add(...).add(...),
    ]);
    ```
    
- When animating that tween you receive a `Map` with the **track names**:
    ```dart
    final middleOfAnimation = tween.transform(0.5);
    final width = middleOfAnimation["width"];
    final height = middleOfAnimation["height"];
    final color = middleOfAnimation["color"];
    final radius = middleOfAnimation["radius"];
    ```

- When tracks have unequal durations, the shorter tracks will stretch 
it's last value to the end of the tween (see example below).

#### Example

```dart
final tween = MultiTrackTween([
  Track("width")
    .add(Duration(seconds: 2), Tween(begin: 0.0, end: 100.0)),
  Track("color")
    .add(Duration(seconds: 1), ColorTween(begin: Colors.red, end: Colors.green))
]);
```
This tween will smoothly interpolate `width` from `0` to `100` for the
whole animation and `color` from `red` to `green` for the first 50%
of the animation. For the last 50% the `color` will remain `green`. 




## Using durations

`MultiTrackTween` is an `Animatable` that operates around an abstract
time interval around zero and one.

Sometimes it's helpful to work with the "designed duration" of the tracks.
That's why `MultiTrackTween` offers an additional *getter* `duration` to
retrieve the `Duration` of the longest track.

#### Example

```dart
final tween = MultiTrackTween(...);
final duration = tween.duration;
```




## Use with ControlledAnimation

Simply create a `MultiTrackTween` and save it into a variable. Later you can
pass it to the `tween` property and also use it to set the `duration`.

#### Example

```dart
final tween = MultiTrackTween([
  Track("width")
      .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 100.0))
      .add(Duration(milliseconds: 1500), Tween(begin: 100.0, end: 200.0)),
  Track("color")
      .add(Duration(milliseconds: 800), ConstantTween(Colors.green))
      .add(Duration(milliseconds: 500),
          ColorTween(begin: Colors.green, end: Colors.yellow))
]);

return ControlledAnimation(
  duration: tween.duration,
  tween: tween,
  builder: (context, animation) {
    return Container(
      width: animation["width"],
      height: 100,
      color: animation["color"],
    );
  },
);
``` 

> **Hint**
>
> You can easily scale the animation speed by multiplying the duration with a factor:
>
> ```dart
> duration: tween.duration * 1.25; // slow down by 25%
> ```