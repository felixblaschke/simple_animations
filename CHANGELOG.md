## 1.3.8

- Integrated app example into main repository:
  - `example/example_app`

## 1.3.7

- This release contains fixes requested by the Flutter Ecosystem Committee:
  - Added API documentation and improved test coverage
  - Accidentally public method `LoopTask.finishIteration(Duration)` is now private.
    Instead you can use public APIs of `AnimationControllerX` to control the tasks.
  - Accidentally public method `AnimationControllerX.completeCurrentTask()` is now private.
    Instead you can use `AnimationControllerX.forceCompleteCurrentTask()`.


## 1.3.6

- Fixed bug in type generics

## 1.3.5

- Preparations for avoiding implicit casting

## 1.3.4

- Fixed documentation: missing line about manual creation of AnimationControllerX

## 1.3.1 - 1.3.3

- Upgraded to Flutter 1.7 and Dart 2.4


## 1.3.0

- Upgraded to Flutter 1.5 and Dart 2.3

### New features

- `AnimationControllerX` a new, powerful AnimationController
- `AnimationControllerMixin` to easily setup AnimationControllerX
- 5 types of `AnimationTask`s to use for AnimationControllerX


## 1.2.0

### New features
- `Rendering` a widget for building of continuous animations
- `AnimationProgress` a utility class that helps you with `Duration`-based
Animations

## 1.1.1

- Fixed strange effect when rebuilding a `ControlledAnimation` with `playback` set to 
  `Playback.MIRROR`

## 1.1.0

### New features
- New property `startPosition` for `ControlledAnimation` widget:
  you can now specify the initial start position (time) of the animation.
  This is useful for designing interactive UI elements.


## 1.0.0
- Initial release

### New features

- `ControlledAnimation`: Widget for simple tween-based custom animations
- `MultiTrackTween`: Animatable for tweening multiple properties at once


## 0.x

- Setting up the project
