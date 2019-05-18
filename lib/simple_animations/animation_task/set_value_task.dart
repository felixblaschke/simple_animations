import 'package:flutter/widgets.dart';

import 'animation_task.dart';

/// An animation task that sets the current animation position to a specified
/// [value]. It completes right after that.
class SetValueTask extends AnimationTask {
  /// Double value between `0.0` and `1.0` to set.
  final double value;

  SetValueTask({
    @required this.value,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  })  : assert(value != null, "Please provide a 'value'."),
        super(onStart: onStart, onComplete: onComplete);

  @override
  double computeValue(Duration time) {
    completeTask();
    return value;
  }

  @override
  String toString() {
    return "SetValueAnimationTask(value: $value)${super.toString()}";
  }
}
