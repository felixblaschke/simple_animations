import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';
import 'animation_task.dart';
import 'from_to_task.dart';

class LoopTask extends AnimationTask {
  double from;
  double to;
  Duration duration;
  int iterations;
  bool startOnCurrentPosition;
  bool mirror;
  AnimationTaskCallback onIterationCompleted;
  Curve curve;
  Duration _lastIterationCompleteTime;

  LoopTask({
    @required this.duration,
    @required this.from,
    @required this.to,
    this.iterations,
    this.startOnCurrentPosition = true,
    this.mirror = false,
    this.onIterationCompleted,
    this.curve = Curves.linear,
    AnimationTaskCallback onStart,
    AnimationTaskCallback onComplete,
  })  : assert(duration != null, "Please provide a 'duration'."),
        assert(from != null, "Please provide a 'from' value."),
        assert(to != null, "Please provide a 'to' value."),
        super(onStart: onStart, onComplete: onComplete);

  FromToTask _currentIterationTask;
  var _iterationsPassed = 0;

  @override
  started(Duration time, double value) {
    _lastIterationCompleteTime = time;
    return super.started(time, value);
  }

  @override
  double computeValue(Duration time) {
    if (_currentIterationTask == null) {
      _createAnimationTaskForCurrentIteration(time);
    }

    final value = _currentIterationTask.computeValue(time);

    if (_currentIterationTask.isCompleted()) {
      finishIteration(time);
    }

    return value;
  }

  void _createAnimationTaskForCurrentIteration(Duration time) {
    var fromValue = from;
    var toValue = to;

    if (startOnCurrentPosition && _iterationsPassed == 0) {
      fromValue = startedValue;
    }

    if (mirror && _iterationsPassed % 2 == 1) {
      final swapValue = toValue;
      toValue = fromValue;
      fromValue = swapValue;
    }

    _currentIterationTask = FromToTask(
      duration: duration,
      from: fromValue,
      to: toValue,
      curve: curve,
      recomputeDurationBasedOnProgress: true,
    );
    _currentIterationTask.started(_lastIterationCompleteTime, fromValue);
  }

  void finishIteration(Duration time) {
    if (onIterationCompleted != null) onIterationCompleted();

    _lastIterationCompleteTime = time;
    _currentIterationTask.dispose();
    _currentIterationTask = null;
    _iterationsPassed++;

    if (iterations != null && _iterationsPassed == iterations) {
      taskCompleted();
    }
  }

  @override
  String toString() {
    return "LoopAnimationTask(from: $from, to: $to, iterationDuration: $duration, iterations: $iterations, mirror: $mirror, curve: $curve)${super.toString()}";
  }
}
