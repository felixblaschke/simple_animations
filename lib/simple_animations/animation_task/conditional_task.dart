import 'package:flutter/widgets.dart';

import 'animation_task.dart';

/// Animation task that keeps emitting the current value of animation until a
/// certain condition occurs (when [predicate] return `true`).
class ConditionalTask extends AnimationTask {
  /// Predicate function that checks for a certain condition.
  /// If it returns `false` the task keep processing.
  /// If it return `true` task completes.
  bool Function() predicate;

  ConditionalTask({
    @required this.predicate,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  })  : assert(predicate != null, "Please provide a 'predicate'."),
        super(onStart: onStart, onComplete: onComplete);

  @override
  double computeValue(Duration time) {
    if (predicate()) {
      completeTask();
    }

    return startedValue;
  }

  @override
  String toString() {
    return "ConditionalAnimationTask()${super.toString()}";
  }
}
