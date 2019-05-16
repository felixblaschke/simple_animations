import 'package:meta/meta.dart';

import 'animation_task.dart';

class SetValueTask extends AnimationTask {
  final double value;

  SetValueTask({
    @required this.value,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  })  : assert(value != null, "Please provide a 'value'."),
        super(onStart: onStart, onComplete: onComplete);

  @override
  double computeValue(Duration time) {
    taskCompleted();
    return value;
  }

  @override
  String toString() {
    return "SetValueAnimationTask(value: $value)${super.toString()}";
  }
}
