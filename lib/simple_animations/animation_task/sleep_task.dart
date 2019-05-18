import 'package:flutter/widgets.dart';

import 'animation_task.dart';

/// Animation task that sleep for a specified [duration]. After that is completes.
class SleepTask extends AnimationTask {
  /// Duration to sleep
  Duration duration;

  SleepTask({
    @required this.duration,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  })  : assert(duration != null, "Please provide a 'duration'."),
        super(onStart: onStart, onComplete: onComplete);

  @override
  double computeValue(Duration time) {
    final timePassed = time - startedTime;
    if (timePassed.inMilliseconds >= duration.inMilliseconds) {
      completeTask();
    }
    return startedValue;
  }

  @override
  String toString() {
    return "SleepAnimationTask(duration: $duration)${super.toString()}";
  }
}
