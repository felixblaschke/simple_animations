# AnimationControllerX

The `AnimationControllerX` is an powerful implementation of an AnimationController.

## Use cases

Use `AnimationControllerX` to create precisely controlled, custom animations or as a replacement for Flutter's own [AnimationController](https://docs.flutter.io/flutter/animation/AnimationController-class.html).

## Import

Use the following import to use `AnimationControllerX`:
```dart
import 'package:simple_animations/simple_animations.dart';
```

## Differences to regular AnimationController

Aspect | AnimationController *(Flutter)* | AnimationControllerX *(Simple Animations)*
-- | -- | --
Interface to `Animatable` | `Tween(...).animate(controller)` |  `Tween(...).animate(controller)`
Playback control | Single command at-a-time execution | Multiple commands task queue
Status callbacks | Very limited | Awesome  
Extendable | No | Yes (`AnimationTask`)
Value control | Internal | External model (`AnimationTask`)
Durations | Only 1 (stored in controller) | Multiple (defined per task)





## Add a new AnimationControllerX

There a two ways to add an `AnimationControllerX` to your stateful widget.

### A: Fast configuration via mixin **(recommended)**

- Just apply the `AnimationControllerMixin` to your `State`. 
- You have ready-to-use `AnimationControllerX` accessable via the property `controller`.

#### Example

```dart
class _WidgetWithAnimationState extends State<WidgetWithAnimation>
    with AnimationControllerMixin {

  Animation<double> width;
  
  @override
  void initState() {
    width = Tween(begin: 100.0, end: 200).animate(controller);
    controller.addTask(FromToTask(duration: Duration(seconds: 1), to: 1.0));
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(width: width.value,);
  }
}
```
This widget animates the container's width from `100` to `200` within `1 second` on widget creation.


### B: Manual configuration

The manual configuration is analogue to the configuration of a regular `AnimationController`:
- add `SingleTickerProviderStateMixin` to your `State`
- override `void initState()` method and initialize `AnimationControllerX` and `Animation` objects
- override `void dispose()` method and make sure to call `dispose()` method of `AnimationControllerX`

#### Example 
```dart
class _WidgetWithAnimationState extends State<WidgetWithAnimation>
    with SingleTickerProviderStateMixin {
  AnimationControllerX controller;
  Animation<double> width;

  @override
  void initState() {
    controller = AnimationControllerX(vsync: this);
    controller.addListener(() => setState(() {}));
    width = Tween(begin: 100.0, end: 200.0).animate(controller);
    controller.addTask(FromToTask(duration: Duration(seconds: 1), to: 1.0));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.value,
    );
  }
}
```
This widget animates the container's width from `100` to `200` within `1 second` on widget creation.



## Execute animation tasks

The `AnimationControllerX` has a task queue that can store unlimited `AnimationTask`s. It continuously processes the task queue until it's empty.

You can add tasks by using

Method | Action
-- | --
`addTask(AnimationTask)` | Adds one task to the queue
`addTasks(List<AnimationTask>)` | Adds a list of tasks to the queue
`reset(List<AnimationTask>)` | Stops the execution (and adds a new tasks if provided via parameter)
`stop()` | Stops the execution
`forceCompleteCurrentTask()` | Instantly completes current task and continues with the next one



## Predefined animation tasks

`AnimationControllerX` comes with many different predefined `AnimationTask`s:

### `FromToTask`
- Animates the animation position from **start value** to a **destination value** in a specified **duration**.
- Supports non-linear easing.
- Can use current animation position when no **start value** is specified.

### `LoopTask`
- Loops the animation position for a given **count of iterations** from a **start value** to a **destination value** in a specified **iteration duration**.
- Supports unlimited loop iterations.
- Supports mirroring between iterations *(every second iteration is reversed)*.
- Supports non-linear easing.
- Supports using current position as **start value** for the first iteration.

### `SetValueTask`
- Immediately sets the animation position to a given **value**.

### `ConditionalTask`
- Emits the current animation position until a **certain event is occured**.

### `SleepTask`
- Emits the current animation position for a specified **duration**.

### Create own tasks types

- You can easily create **own task classes** by **extending** from `AnimationTask` and implement it's `computeValue()` method and add lifecycle methods.


## Combine different tasks

Unfold the whole power combining multiple tasks into one queue:

```dart
controller.addTasks([
    FromToTask(to: 0.5, duration: Duration(seconds: 1)),
    ConditionalTask(predicate: ()=> isMyDataLoaded),
    FromToTask(to: 1.0, duration: Duration(seconds: 1)),
    SleepTask(duration: Duration(seconds: 2)),
    FromToTask(to: 0.0, duration: Duration(milliseconds: 350)),
]);
```
This animation will animate to `0.5` and wait there until `isMyDataLoaded` is `true`. Then it will continue to animate to `1.0`, wait for `2 seconds` and quickly animate back *(reverse)* to `0.0`.

You can also append more tasks while tasks queue is full. These tasks will be executed at the end.


## Status callbacks

There are two mechanics build into `AnimationControllerX`'s design to retrieve status from your animation.

### Use onStatusUpdate listener

```dart
controller.onStatusChange = (AnimationControllerXStatus status, AnimationTask task) {
      if (status == AnimationControllerXStatus.startTask) {
        print("started task: $task");
      }
      if (status == AnimationControllerXStatus.completeTask) {
        print("completed task: $task");
      }
    };
```

### Use AnimationTask listener

Each `AnimationTask` has two defaults listener `onStart` and `onComplete`.

```dart
controller.addTasks([
      FromToTask(
          to: 0.5,
          duration: Duration(seconds: 1),
          onStart: () => print("here we go"),
          onComplete: () {
            setState(() => halfOfAnimationDone = true);
          }),
      FromToTask(
          to: 1.0,
          duration: Duration(seconds: 1),
          onComplete: () => print("animation finished")),
    ]);
```

Additionally `AnimationTask`s can add their own listeners. For example the `LoopTask` has a parameter `onIterationCompleted`.