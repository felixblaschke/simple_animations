import 'package:meta/meta.dart';
import 'animation_task.dart';
import 'from_to_animation_task.dart';

class LoopAnimationTask extends AnimationTask {
  double from;
  double to;
  Duration iterationDuration;
  int iterations;
  bool startWithCurrentPosition;
  bool mirrorIterations;
  AnimationTaskCallback onIterationCompleted;
  // TODO add curve parameter

  LoopAnimationTask({
    @required this.iterationDuration,
    this.from,
    @required this.to,
    this.iterations,
    this.startWithCurrentPosition = true,
    this.mirrorIterations = false,
    this.onIterationCompleted,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  }) : super(onStart: onStart, onComplete: onComplete);

  FromToAnimationTask _currentIterationTask;
  var _iterationsPassed = 0;

  @override
  computeValue(Duration time) {
    if (_currentIterationTask == null) {
      _createAnimationTaskForCurrentIteration(time);
    }

    final value = _currentIterationTask.computeValue(time);

    if (_currentIterationTask.isCompleted()) {
      finishIteration();
    }

    return value;
  }

  void _createAnimationTaskForCurrentIteration(Duration time) {
    var fromValue = from;
    var toValue = to;

    if (startWithCurrentPosition && _iterationsPassed == 0) {
      fromValue = startedValue;
    }

    if (mirrorIterations && _iterationsPassed % 2 == 1) {
      final swapValue = toValue;
      toValue = fromValue;
      fromValue = swapValue;
    }

    _currentIterationTask = FromToAnimationTask(
        duration: iterationDuration, from: fromValue, to: toValue);
    _currentIterationTask.started(time, startedValue);
  }

  void finishIteration() {
    if (onIterationCompleted != null) onIterationCompleted();

    _currentIterationTask.dispose();
    _currentIterationTask = null;
    _iterationsPassed++;

    if (iterations != null && _iterationsPassed == iterations) {
      taskCompleted();
    }
  }

  @override
  String toString() {
    return "LoopAnimationTask(from: $from, to: $to, iterationDuration: $iterationDuration, iterations: $iterations, mirror: $mirrorIterations)${super.toString()}";
  }
}

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
