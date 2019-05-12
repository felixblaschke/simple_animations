import 'dart:math';

import 'package:meta/meta.dart';

import 'animation_task.dart';

class FromToAnimationTask extends AnimationTask {
  Duration duration;
  bool recomputeDurationBasedOnProgress;
  double from;
  double to;
  // TODO add curve parameter

  FromToAnimationTask({
    @required this.duration,
    @required this.to,
    this.recomputeDurationBasedOnProgress = true,
    this.from,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  })  : assert(to != null,
            "Missing paramter 'to'. You need to specify a value to animate to."),
        super(onStart: onStart, onComplete: onComplete);

  @override
  computeValue(Duration time) {
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
      value = (fromValue * (1 - progress) + progress * toValue)
          .clamp(min(fromValue, toValue), max(fromValue, toValue));
    }

    if (value == toValue) taskCompleted();

    return value;
  }

  @override
  String toString() {
    return "FromToAnimationTask(from: $from, to: $to, duration: $duration)${super.toString()}";
  }
}
