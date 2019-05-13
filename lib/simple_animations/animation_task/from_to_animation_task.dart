import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

import 'animation_task.dart';

class FromToAnimationTask extends AnimationTask {
  Duration duration;
  bool recomputeDurationBasedOnProgress;
  double from;
  double to;
  Curve curve;

  FromToAnimationTask({
    @required this.duration,
    @required this.to,
    this.recomputeDurationBasedOnProgress = true,
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
    final toValue = to.clamp(0.0, 1.0);
    final delta = (toValue - fromValue).abs();
    final durationMillis = recomputeDurationBasedOnProgress
        ? delta * duration.inMilliseconds
        : duration.inMilliseconds;

    double value;

    if (durationMillis == 0) {
      value = toValue;
    } else {
      final timePassed = time - startedTime;
      final progress = timePassed.inMilliseconds / durationMillis;
      final linearValue = (fromValue * (1 - progress) + progress * toValue)
          .clamp(min(fromValue, toValue), max(fromValue, toValue));
      value = curve.transform(linearValue);
    }

    if (value == toValue) taskCompleted();

    return value;
  }

  @override
  String toString() {
    return "FromToAnimationTask(from: $from, to: $to, duration: $duration, curve: $curve)${super.toString()}";
  }
}
