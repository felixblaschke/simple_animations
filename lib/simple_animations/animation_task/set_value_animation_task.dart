import 'package:meta/meta.dart';

import 'animation_task.dart';

class SetValueAnimationTask extends AnimationTask {
  final double value;

  SetValueAnimationTask({
    @required this.value,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  })  : assert(value != null, "Please provide a value"),
        super(onStart: onStart, onComplete: onComplete);

  @override
  computeValue(Duration time) {
    taskCompleted();
    return value;
  }

  @override
  String toString() {
    return "SetValueAnimationTask(value: $value)${super.toString()}";
  }
}
