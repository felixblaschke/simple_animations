import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import 'animation_task.dart';
import 'from_to_task.dart';

/// Performs a repeating animation from [from] to [to] within a specified
/// [duration].
///
/// You can set the count of iterations (loops) by setting [iterations].
///
/// By enabling [mirror] every second iteration will reverse. (For example: 0..1,
/// 1..0, 0..1, 1..0, and so on.)
///
/// By setting [startOnCurrentPosition] to `true` it will use the current position
/// of the animation as the starting point for the first iteration.
///
/// You can track the iterations by setting an [onIterationCompleted] listener.
///
/// You can assign an alternative animation curve by setting [curve] which defaults
/// to [Curves.linear].
class LoopTask extends AnimationTask {
  /// Double value between `0.0` and `1.0` that indicates the start position of
  /// the a loop iteration.
  double from;

  /// Double value between `0.0` and `1.0` that indicates the end position of
  /// the a loop iteration.
  double to;

  /// Duration of a single loop iteration
  Duration duration;

  /// Count of iterations to perform until this task completes. If [iterations] is
  /// unset it will loop forever.
  int iterations;

  /// If set the first iteration will start right from the current animation position.
  bool startOnCurrentPosition;

  /// If set every second iteration is reversed.
  bool mirror;

  /// Callback that is called after each iteration
  AnimationTaskCallback onIterationCompleted;

  /// Easing behavior curve. Default: [Curves.linear]
  Curve curve;

  Duration _lastIterationCompleteTime;

  /// Creates a new loop task.
  LoopTask({
    @required this.duration,
    @required this.from,
    @required this.to,
    this.iterations,
    this.startOnCurrentPosition = false,
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
      _finishIteration(time);
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
      durationBasedOnZeroToOneInterval: true,
    );
    _currentIterationTask.started(_lastIterationCompleteTime, fromValue);
  }

  void _finishIteration(Duration time) {
    if (onIterationCompleted != null) onIterationCompleted();

    _lastIterationCompleteTime = time;
    _currentIterationTask.dispose();
    _currentIterationTask = null;
    _iterationsPassed++;

    if (iterations != null && _iterationsPassed == iterations) {
      completeTask();
    }
  }

  @override
  String toString() {
    return "LoopAnimationTask(from: $from, to: $to, iterationDuration: $duration, iterations: $iterations, mirror: $mirror, curve: $curve)${super.toString()}";
  }
}
