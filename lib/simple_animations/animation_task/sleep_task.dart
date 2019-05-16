import 'package:meta/meta.dart';

import 'animation_task.dart';

class SleepTask extends AnimationTask {
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
      taskCompleted();
    }
    return startedValue;
  }

  @override
  String toString() {
    return "SleepAnimationTask(duration: $duration)${super.toString()}";
  }
}
