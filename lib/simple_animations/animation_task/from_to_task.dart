import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

import 'animation_task.dart';

/// Performs an animation from [from] to [to] in [duration] time.
/// If the [from] is not set the animation will start from the current position.
///
/// The [duration] is computed for a an interval from `0.0` to `1.0`. (Example:
/// animating from 0.5 to 1.0 with duration of 1000ms takes 500ms)
/// This behavior can be changed by setting [durationBasedOnZeroToOneInterval]
/// to `false`.
///
/// You can apply an easing curve by setting [curve].
class FromToTask extends AnimationTask {
  /// Animation duration from 0.0 to 1.0 (if [durationBasedOnZeroToOneInterval] is `true`).
  /// Else the duration of this animation task (if [durationBasedOnZeroToOneInterval] is `false`).
  Duration duration;

  /// Sets the duration behavior. See [duration].
  bool durationBasedOnZeroToOneInterval;

  /// Double value between `0.0` and `1.0` that indicates the start position of
  /// the animation. If it's not set the task will refer to the current position
  /// of the animation.
  double from;

  /// Double value between `0.0` and `1.0` that indicates the end position of
  /// the animation.
  double to;

  /// The easing behavior of the animation. Default: [Curves.linear]
  Curve curve;

  /// Creates a new task that animate from a certain value to a another value.
  FromToTask({
    @required this.duration,
    @required this.to,
    this.durationBasedOnZeroToOneInterval = true,
    this.from,
    this.curve = Curves.linear,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  })  : assert(to != null, "Please provide a 'to' value to animate to."),
        assert(duration != null, "Please provide a 'duration'."),
        super(onStart: onStart, onComplete: onComplete);

  @override
  double computeValue(Duration time) {
    final fromValue = (from == null ? startedValue : from).clamp(0.0, 1.0);
    final toValue = to.clamp(0.0, 1.0).toDouble();
    final delta = (toValue - fromValue).abs();
    final durationMillis = durationBasedOnZeroToOneInterval
        ? delta * duration.inMilliseconds
        : duration.inMilliseconds;

    double value;

    if (durationMillis == 0) {
      value = toValue;
    } else {
      final timePassed = time - startedTime;
      final progress = timePassed.inMilliseconds / durationMillis;
      final linearValue = (fromValue * (1 - progress) + progress * toValue)
          .clamp(min(fromValue, toValue), max(fromValue, toValue))
          .toDouble();
      value = curve.transform(linearValue);
    }

    if (value == toValue) completeTask();

    return value;
  }

  @override
  String toString() {
    return "FromToAnimationTask(from: $from, to: $to, duration: $duration, curve: $curve)${super.toString()}";
  }
}
