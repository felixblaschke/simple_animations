
# 🎥 Anicoto documentation

Anicoto (**Ani**mation**Con**troller **to**olkit) enriches your developing expierience with Flutter's AnimationController.

## Basic usage pattern

### Overview

Configuring animation support is three simple steps:

- Add the `AnimationMixin` to the **state class** of your stateful widget
- Declare `Animation<?>` **class variables** for each animated property and **use them** in your `build() {...}` method
- Create an `initState() {...}` method and **connect tweens with the controller** by calling `tween.animatedBy(controller)`. Store that result into your `Animation<?>` variable. Finally **start the animation** with `controller.play()`.

```dart
class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {  // Add AnimationMixin to state class

  Animation<double> size; // Declare animation variable

  @override
  void initState() {
    size = 0.0.tweenTo(200.0).animatedBy(controller); // Connect tween and controller and apply to animation variable
    controller.play(); // Start the animation playback
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.value, // Use animation variable's value here 
      height: size.value, // Use animation variable's value here
      color: Colors.red
    );
  }
}
```

💪 *Note: The `AnimationMixin` generates a preconfigured AnimationController as  `controller`. You can just use it. No need to worry about initialization or disposing.*

### The three steps in more detail

Creating own animations with an `AnimationController` requires state changing. For that you first create a **stateful widget** that contains the content you want to animate.

Start by adding `with AnimationMixin` to your **state class**.
```dart
class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin { // <-- add AnimationMixin to your state class

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0, // <-- value to animate
      height: 100.0, // <-- value to animate
      color: Colors.red
    );
  }
}
```
This snippet wants to animate a red square. For that we identified `width` and `height` to be the animated property "size".

Next we substitute the fixed values for our "size" with a declared `Animation<double>` class variable.

```dart
class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {

  Animation<double> size; // <-- Animation variable for "size"
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.value, // <-- use the animated value for "size"
      height: size.value, // <-- use the animated value for "size"
      color: Colors.red
    );
  }
}
```

The final step is to add an `initState() { ... }` method. In this method we connect **tweens** (*"the movie script of our animation"*) with our **AnimationController** (*"the movie director"*). Then we can start the animation by calling `controller.play()`.

```dart
@override
void initState() {
  size = 0.0.tweenTo(200.0).animatedBy(controller); // <-- connect tween with controller
  controller.play(); // <-- start animation playback
  super.initState(); 
}
```

You can find the complete code on top of the [example page](example/#-anicoto).


## Shortcuts for AnimationController

Anicoto enriches the `AnimationController` with four convenience functions:

- `controller.play()` plays animation and stops at the end.

- `controller.playReverse()` plays animation reversed and stops at the start.

- `controller.loop()` repeatly plays the animation from start to the end.

- `controller.mirror()` repeatly plays the animation forward, then backwards, then forward and so on.

Each of these methods take an optional `duration` named parameter to configure your animation action within one line of code.

```dart
controller.play(duration: 1500.milliseconds);
controller.playReverse(duration: 1500.milliseconds);
controller.loop(duration: 1500.milliseconds);
controller.mirror(duration: 1500.milliseconds);
```

You can use these methods nicely along the already existing `controller.stop()` and `controller.reset()` methods.


## Create multiple AnimationController

With multiple AnimationController you can have many parallel animations at the same time.

Anicoto's `AnimationMixin` enhances your **state class** with a method `createController()` to create multiple **managed\*** AnimationController. *("Managed" means that you don't need to care about initialization and disposing.)*

### Create a managed AnimationController

First create a class variable of type `AnimationController`. Then inside the `initState() {...}` method call `createController()`. That's all.
```dart
class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin { // <-- use AnimationMixin
  
  AnimationController sizeController; // <-- declare custom AnimationController
  Animation<double> size;

  @override
  void initState() {
    sizeController = createController(); // <-- create custom AnimationController
    size = 0.0.tweenTo(100.0).animatedBy(sizeController); // <-- animate "size" with custom AnimationController
    sizeController.play(duration: 5.seconds); // <-- start playback on custom AnimationController
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: size.value, height: size.value, color: Colors.red);
  }
}
```

### Create many managed AnimationController

Anicoto allows you to have as many AnimationController you want. Behind the scenes it keeps track of them.

```dart
class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with AnimationMixin {
  AnimationController widthController;
  AnimationController heightController;
  AnimationController colorController;

  Animation<double> width;
  Animation<double> height;
  Animation<Color> color;

  @override
  void initState() {
    widthController = createController()..mirror(duration: 5.seconds);
    heightController = createController()..mirror(duration: 3.seconds);
    colorController = createController()..mirror(duration: 1500.milliseconds);

    width = 100.0.tweenTo(200.0).animatedBy(widthController);
    height = 100.0.tweenTo(200.0).animatedBy(heightController);
    color = Colors.red.tweenTo(Colors.blue).animatedBy(colorController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width.value, height: height.value, color: color.value);
  }
}
```
Isn't it insanely simple? It's Simple Animations!
