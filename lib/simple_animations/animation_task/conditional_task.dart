import 'package:meta/meta.dart';

import 'animation_task.dart';

class ConditionalTask extends AnimationTask {
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
      taskCompleted();
    }

    return startedValue;
  }

  @override
  String toString() {
    return "ConditionalAnimationTask()${super.toString()}";
  }
}
